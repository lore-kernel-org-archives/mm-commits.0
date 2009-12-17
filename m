From: akpm@linux-foundation.org
Subject: [merged] vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size.patch removed from -mm tree
Date: Thu, 17 Dec 2009 12:39:58 -0800
Message-ID: <200912172039.nBHKdwjc017546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764843AbZLQUkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Dec 2009 15:40:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ezk@cs.sunysb.edu, hugh.dickins@tiscali.co.uk, kirkland@canonical.com, tyhicks@linux.vnet.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs/fsstack: handle 32-bit smp + preempt + large files in fsstack_copy_inode_size
has been removed from the -mm tree.  Its filename was
     vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs/fsstack: handle 32-bit smp + preempt + large files in fsstack_copy_inode_size
From: Erez Zadok <ezk@cs.sunysb.edu>

Copy the inode size and blocks from one inode to another correctly on
32-bit systems with CONFIG_SMP, CONFIG_PREEMPT, or CONFIG_LBDAF.  Use
proper inode spinlocks only when i_size/i_blocks cannot fit in one 32-bit
word.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/stack.c               |   54 ++++++++++++++++++++++++++++++++++---
 include/linux/fs_stack.h |    2 -
 2 files changed, 52 insertions(+), 4 deletions(-)

diff -puN fs/stack.c~vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size fs/stack.c
--- a/fs/stack.c~vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size
+++ a/fs/stack.c
@@ -7,10 +7,58 @@
  * This function cannot be inlined since i_size_{read,write} is rather
  * heavy-weight on 32-bit systems
  */
-void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
+void fsstack_copy_inode_size(struct inode *dst, struct inode *src)
 {
-	i_size_write(dst, i_size_read((struct inode *)src));
-	dst->i_blocks = src->i_blocks;
+	loff_t i_size;
+	blkcnt_t i_blocks;
+
+	/*
+	 * i_size_read() includes its own seqlocking and protection from
+	 * preemption (see include/linux/fs.h): we need nothing extra for
+	 * that here, and prefer to avoid nesting locks than attempt to keep
+	 * i_size and i_blocks in sync together.
+	 */
+	i_size = i_size_read(src);
+
+	/*
+	 * But if CONFIG_LBDAF (on 32-bit), we ought to make an effort to
+	 * keep the two halves of i_blocks in sync despite SMP or PREEMPT -
+	 * though stat's generic_fillattr() doesn't bother, and we won't be
+	 * applying quotas (where i_blocks does become important) at the
+	 * upper level.
+	 *
+	 * We don't actually know what locking is used at the lower level;
+	 * but if it's a filesystem that supports quotas, it will be using
+	 * i_lock as in inode_add_bytes().  tmpfs uses other locking, and
+	 * its 32-bit is (just) able to exceed 2TB i_size with the aid of
+	 * holes; but its i_blocks cannot carry into the upper long without
+	 * almost 2TB swap - let's ignore that case.
+	 */
+	if (sizeof(i_blocks) > sizeof(long))
+		spin_lock(&src->i_lock);
+	i_blocks = src->i_blocks;
+	if (sizeof(i_blocks) > sizeof(long))
+		spin_unlock(&src->i_lock);
+
+	/*
+	 * If CONFIG_SMP or CONFIG_PREEMPT on 32-bit, it's vital for
+	 * fsstack_copy_inode_size() to hold some lock around
+	 * i_size_write(), otherwise i_size_read() may spin forever (see
+	 * include/linux/fs.h).  We don't necessarily hold i_mutex when this
+	 * is called, so take i_lock for that case.
+	 *
+	 * And if CONFIG_LBADF (on 32-bit), continue our effort to keep the
+	 * two halves of i_blocks in sync despite SMP or PREEMPT: use i_lock
+	 * for that case too, and do both at once by combining the tests.
+	 *
+	 * There is none of this locking overhead in the 64-bit case.
+	 */
+	if (sizeof(i_size) > sizeof(long) || sizeof(i_blocks) > sizeof(long))
+		spin_lock(&dst->i_lock);
+	i_size_write(dst, i_size);
+	dst->i_blocks = i_blocks;
+	if (sizeof(i_size) > sizeof(long) || sizeof(i_blocks) > sizeof(long))
+		spin_unlock(&dst->i_lock);
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
 
diff -puN include/linux/fs_stack.h~vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size include/linux/fs_stack.h
--- a/include/linux/fs_stack.h~vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size
+++ a/include/linux/fs_stack.h
@@ -9,7 +9,7 @@
 
 /* externs for fs/stack.c */
 extern void fsstack_copy_attr_all(struct inode *dest, const struct inode *src);
-extern void fsstack_copy_inode_size(struct inode *dst, const struct inode *src);
+extern void fsstack_copy_inode_size(struct inode *dst, struct inode *src);
 
 /* inlines */
 static inline void fsstack_copy_attr_atime(struct inode *dest,
_

Patches currently in -mm which might be from ezk@cs.sunysb.edu are

origin.patch
linux-next.patch


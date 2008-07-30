From: akpm@linux-foundation.org
Subject: - fsstack-fsstack_copy_inode_size-locking.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:17:35 -0700
Message-ID: <200807301917.m6UJHZXt011225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210AbYG3Tc3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:32:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, ezk@cs.sunysb.edu, hch@lst.de, hooanon05@yahoo.co.jp, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fsstack: fsstack_copy_inode_size locking
has been removed from the -mm tree.  Its filename was
     fsstack-fsstack_copy_inode_size-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsstack: fsstack_copy_inode_size locking
From: Hugh Dickins <hugh@veritas.com>

LTP's iogen01 doio tests used to hang nicely on 32-bit SMP when /tmp was a
unionfs mount of a tmpfs, i_size_read spinning forever, waiting for a lost
seqcount update: fixed by taking i_lock around i_size_write when 32-bit
SMP.

But akpm was dissatisfied with the resulting patch: its lack of
commentary, the #ifs, the nesting around i_size_read, the lack of
attention to i_blocks.  I promised to redo it with the general
spin_lock_32bit() he proposed; but disliked the result, partly because
"32bit" obscures the real constraints, which are best commented within
fsstack_copy_inode_size itself.

This version adds those comments, and uses sizeof comparisons which the
compiler can optimize out, instead of CONFIG_SMP, CONFIG_LSF. 
BITS_PER_LONG.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: <hooanon05@yahoo.co.jp>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/stack.c               |   58 +++++++++++++++++++++++++++++++------
 include/linux/fs_stack.h |    3 -
 2 files changed, 50 insertions(+), 11 deletions(-)

diff -puN fs/stack.c~fsstack-fsstack_copy_inode_size-locking fs/stack.c
--- a/fs/stack.c~fsstack-fsstack_copy_inode_size-locking
+++ a/fs/stack.c
@@ -19,16 +19,56 @@
  * This function cannot be inlined since i_size_{read,write} is rather
  * heavy-weight on 32-bit systems
  */
-void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
+void fsstack_copy_inode_size(struct inode *dst, struct inode *src)
 {
-#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
-	spin_lock(&dst->i_lock);
-#endif
-	i_size_write(dst, i_size_read(src));
-	dst->i_blocks = src->i_blocks;
-#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
-	spin_unlock(&dst->i_lock);
-#endif
+	loff_t i_size;
+	blkcnt_t i_blocks;
+
+	/*
+	 * i_size_read() includes its own seqlocking and protection from
+	 * preemption (see include/linux/fs.h): we need nothing extra for
+	 * that here, and prefer to avoid nesting locks than attempt to
+	 * keep i_size and i_blocks in synch together.
+	 */
+	i_size = i_size_read(src);
+
+	/*
+	 * But if CONFIG_LSF (on 32-bit), we ought to make an effort to keep
+	 * the two halves of i_blocks in synch despite SMP or PREEMPT - though
+	 * stat's generic_fillattr() doesn't bother, and we won't be applying
+	 * quotas (where i_blocks does become important) at the upper level.
+	 *
+	 * We don't actually know what locking is used at the lower level; but
+	 * if it's a filesystem that supports quotas, it will be using i_lock
+	 * as in inode_add_bytes().  tmpfs uses other locking, and its 32-bit
+	 * is (just) able to exceed 2TB i_size with the aid of holes; but its
+	 * i_blocks cannot carry into the upper long without almost 2TB swap -
+	 * let's ignore that case.
+	 */
+	if (sizeof(i_blocks) > sizeof(long))
+		spin_lock(&src->i_lock);
+	i_blocks = src->i_blocks;
+	if (sizeof(i_blocks) > sizeof(long))
+		spin_unlock(&src->i_lock);
+
+	/*
+	 * If CONFIG_SMP on 32-bit, it's vital for fsstack_copy_inode_size()
+	 * to hold some lock around i_size_write(), otherwise i_size_read()
+	 * may spin forever (see include/linux/fs.h).  We don't necessarily
+	 * hold i_mutex when this is called, so take i_lock for that case.
+	 *
+	 * And if CONFIG_LSF (on 32-bit), continue our effort to keep the
+	 * two halves of i_blocks in synch despite SMP or PREEMPT: use i_lock
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
 
diff -puN include/linux/fs_stack.h~fsstack-fsstack_copy_inode_size-locking include/linux/fs_stack.h
--- a/include/linux/fs_stack.h~fsstack-fsstack_copy_inode_size-locking
+++ a/include/linux/fs_stack.h
@@ -21,8 +21,7 @@
 
 /* externs for fs/stack.c */
 extern void fsstack_copy_attr_all(struct inode *dest, const struct inode *src);
-extern void fsstack_copy_inode_size(struct inode *dst,
-				    const struct inode *src);
+extern void fsstack_copy_inode_size(struct inode *dst, struct inode *src);
 
 /* inlines */
 static inline void fsstack_copy_attr_atime(struct inode *dest,
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
mlock-mlocked-pages-are-unevictable.patch
vmscan-unevictable-lru-scan-sysctl.patch
mmapc-deinline-a-few-functions.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
prio_tree-debugging-patch.patch


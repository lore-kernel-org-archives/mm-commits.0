From: akpm@linux-foundation.org
Subject: - revoke-core-code-fix-zero-length-kmalloc.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:40:25 -0700
Message-ID: <200707092340.l69NePAY020822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38001 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758674AbXGIXkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:40:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     revoke: fix zero-length kmalloc
has been removed from the -mm tree.  Its filename was
     revoke-core-code-fix-zero-length-kmalloc.patch

This patch was dropped because it was folded into revoke-core-code.patch

------------------------------------------------------
Subject: revoke: fix zero-length kmalloc
From: Pekka Enberg <penberg@cs.helsinki.fi>

Fix a zero-length kmalloc in the case where there is nothing to revoke.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-fix-zero-length-kmalloc fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-fix-zero-length-kmalloc
+++ a/fs/revoke.c
@@ -547,22 +547,12 @@ static struct fileset *__alloc_revoke_fs
 	return NULL;
 }
 
-static struct fileset *alloc_revoke_fset(struct inode *inode, struct file *to_exclude)
-{
-	unsigned long nr_fds;
-
-	read_lock(&tasklist_lock);
-	nr_fds = inode_fds(inode, to_exclude);
-	read_unlock(&tasklist_lock);
-
-	return __alloc_revoke_fset(nr_fds);
-}
-
 static int do_revoke(struct inode *inode, struct file *to_exclude)
 {
 	struct revoke_details details;
 	struct fileset *fset = NULL;
 	struct task_struct *g, *p;
+	unsigned long nr_fds;
 	int err = 0;
 
 	if (current->fsuid != inode->i_uid && !capable(CAP_FOWNER)) {
@@ -576,11 +566,18 @@ static int do_revoke(struct inode *inode
 		goto out;
 	}
 
+	read_lock(&tasklist_lock);
+	nr_fds = inode_fds(inode, to_exclude);
+	read_unlock(&tasklist_lock);
+
+	if (!nr_fds)
+		goto out;
+
 	/*
 	 * Pre-allocate memory because the first pass is done under
 	 * tasklist_lock.
 	 */
-	fset = alloc_revoke_fset(inode, to_exclude);
+	fset = __alloc_revoke_fset(nr_fds);
 	if (!fset) {
 		err = -ENOMEM;
 		goto out;
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

git-unionfs.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch
slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch
slab-allocators-support-__gfp_zero-in-all-allocators.patch
remove-useless-tolower-in-isofs.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-fix-zero-length-kmalloc.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
slab-leaks3-default-y.patch

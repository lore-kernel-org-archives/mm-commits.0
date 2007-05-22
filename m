From: akpm@linux-foundation.org
Subject: + revoke-core-code-fix-zero-length-kmalloc.patch added to -mm tree
Date: Tue, 22 May 2007 13:17:57 -0700
Message-ID: <200705222017.l4MKHvfK009016@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760989AbXEVUTN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 16:19:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi


The patch titled
     revoke: fix zero-length kmalloc
has been added to the -mm tree.  Its filename is
     revoke-core-code-fix-zero-length-kmalloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
git-unionfs.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slub-use-ilog2-instead-of-series-of-constant-comparisons.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-fix-zero-length-kmalloc.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch

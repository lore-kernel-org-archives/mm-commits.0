From: akpm@linux-foundation.org
Subject: - unionfs-fix-memory-leak.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:17:32 -0700
Message-ID: <200807301917.m6UJHWp9011222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020AbYG3TSb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:18:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, ezk@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     unionfs: fix memory leak
has been removed from the -mm tree.  Its filename was
     unionfs-fix-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unionfs: fix memory leak
From: Hugh Dickins <hugh@veritas.com>

Unionfs has slowly been leaking memory: although many places do explicitly
free the dentry's lower_paths array (and I've not changed those, in case
the ordering is important), not all do - and adding a WARN_ON didn't seem
to finger any particular culprit.  So free_dentry_private_data needs to
kfree lower_paths (other freeers are good about setting it to NULL).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unionfs/lookup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/unionfs/lookup.c~unionfs-fix-memory-leak fs/unionfs/lookup.c
--- a/fs/unionfs/lookup.c~unionfs-fix-memory-leak
+++ a/fs/unionfs/lookup.c
@@ -498,6 +498,7 @@ void free_dentry_private_data(struct den
 {
 	if (!dentry || !dentry->d_fsdata)
 		return;
+	kfree(UNIONFS_D(dentry)->lower_paths);
 	kmem_cache_free(unionfs_dentry_cachep, dentry->d_fsdata);
 	dentry->d_fsdata = NULL;
 }
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


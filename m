From: akpm@linux-foundation.org
Subject: [merged] fs-locksc-remove-init_once.patch removed from -mm tree
Date: Mon, 18 Jul 2011 11:32:55 -0700
Message-ID: <201107181832.p6IIWK1p019818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010Ab1GRScb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Jul 2011 14:32:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, bfields@fieldses.org, mm-commits@vger.kernel.org


The patch titled
     fs/locks.c: remove init_once()
has been removed from the -mm tree.  Its filename was
     fs-locksc-remove-init_once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/locks.c: remove init_once()
From: Miklos Szeredi <mszeredi@suse.cz>

Remove SLAB initialization entirely, as suggested by Bruce and Linus. 
Allocate with __GFP_ZERO instead and only initialize list heads.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |   41 ++++++++++-------------------------------
 1 file changed, 10 insertions(+), 31 deletions(-)

diff -puN fs/locks.c~fs-locksc-remove-init_once fs/locks.c
--- a/fs/locks.c~fs-locksc-remove-init_once
+++ a/fs/locks.c
@@ -160,26 +160,20 @@ EXPORT_SYMBOL_GPL(unlock_flocks);
 
 static struct kmem_cache *filelock_cache __read_mostly;
 
-static void locks_init_lock_always(struct file_lock *fl)
+static void locks_init_lock_heads(struct file_lock *fl)
 {
-	fl->fl_next = NULL;
-	fl->fl_fasync = NULL;
-	fl->fl_owner = NULL;
-	fl->fl_pid = 0;
-	fl->fl_nspid = NULL;
-	fl->fl_file = NULL;
-	fl->fl_flags = 0;
-	fl->fl_type = 0;
-	fl->fl_start = fl->fl_end = 0;
+	INIT_LIST_HEAD(&fl->fl_link);
+	INIT_LIST_HEAD(&fl->fl_block);
+	init_waitqueue_head(&fl->fl_wait);
 }
 
 /* Allocate an empty lock structure. */
 struct file_lock *locks_alloc_lock(void)
 {
-	struct file_lock *fl = kmem_cache_alloc(filelock_cache, GFP_KERNEL);
+	struct file_lock *fl = kmem_cache_zalloc(filelock_cache, GFP_KERNEL);
 
 	if (fl)
-		locks_init_lock_always(fl);
+		locks_init_lock_heads(fl);
 
 	return fl;
 }
@@ -215,27 +209,12 @@ EXPORT_SYMBOL(locks_free_lock);
 
 void locks_init_lock(struct file_lock *fl)
 {
-	INIT_LIST_HEAD(&fl->fl_link);
-	INIT_LIST_HEAD(&fl->fl_block);
-	init_waitqueue_head(&fl->fl_wait);
-	fl->fl_ops = NULL;
-	fl->fl_lmops = NULL;
-	locks_init_lock_always(fl);
+	memset(fl, 0, sizeof(struct file_lock));
+	locks_init_lock_heads(fl);
 }
 
 EXPORT_SYMBOL(locks_init_lock);
 
-/*
- * Initialises the fields of the file lock which are invariant for
- * free file_locks.
- */
-static void init_once(void *foo)
-{
-	struct file_lock *lock = (struct file_lock *) foo;
-
-	locks_init_lock(lock);
-}

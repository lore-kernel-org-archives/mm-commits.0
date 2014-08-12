From: akpm@linux-foundation.org
Subject: [obsolete] dlm-fs-remove-unused-conf-from-lm_grant.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:35:40 -0700
Message-ID: <53ea6c8c.mCNbewkOa3avdiNg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:39119 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbaHLTfl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:35:41 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1921131obb.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:35:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bfields@fieldses.org, ccaulfie@redhat.com, jlayton@poochiereds.net, teigland@redhat.com, trond.myklebust@primarydata.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: dlm, lockd: remove unused conf from lm_grant
has been removed from the -mm tree.  Its filename was
     dlm-fs-remove-unused-conf-from-lm_grant.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: dlm, lockd: remove unused conf from lm_grant

This argument is always NULL so don't pass it around.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Teigland <teigland@redhat.com>
Reviewed-by: Jeff Layton <jlayton@poochiereds.net>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/plock.c     |    8 ++++----
 fs/lockd/svclock.c |   12 +++---------
 include/linux/fs.h |    2 +-
 3 files changed, 8 insertions(+), 14 deletions(-)

diff -puN fs/dlm/plock.c~dlm-fs-remove-unused-conf-from-lm_grant fs/dlm/plock.c
--- a/fs/dlm/plock.c~dlm-fs-remove-unused-conf-from-lm_grant
+++ a/fs/dlm/plock.c
@@ -30,7 +30,7 @@ struct plock_op {
 
 struct plock_xop {
 	struct plock_op xop;
-	int (*callback)(struct file_lock *, struct file_lock *, int);
+	int (*callback)(struct file_lock *fl, int result);
 	void *fl;
 	void *file;
 	struct file_lock flc;
@@ -190,7 +190,7 @@ static int dlm_plock_callback(struct plo
 	struct file *file;
 	struct file_lock *fl;
 	struct file_lock *flc;
-	int (*notify)(struct file_lock *fl, struct file_lock *cont, int result) = NULL;
+	int (*notify)(struct file_lock *fl, int result) = NULL;
 	struct plock_xop *xop = (struct plock_xop *)op;
 	int rv = 0;
 
@@ -209,7 +209,7 @@ static int dlm_plock_callback(struct plo
 	notify = xop->callback;
 
 	if (op->info.rv) {
-		notify(fl, NULL, op->info.rv);
+		notify(fl, op->info.rv);
 		goto out;
 	}
 
@@ -228,7 +228,7 @@ static int dlm_plock_callback(struct plo
 			  (unsigned long long)op->info.number, file, fl);
 	}
 
-	rv = notify(fl, NULL, 0);
+	rv = notify(fl, 0);
 	if (rv) {
 		/* XXX: We need to cancel the fs lock here: */
 		log_print("dlm_plock_callback: lock granted after lock request "
diff -puN fs/lockd/svclock.c~dlm-fs-remove-unused-conf-from-lm_grant fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~dlm-fs-remove-unused-conf-from-lm_grant
+++ a/fs/lockd/svclock.c
@@ -667,22 +667,16 @@ nlmsvc_cancel_blocked(struct net *net, s
  * deferred rpc for GETLK and SETLK.
  */
 static void
-nlmsvc_update_deferred_block(struct nlm_block *block, struct file_lock *conf,
-			     int result)
+nlmsvc_update_deferred_block(struct nlm_block *block, int result)
 {
 	block->b_flags |= B_GOT_CALLBACK;
 	if (result == 0)
 		block->b_granted = 1;
 	else
 		block->b_flags |= B_TIMED_OUT;
-	if (conf) {
-		if (block->b_fl)
-			__locks_copy_lock(block->b_fl, conf);
-	}
 }
 
-static int nlmsvc_grant_deferred(struct file_lock *fl, struct file_lock *conf,
-					int result)
+static int nlmsvc_grant_deferred(struct file_lock *fl, int result)
 {
 	struct nlm_block *block;
 	int rc = -ENOENT;
@@ -697,7 +691,7 @@ static int nlmsvc_grant_deferred(struct
 					rc = -ENOLCK;
 					break;
 				}
-				nlmsvc_update_deferred_block(block, conf, result);
+				nlmsvc_update_deferred_block(block, result);
 			} else if (result == 0)
 				block->b_granted = 1;
 
diff -puN include/linux/fs.h~dlm-fs-remove-unused-conf-from-lm_grant include/linux/fs.h
--- a/include/linux/fs.h~dlm-fs-remove-unused-conf-from-lm_grant
+++ a/include/linux/fs.h
@@ -867,7 +867,7 @@ struct lock_manager_operations {
 	int (*lm_compare_owner)(struct file_lock *fl1, struct file_lock *fl2);
 	unsigned long (*lm_owner_key)(struct file_lock *fl);
 	void (*lm_notify)(struct file_lock *fl);	/* unblock callback */
-	int (*lm_grant)(struct file_lock *fl, struct file_lock *conf, int result);
+	int (*lm_grant)(struct file_lock *fl, int result);
 	void (*lm_break)(struct file_lock *fl);
 	int (*lm_change)(struct file_lock **fl, int type);
 };
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
dlm-plock-reduce-indentation-by-rearranging-order.patch


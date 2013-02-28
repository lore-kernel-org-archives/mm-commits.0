From: akpm@linux-foundation.org
Subject: [merged] dlm-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:30 -0800
Message-ID: <20130228201530.A661731C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:51143 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303Ab3B1UPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:31 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so245216ggi.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dlm: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     dlm-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: dlm: convert to idr_alloc()

Convert to the much saner new idr interface.  Error return values from
recover_idr_add() mix -1 and -errno.  The conversion doesn't change
that but it looks iffy.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/lock.c    |   18 ++++++------------
 fs/dlm/recover.c |   27 +++++++++++++--------------
 2 files changed, 19 insertions(+), 26 deletions(-)

diff -puN fs/dlm/lock.c~dlm-convert-to-idr_alloc fs/dlm/lock.c
--- a/fs/dlm/lock.c~dlm-convert-to-idr_alloc
+++ a/fs/dlm/lock.c
@@ -1183,7 +1183,7 @@ static void detach_lkb(struct dlm_lkb *l
 static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
 {
 	struct dlm_lkb *lkb;
-	int rv, id;
+	int rv;
 
 	lkb = dlm_allocate_lkb(ls);
 	if (!lkb)
@@ -1199,19 +1199,13 @@ static int create_lkb(struct dlm_ls *ls,
 	mutex_init(&lkb->lkb_cb_mutex);
 	INIT_WORK(&lkb->lkb_cb_work, dlm_callback_work);
 
- retry:
-	rv = idr_pre_get(&ls->ls_lkbidr, GFP_NOFS);
-	if (!rv)
-		return -ENOMEM;
-
+	idr_preload(GFP_NOFS);
 	spin_lock(&ls->ls_lkbidr_spin);
-	rv = idr_get_new_above(&ls->ls_lkbidr, lkb, 1, &id);
-	if (!rv)
-		lkb->lkb_id = id;
+	rv = idr_alloc(&ls->ls_lkbidr, lkb, 1, 0, GFP_NOWAIT);
+	if (rv >= 0)
+		lkb->lkb_id = rv;
 	spin_unlock(&ls->ls_lkbidr_spin);
-
-	if (rv == -EAGAIN)
-		goto retry;
+	idr_preload_end();
 
 	if (rv < 0) {
 		log_error(ls, "create_lkb idr error %d", rv);
diff -puN fs/dlm/recover.c~dlm-convert-to-idr_alloc fs/dlm/recover.c
--- a/fs/dlm/recover.c~dlm-convert-to-idr_alloc
+++ a/fs/dlm/recover.c
@@ -305,27 +305,26 @@ static int recover_idr_empty(struct dlm_
 static int recover_idr_add(struct dlm_rsb *r)
 {
 	struct dlm_ls *ls = r->res_ls;
-	int rv, id;
-
-	rv = idr_pre_get(&ls->ls_recover_idr, GFP_NOFS);
-	if (!rv)
-		return -ENOMEM;
+	int rv;
 
+	idr_preload(GFP_NOFS);
 	spin_lock(&ls->ls_recover_idr_lock);
 	if (r->res_id) {
-		spin_unlock(&ls->ls_recover_idr_lock);
-		return -1;
-	}
-	rv = idr_get_new_above(&ls->ls_recover_idr, r, 1, &id);
-	if (rv) {
-		spin_unlock(&ls->ls_recover_idr_lock);
-		return rv;
+		rv = -1;
+		goto out_unlock;
 	}
-	r->res_id = id;
+	rv = idr_alloc(&ls->ls_recover_idr, r, 1, 0, GFP_NOWAIT);
+	if (rv < 0)
+		goto out_unlock;
+
+	r->res_id = rv;
 	ls->ls_recover_list_count++;
 	dlm_hold_rsb(r);
+	rv = 0;
+out_unlock:
 	spin_unlock(&ls->ls_recover_idr_lock);
-	return 0;
+	idr_preload_end();
+	return rv;
 }
 
 static void recover_idr_del(struct dlm_rsb *r)
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch


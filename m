From: akpm@linux-foundation.org
Subject: [merged] dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:45 -0800
Message-ID: <20130228201245.E79BB31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:48037 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab3B1UMq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:46 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so245143yen.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, ccaulfie@redhat.com, teigland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dlm: use idr_for_each_entry() in recover_idr_clear() error path
has been removed from the -mm tree.  Its filename was
     dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: dlm: use idr_for_each_entry() in recover_idr_clear() error path

Convert recover_idr_clear() to use idr_for_each_entry() instead of
idr_for_each().  It's somewhat less efficient this way but it
shouldn't matter in an error path.  This is to help with deprecation
of idr_remove_all().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/recover.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN fs/dlm/recover.c~dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path fs/dlm/recover.c
--- a/fs/dlm/recover.c~dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path
+++ a/fs/dlm/recover.c
@@ -351,23 +351,20 @@ static struct dlm_rsb *recover_idr_find(
 	return r;
 }
 
-static int recover_idr_clear_rsb(int id, void *p, void *data)
+static void recover_idr_clear(struct dlm_ls *ls)
 {
-	struct dlm_ls *ls = data;
-	struct dlm_rsb *r = p;
+	struct dlm_rsb *r;
+	int id;
 
-	r->res_id = 0;
-	r->res_recover_locks_count = 0;
-	ls->ls_recover_list_count--;
+	spin_lock(&ls->ls_recover_idr_lock);
 
-	dlm_put_rsb(r);
-	return 0;
-}
+	idr_for_each_entry(&ls->ls_recover_idr, r, id) {
+		r->res_id = 0;
+		r->res_recover_locks_count = 0;
+		ls->ls_recover_list_count--;
 
-static void recover_idr_clear(struct dlm_ls *ls)
-{
-	spin_lock(&ls->ls_recover_idr_lock);
-	idr_for_each(&ls->ls_recover_idr, recover_idr_clear_rsb, ls);
+		dlm_put_rsb(r);
+	}
 	idr_remove_all(&ls->ls_recover_idr);
 
 	if (ls->ls_recover_list_count != 0) {
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


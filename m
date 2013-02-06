From: akpm@linux-foundation.org
Subject: [to-be-updated] dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch removed from -mm tree
Date: Wed, 06 Feb 2013 14:01:00 -0800
Message-ID: <20130206220100.A51C85A41FB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:59868 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3BFWBB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:01:01 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so206130vbi.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:01:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, ccaulfie@redhat.com, teigland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dlm: use idr_for_each_entry() in recover_idr_clear() error path
has been removed from the -mm tree.  Its filename was
     dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: dlm: use idr_for_each_entry() in recover_idr_clear() error path

Convert recover_idr_clear() to use idr_for_each_entry() instead of
idr_for_each().  It's somewhat less efficient this way but it
shouldn't matter in an error path.  This is to help with deprecation
of idr_remove_all().

Only compile tested.

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

linux-next.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
dlm-dont-use-idr_remove_all.patch
nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
inotify-dont-use-idr_remove_all.patch
cgroup-dont-use-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch


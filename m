From: akpm@linux-foundation.org
Subject: + dlm-dont-use-idr_remove_all.patch added to -mm tree
Date: Mon, 28 Jan 2013 16:07:23 -0800
Message-ID: <20130129000724.3E3A05A424E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:36071 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab3A2AHZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 19:07:25 -0500
Received: by mail-ie0-f201.google.com with SMTP id c14so130679ieb.2
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 16:07:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, ccaulfie@redhat.com, teigland@redhat.com


The patch titled
     Subject: dlm: don't use idr_remove_all()
has been added to the -mm tree.  Its filename is
     dlm-dont-use-idr_remove_all.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: dlm: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.

The conversion isn't completely trivial for recover_idr_clear() as it's
the only place in kernel which makes legitimate use of idr_remove_all()
w/o idr_destroy().  Replace it with idr_remove() call inside
idr_for_each_entry() loop.  It goes on top so that it matches the
operation order in recover_idr_del().

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/lockspace.c |    1 -
 fs/dlm/recover.c   |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/dlm/lockspace.c~dlm-dont-use-idr_remove_all fs/dlm/lockspace.c
--- a/fs/dlm/lockspace.c~dlm-dont-use-idr_remove_all
+++ a/fs/dlm/lockspace.c
@@ -796,7 +796,6 @@ static int release_lockspace(struct dlm_
 	 */
 
 	idr_for_each(&ls->ls_lkbidr, lkb_idr_free, ls);
-	idr_remove_all(&ls->ls_lkbidr);
 	idr_destroy(&ls->ls_lkbidr);
 
 	/*
diff -puN fs/dlm/recover.c~dlm-dont-use-idr_remove_all fs/dlm/recover.c
--- a/fs/dlm/recover.c~dlm-dont-use-idr_remove_all
+++ a/fs/dlm/recover.c
@@ -359,13 +359,13 @@ static void recover_idr_clear(struct dlm
 	spin_lock(&ls->ls_recover_idr_lock);
 
 	idr_for_each_entry(&ls->ls_recover_idr, r, id) {
+		idr_remove(&ls->ls_recover_idr, id);
 		r->res_id = 0;
 		r->res_recover_locks_count = 0;
 		ls->ls_recover_list_count--;
 
 		dlm_put_rsb(r);
 	}
-	idr_remove_all(&ls->ls_recover_idr);
 
 	if (ls->ls_recover_list_count != 0) {
 		log_error(ls, "warning: recover_list_count %d",
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
idr-make-idr_destroy-imply-idr_remove_all.patch
atm-nicstar-dont-use-idr_remove_all.patch
block-loop-dont-use-idr_remove_all.patch
firewire-dont-use-idr_remove_all.patch
drm-dont-use-idr_remove_all.patch
dm-dont-use-idr_remove_all.patch
remoteproc-dont-use-idr_remove_all.patch
rpmsg-dont-use-idr_remove_all.patch
dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch
dlm-dont-use-idr_remove_all.patch
nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
inotify-dont-use-idr_remove_all.patch
cgroup-dont-use-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch


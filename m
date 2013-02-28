From: akpm@linux-foundation.org
Subject: [merged] dlm-dont-use-idr_remove_all.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:47 -0800
Message-ID: <20130228201248.18FAE5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:42879 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122Ab3B1UMt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:49 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so244713vch.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, ccaulfie@redhat.com, teigland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dlm: don't use idr_remove_all()
has been removed from the -mm tree.  Its filename was
     dlm-dont-use-idr_remove_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: dlm: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.

The conversion isn't completely trivial for recover_idr_clear() as
it's the only place in kernel which makes legitimate use of
idr_remove_all() w/o idr_destroy().  Replace it with idr_remove() call
inside idr_for_each_entry() loop.  It goes on top so that it matches
the operation order in recover_idr_del().

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


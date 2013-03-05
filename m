From: akpm@linux-foundation.org
Subject: + nfsd-convert-to-idr_alloc.patch added to -mm tree
Date: Tue, 05 Mar 2013 14:08:10 -0800
Message-ID: <20130305220810.C568E5A41D3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:55008 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3CEWIL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 17:08:11 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so792085yen.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 14:08:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, bfields@fieldses.org


The patch titled
     Subject: nfsd: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     nfsd-convert-to-idr_alloc.patch

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
Subject: nfsd: convert to idr_alloc()

idr_get_new*() and friends are about to be deprecated.  Convert to the
new idr_alloc() interface.

Only compile-tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/nfsd/nfs4state.c~nfsd-convert-to-idr_alloc fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~nfsd-convert-to-idr_alloc
+++ a/fs/nfsd/nfs4state.c
@@ -242,9 +242,8 @@ kmem_cache *slab)
 	if (!stid)
 		return NULL;
 
-	if (!idr_pre_get(stateids, GFP_KERNEL))
-		goto out_free;
-	if (idr_get_new_above(stateids, stid, min_stateid, &new_id))
+	new_id = idr_alloc(stateids, stid, min_stateid, 0, GFP_KERNEL);
+	if (new_id < 0)
 		goto out_free;
 	stid->sc_client = cl;
 	stid->sc_type = 0;
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
idr-remove-warn_on_once-on-negative-ids.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
rtc-add-devm_rtc_device_registerunregister.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-remove-unused-get_new_stid.patch
nfsd-convert-to-idr_alloc.patch
workqueue-convert-to-idr_alloc.patch
mlx4-remove-leftover-idr_pre_get-call.patch
zcache-convert-to-idr_alloc.patch
tidspbridge-convert-to-idr_alloc.patch
idr-deprecate-idr_pre_get-and-idr_get_new.patch


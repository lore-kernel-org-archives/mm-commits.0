From: akpm@linux-foundation.org
Subject: [merged] nfsd-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 14 Mar 2013 11:52:19 -0700
Message-ID: <20130314185219.75AE15A41B0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:35037 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab3CNSwU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 14:52:20 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so80546vcb.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 11:52:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, bfields@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nfsd: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     nfsd-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: nfsd: convert to idr_alloc()

idr_get_new*() and friends are about to be deprecated.  Convert to the
new idr_alloc() interface.

Only compile-tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: J. Bruce Fields <bfields@redhat.com>
Tested-by: J. Bruce Fields <bfields@redhat.com>
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

origin.patch
linux-next.patch
thinkpad-acpi-kill-hotkey_thread_mutex.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memblock-add-assertion-for-zero-allocation-alignment.patch
rtc-add-devm_rtc_device_registerunregister.patch
rtc-use-struct-device-as-the-first-argument-for-devm_rtc_device_register.patch
kernel-sysc-use-the-simpler-call_usermodehelper.patch
usermodehelper-export-_exec-and-_setup-functions.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-introduce-dump_interrupted.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch


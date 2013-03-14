From: akpm@linux-foundation.org
Subject: [merged] nfsd-remove-unused-get_new_stid.patch removed from -mm tree
Date: Thu, 14 Mar 2013 11:52:16 -0700
Message-ID: <20130314185216.7215731C174@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:46933 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3CNSwR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 14:52:17 -0400
Received: by mail-gg0-f201.google.com with SMTP id l2so258730ggn.0
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 11:52:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, bfields@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nfsd: remove unused get_new_stid()
has been removed from the -mm tree.  Its filename was
     nfsd-remove-unused-get_new_stid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: nfsd: remove unused get_new_stid()

get_new_stid() is no longer used since 3abdb607125 ("nfsd4: simplify
idr allocation").  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |   31 -------------------------------
 1 file changed, 31 deletions(-)

diff -puN fs/nfsd/nfs4state.c~nfsd-remove-unused-get_new_stid fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~nfsd-remove-unused-get_new_stid
+++ a/fs/nfsd/nfs4state.c
@@ -230,37 +230,6 @@ static void nfs4_file_put_access(struct
 		__nfs4_file_put_access(fp, oflag);
 }
 
-static inline int get_new_stid(struct nfs4_stid *stid)
-{
-	static int min_stateid = 0;
-	struct idr *stateids = &stid->sc_client->cl_stateids;
-	int new_stid;
-	int error;
-
-	error = idr_get_new_above(stateids, stid, min_stateid, &new_stid);
-	/*
-	 * Note: the necessary preallocation was done in
-	 * nfs4_alloc_stateid().  The idr code caps the number of
-	 * preallocations that can exist at a time, but the state lock
-	 * prevents anyone from using ours before we get here:
-	 */
-	WARN_ON_ONCE(error);
-	/*
-	 * It shouldn't be a problem to reuse an opaque stateid value.
-	 * I don't think it is for 4.1.  But with 4.0 I worry that, for
-	 * example, a stray write retransmission could be accepted by
-	 * the server when it should have been rejected.  Therefore,
-	 * adopt a trick from the sctp code to attempt to maximize the
-	 * amount of time until an id is reused, by ensuring they always
-	 * "increase" (mod INT_MAX):
-	 */
-
-	min_stateid = new_stid+1;
-	if (min_stateid == INT_MAX)
-		min_stateid = 0;
-	return new_stid;
-}
-
 static struct nfs4_stid *nfs4_alloc_stid(struct nfs4_client *cl, struct
 kmem_cache *slab)
 {
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


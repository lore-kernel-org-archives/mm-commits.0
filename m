From: akpm@linux-foundation.org
Subject: + nfsd-remove-unused-get_new_stid.patch added to -mm tree
Date: Tue, 05 Mar 2013 14:08:08 -0800
Message-ID: <20130305220809.15BE35A41D3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:34530 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3CEWIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 17:08:10 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so791708vcd.3
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 14:08:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, bfields@redhat.com


The patch titled
     Subject: nfsd: remove unused get_new_stid()
has been added to the -mm tree.  Its filename is
     nfsd-remove-unused-get_new_stid.patch

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


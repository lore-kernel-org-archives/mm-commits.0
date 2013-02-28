From: akpm@linux-foundation.org
Subject: [merged] sctp-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:58 -0800
Message-ID: <20130228201558.E0D7D31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:47917 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441Ab3B1UP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:59 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so245127ggi.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, nhorman@tuxdriver.com, sri@us.ibm.com, vyasevich@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sctp: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     sctp-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: sctp: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/associola.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff -puN net/sctp/associola.c~sctp-convert-to-idr_alloc net/sctp/associola.c
--- a/net/sctp/associola.c~sctp-convert-to-idr_alloc
+++ a/net/sctp/associola.c
@@ -1591,32 +1591,31 @@ int sctp_assoc_lookup_laddr(struct sctp_
 /* Set an association id for a given association */
 int sctp_assoc_set_id(struct sctp_association *asoc, gfp_t gfp)
 {
-	int assoc_id;
-	int error = 0;
+	bool preload = gfp & __GFP_WAIT;
+	int ret;
 
 	/* If the id is already assigned, keep it. */
 	if (asoc->assoc_id)
-		return error;
-retry:
-	if (unlikely(!idr_pre_get(&sctp_assocs_id, gfp)))
-		return -ENOMEM;
+		return 0;
 
+	if (preload)
+		idr_preload(gfp);
 	spin_lock_bh(&sctp_assocs_id_lock);
-	error = idr_get_new_above(&sctp_assocs_id, (void *)asoc,
-				    idr_low, &assoc_id);
-	if (!error) {
-		idr_low = assoc_id + 1;
+	/* 0 is not a valid id, idr_low is always >= 1 */
+	ret = idr_alloc(&sctp_assocs_id, asoc, idr_low, 0, GFP_NOWAIT);
+	if (ret >= 0) {
+		idr_low = ret + 1;
 		if (idr_low == INT_MAX)
 			idr_low = 1;
 	}
 	spin_unlock_bh(&sctp_assocs_id_lock);
-	if (error == -EAGAIN)
-		goto retry;
-	else if (error)
-		return error;
+	if (preload)
+		idr_preload_end();
+	if (ret < 0)
+		return ret;
 
-	asoc->assoc_id = (sctp_assoc_t) assoc_id;
-	return error;
+	asoc->assoc_id = (sctp_assoc_t)ret;
+	return 0;
 }
 
 /* Free the ASCONF queue */
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


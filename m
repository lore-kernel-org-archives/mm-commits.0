From: akpm@linux-foundation.org
Subject: [merged] sctp-convert-sctp_assoc_set_id-to-use-idr_alloc_cyclic.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:14 -0700
Message-ID: <20130430190214.852A031C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:62240 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531Ab3D3TCQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:16 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so87500qea.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, davem@davemloft.net, nhorman@tuxdriver.com, sri@us.ibm.com, tj@kernel.org, vyasevich@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sctp: convert sctp_assoc_set_id() to use idr_alloc_cyclic()
has been removed from the -mm tree.  Its filename was
     sctp-convert-sctp_assoc_set_id-to-use-idr_alloc_cyclic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: sctp: convert sctp_assoc_set_id() to use idr_alloc_cyclic()

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/associola.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff -puN net/sctp/associola.c~sctp-convert-sctp_assoc_set_id-to-use-idr_alloc_cyclic net/sctp/associola.c
--- a/net/sctp/associola.c~sctp-convert-sctp_assoc_set_id-to-use-idr_alloc_cyclic
+++ a/net/sctp/associola.c
@@ -66,13 +66,6 @@ static void sctp_assoc_bh_rcv(struct wor
 static void sctp_assoc_free_asconf_acks(struct sctp_association *asoc);
 static void sctp_assoc_free_asconf_queue(struct sctp_association *asoc);
 
-/* Keep track of the new idr low so that we don't re-use association id
- * numbers too fast.  It is protected by they idr spin lock is in the
- * range of 1 - INT_MAX.
- */
-static u32 idr_low = 1;
-
-
 /* 1st Level Abstractions. */
 
 /* Initialize a new association from provided memory. */
@@ -1597,13 +1590,8 @@ int sctp_assoc_set_id(struct sctp_associ
 	if (preload)
 		idr_preload(gfp);
 	spin_lock_bh(&sctp_assocs_id_lock);
-	/* 0 is not a valid id, idr_low is always >= 1 */
-	ret = idr_alloc(&sctp_assocs_id, asoc, idr_low, 0, GFP_NOWAIT);
-	if (ret >= 0) {
-		idr_low = ret + 1;
-		if (idr_low == INT_MAX)
-			idr_low = 1;
-	}
+	/* 0 is not a valid assoc_id, must be >= 1 */
+	ret = idr_alloc_cyclic(&sctp_assocs_id, asoc, 1, 0, GFP_NOWAIT);
 	spin_unlock_bh(&sctp_assocs_id_lock);
 	if (preload)
 		idr_preload_end();
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
linux-next.patch


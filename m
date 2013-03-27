From: akpm@linux-foundation.org
Subject: + sctp-convert-sctp_assoc_set_id-to-use-idr_alloc_cyclic.patch added to -mm tree
Date: Wed, 27 Mar 2013 13:22:21 -0700
Message-ID: <20130327202221.D68F731C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:49782 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab3C0UWX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 16:22:23 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so326668ves.5
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 13:22:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, davem@davemloft.net, nhorman@tuxdriver.com, sri@us.ibm.com, tj@kernel.org, vyasevich@gmail.com


The patch titled
     Subject: sctp: convert sctp_assoc_set_id() to use idr_alloc_cyclic()
has been added to the -mm tree.  Its filename is
     sctp-convert-sctp_assoc_set_id-to-use-idr_alloc_cyclic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1601,13 +1594,8 @@ int sctp_assoc_set_id(struct sctp_associ
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
idr-introduce-idr_alloc_cyclic.patch
drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic.patch
drivers-infiniband-hw-mlx4-convert-to-using-idr_alloc_cyclic.patch
nfsd-convert-nfs4_alloc_stid-to-use-idr_alloc_cyclic.patch
inotify-convert-inotify_add_to_idr-to-use-idr_alloc_cyclic.patch
sctp-convert-sctp_assoc_set_id-to-use-idr_alloc_cyclic.patch


From: akpm@linux-foundation.org
Subject: + drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic.patch added to -mm tree
Date: Wed, 27 Mar 2013 13:22:13 -0700
Message-ID: <20130327202213.CF57B31C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:65006 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab3C0UWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 16:22:15 -0400
Received: by mail-ye0-f202.google.com with SMTP id l8so345531yen.3
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 13:22:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, swise@opengridcomputing.com, tj@kernel.org, tom@opengridcomputing.com


The patch titled
     Subject: drivers/infiniband/hw/amso1100: convert to using idr_alloc_cyclic
has been added to the -mm tree.  Its filename is
     drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic.patch

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
Subject: drivers/infiniband/hw/amso1100: convert to using idr_alloc_cyclic

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/amso1100/c2.h    |    1 -
 drivers/infiniband/hw/amso1100/c2_qp.c |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/infiniband/hw/amso1100/c2.h~drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic drivers/infiniband/hw/amso1100/c2.h
--- a/drivers/infiniband/hw/amso1100/c2.h~drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic
+++ a/drivers/infiniband/hw/amso1100/c2.h
@@ -265,7 +265,6 @@ struct c2_pd_table {
 struct c2_qp_table {
 	struct idr idr;
 	spinlock_t lock;
-	int last;
 };
 
 struct c2_element {
diff -puN drivers/infiniband/hw/amso1100/c2_qp.c~drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic drivers/infiniband/hw/amso1100/c2_qp.c
--- a/drivers/infiniband/hw/amso1100/c2_qp.c~drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic
+++ a/drivers/infiniband/hw/amso1100/c2_qp.c
@@ -385,8 +385,7 @@ static int c2_alloc_qpn(struct c2_dev *c
 	idr_preload(GFP_KERNEL);
 	spin_lock_irq(&c2dev->qp_table.lock);
 
-	ret = idr_alloc(&c2dev->qp_table.idr, qp, c2dev->qp_table.last++, 0,
-			GFP_NOWAIT);
+	ret = idr_alloc_cyclic(&c2dev->qp_table.idr, qp, 0, 0, GFP_NOWAIT);
 	if (ret >= 0)
 		qp->qpn = ret;
 
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


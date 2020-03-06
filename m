From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 05 Mar 2020 17:20:05 -0800
Message-ID: <20200306012005.Z5pqydhio%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgCFBUH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Mar 2020 20:20:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ti/k3-udma.c |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/drivers/dma/ti/k3-udma.c~linux-next-git-rejects
+++ a/drivers/dma/ti/k3-udma.c
@@ -149,10 +149,7 @@ struct udma_dev {
 
 	struct udma_chan *channels;
 	u32 psil_base;
-<<<<<<< HEAD
-=======
 	u32 atype;
->>>>>>> linux-next/akpm-base
 };
 
 struct udma_desc {
@@ -2495,7 +2492,6 @@ udma_prep_dma_cyclic_tr(struct udma_chan
 	period_addr = buf_addr;
 	for (i = 0; i < periods; i++) {
 		int tr_idx = i * num_tr;
-<<<<<<< HEAD
 
 		cppi5_tr_init(&tr_req[tr_idx].flags, CPPI5_TR_TYPE1, false,
 			      false, CPPI5_TR_EVENT_SIZE_COMPLETION, 0);
@@ -2510,22 +2506,6 @@ udma_prep_dma_cyclic_tr(struct udma_chan
 					 CPPI5_TR_CSF_SUPR_EVT);
 			tr_idx++;
 
-=======
-
-		cppi5_tr_init(&tr_req[tr_idx].flags, CPPI5_TR_TYPE1, false,
-			      false, CPPI5_TR_EVENT_SIZE_COMPLETION, 0);
-
-		tr_req[tr_idx].addr = period_addr;
-		tr_req[tr_idx].icnt0 = tr0_cnt0;
-		tr_req[tr_idx].icnt1 = tr0_cnt1;
-		tr_req[tr_idx].dim1 = tr0_cnt0;
-
-		if (num_tr == 2) {
-			cppi5_tr_csf_set(&tr_req[tr_idx].flags,
-					 CPPI5_TR_CSF_SUPR_EVT);
-			tr_idx++;

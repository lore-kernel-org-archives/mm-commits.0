From: akpm@linux-foundation.org
Subject: [merged] atm-nicstar-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:21 -0800
Message-ID: <20130228201321.CD4B531C211@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:49186 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3B1UNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:22 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so39444vbi.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, chas@cmf.nrl.navy.mil, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: atm/nicstar: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     atm-nicstar-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: atm/nicstar: convert to idr_alloc()

Convert to the much saner new idr interface.  The existing code looks
buggy to me - ID 0 is treated as no-ID but allocation specifies 0 as
lower limit and there's no error handling after partial success.  This
conversion keeps the bugs unchanged.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Chas Williams <chas@cmf.nrl.navy.mil>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/nicstar.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff -puN drivers/atm/nicstar.c~atm-nicstar-convert-to-idr_alloc drivers/atm/nicstar.c
--- a/drivers/atm/nicstar.c~atm-nicstar-convert-to-idr_alloc
+++ a/drivers/atm/nicstar.c
@@ -949,11 +949,10 @@ static void free_scq(ns_dev *card, scq_i
 static void push_rxbufs(ns_dev * card, struct sk_buff *skb)
 {
 	struct sk_buff *handle1, *handle2;
-	u32 id1 = 0, id2 = 0;
+	int id1, id2;
 	u32 addr1, addr2;
 	u32 stat;
 	unsigned long flags;
-	int err;
 
 	/* *BARF* */
 	handle2 = NULL;
@@ -1026,23 +1025,12 @@ static void push_rxbufs(ns_dev * card, s
 				card->lbfqc += 2;
 		}
 
-		do {
-			if (!idr_pre_get(&card->idr, GFP_ATOMIC)) {
-				printk(KERN_ERR
-				       "nicstar%d: no free memory for idr\n",
-				       card->index);
-				goto out;
-			}
-
-			if (!id1)
-				err = idr_get_new_above(&card->idr, handle1, 0, &id1);
-
-			if (!id2 && err == 0)
-				err = idr_get_new_above(&card->idr, handle2, 0, &id2);
-
-		} while (err == -EAGAIN);
+		id1 = idr_alloc(&card->idr, handle1, 0, 0, GFP_ATOMIC);
+		if (id1 < 0)
+			goto out;
 
-		if (err)
+		id2 = idr_alloc(&card->idr, handle2, 0, 0, GFP_ATOMIC);
+		if (id2 < 0)
 			goto out;
 
 		spin_lock_irqsave(&card->res_lock, flags);
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


From: akpm@linux-foundation.org
Subject: [merged] scsi-rename-random32-to-prandom_u32.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:50 -0700
Message-ID: <20130430190250.8019B5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:61082 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507Ab3D3TCv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:51 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so87634ggc.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, JBottomley@parallels.com, andrew.vasquez@qlogic.com, james.smart@emulex.com, robert.w.love@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: rename random32() to prandom_u32()
has been removed from the -mm tree.  Its filename was
     scsi-rename-random32-to-prandom_u32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: scsi: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: James Smart <james.smart@emulex.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/fcoe/fcoe_ctlr.c    |    4 ++--
 drivers/scsi/lpfc/lpfc_hbadisc.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/fcoe/fcoe_ctlr.c~scsi-rename-random32-to-prandom_u32 drivers/scsi/fcoe/fcoe_ctlr.c
--- a/drivers/scsi/fcoe/fcoe_ctlr.c~scsi-rename-random32-to-prandom_u32
+++ a/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2161,7 +2161,7 @@ static void fcoe_ctlr_vn_restart(struct
 
 	if (fip->probe_tries < FIP_VN_RLIM_COUNT) {
 		fip->probe_tries++;
-		wait = random32() % FIP_VN_PROBE_WAIT;
+		wait = prandom_u32() % FIP_VN_PROBE_WAIT;
 	} else
 		wait = FIP_VN_RLIM_INT;
 	mod_timer(&fip->timer, jiffies + msecs_to_jiffies(wait));
@@ -2794,7 +2794,7 @@ static void fcoe_ctlr_vn_timeout(struct
 					  fcoe_all_vn2vn, 0);
 			fip->port_ka_time = jiffies +
 				 msecs_to_jiffies(FIP_VN_BEACON_INT +
-					(random32() % FIP_VN_BEACON_FUZZ));
+					(prandom_u32() % FIP_VN_BEACON_FUZZ));
 		}
 		if (time_before(fip->port_ka_time, next_time))
 			next_time = fip->port_ka_time;
diff -puN drivers/scsi/lpfc/lpfc_hbadisc.c~scsi-rename-random32-to-prandom_u32 drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c~scsi-rename-random32-to-prandom_u32
+++ a/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1735,7 +1735,7 @@ lpfc_check_pending_fcoe_event(struct lpf
  * use through a sequence of @fcf_cnt eligible FCF records with equal
  * probability. To perform integer manunipulation of random numbers with
  * size unit32_t, the lower 16 bits of the 32-bit random number returned
- * from random32() are taken as the random random number generated.
+ * from prandom_u32() are taken as the random random number generated.
  *
  * Returns true when outcome is for the newly read FCF record should be
  * chosen; otherwise, return false when outcome is for keeping the previously
@@ -1747,7 +1747,7 @@ lpfc_sli4_new_fcf_random_select(struct l
 	uint32_t rand_num;
 
 	/* Get 16-bit uniform random number */
-	rand_num = (0xFFFF & random32());
+	rand_num = 0xFFFF & prandom_u32();
 
 	/* Decision with probability 1/fcf_cnt */
 	if ((fcf_cnt * rand_num) < 0xFFFF)
@@ -2385,7 +2385,7 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 		phba->fcf.eligible_fcf_cnt = 1;
 		/* Seeding the random number generator for random selection */
 		seed = (uint32_t)(0xFFFFFFFF & jiffies);
-		srandom32(seed);
+		prandom_seed(seed);
 	}
 	spin_unlock_irq(&phba->hbalock);
 	goto read_next_fcf;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
remove-unused-random32-and-srandom32.patch
notifier-error-inject-fix-module-names-in-kconfig.patch


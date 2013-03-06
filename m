From: akpm@linux-foundation.org
Subject: + scsi-rename-random32-to-prandom_u32.patch added to -mm tree
Date: Tue, 05 Mar 2013 17:02:17 -0800
Message-ID: <20130306010217.D1F395A41EB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:62923 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab3CFBCT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 20:02:19 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so809913qen.2
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 17:02:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, JBottomley@parallels.com, andrew.vasquez@qlogic.com, james.smart@emulex.com, robert.w.love@intel.com


The patch titled
     Subject: scsi: rename random32() to prandom_u32()
has been added to the -mm tree.  Its filename is
     scsi-rename-random32-to-prandom_u32.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 drivers/scsi/qla2xxx/qla_attr.c  |    7 +++++--
 3 files changed, 10 insertions(+), 7 deletions(-)

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
@@ -1732,7 +1732,7 @@ lpfc_check_pending_fcoe_event(struct lpf
  * use through a sequence of @fcf_cnt eligible FCF records with equal
  * probability. To perform integer manunipulation of random numbers with
  * size unit32_t, the lower 16 bits of the 32-bit random number returned
- * from random32() are taken as the random random number generated.
+ * from prandom_u32() are taken as the random random number generated.
  *
  * Returns true when outcome is for the newly read FCF record should be
  * chosen; otherwise, return false when outcome is for keeping the previously
@@ -1744,7 +1744,7 @@ lpfc_sli4_new_fcf_random_select(struct l
 	uint32_t rand_num;
 
 	/* Get 16-bit uniform random number */
-	rand_num = (0xFFFF & random32());
+	rand_num = 0xFFFF & prandom_u32();
 
 	/* Decision with probability 1/fcf_cnt */
 	if ((fcf_cnt * rand_num) < 0xFFFF)
@@ -2380,7 +2380,7 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 		phba->fcf.eligible_fcf_cnt = 1;
 		/* Seeding the random number generator for random selection */
 		seed = (uint32_t)(0xFFFFFFFF & jiffies);
-		srandom32(seed);
+		prandom_seed(seed);
 	}
 	spin_unlock_irq(&phba->hbalock);
 	goto read_next_fcf;
diff -puN drivers/scsi/qla2xxx/qla_attr.c~scsi-rename-random32-to-prandom_u32 drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c~scsi-rename-random32-to-prandom_u32
+++ a/drivers/scsi/qla2xxx/qla_attr.c
@@ -1940,8 +1940,11 @@ qla24xx_vport_delete(struct fc_vport *fc
 
 	/* No pending activities shall be there on the vha now */
 	if (ql2xextended_error_logging & ql_dbg_user)
-		msleep(random32()%10);  /* Just to see if something falls on
-					* the net we have placed below */
+		msleep(prandom_u32() % 10);
+		/*
+		 * Just to see if something falls on the net we have placed
+		 * below
+		 */
 
 	BUG_ON(atomic_read(&vha->vref_count));
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
raid6test-use-prandom_bytes.patch
uuid-use-prandom_bytes.patch
x86-pageattr-test-remove-srandom32-call.patch
x86-rename-random32-to-prandom_u32.patch
lib-rename-random32-to-prandom_u32.patch
mm-rename-random32-to-prandom_u32.patch
kernel-rename-random32-to-prandom_u32.patch
drbd-rename-random32-to-prandom_u32.patch
infiniband-rename-random32-to-prandom_u32.patch
mmc-rename-random32-to-prandom_u32.patch
video-uvesafb-rename-random32-to-prandom_u32.patch
xfs-rename-random32-to-prandom_u32.patch
uwb-rename-random32-to-prandom_u32.patch
lguest-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32.patch
net-sunrpc-rename-random32-to-prandom_u32.patch
net-sched-rename-random32-to-prandom_u32.patch
net-netfilter-rename-random32-to-prandom_u32.patch
net-core-rename-random32-to-prandom_u32.patch
net-core-remove-duplicate-statements-by-do-while-loop.patch
net-rename-random32-to-prandom.patch
remove-unused-random32-and-srandom32.patch


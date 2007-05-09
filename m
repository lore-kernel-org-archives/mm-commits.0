From: akpm@linux-foundation.org
Subject: - replace-deprecated-sa_xxx-interrupt-flags.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:57 -0700
Message-ID: <200705090248.l492mvAM009168@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbXEICtD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Replace deprecated SA_xxx interrupt flags
has been removed from the -mm tree.  Its filename was
     replace-deprecated-sa_xxx-interrupt-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Replace deprecated SA_xxx interrupt flags
From: Thomas Gleixner <tglx@linutronix.de>

Fix the last users of the deprecated SA_xxx interrupt flags.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/sni/irq.c       |    2 +-
 drivers/scsi/sni_53c710.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/mips/sni/irq.c~replace-deprecated-sa_xxx-interrupt-flags arch/mips/sni/irq.c
--- a/arch/mips/sni/irq.c~replace-deprecated-sa_xxx-interrupt-flags
+++ a/arch/mips/sni/irq.c
@@ -42,7 +42,7 @@ static irqreturn_t sni_isa_irq_handler(i
 struct irqaction sni_isa_irq = {
 	.handler = sni_isa_irq_handler,
 	.name = "ISA",
-	.flags = SA_SHIRQ
+	.flags = IRQF_SHARED
 };
 
 /*
diff -puN drivers/scsi/sni_53c710.c~replace-deprecated-sa_xxx-interrupt-flags drivers/scsi/sni_53c710.c
--- a/drivers/scsi/sni_53c710.c~replace-deprecated-sa_xxx-interrupt-flags
+++ a/drivers/scsi/sni_53c710.c
@@ -98,7 +98,7 @@ static int __init snirm710_probe(struct 
 	host->this_id = 7;
 	host->base = base;
 	host->irq = platform_get_irq(dev, 0);
-	if(request_irq(host->irq, NCR_700_intr, SA_SHIRQ, "snirm710", host)) {
+	if(request_irq(host->irq, NCR_700_intr, IRQF_SHARED, "snirm710", host)) {
 		printk(KERN_ERR "snirm710: request_irq failed!\n");
 		goto out_put_host;
 	}
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
arm-spinlock-initializer-cleanup.patch
git-avr32.patch
drm-spinlock-initializer-cleanup.patch
git-dvb.patch
git-ieee1394.patch
git-mtd.patch
s390-spinlock-initializer-cleanup.patch
fix-printk-format-warnings-in-timer_listc.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
declare-struct-ktime.patch
timer-parenthesis-fix-in-tbase_get_deferrable-etc.patch
clocksource-fix-resume-logic.patch
clockevents-fix-resume-logic-updated-version.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch

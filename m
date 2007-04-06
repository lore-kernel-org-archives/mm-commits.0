From: akpm@linux-foundation.org
Subject: + replace-deprecated-sa_xxx-interrupt-flags.patch added to -mm tree
Date: Fri, 06 Apr 2007 13:15:43 -0700
Message-ID: <200704062015.l36KFh4b018019@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32984 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbXDFUPr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 16:15:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de


The patch titled
     Replace deprecated SA_xxx interrupt flags
has been added to the -mm tree.  Its filename is
     replace-deprecated-sa_xxx-interrupt-flags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-ieee1394.patch
optimize-timespec_trunc.patch
kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-tidy.patch
add-support-for-deferrable-timers-respun-fix.patch
irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
move-timekeeping-code-to-timekeepingc.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
replace-deprecated-sa_xxx-interrupt-flags.patch
deprecate-sa_xxx-interrupt-flags-v2.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
declare-struct-ktime.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch

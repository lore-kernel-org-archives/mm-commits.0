From: akpm@linux-foundation.org
Subject: + vioc-replace-more-deprecated-sa_xxx-interrupt-flags.patch added to -mm tree
Date: Fri, 06 Apr 2007 13:42:38 -0700
Message-ID: <200704062042.l36Kgcca018483@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33834 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932794AbXDFUms (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 16:42:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, jeff@garzik.org, schidambaram@fabric7.com


The patch titled
     vioc: replace more deprecated SA_xxx interrupt flags
has been added to the -mm tree.  Its filename is
     vioc-replace-more-deprecated-sa_xxx-interrupt-flags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vioc: replace more deprecated SA_xxx interrupt flags
From: Thomas Gleixner <tglx@linutronix.de>

Fix the obnoxious users of the deprecated SA_xxx interrupt flags.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Sriram Chidambaram <schidambaram@fabric7.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/vioc/vioc_irq.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/vioc/vioc_irq.c~vioc-replace-more-deprecated-sa_xxx-interrupt-flags drivers/net/vioc/vioc_irq.c
--- a/drivers/net/vioc/vioc_irq.c~vioc-replace-more-deprecated-sa_xxx-interrupt-flags
+++ a/drivers/net/vioc/vioc_irq.c
@@ -319,7 +319,7 @@ static int vioc_irq_install(struct pci_d
 
 	ret = request_irq(vioc_interrupts[vioc_id].intreq[intr_id].irq,
 			  vioc_interrupts[vioc_id].intreq[intr_id].hthandler,
-			  SA_INTERRUPT,
+			  IRQF_DISABLED,
 			  vioc_interrupts[vioc_id].intreq[intr_id].name,
 			  vioc_interrupts[vioc_id].intreq[intr_id].
 			  intrFuncparm);
_

Patches currently in -mm which might be from tglx@linutronix.de are

i2c-replace-more-deprecated-sa_xxx-interrupt-flags.patch
git-ieee1394.patch
vioc-replace-more-deprecated-sa_xxx-interrupt-flags.patch
input-replace-more-deprecated-sa_xxx-interrupt-flags.patch
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

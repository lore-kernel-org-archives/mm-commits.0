From: akpm@linux-foundation.org
Subject: + s390-spinlock-initializer-cleanup.patch added to -mm tree
Date: Thu, 03 May 2007 23:36:13 -0700
Message-ID: <200705040636.l446aD8W030716@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423592AbXEDGg0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:36:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, heiko.carstens@de.ibm.com, jeff@garzik.org, schwidefsky@de.ibm.com


The patch titled
     S390: Spinlock initializer cleanup
has been added to the -mm tree.  Its filename is
     s390-spinlock-initializer-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: S390: Spinlock initializer cleanup
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/net/netiucv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/s390/net/netiucv.c~s390-spinlock-initializer-cleanup drivers/s390/net/netiucv.c
--- a/drivers/s390/net/netiucv.c~s390-spinlock-initializer-cleanup
+++ a/drivers/s390/net/netiucv.c
@@ -212,7 +212,7 @@ struct iucv_connection {
  */
 static struct list_head iucv_connection_list =
 	LIST_HEAD_INIT(iucv_connection_list);
-static rwlock_t iucv_connection_rwlock = RW_LOCK_UNLOCKED;
+DEFINE_RWLOCK(iucv_connection_rwlock);
 
 /**
  * Representation of event-data for the
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
h8300-generic-irq.patch
git-arm.patch
git-avr32.patch
git-dvb.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
optimize-timespec_trunc.patch
kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
add-support-for-deferrable-timers-respun.patch
irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
move-timekeeping-code-to-timekeepingc.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
replace-deprecated-sa_xxx-interrupt-flags.patch
deprecate-sa_xxx-interrupt-flags-v2.patch
pad-irq_desc-to-internode-cacheline-size.patch
highres-dyntick-prevent-xtime-lock-contention.patch
introduce-a-handy-list_first_entry-macro-v2.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
clockchipsh-kernel-doc-fix.patch
export-hrtimer_forward.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
declare-struct-ktime.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
clocksource-fix-resume-logic.patch
acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set.patch
acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set-vs-x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch
clockevents-fix-resume-logic.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
arm-spinlock-initializer-cleanup.patch
drm-spinlock-initializer-cleanup.patch
isdn-spinlock-initializer-cleanup.patch
s390-spinlock-initializer-cleanup.patch

From: akpm@linux-foundation.org
Subject: - i386-use-the-right-wrapper-to-disable-the-nmi-watchdog.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:26:57 -0700
Message-ID: <200706231926.l5NJQvDm022017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42467 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753407AbXFWT1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:27:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: B.Steinbrink@gmx.de, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: use the right wrapper to disable the NMI watchdog
has been removed from the -mm tree.  Its filename was
     i386-use-the-right-wrapper-to-disable-the-nmi-watchdog.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: use the right wrapper to disable the NMI watchdog
From: Bjorn Steinbrink <B.Steinbrink@gmx.de>

When disabled through /proc/sys/kernel/nmi_watchdog, the NMI watchdog uses the
stop() method directly, which does not decrement the activity counter, leading
to a BUG().  Use the wrapper function instead to fix that.

Signed-off-by: Bjorn Steinbrink <B.Steinbrink@gmx.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/perfctr-watchdog.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/cpu/perfctr-watchdog.c~i386-use-the-right-wrapper-to-disable-the-nmi-watchdog arch/i386/kernel/cpu/perfctr-watchdog.c
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c~i386-use-the-right-wrapper-to-disable-the-nmi-watchdog
+++ a/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -28,7 +28,7 @@ struct wd_ops {
 	void (*unreserve)(void);
 	int (*setup)(unsigned nmi_hz);
 	void (*rearm)(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz);
-	void (*stop)(void *);
+	void (*stop)(void);
 	unsigned perfctr;
 	unsigned evntsel;
 	u64 checkbit;
@@ -142,7 +142,7 @@ void disable_lapic_nmi_watchdog(void)
 	if (atomic_read(&nmi_active) <= 0)
 		return;
 
-	on_each_cpu(wd_ops->stop, NULL, 0, 1);
+	on_each_cpu(stop_apic_nmi_watchdog, NULL, 0, 1);
 	wd_ops->unreserve();
 
 	BUG_ON(atomic_read(&nmi_active) != 0);
@@ -255,7 +255,7 @@ static int setup_k7_watchdog(unsigned nm
 	return 1;
 }
 
-static void single_msr_stop_watchdog(void *arg)
+static void single_msr_stop_watchdog(void)
 {
 	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 
@@ -442,7 +442,7 @@ static int setup_p4_watchdog(unsigned nm
 	return 1;
 }
 
-static void stop_p4_watchdog(void *arg)
+static void stop_p4_watchdog(void)
 {
 	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 	wrmsr(wd->cccr_msr, 0, 0);
@@ -634,7 +634,7 @@ int lapic_watchdog_init(unsigned nmi_hz)
 void lapic_watchdog_stop(void)
 {
 	if (wd_ops)
-		wd_ops->stop(NULL);
+		wd_ops->stop();
 }
 
 unsigned lapic_adjust_nmi_hz(unsigned hz)
_

Patches currently in -mm which might be from B.Steinbrink@gmx.de are

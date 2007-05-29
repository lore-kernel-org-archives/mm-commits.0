From: akpm@linux-foundation.org
Subject: - ignore-bogus-acpi-info-for-offline-cpus.patch removed from -mm tree
Date: Tue, 29 May 2007 11:50:25 -0700
Message-ID: <200705291850.l4TIoOdr008259@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415AbXE2SvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:51:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Ignore bogus ACPI info for offline CPUs
has been removed from the -mm tree.  Its filename was
     ignore-bogus-acpi-info-for-offline-cpus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Ignore bogus ACPI info for offline CPUs
From: Thomas Gleixner <tglx@linutronix.de>

Booting a SMP kernel with maxcpus=1 on a SMP system leads to a hard hang,
because ACPI ignores the maxcpus setting and sends timer broadcast info for
the offline CPUs.  This results in a stuck for ever call to
smp_call_function_single() on an offline CPU.

Ignore the bogus information and print a kernel error to remind ACPI
folks to fix it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-broadcast.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff -puN kernel/time/tick-broadcast.c~ignore-bogus-acpi-info-for-offline-cpus kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~ignore-bogus-acpi-info-for-offline-cpus
+++ a/kernel/time/tick-broadcast.c
@@ -243,11 +243,18 @@ void tick_broadcast_on_off(unsigned long
 {
 	int cpu = get_cpu();
 
-	if (cpu == *oncpu)
-		tick_do_broadcast_on_off(&reason);
-	else
-		smp_call_function_single(*oncpu, tick_do_broadcast_on_off,
-					 &reason, 1, 1);
+	if (!cpu_isset(*oncpu, cpu_online_map)) {
+		printk(KERN_ERR "tick-braodcast: ignoring broadcast for "
+		       "offline CPU #%d\n", *oncpu);
+	} else {
+
+		if (cpu == *oncpu)
+			tick_do_broadcast_on_off(&reason);
+		else
+			smp_call_function_single(*oncpu,
+						 tick_do_broadcast_on_off,
+						 &reason, 1, 1);
+	}
 	put_cpu();
 }
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

git-drm.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch

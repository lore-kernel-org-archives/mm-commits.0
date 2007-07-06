From: akpm@linux-foundation.org
Subject: - reserve-the-right-performance-counter-for-the-intel-perfmon-nmi-watchdog.patch removed from -mm tree
Date: Thu, 05 Jul 2007 17:52:32 -0700
Message-ID: <200707060052.l660qWUY028379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58641 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759685AbXGFA7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 20:59:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: B.Steinbrink@gmx.de, ak@suse.de, eranian@hpl.hp.com, levon@movementarian.org, phil.el@wanadoo.fr, mm-commits@vger.kernel.org


The patch titled
     x86: reserve the right performance counter for the Intel PerfMon N=
MI watchdog
has been removed from the -mm tree.  Its filename was
     reserve-the-right-performance-counter-for-the-intel-perfmon-nmi-wa=
tchdog.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: x86: reserve the right performance counter for the Intel PerfM=
on NMI watchdog
=46rom: Bj=F6rn Steinbrink <B.Steinbrink@gmx.de>

The Intel PerfMon NMI watchdog was using the generic reservation functi=
on
which always reserves the first performance counter.  But the watchdog
actually uses the second performance counter, thus we need a specialise=
d
function.

Signed-off-by: Bj=F6rn Steinbrink <B.Steinbrink@gmx.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Stephane Eranian <eranian@hpl.hp.com>
Cc: John Levon <levon@movementarian.org>
Cc: Philippe Elie <phil.el@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/perfctr-watchdog.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/cpu/perfctr-watchdog.c~reserve-the-right-per=
formance-counter-for-the-intel-perfmon-nmi-watchdog arch/i386/kernel/cp=
u/perfctr-watchdog.c
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c~reserve-the-right-perform=
ance-counter-for-the-intel-perfmon-nmi-watchdog
+++ a/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -562,9 +562,27 @@ static int setup_intel_arch_watchdog(uns
 	return 1;
 }
=20
+static int intel_arch_reserve(void)
+{
+	if (!reserve_perfctr_nmi(MSR_ARCH_PERFMON_PERFCTR1))
+		return 0;
+
+	if (!reserve_evntsel_nmi(MSR_ARCH_PERFMON_EVENTSEL1)) {
+		release_perfctr_nmi(MSR_ARCH_PERFMON_PERFCTR1);
+		return 0;
+	}
+	return 1;
+}
+
+static void intel_arch_unreserve(void)
+{
+	release_evntsel_nmi(MSR_ARCH_PERFMON_EVENTSEL1);
+	release_perfctr_nmi(MSR_ARCH_PERFMON_PERFCTR1);
+}
+
 static struct wd_ops intel_arch_wd_ops =3D {
-	.reserve =3D single_msr_reserve,
-	.unreserve =3D single_msr_unreserve,
+	.reserve =3D intel_arch_reserve,
+	.unreserve =3D intel_arch_unreserve,
 	.setup =3D setup_intel_arch_watchdog,
 	.rearm =3D p6_rearm,
 	.stop =3D single_msr_stop_watchdog,
_

Patches currently in -mm which might be from B.Steinbrink@gmx.de are

origin.patch
replace-obscure-constructs-in-fs-block_devc.patch
replace-obscure-constructs-in-fs-block_devc-fix.patch
bd_claim_by_disk-fix-warning.patch

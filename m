From: akpm@linux-foundation.org
Subject: + always-probe-the-nmi-watchdog.patch added to -mm tree
Date: Mon, 25 Jun 2007 12:07:32 -0700
Message-ID: <200706251907.l5PJ7WOT008582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51009 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286AbXFYTId (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 15:08:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: B.Steinbrink@gmx.de, ak@suse.de, eranian@hpl.hp.com, levon@movementarian.org, phil.el@wanadoo.fr


The patch titled
     x86: Always probe the NMI watchdog
has been added to the -mm tree.  Its filename is
     always-probe-the-nmi-watchdog.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: x86: Always probe the NMI watchdog
=46rom: Bj=F6rn Steinbrink <B.Steinbrink@gmx.de>

The performance counter allocator relies on the nmi watchdog being prob=
ed, so
we have to do that even if the watchdog is not enabled.

Signed-off-by: Bj=F6rn Steinbrink <B.Steinbrink@gmx.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Stephane Eranian <eranian@hpl.hp.com>
Cc: John Levon <levon@movementarian.org>
Cc: Philippe Elie <phil.el@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/perfctr-watchdog.c |   11 +++++------
 arch/i386/kernel/nmi.c                  |    3 +++
 arch/x86_64/kernel/nmi.c                |    3 +++
 include/asm-i386/nmi.h                  |    1 +
 include/asm-x86_64/nmi.h                |    1 +
 5 files changed, 13 insertions(+), 6 deletions(-)

diff -puN arch/i386/kernel/cpu/perfctr-watchdog.c~always-probe-the-nmi-=
watchdog arch/i386/kernel/cpu/perfctr-watchdog.c
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c~always-probe-the-nmi-watc=
hdog
+++ a/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -572,7 +572,7 @@ static struct wd_ops intel_arch_wd_ops =3D
 	.evntsel =3D MSR_ARCH_PERFMON_EVENTSEL0,
 };
=20
-static void probe_nmi_watchdog(void)
+void probe_nmi_watchdog(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
@@ -610,17 +610,16 @@ static void probe_nmi_watchdog(void)
=20
 int lapic_watchdog_init(unsigned nmi_hz)
 {
-	if (!wd_ops) {
-		probe_nmi_watchdog();
-		if (!wd_ops)
-			return -1;
+	if (!wd_ops)
+		return -1;
=20
+	/* hack to make sure that we only try to reserver the perfctrs once *=
/
+	if (smp_processor_id() =3D=3D 0)
 		if (!wd_ops->reserve()) {
 			printk(KERN_ERR
 				"NMI watchdog: cannot reserve perfctrs\n");
 			return -1;
 		}
-	}
=20
 	if (!(wd_ops->setup(nmi_hz))) {
 		printk(KERN_ERR "Cannot setup NMI watchdog on CPU %d\n",
diff -puN arch/i386/kernel/nmi.c~always-probe-the-nmi-watchdog arch/i38=
6/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c~always-probe-the-nmi-watchdog
+++ a/arch/i386/kernel/nmi.c
@@ -248,6 +248,9 @@ void setup_apic_nmi_watchdog (void *unus
 	if ((smp_processor_id() !=3D 0) && (atomic_read(&nmi_active) <=3D 0))
 		return;
=20
+	/* always probe the watchdog, the perfctr allocator requires that */
+	probe_nmi_watchdog();
+
 	switch (nmi_watchdog) {
 	case NMI_LOCAL_APIC:
 		__get_cpu_var(wd_enabled) =3D 1; /* enable it before to avoid race w=
ith handler */
diff -puN arch/x86_64/kernel/nmi.c~always-probe-the-nmi-watchdog arch/x=
86_64/kernel/nmi.c
--- a/arch/x86_64/kernel/nmi.c~always-probe-the-nmi-watchdog
+++ a/arch/x86_64/kernel/nmi.c
@@ -255,6 +255,9 @@ void setup_apic_nmi_watchdog(void *unuse
 	if ((smp_processor_id() !=3D 0) && (atomic_read(&nmi_active) <=3D 0))
 		return;
=20
+	/* always probe the watchdog, the perfctr allocator requires that */
+	probe_nmi_watchdog();
+
 	switch (nmi_watchdog) {
 	case NMI_LOCAL_APIC:
 		__get_cpu_var(wd_enabled) =3D 1;
diff -puN include/asm-i386/nmi.h~always-probe-the-nmi-watchdog include/=
asm-i386/nmi.h
--- a/include/asm-i386/nmi.h~always-probe-the-nmi-watchdog
+++ a/include/asm-i386/nmi.h
@@ -18,6 +18,7 @@
 int do_nmi_callback(struct pt_regs *regs, int cpu);
=20
 extern int nmi_watchdog_enabled;
+extern void probe_nmi_watchdog(void);
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int avail_to_resrv_perfctr_nmi(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
diff -puN include/asm-x86_64/nmi.h~always-probe-the-nmi-watchdog includ=
e/asm-x86_64/nmi.h
--- a/include/asm-x86_64/nmi.h~always-probe-the-nmi-watchdog
+++ a/include/asm-x86_64/nmi.h
@@ -45,6 +45,7 @@ extern int panic_on_timeout;
 extern int unknown_nmi_panic;
 extern int nmi_watchdog_enabled;
=20
+extern void probe_nmi_watchdog(void);
 extern int check_nmi_watchdog(void);
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int avail_to_resrv_perfctr_nmi(unsigned int);
_

Patches currently in -mm which might be from B.Steinbrink@gmx.de are

always-probe-the-nmi-watchdog.patch
reserve-the-right-performance-counter-for-the-intel-perfmon-nmi-watchdo=
g.patch

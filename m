From: akpm@linux-foundation.org
Subject: - allow-boot-time-disable-of-paravirt_ops-patching.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:55:07 -0700
Message-ID: <200704281055.l3SAt7CS020155@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031520AbXD1KzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, jeremy@xensource.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Allow boot-time disable of paravirt_ops patching
has been removed from the -mm tree.  Its filename was
     allow-boot-time-disable-of-paravirt_ops-patching.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Allow boot-time disable of paravirt_ops patching
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add "noreplace-paravirt" to disable paravirt_ops patching.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 +++
 arch/i386/kernel/alternative.c      |   13 +++++++++++++
 2 files changed, 16 insertions(+)

diff -puN Documentation/kernel-parameters.txt~allow-boot-time-disable-of-paravirt_ops-patching Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~allow-boot-time-disable-of-paravirt_ops-patching
+++ a/Documentation/kernel-parameters.txt
@@ -64,6 +64,7 @@ parameter is applicable:
 	GENERIC_TIME The generic timeofday code is enabled.
 	NFS	Appropriate NFS support is enabled.
 	OSS	OSS sound support is enabled.
+	PV_OPS	A paravirtualized kernel
 	PARIDE	The ParIDE subsystem is enabled.
 	PARISC	The PA-RISC architecture is enabled.
 	PCI	PCI bus support is enabled.
@@ -1164,6 +1165,8 @@ and is between 256 and 4096 characters. 
 
 	nomce		[IA-32] Machine Check Exception
 
+	noreplace-paravirt	[IA-32,PV_OPS] Don't patch paravirt_ops
+
 	noreplace-smp	[IA-32,SMP] Don't replace SMP instructions
 			with UP alternatives
 
diff -puN arch/i386/kernel/alternative.c~allow-boot-time-disable-of-paravirt_ops-patching arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~allow-boot-time-disable-of-paravirt_ops-patching
+++ a/arch/i386/kernel/alternative.c
@@ -30,6 +30,16 @@ static int __init setup_noreplace_smp(ch
 }
 __setup("noreplace-smp", setup_noreplace_smp);
 
+#ifdef CONFIG_PARAVIRT
+static int noreplace_paravirt = 0;
+
+static int __init setup_noreplace_paravirt(char *str)
+{
+	noreplace_paravirt = 1;
+	return 1;
+}
+__setup("noreplace-paravirt", setup_noreplace_paravirt);
+#endif
 
 #define DPRINTK(fmt, args...) if (debug_alternative) \
 	printk(KERN_DEBUG fmt, args)
@@ -330,6 +340,9 @@ void apply_paravirt(struct paravirt_patc
 {
 	struct paravirt_patch_site *p;
 
+	if (noreplace_paravirt)
+		return;
+
 	for (p = start; p < end; p++) {
 		unsigned int used;
 
_

Patches currently in -mm which might be from jeremy@goop.org are

add-kvasprintf.patch
add-kvasprintf-fix.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
add-touch_all_softlockup_watchdogs.patch
deflate-inflate_dynamic-too.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch

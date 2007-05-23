From: akpm@linux-foundation.org
Subject: + i386-bigsmp-section-mismatch-fixes.patch added to -mm tree
Date: Wed, 23 May 2007 11:33:52 -0700
Message-ID: <200705231833.l4NIXpug029272@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755863AbXEWSeu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 14:34:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wli@holomorphy.com, ak@suse.de, bill.irwin@oracle.com


The patch titled
     i386 bigsmp: section mismatch fixes
has been added to the -mm tree.  Its filename is
     i386-bigsmp-section-mismatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 bigsmp: section mismatch fixes
From: William Lee Irwin III <wli@holomorphy.com>

WARNING: arch/i386/mach-generic/built-in.o(.data+0xc4): Section mismatch: reference to .init.text: (between 'apic_bigsmp' and 'cpu.4905')
This appears to be resolvable by removing all the __init and __initdata
qualifiers from arch/i386/mach-generic/bigsmp.c

Signed-off-by: William Irwin <bill.irwin@oracle.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mach-generic/bigsmp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/i386/mach-generic/bigsmp.c~i386-bigsmp-section-mismatch-fixes arch/i386/mach-generic/bigsmp.c
--- a/arch/i386/mach-generic/bigsmp.c~i386-bigsmp-section-mismatch-fixes
+++ a/arch/i386/mach-generic/bigsmp.c
@@ -21,7 +21,7 @@
 
 static int dmi_bigsmp; /* can be set by dmi scanners */
 
-static __init int hp_ht_bigsmp(struct dmi_system_id *d)
+static int hp_ht_bigsmp(struct dmi_system_id *d)
 {
 #ifdef CONFIG_X86_GENERICARCH
 	printk(KERN_NOTICE "%s detected: force use of apic=bigsmp\n", d->ident);
@@ -31,7 +31,7 @@ static __init int hp_ht_bigsmp(struct dm
 }
 
 
-static struct dmi_system_id __initdata bigsmp_dmi_table[] = {
+static struct dmi_system_id bigsmp_dmi_table[] = {
 	{ hp_ht_bigsmp, "HP ProLiant DL760 G2", {
 		DMI_MATCH(DMI_BIOS_VENDOR, "HP"),
 		DMI_MATCH(DMI_BIOS_VERSION, "P44-"),
@@ -45,7 +45,7 @@ static struct dmi_system_id __initdata b
 };
 
 
-static int __init probe_bigsmp(void)
+static int probe_bigsmp(void)
 { 
 	if (def_to_bigsmp)
         	dmi_bigsmp = 1;
_

Patches currently in -mm which might be from wli@holomorphy.com are

quicklist-support-for-x86_64.patch
x86_64-support-poll-on-dev-mcelog-fix.patch
i386-bigsmp-section-mismatch-fixes.patch
rework-ptep_set_access_flags-and-fix-sun4c.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch

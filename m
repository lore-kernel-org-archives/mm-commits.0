From: akpm@linux-foundation.org
Subject: - fix-mtrr-sections.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:55:10 -0700
Message-ID: <200704281055.l3SAtAte020158@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031522AbXD1KzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:55:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     fix mtrr sections
has been removed from the -mm tree.  Its filename was
     fix-mtrr-sections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix mtrr sections
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warnings in mtrr code.
Fix line length on one source line.

WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data: from .text.get_mtrr_state after 'get_mtrr_state' (at offset 0x103)
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text: from .text.get_mtrr_state after 'get_mtrr_state' (at offset 0x180)
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text: from .text.get_mtrr_state after 'get_mtrr_state' (at offset 0x199)
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text: from .text.get_mtrr_state after 'get_mtrr_state' (at offset 0x1c1)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/generic.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/cpu/mtrr/generic.c~fix-mtrr-sections arch/i386/kernel/cpu/mtrr/generic.c
--- a/arch/i386/kernel/cpu/mtrr/generic.c~fix-mtrr-sections
+++ a/arch/i386/kernel/cpu/mtrr/generic.c
@@ -38,7 +38,7 @@ static struct mtrr_state mtrr_state = {}
 #undef MODULE_PARAM_PREFIX
 #define MODULE_PARAM_PREFIX "mtrr."
 
-static __initdata int mtrr_show;
+static int mtrr_show;
 module_param_named(show, mtrr_show, bool, 0);
 
 /*  Get the MSR pair relating to a var range  */
@@ -68,12 +68,13 @@ void mtrr_save_fixed_ranges(void *info)
 	get_fixed_ranges(mtrr_state.fixed_ranges);
 }
 
-static void __init print_fixed(unsigned base, unsigned step, const mtrr_type*types)
+static void __cpuinit print_fixed(unsigned base, unsigned step, const mtrr_type*types)
 {
 	unsigned i;
 
 	for (i = 0; i < 8; ++i, ++types, base += step)
-		printk(KERN_INFO "MTRR %05X-%05X %s\n", base, base + step - 1, mtrr_attrib_to_str(*types));
+		printk(KERN_INFO "MTRR %05X-%05X %s\n",
+			base, base + step - 1, mtrr_attrib_to_str(*types));
 }
 
 /*  Grab all of the MTRR state for this CPU into *state  */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-drm.patch
git-ieee1394.patch
git-kbuild.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
8250_pci-fix-pci-must_checks.patch
git-scsi-misc.patch
git-ipwireless_cs.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
expose-range-checking-functions-from-arch-specific.patch
expose-range-checking-functions-from-arch-specific-update.patch
expose-range-checking-functions-from-arch-specific-update-fix.patch
parport_serial-fix-pci-must_checks.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
alphabetically-sorted-entries-in.patch
kernel-doc-html-mode-struct-highlights.patch
taskstats-fix-getdelays-usage-information.patch
introduce-a-handy-list_first_entry-macro-v2.patch
add-pci_try_set_mwi.patch
consolidate-asm-consth-to-linux-consth.patch
x86_64-kill-19000-sparse-warnings.patch
move-log_buf_shift-to-a-more-sensible-place.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
s3fb-fix-pci-must_checks.patch
profile-likely-unlikely-macros.patch

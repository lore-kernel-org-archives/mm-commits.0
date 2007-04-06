From: akpm@linux-foundation.org
Subject: + fix-mtrr-sections.patch added to -mm tree
Date: Thu, 05 Apr 2007 18:06:10 -0700
Message-ID: <200704060106.l3616AMF031172@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59991 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767460AbXDFBGR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 21:06:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, ak@suse.de


The patch titled
     fix mtrr sections
has been added to the -mm tree.  Its filename is
     fix-mtrr-sections.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/cpu/mtrr/generic.c~fix-mtrr-sections arch/i386/kernel/cpu/mtrr/generic.c
--- a/arch/i386/kernel/cpu/mtrr/generic.c~fix-mtrr-sections
+++ a/arch/i386/kernel/cpu/mtrr/generic.c
@@ -26,7 +26,7 @@ static struct mtrr_state mtrr_state = {}
 #undef MODULE_PARAM_PREFIX
 #define MODULE_PARAM_PREFIX "mtrr."
 
-static __initdata int mtrr_show;
+static int mtrr_show;
 module_param_named(show, mtrr_show, bool, 0);
 
 /*  Get the MSR pair relating to a var range  */
@@ -51,12 +51,13 @@ get_fixed_ranges(mtrr_type * frs)
 		rdmsr(MTRRfix4K_C0000_MSR + i, p[6 + i * 2], p[7 + i * 2]);
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

git-acpi.patch
git-drm.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-mtrr-sections.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
ext4-use-null-for-pointers.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch

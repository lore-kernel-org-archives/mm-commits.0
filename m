From: akpm@linux-foundation.org
Subject: + mips-excite-use-__attribute_unused__.patch added to -mm tree
Date: Fri, 04 May 2007 02:09:28 -0700
Message-ID: <200705040909.l4499SpX000554@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933045AbXEDJK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 05:10:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, ralf@linux-mips.org, thomas.koeller@baslerweb.com


The patch titled
     mips: excite: use __attribute_unused__
has been added to the -mm tree.  Its filename is
     mips-excite-use-__attribute_unused__.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mips: excite: use __attribute_unused__
From: David Rientjes <rientjes@google.com>

Replace variable instances of __attribute__((unused)) with
__attribute_unused__.

Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Koeller <thomas.koeller@baslerweb.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/basler/excite/excite_device.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/mips/basler/excite/excite_device.c~mips-excite-use-__attribute_unused__ arch/mips/basler/excite/excite_device.c
--- a/arch/mips/basler/excite/excite_device.c~mips-excite-use-__attribute_unused__
+++ a/arch/mips/basler/excite/excite_device.c
@@ -68,7 +68,7 @@ enum {
 
 
 static struct resource
-	excite_ctr_resource __attribute__((unused)) = {
+	excite_ctr_resource __attribute_unused__ = {
 		.name		= "GPI counters",
 		.start		= 0,
 		.end		= 5,
@@ -77,7 +77,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_gpislice_resource __attribute__((unused)) = {
+	excite_gpislice_resource __attribute_unused__ = {
 		.name		= "GPI slices",
 		.start		= 0,
 		.end		= 1,
@@ -86,7 +86,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_mdio_channel_resource __attribute__((unused)) = {
+	excite_mdio_channel_resource __attribute_unused__ = {
 		.name		= "MDIO channels",
 		.start		= 0,
 		.end		= 1,
@@ -95,7 +95,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_fifomem_resource __attribute__((unused)) = {
+	excite_fifomem_resource __attribute_unused__ = {
 		.name		= "FIFO memory",
 		.start		= 0,
 		.end		= 767,
@@ -104,7 +104,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_scram_resource __attribute__((unused)) = {
+	excite_scram_resource __attribute_unused__ = {
 		.name		= "Scratch RAM",
 		.start		= EXCITE_PHYS_SCRAM,
 		.end		= EXCITE_PHYS_SCRAM + EXCITE_SIZE_SCRAM - 1,
@@ -113,7 +113,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_fpga_resource __attribute__((unused)) = {
+	excite_fpga_resource __attribute_unused__ = {
 		.name		= "System FPGA",
 		.start		= EXCITE_PHYS_FPGA,
 		.end		= EXCITE_PHYS_FPGA + EXCITE_SIZE_FPGA - 1,
@@ -122,7 +122,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_nand_resource __attribute__((unused)) = {
+	excite_nand_resource __attribute_unused__ = {
 		.name		= "NAND flash control",
 		.start		= EXCITE_PHYS_NAND,
 		.end		= EXCITE_PHYS_NAND + EXCITE_SIZE_NAND - 1,
@@ -131,7 +131,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_titan_resource __attribute__((unused)) = {
+	excite_titan_resource __attribute_unused__ = {
 		.name		= "TITAN registers",
 		.start		= EXCITE_PHYS_TITAN,
 		.end		= EXCITE_PHYS_TITAN + EXCITE_SIZE_TITAN - 1,
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
oom-fix-constraint-deadlock.patch
wavefront-only-declare-isapnp-on-config_pnp.patch
git-cpufreq.patch
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
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
compiler-define-__attribute_unused__.patch
i386-pci-type-may-be-unused.patch
sh-dma-use-__attribute_unused__.patch
scsi-fix-ambiguous-gdthtable-definition.patch
frv-gdb-use-__attribute_unused__.patch
i386-voyager-use-__attribute_unused__.patch
mips-excite-use-__attribute_unused__.patch
mips-tlbex-use-__attribute_unused__.patch
powerpc-ps3-use-__attribute_unused__.patch
i386-mmzone-use-__attribute_unused__.patch

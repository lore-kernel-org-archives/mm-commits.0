From: akpm@linux-foundation.org
Subject: - mips-excite-use-__maybe_unused.patch removed from -mm tree
Date: Fri, 11 May 2007 22:36:45 -0700
Message-ID: <200705120536.l4C5ajdx002400@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756886AbXELFhA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:37:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ralf@linux-mips.org, thomas.koeller@baslerweb.com, mm-commits@vger.kernel.org


The patch titled
     mips: excite: use __maybe_unused
has been removed from the -mm tree.  Its filename was
     mips-excite-use-__maybe_unused.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mips: excite: use __maybe_unused
From: David Rientjes <rientjes@google.com>

Replace variable instances of __attribute__((unused)) with
__maybe_unused.

Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Koeller <thomas.koeller@baslerweb.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/basler/excite/excite_device.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/mips/basler/excite/excite_device.c~mips-excite-use-__maybe_unused arch/mips/basler/excite/excite_device.c
--- a/arch/mips/basler/excite/excite_device.c~mips-excite-use-__maybe_unused
+++ a/arch/mips/basler/excite/excite_device.c
@@ -68,7 +68,7 @@ enum {
 
 
 static struct resource
-	excite_ctr_resource __attribute__((unused)) = {
+	excite_ctr_resource __maybe_unused = {
 		.name		= "GPI counters",
 		.start		= 0,
 		.end		= 5,
@@ -77,7 +77,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_gpislice_resource __attribute__((unused)) = {
+	excite_gpislice_resource __maybe_unused = {
 		.name		= "GPI slices",
 		.start		= 0,
 		.end		= 1,
@@ -86,7 +86,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_mdio_channel_resource __attribute__((unused)) = {
+	excite_mdio_channel_resource __maybe_unused = {
 		.name		= "MDIO channels",
 		.start		= 0,
 		.end		= 1,
@@ -95,7 +95,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_fifomem_resource __attribute__((unused)) = {
+	excite_fifomem_resource __maybe_unused = {
 		.name		= "FIFO memory",
 		.start		= 0,
 		.end		= 767,
@@ -104,7 +104,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_scram_resource __attribute__((unused)) = {
+	excite_scram_resource __maybe_unused = {
 		.name		= "Scratch RAM",
 		.start		= EXCITE_PHYS_SCRAM,
 		.end		= EXCITE_PHYS_SCRAM + EXCITE_SIZE_SCRAM - 1,
@@ -113,7 +113,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_fpga_resource __attribute__((unused)) = {
+	excite_fpga_resource __maybe_unused = {
 		.name		= "System FPGA",
 		.start		= EXCITE_PHYS_FPGA,
 		.end		= EXCITE_PHYS_FPGA + EXCITE_SIZE_FPGA - 1,
@@ -122,7 +122,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_nand_resource __attribute__((unused)) = {
+	excite_nand_resource __maybe_unused = {
 		.name		= "NAND flash control",
 		.start		= EXCITE_PHYS_NAND,
 		.end		= EXCITE_PHYS_NAND + EXCITE_SIZE_NAND - 1,
@@ -131,7 +131,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_titan_resource __attribute__((unused)) = {
+	excite_titan_resource __maybe_unused = {
 		.name		= "TITAN registers",
 		.start		= EXCITE_PHYS_TITAN,
 		.end		= EXCITE_PHYS_TITAN + EXCITE_SIZE_TITAN - 1,
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
git-alsa.patch
powerpc-ps3-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-update.patch
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

From: akpm@linux-foundation.org
Subject: - scsi-fix-ambiguous-gdthtable-definition.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:07:00 -0700
Message-ID: <200706010706.l5176xlo004753@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756264AbXFAHHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:07:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, achim_leubner@adaptec.com, mm-commits@vger.kernel.org


The patch titled
     scsi: fix ambiguous gdthtable definition
has been removed from the -mm tree.  Its filename was
     scsi-fix-ambiguous-gdthtable-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: fix ambiguous gdthtable definition
From: David Rientjes <rientjes@google.com>

Labeling a variable as __attribute_used__ is ambiguous: it means
__attribute__((unused)) for gcc <3.4 and __attribute__((used)) for gcc >=3.4. 
There is no such thing as labeling a variable as __attribute__((used)).  We
assume that we're simply suppressing a warning here if gdthtable[] is declared
but unreferenced.

Cc: Achim Leubner <achim_leubner@adaptec.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/gdth.c~scsi-fix-ambiguous-gdthtable-definition drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~scsi-fix-ambiguous-gdthtable-definition
+++ a/drivers/scsi/gdth.c
@@ -876,7 +876,7 @@ static int __init gdth_search_pci(gdth_p
 /* Vortex only makes RAID controllers.
  * We do not really want to specify all 550 ids here, so wildcard match.
  */
-static struct pci_device_id gdthtable[] __attribute_used__ = {
+static struct pci_device_id gdthtable[] __maybe_unused = {
     {PCI_VENDOR_ID_VORTEX,PCI_ANY_ID,PCI_ANY_ID, PCI_ANY_ID},
     {PCI_VENDOR_ID_INTEL,PCI_DEVICE_ID_INTEL_SRC,PCI_ANY_ID,PCI_ANY_ID}, 
     {PCI_VENDOR_ID_INTEL,PCI_DEVICE_ID_INTEL_SRC_XSCALE,PCI_ANY_ID,PCI_ANY_ID}, 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
powerpc-ps3-use-__maybe_unused.patch
git-scsi-misc.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
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

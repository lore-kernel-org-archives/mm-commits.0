From: akpm@osdl.org
Subject: - agp-amd64-section-mismatches-with-hotplug=n.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:06:25 -0800
Message-ID: <200612072306.kB7N6PTv030264@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52684 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163919AbWLGXGr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:06:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     agp-amd64: section mismatches with HOTPLUG=n
has been removed from the -mm tree.  Its filename was
     agp-amd64-section-mismatches-with-hotplug=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: agp-amd64: section mismatches with HOTPLUG=n
From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_HOTPLUG=n, agp_amd64_resume() calls nforce3_agp_init(), which is
__devinit == __init, so has been discarded and is not usable for resume.

WARNING: drivers/char/agp/amd64-agp.o - Section mismatch: reference to .init.text: from .text between 'agp_amd64_resume' (at offset 0x249) and 'amd64_tlbflush'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/agp/amd64-agp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/agp/amd64-agp.c~agp-amd64-section-mismatches-with-hotplug=n drivers/char/agp/amd64-agp.c
--- a/drivers/char/agp/amd64-agp.c~agp-amd64-section-mismatches-with-hotplug=n
+++ a/drivers/char/agp/amd64-agp.c
@@ -459,7 +459,7 @@ static const struct aper_size_info_32 nf
 
 /* Handle shadow device of the Nvidia NForce3 */
 /* CHECK-ME original 2.4 version set up some IORRs. Check if that is needed. */
-static int __devinit nforce3_agp_init(struct pci_dev *pdev)
+static int nforce3_agp_init(struct pci_dev *pdev)
 {
 	u32 tmp, apbase, apbar, aplimit;
 	struct pci_dev *dev1;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
generic-bug-implementation-handle-bug=n.patch
reiser4-use-null-for-pointers.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch


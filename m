From: akpm@osdl.org
Subject: - parport-section-mismatches-with-hotplug=n.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:06:23 -0800
Message-ID: <200612072306.kB7N6NJ8030261@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52658 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163768AbWLGXGi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:06:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     parport: section mismatches with HOTPLUG=n
has been removed from the -mm tree.  Its filename was
     parport-section-mismatches-with-hotplug=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: parport: section mismatches with HOTPLUG=n
From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_HOTPLUG=n, parport_pc calls some __devinit == __init code that
could be discarded.  These calls are made from parport_irq_probe(), which is
called from parport_pc_probe_port(), which is an exported symbol, so the calls
could (possibly) happen after init time.

WARNING: drivers/parport/parport_pc.o - Section mismatch: reference to .init.text: from .text between 'parport_irq_probe' (at offset 0x31d) and 'parport_pc_probe_port'
WARNING: drivers/parport/parport_pc.o - Section mismatch: reference to .init.text: from .text between 'parport_irq_probe' (at offset 0x346) and 'parport_pc_probe_port'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/parport/parport_pc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/parport/parport_pc.c~parport-section-mismatches-with-hotplug=n drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~parport-section-mismatches-with-hotplug=n
+++ a/drivers/parport/parport_pc.c
@@ -1975,7 +1975,7 @@ static int __devinit parport_ECPPS2_supp
 /* --- IRQ detection -------------------------------------- */
 
 /* Only if supports ECP mode */
-static int __devinit programmable_irq_support(struct parport *pb)
+static int programmable_irq_support(struct parport *pb)
 {
 	int irq, intrLine;
 	unsigned char oecr = inb (ECONTROL (pb));
@@ -1992,7 +1992,7 @@ static int __devinit programmable_irq_su
 	return irq;
 }
 
-static int __devinit irq_probe_ECP(struct parport *pb)
+static int irq_probe_ECP(struct parport *pb)
 {
 	int i;
 	unsigned long irqs;
@@ -2020,7 +2020,7 @@ static int __devinit irq_probe_ECP(struc
  * This detection seems that only works in National Semiconductors
  * This doesn't work in SMC, LGS, and Winbond 
  */
-static int __devinit irq_probe_EPP(struct parport *pb)
+static int irq_probe_EPP(struct parport *pb)
 {
 #ifndef ADVANCED_DETECT
 	return PARPORT_IRQ_NONE;
@@ -2059,7 +2059,7 @@ static int __devinit irq_probe_EPP(struc
 #endif /* Advanced detection */
 }
 
-static int __devinit irq_probe_SPP(struct parport *pb)
+static int irq_probe_SPP(struct parport *pb)
 {
 	/* Don't even try to do this. */
 	return PARPORT_IRQ_NONE;
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


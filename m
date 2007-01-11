From: akpm@osdl.org
Subject: - pci-quirks-modpost-warning-fix.patch removed from -mm tree
Date: Wed, 10 Jan 2007 23:06:27 -0800
Message-ID: <200701110706.l0B76RLJ018983@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37209 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965311AbXAKHHe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 02:07:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     pci quirks MODPOST warning fix
has been removed from the -mm tree.  Its filename was
     pci-quirks-modpost-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci quirks MODPOST warning fix
From: Vivek Goyal <vgoyal@in.ibm.com>

o MODPOST generates warnings for i386 if kernel is compiled with
  CONFIG_RELOCATABLE=y

WARNING: vmlinux - Section mismatch: reference to .init.data: from .text between 'asus_hides_smbus_lpc_ich6' (at offset 0xc0217d58) and 'quirk_cardbus_legacy'
WARNING: vmlinux - Section mismatch: reference to .init.data: from .text between 'asus_hides_smbus_lpc' (at offset 0xc0217fd9) and 'pci_match_id'

o Two quirk functions which are non __init, are accessing data which is
  of type __init.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/quirks.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/quirks.c~pci-quirks-modpost-warning-fix drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-quirks-modpost-warning-fix
+++ a/drivers/pci/quirks.c
@@ -955,7 +955,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_V
  * becomes necessary to do this tweak in two steps -- I've chosen the Host
  * bridge as trigger.
  */
-static int __initdata asus_hides_smbus;
+static int asus_hides_smbus;
 
 static void __init asus_hides_smbus_hostbridge(struct pci_dev *dev)
 {
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

origin.patch
change-cpu_up-and-co-from-__devinit-to-__cpuinit.patch
kdump-documentation-update-for-2620.patch
i386-sched_clock-using-init-data-tsc_disable-fix.patch
scsi-megaraid_mmmbox-init-fix-for-kdump.patch
clockevents-i386-drivers.patch

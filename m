From: akpm@osdl.org
Subject: - pci-avoid-taking-pci_bus_sem-early-in-boot.patch removed from -mm tree
Date: Fri, 05 Jan 2007 16:13:33 -0800
Message-ID: <200701060013.l060Dxsv011361@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44787 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbXAFAON (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 19:14:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, 76306.1226@compuserve.com, agalanin@mera.ru, ard@telegraafnet.nl, ebiederm@xmission.com, greg@kroah.com, take@libero.it, yanmin.zhang@intel.com, yinghai.lu@amd.com, mm-commits@vger.kernel.org


The patch titled
     pci-avoid-taking-pci_bus_sem-early-in-boot
has been removed from the -mm tree.  Its filename was
     pci-avoid-taking-pci_bus_sem-early-in-boot.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: pci-avoid-taking-pci_bus_sem-early-in-boot
From: Andrew Morton <akpm@osdl.org>

Various people have reported machines failing to boot since pci_bus_sem was
switched from a spinlock to an rwsem.

The reason for this is that these people had "ide=" on the kernel command
line, and ide_setup() can end up calling PCI functions which do
down_read(&pci_bus_sem).


Ard has worked out the call tree:

init/main.c         start_kernel
kernel/params.c      parse_args("Booting kernel"
kernel/params.c       parse_one
drivers/ide/ide.c      ide_setup
drivers/ide/ide.c       init_ide_data
drivers/ide/ide.c        init_hwif_default
include/asm-i386/ide.h    ide_default_io_base(index)
drivers/pci/search.c       pci_find_device
drivers/pci/search.c        pci_find_subsys
                             down_read(&pci_bus_sem);


down_read() will unconditionally enable interrupts and some early interrupt
(source unknown) comes in and whacks the machine, apparently because the LDT
isn't set up yet.

Fix that by avoiding taking the semaphore in the PCI code in this situation.

Cc: Ard -kwaak- van Breemen <ard@telegraafnet.nl>
Cc: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: Chuck Ebbert <76306.1226@compuserve.com>
Cc: Yinghai Lu <yinghai.lu@amd.com>
Cc: <take@libero.it>
Cc: <agalanin@mera.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/search.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/pci/search.c~pci-avoid-taking-pci_bus_sem-early-in-boot drivers/pci/search.c
--- a/drivers/pci/search.c~pci-avoid-taking-pci_bus_sem-early-in-boot
+++ a/drivers/pci/search.c
@@ -259,6 +259,16 @@ pci_get_subsys(unsigned int vendor, unsi
 	struct pci_dev *dev;
 
 	WARN_ON(in_interrupt());
+
+	/*
+	 * pci_get_subsys() can be called on the ide_setup() path, super-early
+	 * in boot.  But the down_read() will enable local interrupts, which
+	 * can cause some machines to crash.  So here we detect that situation
+	 * and bail out early.
+	 */
+	if (unlikely(list_empty(&pci_devices)))
+		return NULL;
+
 	down_read(&pci_bus_sem);
 	n = from ? from->global_list.next : pci_devices.next;
 
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again.patch
kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs.patch
pci-prevent-down_read-when-pci_devices-is-empty.patch
atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy.patch
ip2-warning-fix.patch
pci-avoid-taking-pci_bus_sem-early-in-boot.patch
shrink_all_memory-fix-lru_pages-handling.patch

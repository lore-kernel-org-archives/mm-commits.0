From: akpm@linux-foundation.org
Subject: - pci-remove-unneeded-lock_kernel-in-drivers-pci-syscallc.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:49:16 -0800
Message-ID: <200711262149.lAQLnG1n024745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41572 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755456AbXKZV6c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:58:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: diego@woitasen.com.ar, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     pci: remove unneeded lock_kernel() in drivers/pci/syscall.c.
has been removed from the -mm tree.  Its filename was
     pci-remove-unneeded-lock_kernel-in-drivers-pci-syscallc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci: remove unneeded lock_kernel() in drivers/pci/syscall.c.
From: Diego Woitasen <diego@woitasen.com.ar>

sys_pciconfig_{read,write}() are protected against PCI removal with the
reference count in struct pci_dev.  The concurrency of
pci_user_{read,write}_config_* functions are already protected by pci_lock
in drivers/pci/access.c.

Signed-off-by: Diego Woitasen <diego@woitasen.com.ar>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/syscall.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/pci/syscall.c~pci-remove-unneeded-lock_kernel-in-drivers-pci-syscallc drivers/pci/syscall.c
--- a/drivers/pci/syscall.c~pci-remove-unneeded-lock_kernel-in-drivers-pci-syscallc
+++ a/drivers/pci/syscall.c
@@ -34,7 +34,6 @@ sys_pciconfig_read(unsigned long bus, un
 	if (!dev)
 		goto error;
 
-	lock_kernel();
 	switch (len) {
 	case 1:
 		cfg_ret = pci_user_read_config_byte(dev, off, &byte);
@@ -47,10 +46,8 @@ sys_pciconfig_read(unsigned long bus, un
 		break;
 	default:
 		err = -EINVAL;
-		unlock_kernel();
 		goto error;
 	};
-	unlock_kernel();
 
 	err = -EIO;
 	if (cfg_ret != PCIBIOS_SUCCESSFUL)
@@ -107,7 +104,6 @@ sys_pciconfig_write(unsigned long bus, u
 	if (!dev)
 		return -ENODEV;
 
-	lock_kernel();
 	switch(len) {
 	case 1:
 		err = get_user(byte, (u8 __user *)buf);
@@ -140,7 +136,6 @@ sys_pciconfig_write(unsigned long bus, u
 		err = -EINVAL;
 		break;
 	}
-	unlock_kernel();
 	pci_dev_put(dev);
 	return err;
 }
_

Patches currently in -mm which might be from diego@woitasen.com.ar are

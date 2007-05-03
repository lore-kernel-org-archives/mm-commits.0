From: akpm@linux-foundation.org
Subject: - pci-syscallc-switch-to-refcounting-api.patch removed from -mm tree
Date: Thu, 03 May 2007 12:31:27 -0700
Message-ID: <200705031931.l43JVRvu018268@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767869AbXECTdj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:33:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     pci syscall.c: Switch to refcounting API
has been removed from the -mm tree.  Its filename was
     pci-syscallc-switch-to-refcounting-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci syscall.c: Switch to refcounting API
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/syscall.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/pci/syscall.c~pci-syscallc-switch-to-refcounting-api drivers/pci/syscall.c
--- a/drivers/pci/syscall.c~pci-syscallc-switch-to-refcounting-api
+++ a/drivers/pci/syscall.c
@@ -30,7 +30,7 @@ sys_pciconfig_read(unsigned long bus, un
 		goto error;
 
 	err = -ENODEV;
-	dev = pci_find_slot(bus, dfn);
+	dev = pci_get_bus_and_slot(bus, dfn);
 	if (!dev)
 		goto error;
 
@@ -67,6 +67,7 @@ sys_pciconfig_read(unsigned long bus, un
 		err = put_user(dword, (unsigned int __user *)buf);
 		break;
 	};
+	pci_dev_put(dev);
 	return err;
 
 error:
@@ -84,6 +85,7 @@ error:
 		put_user(-1, (unsigned int __user *)buf);
 		break;
 	};
+	pci_dev_put(dev);
 	return err;
 }
 
@@ -101,7 +103,7 @@ sys_pciconfig_write(unsigned long bus, u
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	dev = pci_find_slot(bus, dfn);
+	dev = pci_get_bus_and_slot(bus, dfn);
 	if (!dev)
 		return -ENODEV;
 
@@ -139,6 +141,6 @@ sys_pciconfig_write(unsigned long bus, u
 		break;
 	};
 	unlock_kernel();
-
+	pci_dev_put(dev);
 	return err;
 }
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
driver_bfin_serial_core.patch
git-agpgart.patch
ata_timing-ensure-t-cycle-is-always-correct.patch
libata-add-support-for-ata_16-on-atapi.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
sl82c105-switch-to-ref-counting-api.patch
fix-pci_find_present.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
protect-tty-drivers-list-with-tty_mutex.patch
fix-82875-pci-setup.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
remove-redundant-check-from-proc_sys_setattr.patch
apm-fix-incorrect-comment.patch
upper-32-bits.patch
console-utf-8-fixes.patch
add-pci_try_set_mwi.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch

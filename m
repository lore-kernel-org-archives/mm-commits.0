From: akpm@linux-foundation.org
Subject: - whci-allow-modular-fix-busted-build.patch removed from -mm tree
Date: Thu, 22 May 2008 12:29:28 -0700
Message-ID: <200805221929.m4MJTSnG017660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756114AbYEVTaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 15:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, david.vrabel@csr.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     whci: allow modular, fix busted build
has been removed from the -mm tree.  Its filename was
     whci-allow-modular-fix-busted-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: whci: allow modular, fix busted build
From: Randy Dunlap <randy.dunlap@oracle.com>

wusb components should depend on CONFIG_USB and be allowed to be
built as modules, not just built-in.

drivers/built-in.o: In function `asl_urb_dequeue':
(.text+0x92d5e): undefined reference to `usb_hcd_check_unlink_urb'
drivers/built-in.o: In function `asl_urb_enqueue':
(.text+0x92e70): undefined reference to `usb_hcd_link_urb_to_ep'
drivers/built-in.o: In function `whc_remove':
hcd.c:(.text+0x93042): undefined reference to `usb_remove_hcd'
drivers/built-in.o: In function `whc_probe':
hcd.c:(.text+0x931b7): undefined reference to `usb_create_hcd'
hcd.c:(.text+0x932b8): undefined reference to `usb_add_hcd'
hcd.c:(.text+0x932f6): undefined reference to `usb_remove_hcd'
hcd.c:(.text+0x9332e): undefined reference to `usb_put_hcd'
drivers/built-in.o: In function `whc_remove':
hcd.c:(.text+0x93067): undefined reference to `usb_put_hcd'
drivers/built-in.o: In function `pzl_urb_dequeue':
(.text+0x93fc3): undefined reference to `usb_hcd_check_unlink_urb'
drivers/built-in.o: In function `pzl_urb_enqueue':
(.text+0x940d5): undefined reference to `usb_hcd_link_urb_to_ep'
drivers/built-in.o: In function `qset_remove_urb':
(.text+0x947cc): undefined reference to `usb_hcd_unlink_urb_from_ep'
drivers/built-in.o: In function `wusb_dev_free':
devconnect.c:(.text+0x9682a): undefined reference to `usb_free_urb'
drivers/built-in.o: In function `wusb_usb_ncb':
(.text+0x96994): undefined reference to `usb_put_dev'
drivers/built-in.o: In function `wusb_usb_ncb':
(.text+0x969c7): undefined reference to `usb_get_hcd'
drivers/built-in.o: In function `wusb_usb_ncb':
(.text+0x96a34): undefined reference to `usb_get_dev'
drivers/built-in.o: In function `wusb_usb_ncb':
(.text+0x96a9c): undefined reference to `usb_get_descriptor'
drivers/built-in.o: In function `wusb_usb_ncb':
(.text+0x96af8): undefined reference to `usb_get_descriptor'
drivers/built-in.o: In function `wusb_usb_ncb':
(.text+0x96b74): undefined reference to `usb_put_hcd'
drivers/built-in.o: In function `wusbhc_handle_dn':
(.text+0x974a2): undefined reference to `usb_alloc_urb'
drivers/built-in.o: In function `wusb_cdid_show':
dev-sysfs.c:(.text+0x97921): undefined reference to `usb_get_hcd'
dev-sysfs.c:(.text+0x97967): undefined reference to `usb_put_hcd'
drivers/built-in.o: In function `wusb_dev_cc_store':
dev-sysfs.c:(.text+0x97d08): undefined reference to `usb_get_hcd'
dev-sysfs.c:(.text+0x97d8b): undefined reference to `usb_put_hcd'
drivers/built-in.o: In function `wusb_dev_disconnect_store':
dev-sysfs.c:(.text+0x97ed5): undefined reference to `usb_get_hcd'
dev-sysfs.c:(.text+0x97f25): undefined reference to `usb_put_hcd'
drivers/built-in.o: In function `wusbhc_gtk_rekey':
(.text+0x98e8c): undefined reference to `usb_submit_urb'
drivers/built-in.o: In function `wusb_dev_set_encryption':
security.c:(.text+0x991c9): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `wusb_dev_sec_add':
(.text+0x99342): undefined reference to `usb_get_descriptor'
drivers/built-in.o: In function `wusb_dev_sec_add':
(.text+0x993c1): undefined reference to `usb_get_descriptor'
drivers/built-in.o: In function `wusb_dev_4way_handshake':
(.text+0x997e0): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `wusb_dev_4way_handshake':
(.text+0x9982f): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `wusb_dev_4way_handshake':
(.text+0x9a0f4): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `wusb_dev_4way_handshake':
(.text+0x9a25b): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `wusb_dev_4way_handshake':
(.text+0x9a32e): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `wusb_dev_4way_handshake':
(.text+0x9a359): undefined reference to `usb_ep0_reinit'
drivers/built-in.o: In function `wusb_dev_4way_handshake':
(.text+0x9a397): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `wusb_dev_4way_handshake':
(.text+0x9a3c3): undefined reference to `usb_ep0_reinit'
drivers/built-in.o: In function `wusbhc_giveback_urb':
(.text+0x9a75f): undefined reference to `usb_hcd_giveback_urb'
drivers/built-in.o: In function `cbaf_disconnect':
cbaf.c:(.text+0x9ab72): undefined reference to `usb_put_intf'
drivers/built-in.o: In function `cbaf_wusb_host_info_store':
cbaf.c:(.text+0x9add5): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `cbaf_wusb_cdid_show':
cbaf.c:(.text+0x9af6a): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `cbaf_wusb_cc_store':
cbaf.c:(.text+0x9b411): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `cbaf_probe':
cbaf.c:(.text+0x9bb17): undefined reference to `usb_get_dev'
cbaf.c:(.text+0x9bb29): undefined reference to `usb_get_intf'
cbaf.c:(.text+0x9bb7f): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `wusbcore_init':
wusbhc.c:(.init.text+0x58f8): undefined reference to `usb_register_notify'
drivers/built-in.o: In function `cbaf_driver_init':
cbaf.c:(.init.text+0x5941): undefined reference to `usb_register_driver'
drivers/built-in.o: In function `wusbcore_exit':
wusbhc.c:(.exit.text+0x782): undefined reference to `usb_unregister_notify'
drivers/built-in.o: In function `cbaf_driver_exit':
cbaf.c:(.exit.text+0x7a8): undefined reference to `usb_deregister'
make[1]: *** [vmlinux] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: <david.vrabel@csr.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/Kconfig  |    2 +-
 drivers/usb/host/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/host/Kconfig~whci-allow-modular-fix-busted-build drivers/usb/host/Kconfig
--- a/drivers/usb/host/Kconfig~whci-allow-modular-fix-busted-build
+++ a/drivers/usb/host/Kconfig
@@ -308,7 +308,7 @@ config SUPERH_ON_CHIP_R8A66597
 
 config USB_WHCI_HCD
 	tristate "Wireless USB Host Controller Interface (WHCI) driver"
-	depends on PCI
+	depends on PCI && USB
 	select USB_WUSB
 	select UWB_WHCI
 	help
diff -puN drivers/usb/host/Makefile~whci-allow-modular-fix-busted-build drivers/usb/host/Makefile
--- a/drivers/usb/host/Makefile~whci-allow-modular-fix-busted-build
+++ a/drivers/usb/host/Makefile
@@ -8,7 +8,7 @@ endif
 
 isp1760-objs := isp1760-hcd.o isp1760-if.o
 
-obj-y				+= whci/
+obj-$(CONFIG_USB_WHCI_HCD)	+= whci/
 
 obj-$(CONFIG_PCI)		+= pci-quirks.o
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
documentation-build-source-files-in-documentation-sub-dir.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
3c515-fix-using-pnp_get_resource-when-config_isapnp=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-unionfs.patch
uwb-fix-kconfig-causing-undefined-references.patch
audit-fix-kernel-doc-parameter-notation.patch
scsi-do-not-automatically-select-scsi_dh-for-dm-multipath.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
bsdacct-stir-up-comments-around-acct_process.patch
profile-likely-unlikely-macros.patch


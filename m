From: akpm@linux-foundation.org
Subject: [merged] bluetooth-fix-l2cap-build-error.patch removed from -mm tree
Date: Wed, 26 Aug 2009 12:40:13 -0700
Message-ID: <200908261940.n7QJeDs4001834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902AbZHZTkU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Aug 2009 15:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, davem@davemloft.net, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     bluetooth: fix l2cap build error
has been removed from the -mm tree.  Its filename was
     bluetooth-fix-l2cap-build-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bluetooth: fix l2cap build error
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix net/bluetooth/l2cap.c build errors:

l2cap.c:(.text+0x126035): undefined reference to `crc16'
l2cap.c:(.text+0x126323): undefined reference to `crc16'
l2cap.c:(.text+0x12668e): undefined reference to `crc16'
l2cap.c:(.text+0x12683b): undefined reference to `crc16'
l2cap.c:(.text+0x126956): undefined reference to `crc16'
net/built-in.o:l2cap.c:(.text+0x129041): more undefined references to `crc16' follow

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN net/bluetooth/Kconfig~bluetooth-fix-l2cap-build-error net/bluetooth/Kconfig
--- a/net/bluetooth/Kconfig~bluetooth-fix-l2cap-build-error
+++ a/net/bluetooth/Kconfig
@@ -34,6 +34,7 @@ menuconfig BT
 config BT_L2CAP
 	tristate "L2CAP protocol support"
 	depends on BT
+	select CRC16
 	help
 	  L2CAP (Logical Link Control and Adaptation Protocol) provides
 	  connection oriented and connection-less data transport.  L2CAP
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
gspca-fix-sn9c20x-build-errors.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
mtd-make-onenand-genericc-more-generic-fix.patch
isdn-fix-netjet-build-errors.patch
scsi-fix-func-names-in-kernel-doc.patch
staging-iio-fix-duplicate-dev_attr_name.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
reiser4-export-remove_from_page_cache-fix.patch


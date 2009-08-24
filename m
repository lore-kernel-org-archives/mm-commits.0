From: akpm@linux-foundation.org
Subject: + bluetooth-fix-l2cap-build-error.patch added to -mm tree
Date: Mon, 24 Aug 2009 15:32:06 -0700
Message-ID: <200908242232.n7OMW6A2019344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753856AbZHXWcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 18:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, davem@davemloft.net, marcel@holtmann.org


The patch titled
     bluetooth: fix l2cap build error
has been added to the -mm tree.  Its filename is
     bluetooth-fix-l2cap-build-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
gspca-fix-sn9c20x-build-errors.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
mtd-make-onenand-genericc-more-generic-fix.patch
isdn-fix-netjet-build-errors.patch
bluetooth-fix-l2cap-build-error.patch
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
kref-documentation-double-kref_put-in-my_data_handler.patch
reiser4-export-remove_from_page_cache-fix.patch


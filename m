From: akpm@linux-foundation.org
Subject: [merged] isdn-fix-netjet-build-errors.patch removed from -mm tree
Date: Thu, 01 Oct 2009 11:44:43 -0700
Message-ID: <200910011844.n91IihIZ013488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755716AbZJASou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2009 14:44:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, isdn@linux-pingi.de, mm-commits@vger.kernel.org


The patch titled
     isdn: fix netjet build errors
has been removed from the -mm tree.  Its filename was
     isdn-fix-netjet-build-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: fix netjet build errors
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix netjet driver link errors when ISDN_I4L is not enabled:

drivers/built-in.o: In function `mode_tiger':
netjet.c:(.text+0x325dc8): undefined reference to `isdnhdlc_rcv_init'
netjet.c:(.text+0x325dd5): undefined reference to `isdnhdlc_out_init'
drivers/built-in.o: In function `fill_dma':
netjet.c:(.text+0x325fb6): undefined reference to `isdnhdlc_encode'
drivers/built-in.o: In function `read_dma':
netjet.c:(.text+0x32631a): undefined reference to `isdnhdlc_decode'
drivers/built-in.o: In function `nj_irq':
netjet.c:(.text+0x326e01): undefined reference to `isdnhdlc_encode'

or move isdnhdlc.c to some other sub-dir..

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/mISDN/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/isdn/hardware/mISDN/Kconfig~isdn-fix-netjet-build-errors drivers/isdn/hardware/mISDN/Kconfig
--- a/drivers/isdn/hardware/mISDN/Kconfig~isdn-fix-netjet-build-errors
+++ a/drivers/isdn/hardware/mISDN/Kconfig
@@ -78,6 +78,7 @@ config MISDN_NETJET
 	depends on PCI
 	select MISDN_IPAC
 	select ISDN_HDLC
+	select ISDN_I4L # so that make will recurse into sub-dir.
 	help
 	  Enable support for Traverse Technologies NETJet PCI cards.
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-serio_libps2-depends-on-serio_i8042.patch
scsi-fix-func-names-in-kernel-doc.patch
docs-update-patch-size-in-submittingpatches.patch
readahead-add-blk_run_backing_dev.patch
pcmcia-fix-controller-printk-warnings.patch
reiser4-export-remove_from_page_cache-fix.patch


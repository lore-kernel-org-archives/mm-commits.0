From: akpm@linux-foundation.org
Subject: + bnx2x-depends-on-zlib_inflate.patch added to -mm tree
Date: Thu, 29 Nov 2007 15:02:39 -0800
Message-ID: <200711292302.lATN2dMF011819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58237 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759343AbXK2XCv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 18:02:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, eliezert@broadcom.com, jeff@garzik.org, lee.schermerhorn@hp.com


The patch titled
     bnx2x depends on ZLIB_INFLATE
has been added to the -mm tree.  Its filename is
     bnx2x-depends-on-zlib_inflate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bnx2x depends on ZLIB_INFLATE
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

The bnx2x module depends on the zlib_inflate functions.  The build will
fail if ZLIB_INFLATE has not been selected manually or by building another
module that automatically selects it.

Modify BNX2X config option to 'select ZLIB_INFLATE' like BNX2
and others.  This seems to fix it.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Eliezer Tamir <eliezert@broadcom.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/Kconfig~bnx2x-depends-on-zlib_inflate drivers/net/Kconfig
--- a/drivers/net/Kconfig~bnx2x-depends-on-zlib_inflate
+++ a/drivers/net/Kconfig
@@ -2606,6 +2606,7 @@ config TEHUTI
 config BNX2X
 	tristate "Broadcom NetXtremeII 10Gb support"
 	depends on PCI
+	select ZLIB_INFLATE
 	help
 	  This driver supports Broadcom NetXtremeII 10 gigabit Ethernet cards.
 	  To compile this driver as a module, choose M here: the module
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

bnx2x-depends-on-zlib_inflate.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch

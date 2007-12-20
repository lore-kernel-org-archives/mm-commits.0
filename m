From: akpm@linux-foundation.org
Subject: - bnx2x-depends-on-zlib_inflate.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:37:52 -0800
Message-ID: <200712202337.lBKNbqvK018934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757568AbXLTXsG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:48:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, eliezert@broadcom.com, jeff@garzik.org, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     bnx2x depends on ZLIB_INFLATE
has been removed from the -mm tree.  Its filename was
     bnx2x-depends-on-zlib_inflate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2607,6 +2607,7 @@ config TEHUTI
 config BNX2X
 	tristate "Broadcom NetXtremeII 10Gb support"
 	depends on PCI
+	select ZLIB_INFLATE
 	help
 	  This driver supports Broadcom NetXtremeII 10 gigabit Ethernet cards.
 	  To compile this driver as a module, choose M here: the module
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

git-netdev-all.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-bugfix-for-memory-cgroup-per-zone-struct-allocation.patch

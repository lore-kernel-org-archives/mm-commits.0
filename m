From: akpm@linux-foundation.org
Subject: - drivers-spi-move-a-dereference-below-a-null-test.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:49 -0800
Message-ID: <200901072217.n07MHnu0017384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762205AbZAGWSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:18:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     drivers/spi: move a dereference below a NULL test
has been removed from the -mm tree.  Its filename was
     drivers-spi-move-a-dereference-below-a-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/spi: move a dereference below a NULL test
From: Julia Lawall <julia@diku.dk>

In each case, if the NULL test is necessary, then the dereference should be
moved below the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/spi/pxa2xx_spi.c~drivers-spi-move-a-dereference-below-a-null-test drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~drivers-spi-move-a-dereference-below-a-null-test
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1561,11 +1561,12 @@ out_error_master_alloc:
 static int pxa2xx_spi_remove(struct platform_device *pdev)
 {
 	struct driver_data *drv_data = platform_get_drvdata(pdev);
-	struct ssp_device *ssp = drv_data->ssp;
+	struct ssp_device *ssp;
 	int status = 0;
 
 	if (!drv_data)
 		return 0;
+	ssp = drv_data->ssp;
 
 	/* Remove the queue */
 	status = destroy_queue(drv_data);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
powerpc-powermac-add-missing-of_node_put.patch
net-tipc-bcasth-use-array_size.patch
net-bridge-netfilter-move-a-dereference-below-a-null-test.patch
drivers-isdn-hardware-misdn-move-a-dereference-below-a-null-test.patch
drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test.patch
drivers-net-wireless-libertas-move-a-dereference-below-a-null-test.patch


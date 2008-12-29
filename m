From: akpm@linux-foundation.org
Subject: - drivers-mmc-move-a-dereference-below-a-null-test.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:19:06 -0800
Message-ID: <200812291919.mBTJJ6gK031410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbYL2TTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:19:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     drivers/mmc: move a dereference below a NULL test
has been removed from the -mm tree.  Its filename was
     drivers-mmc-move-a-dereference-below-a-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mmc: move a dereference below a NULL test
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/tmio_mmc.c~drivers-mmc-move-a-dereference-below-a-null-test drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~drivers-mmc-move-a-dereference-below-a-null-test
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -224,7 +224,7 @@ static inline void tmio_mmc_data_irq(str
 {
 	void __iomem *ctl = host->ctl;
 	struct mmc_data *data = host->data;
-	struct mmc_command *stop = data->stop;
+	struct mmc_command *stop;
 
 	host->data = NULL;
 
@@ -232,6 +232,7 @@ static inline void tmio_mmc_data_irq(str
 		pr_debug("Spurious data end IRQ\n");
 		return;
 	}
+	stop = data->stop;
 
 	/* FIXME - return correct transfer count on errors */
 	if (!data->error)
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
powerpc-powermac-add-missing-of_node_put.patch
net-tipc-bcasth-use-array_size.patch
net-bridge-netfilter-move-a-dereference-below-a-null-test.patch
drivers-isdn-hardware-misdn-move-a-dereference-below-a-null-test.patch
drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test.patch
drivers-net-wireless-libertas-move-a-dereference-below-a-null-test.patch
drivers-scsi-move-a-dereference-below-a-null-test.patch
fs-namespacec-drop-code-after-return.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch
drivers-spi-move-a-dereference-below-a-null-test.patch
drivers-rtc-correct-an-error-test.patch


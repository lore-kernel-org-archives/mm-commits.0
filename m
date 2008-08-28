From: akpm@linux-foundation.org
Subject: - e100-fix-iomap-read.patch removed from -mm tree
Date: Thu, 28 Aug 2008 14:48:41 -0700
Message-ID: <200808282148.m7SLmfmC016116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756073AbYH1Vut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 17:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, bruce.w.allan@intel.com, jeff@garzik.org, jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com, john.ronciak@intel.com, peter.p.waskiewicz.jr@intel.com, mm-com


The patch titled
     e100: fix iomap read
has been removed from the -mm tree.  Its filename was
     e100-fix-iomap-read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e100: fix iomap read
From: Jiri Slaby <jirislaby@gmail.com>

There were 2 omitted readb's used on an iomap space. eliminate them
by using ioread8 instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>
Cc: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
Cc: John Ronciak <john.ronciak@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e100.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/e100.c~e100-fix-iomap-read drivers/net/e100.c
--- a/drivers/net/e100.c~e100-fix-iomap-read
+++ a/drivers/net/e100.c
@@ -1727,7 +1727,7 @@ static int e100_rx_indicate(struct nic *
 		if ((le16_to_cpu(rfd->command) & cb_el) &&
 		    (RU_RUNNING == nic->ru_running))
 
-			if (readb(&nic->csr->scb.status) & rus_no_res)
+			if (ioread8(&nic->csr->scb.status) & rus_no_res)
 				nic->ru_running = RU_SUSPENDED;
 		return -ENODATA;
 	}
@@ -1750,7 +1750,7 @@ static int e100_rx_indicate(struct nic *
 	if ((le16_to_cpu(rfd->command) & cb_el) &&
 	    (RU_RUNNING == nic->ru_running)) {
 
-	    if (readb(&nic->csr->scb.status) & rus_no_res)
+	    if (ioread8(&nic->csr->scb.status) & rus_no_res)
 		nic->ru_running = RU_SUSPENDED;
 	}
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
mm-owner-fix-race-between-swap-and-exit-fix.patch
char-sx-remove-bogus-iomap.patch
serial-mpc52xx_uart-remove-code-associated-with-config_ppc_merge.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
char-moxac-sparse-annotation.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch


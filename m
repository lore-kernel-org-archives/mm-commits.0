From: akpm@linux-foundation.org
Subject: [merged] atm-nicstar-dont-use-idr_remove_all.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:30 -0800
Message-ID: <20130228201231.0E3B331C211@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:56418 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab3B1UMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:31 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so244891ggi.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, chas@cmf.nrl.navy.mil, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: atm/nicstar: don't use idr_remove_all()
has been removed from the -mm tree.  Its filename was
     atm-nicstar-dont-use-idr_remove_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: atm/nicstar: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/nicstar.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/atm/nicstar.c~atm-nicstar-dont-use-idr_remove_all drivers/atm/nicstar.c
--- a/drivers/atm/nicstar.c~atm-nicstar-dont-use-idr_remove_all
+++ a/drivers/atm/nicstar.c
@@ -251,7 +251,6 @@ static void nicstar_remove_one(struct pc
 		if (card->scd2vc[j] != NULL)
 			free_scq(card, card->scd2vc[j]->scq, card->scd2vc[j]->tx_vcc);
 	}
-	idr_remove_all(&card->idr);
 	idr_destroy(&card->idr);
 	pci_free_consistent(card->pcidev, NS_RSQSIZE + NS_RSQ_ALIGNMENT,
 			    card->rsq.org, card->rsq.dma);
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch


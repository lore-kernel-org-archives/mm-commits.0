From: akpm@linux-foundation.org
Subject: [merged] sfc-modify-allocation-error-message.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:33 -0700
Message-ID: <200905261935.n4QJZXNd006355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756753AbZEZTps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:45:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, bhutchings@solarflare.com, davem@davemloft.net, mingo@elte.hu, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     sfc: modify allocation error message
has been removed from the -mm tree.  Its filename was
     sfc-modify-allocation-error-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sfc: modify allocation error message
From: Mike Travis <travis@sgi.com>

Change error message when alloc_cpumask_var fails.

Repairs "cpumask: convert drivers/net/sfc".

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Ben Hutchings <bhutchings@solarflare.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/efx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/sfc/efx.c~sfc-modify-allocation-error-message drivers/net/sfc/efx.c
--- a/drivers/net/sfc/efx.c~sfc-modify-allocation-error-message
+++ a/drivers/net/sfc/efx.c
@@ -894,9 +894,9 @@ static int efx_wanted_rx_queues(void)
 	int count;
 	int cpu;
 
-	if (!alloc_cpumask_var(&core_mask, GFP_KERNEL)) {
+	if (unlikely(!alloc_cpumask_var(&core_mask, GFP_KERNEL))) {
 		printk(KERN_WARNING
-		       "efx.c: allocation failure, irq balancing hobbled\n");
+		       "sfc: RSS disabled due to allocation failure\n");
 		return 1;
 	}
 
_

Patches currently in -mm which might be from travis@sgi.com are

linux-next.patch


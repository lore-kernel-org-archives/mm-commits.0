From: akpm@linux-foundation.org
Subject: + sfc-modify-allocation-error-message.patch added to -mm tree
Date: Wed, 28 Jan 2009 17:04:33 -0800
Message-ID: <200901290104.n0T14Xe9027131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbZA2BFH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 20:05:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, bhutchings@solarflare.com


The patch titled
     sfc: modify allocation error message
has been added to the -mm tree.  Its filename is
     sfc-modify-allocation-error-message.patch

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
Subject: sfc: modify allocation error message
From: Mike Travis <travis@sgi.com>

Change error message when alloc_cpumask_var fails.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/efx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/sfc/efx.c~sfc-modify-allocation-error-message drivers/net/sfc/efx.c
--- a/drivers/net/sfc/efx.c~sfc-modify-allocation-error-message
+++ a/drivers/net/sfc/efx.c
@@ -857,9 +857,9 @@ static int efx_wanted_rx_queues(void)
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
sfc-modify-allocation-error-message.patch
sysrq-include-interrupth-instead-of-irqh.patch


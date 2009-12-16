From: akpm@linux-foundation.org
Subject: [merged] gru-remove-stray-local_irq_enable.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:58 -0800
Message-ID: <200912162040.nBGKewbw013691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965027AbZLPUlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:41:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: remove stray local_irq_enable
has been removed from the -mm tree.  Its filename was
     gru-remove-stray-local_irq_enable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: remove stray local_irq_enable
From: Jack Steiner <steiner@sgi.com>

Remove a stray local_irq_enable() in the GRU TLB dropin code.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-remove-stray-local_irq_enable drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-remove-stray-local_irq_enable
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -253,7 +253,6 @@ static int atomic_pte_lookup(struct vm_a
 	return 0;
 
 err:
-	local_irq_enable();
 	return 1;
 }
 
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch


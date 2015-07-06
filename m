From: akpm@linux-foundation.org
Subject: [merged] cxgb3-use-kvfree-in-cxgb_free_mem.patch removed from -mm tree
Date: Mon, 06 Jul 2015 12:47:43 -0700
Message-ID: <559adb5f.HFKUPMkecVfS2fhB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbbGFTrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@kernel.org, santosh@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cxgb3: use kvfree() in cxgb_free_mem()
has been removed from the -mm tree.  Its filename was
     cxgb3-use-kvfree-in-cxgb_free_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pekka Enberg <penberg@kernel.org>
Subject: cxgb3: use kvfree() in cxgb_free_mem()

Use kvfree() instead of open-coding it.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Cc: Santosh Raspatur <santosh@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c~cxgb3-use-kvfree-in-cxgb_free_mem drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c~cxgb3-use-kvfree-in-cxgb_free_mem
+++ a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
@@ -1169,10 +1169,7 @@ void *cxgb_alloc_mem(unsigned long size)
  */
 void cxgb_free_mem(void *addr)
 {
-	if (is_vmalloc_addr(addr))
-		vfree(addr);
-	else
-		kfree(addr);
+	kvfree(addr);
 }
 
 /*
_

Patches currently in -mm which might be from penberg@kernel.org are

slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch


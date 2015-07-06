From: akpm@linux-foundation.org
Subject: [merged] ib-ehca-use-kvfree-in-ipz_queue_cdtor.patch removed from -mm tree
Date: Mon, 06 Jul 2015 12:47:51 -0700
Message-ID: <559adb67.qn9jENEuw2F42h+a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbbGFTrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@kernel.org, hnguyen@de.ibm.com, raisch@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: IB/ehca: use kvfree() in ipz_queue_{cd}tor()
has been removed from the -mm tree.  Its filename was
     ib-ehca-use-kvfree-in-ipz_queue_cdtor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pekka Enberg <penberg@kernel.org>
Subject: IB/ehca: use kvfree() in ipz_queue_{cd}tor()

Use kvfree() instead of open-coding it.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ehca/ipz_pt_fn.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/infiniband/hw/ehca/ipz_pt_fn.c~ib-ehca-use-kvfree-in-ipz_queue_cdtor drivers/infiniband/hw/ehca/ipz_pt_fn.c
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.c~ib-ehca-use-kvfree-in-ipz_queue_cdtor
+++ a/drivers/infiniband/hw/ehca/ipz_pt_fn.c
@@ -245,10 +245,7 @@ int ipz_queue_ctor(struct ehca_pd *pd, s
 ipz_queue_ctor_exit0:
 	ehca_gen_err("Couldn't alloc pages queue=%p "
 		 "nr_of_pages=%x",  queue, nr_of_pages);
-	if (is_vmalloc_addr(queue->queue_pages))
-		vfree(queue->queue_pages);
-	else
-		kfree(queue->queue_pages);
+	kvfree(queue->queue_pages);
 
 	return 0;
 }
@@ -270,10 +267,7 @@ int ipz_queue_dtor(struct ehca_pd *pd, s
 			free_page((unsigned long)queue->queue_pages[i]);
 	}
 
-	if (is_vmalloc_addr(queue->queue_pages))
-		vfree(queue->queue_pages);
-	else
-		kfree(queue->queue_pages);
+	kvfree(queue->queue_pages);
 
 	return 1;
 }
_

Patches currently in -mm which might be from penberg@kernel.org are

slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch


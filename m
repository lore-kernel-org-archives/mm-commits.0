Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C61AC5517A
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C105424673
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408225;
	bh=23t0avVyn8kCQIYJY1i05teqI6oyhMMLr9raWAAUnEs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Nh8T37+AaffncgQs7HFxa9/IiZKJksKil4KQJfm/rNtmwuOdfO2cWtBTqINt3VK9Z
	 Jge/BcErg2p3Z3drxBfM7vU0pet2mYSNDH7i5vX2Yr5vuhXjGnoG9Rnktrk+kDz5xG
	 qtv9k60dERA2o2UKnp6wEs/DMcM1pPjRsRSVrc+8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373264AbgJVXKZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373254AbgJVXKZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:10:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7A4E24650;
        Thu, 22 Oct 2020 23:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408224;
        bh=23t0avVyn8kCQIYJY1i05teqI6oyhMMLr9raWAAUnEs=;
        h=Date:From:To:Subject:From;
        b=EIX6PtTxyznl8wGooy8I8QDNnnn5wE3znpGk4uyNVcVYhyrP026iDEOfLtZ01D450
         2mWFkCM+vJ3kDHEYQUeaJNc8RNZ10sdv4v3GKFMMglAG6SpdxevQZY1SgV2cSnm0YU
         IpnBoF4UwBpYzrJ8W6alJVtLzxnI8l/YoGrN6TEs=
Date:   Thu, 22 Oct 2020 16:10:23 -0700
From:   akpm@linux-foundation.org
To:     boris.ostrovsky@oracle.com, chris@chris-wilson.co.uk, hch@lst.de,
        jani.nikula@linux.intel.com, jgross@suse.com,
        joonas.lahtinen@linux.intel.com, matthew.auld@intel.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, tvrtko.ursulin@intel.com, urezki@gmail.com,
        willy@infradead.org
Subject:  [merged]
 xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch
 removed from -mm tree
Message-ID: <20201022231023.f9XAggNVc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xen/xenbus: use apply_to_page_range directly in xenbus_map_ring_pv
has been removed from the -mm tree.  Its filename was
     xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: xen/xenbus: use apply_to_page_range directly in xenbus_map_ring_pv

Replacing alloc_vm_area with get_vm_area_caller + apply_page_range allows
to fill put the phys_addr values directly instead of doing another loop
over all addresses.

Link: https://lkml.kernel.org/r/20201002122204.1534411-10-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/xenbus/xenbus_client.c |   30 ++++++++++++++-------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/drivers/xen/xenbus/xenbus_client.c~xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv
+++ a/drivers/xen/xenbus/xenbus_client.c
@@ -73,16 +73,13 @@ struct map_ring_valloc {
 	struct xenbus_map_node *node;
 
 	/* Why do we need two arrays? See comment of __xenbus_map_ring */
-	union {
-		unsigned long addrs[XENBUS_MAX_RING_GRANTS];
-		pte_t *ptes[XENBUS_MAX_RING_GRANTS];
-	};
+	unsigned long addrs[XENBUS_MAX_RING_GRANTS];
 	phys_addr_t phys_addrs[XENBUS_MAX_RING_GRANTS];
 
 	struct gnttab_map_grant_ref map[XENBUS_MAX_RING_GRANTS];
 	struct gnttab_unmap_grant_ref unmap[XENBUS_MAX_RING_GRANTS];
 
-	unsigned int idx;	/* HVM only. */
+	unsigned int idx;
 };
 
 static DEFINE_SPINLOCK(xenbus_valloc_lock);
@@ -686,6 +683,14 @@ int xenbus_unmap_ring_vfree(struct xenbu
 EXPORT_SYMBOL_GPL(xenbus_unmap_ring_vfree);
 
 #ifdef CONFIG_XEN_PV
+static int map_ring_apply(pte_t *pte, unsigned long addr, void *data)
+{
+	struct map_ring_valloc *info = data;
+
+	info->phys_addrs[info->idx++] = arbitrary_virt_to_machine(pte).maddr;
+	return 0;
+}
+
 static int xenbus_map_ring_pv(struct xenbus_device *dev,
 			      struct map_ring_valloc *info,
 			      grant_ref_t *gnt_refs,
@@ -694,18 +699,15 @@ static int xenbus_map_ring_pv(struct xen
 {
 	struct xenbus_map_node *node = info->node;
 	struct vm_struct *area;
-	int err = GNTST_okay;
-	int i;
-	bool leaked;
+	bool leaked = false;
+	int err = -ENOMEM;
 
-	area = alloc_vm_area(XEN_PAGE_SIZE * nr_grefs, info->ptes);
+	area = get_vm_area(XEN_PAGE_SIZE * nr_grefs, VM_IOREMAP);
 	if (!area)
 		return -ENOMEM;
-
-	for (i = 0; i < nr_grefs; i++)
-		info->phys_addrs[i] =
-			arbitrary_virt_to_machine(info->ptes[i]).maddr;
-
+	if (apply_to_page_range(&init_mm, (unsigned long)area->addr,
+				XEN_PAGE_SIZE * nr_grefs, map_ring_apply, info))
+		goto failed;
 	err = __xenbus_map_ring(dev, gnt_refs, nr_grefs, node->handles,
 				info, GNTMAP_host_map | GNTMAP_contains_pte,
 				&leaked);
_

Patches currently in -mm which might be from hch@lst.de are



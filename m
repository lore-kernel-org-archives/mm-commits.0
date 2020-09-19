Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502A2C43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AD3822208
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600474133;
	bh=Li9sJRlSwcqjbLwIixq6cr1y7qOMP3gJ3mNoi5+g6O0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LrWqmj2x62qBWs22ad9popgWw2mK8V8bvVJ0AdO2MWrjKdvZi5Jv+olVmfNiaGhC0
	 Fx6i67Iuri07wGF1QQ2PKAvxEikdiQR6qrukQDghj2wq4YFq5qJtqhWdSXSriEqjmt
	 foATp5e9qJNWDnoeeOxAfJSLZFl5uIJavW8yCjGo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgISAIw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:08:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAIw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:08:52 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05A7821D43;
        Sat, 19 Sep 2020 00:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600474132;
        bh=Li9sJRlSwcqjbLwIixq6cr1y7qOMP3gJ3mNoi5+g6O0=;
        h=Date:From:To:Subject:From;
        b=AwgqWEv/jrC7WX0HSIPHBjeh8qcF9Yh7QfZ99+YigG/owxo/Vrs6dPlUtzUxTlZJa
         zcJ3Wsz1HpJ0DobLY1M4QgyE/zXqlqHJSnJqm1AYt4lx4Pszhi5+ikdYd2mNDYJ4sm
         8utGN4zUk2b9SjQcnsBxDqi4KfhITGNDbajXDnlQ=
Date:   Fri, 18 Sep 2020 17:08:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hch@lst.de
Subject:  +
 xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch added
 to -mm tree
Message-ID: <20200919000851.XBbix%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xen/xenbus: use apply_to_page_range directly in xenbus_map_ring_pv
has been added to the -mm tree.  Its filename is
     xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: xen/xenbus: use apply_to_page_range directly in xenbus_map_ring_pv

Replacing alloc_vm_area with get_vm_area_caller + apply_page_range allows
to fill put the phys_addr values directly instead of doing another loop
over all addresses.

Link: https://lkml.kernel.org/r/20200918163724.2511-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
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

zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch
mm-add-a-vmap_pfn-function.patch
drm-i915-use-vmap-in-shmem_pin_map.patch
drm-i915-use-vmap-in-i915_gem_object_map.patch
xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch
x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch


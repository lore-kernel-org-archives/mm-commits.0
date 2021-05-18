Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5536C433ED
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 22:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6EF56135B
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 22:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbhERWE7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 18:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236218AbhERWE6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 18:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF10A61004;
        Tue, 18 May 2021 22:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621375419;
        bh=yLj9piA7ZgcaDFrwJAH8Hp6x/mOXsh6qDpl/Ya+W1JA=;
        h=Date:From:To:Subject:From;
        b=AueHDNx0ERNmlNbpJ0TQFrI8xrJlSxQU8Qc5KDXmH9BTaboxvHuEV7703dEi/zEC2
         PFr/sjCjdCjqtimBgzp536c2cN7mX9iiMY/J9j1LeFeVGiwKuLFGpfibRGqjC4lwlo
         lN0MqxRE84pWmqElTUOguNgoFmig0Fi+S/PEPE6c=
Date:   Tue, 18 May 2021 15:03:38 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org
Subject:  + mm-remove-devm_request_free_mem_region.patch added to
 -mm tree
Message-ID: <20210518220338.cIt_ZKwc0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove devm_request_free_mem_region
has been added to the -mm tree.  Its filename is
     mm-remove-devm_request_free_mem_region.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-devm_request_free_mem_region.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-devm_request_free_mem_region.patch

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
Subject: mm: remove devm_request_free_mem_region

Remove the unused devm_request_free_mem_region, massage the kerneldoc
comment for devm_request_free_mem_region into one documenting the actual
used request_free_mem_region function and fold __request_free_mem_region
into request_free_mem_region now that no other caller is left.

Link: https://lkml.kernel.org/r/20210518063922.2910123-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hmm.rst |    5 +--
 include/linux/ioport.h   |    2 -
 kernel/resource.c        |   60 ++++++++-----------------------------
 3 files changed, 15 insertions(+), 52 deletions(-)

--- a/Documentation/vm/hmm.rst~mm-remove-devm_request_free_mem_region
+++ a/Documentation/vm/hmm.rst
@@ -299,9 +299,8 @@ These can be allocated and freed with::
     memunmap_pages(&pagemap);
     release_mem_region(pagemap.range.start, range_len(&pagemap.range));
 
-There are also devm_request_free_mem_region(), devm_memremap_pages(),
-devm_memunmap_pages(), and devm_release_mem_region() when the resources can
-be tied to a ``struct device``.
+There are also devm_memremap_pages() and devm_memunmap_pages() when the
+resources can be tied to a ``struct device``.
 
 The overall migration steps are similar to migrating NUMA pages within system
 memory (see :ref:`Page migration <page_migration>`) but the steps are split
--- a/include/linux/ioport.h~mm-remove-devm_request_free_mem_region
+++ a/include/linux/ioport.h
@@ -323,8 +323,6 @@ extern int
 walk_iomem_res_desc(unsigned long desc, unsigned long flags, u64 start, u64 end,
 		    void *arg, int (*func)(struct resource *, void *));
 
-struct resource *devm_request_free_mem_region(struct device *dev,
-		struct resource *base, unsigned long size);
 struct resource *request_free_mem_region(struct resource *base,
 		unsigned long size, const char *name);
 
--- a/kernel/resource.c~mm-remove-devm_request_free_mem_region
+++ a/kernel/resource.c
@@ -1775,12 +1775,22 @@ void resource_list_free(struct list_head
 EXPORT_SYMBOL(resource_list_free);
 
 #ifdef CONFIG_DEVICE_PRIVATE
-static struct resource *__request_free_mem_region(struct device *dev,
-		struct resource *base, unsigned long size, const char *name)
+/**
+ * request_free_mem_region - find free region for device private memory
+ *
+ * @base: resource tree to look in
+ * @size: size in bytes of the device memory to add
+ * @name: name that describes the region
+ *
+ * This function tries to find an empty range of physical address big enough to
+ * contain the new resource, so that it can later be hotplugged as ZONE_DEVICE
+ * memory, which in turn allocates struct pages.
+ */
+struct resource *request_free_mem_region(struct resource *base,
+		unsigned long size, const char *name)
 {
 	resource_size_t end, addr;
 	struct resource *res;
-	struct region_devres *dr = NULL;
 
 	size = ALIGN(size, 1UL << PA_SECTION_SHIFT);
 	end = min_t(unsigned long, base->end, (1UL << MAX_PHYSMEM_BITS) - 1);
@@ -1790,15 +1800,6 @@ static struct resource *__request_free_m
 	if (!res)
 		return ERR_PTR(-ENOMEM);
 
-	if (dev) {
-		dr = devres_alloc(devm_region_release,
-				sizeof(struct region_devres), GFP_KERNEL);
-		if (!dr) {
-			free_resource(res);
-			return ERR_PTR(-ENOMEM);
-		}
-	}
-
 	write_lock(&resource_lock);
 	for (; addr > size && addr >= base->start; addr -= size) {
 		if (__region_intersects(addr, size, 0, IORES_DESC_NONE) !=
@@ -1809,13 +1810,6 @@ static struct resource *__request_free_m
 						name, 0))
 			break;
 
-		if (dev) {
-			dr->parent = &iomem_resource;
-			dr->start = addr;
-			dr->n = size;
-			devres_add(dev, dr);
-		}
-
 		res->desc = IORES_DESC_DEVICE_PRIVATE_MEMORY;
 		write_unlock(&resource_lock);
 
@@ -1828,37 +1822,9 @@ static struct resource *__request_free_m
 	write_unlock(&resource_lock);
 
 	free_resource(res);
-	if (dr)
-		devres_free(dr);
-
 	return ERR_PTR(-ERANGE);
 }
-
-/**
- * devm_request_free_mem_region - find free region for device private memory
- *
- * @dev: device struct to bind the resource to
- * @size: size in bytes of the device memory to add
- * @base: resource tree to look in
- *
- * This function tries to find an empty range of physical address big enough to
- * contain the new resource, so that it can later be hotplugged as ZONE_DEVICE
- * memory, which in turn allocates struct pages.
- */
-struct resource *devm_request_free_mem_region(struct device *dev,
-		struct resource *base, unsigned long size)
-{
-	return __request_free_mem_region(dev, base, size, dev_name(dev));
-}
-EXPORT_SYMBOL_GPL(devm_request_free_mem_region);
-
-struct resource *request_free_mem_region(struct resource *base,
-		unsigned long size, const char *name)
-{
-	return __request_free_mem_region(NULL, base, size, name);
-}
 EXPORT_SYMBOL_GPL(request_free_mem_region);
-
 #endif /* CONFIG_DEVICE_PRIVATE */
 
 static int __init strict_iomem(char *str)
_

Patches currently in -mm which might be from hch@lst.de are

mm-remove-devm_request_free_mem_region.patch


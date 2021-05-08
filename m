Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49B2C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C95786142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhEHWzU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:55:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWzT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:55:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E47561448;
        Sat,  8 May 2021 22:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514457;
        bh=VYtbL9CWTh9wc2qsezZn8qDh3ViXLoPlHKvjsUivbHo=;
        h=Date:From:To:Subject:From;
        b=JWIvn5zxvTDoD6hnVKIyFhWtWt315zriYTp99gEoOxhV1ePpyLqJER/+eTWNXT+KJ
         9XBMDORNpGrc/kR/dtiYSw/zHM3UeMzQkgDbJk9XRjjv8Ytti5QlckzugCngbSD6to
         i8JnjoeqfcBVtJVsu1HXz5XoYN/CLz7Iu8BYcrGE=
Date:   Sat, 08 May 2021 15:54:17 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, bsingharora@gmail.com,
        dan.j.williams@intel.com, daniel.vetter@ffwll.ch, david@redhat.com,
        gregkh@linuxfoundation.org, jglisse@redhat.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org, smuchun@gmail.com
Subject:  [merged]
 kernel-resource-fix-locking-in-request_free_mem_region.patch removed from
 -mm tree
Message-ID: <20210508225417.JAy79kEHJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: fix locking in request_free_mem_region
has been removed from the -mm tree.  Its filename was
     kernel-resource-fix-locking-in-request_free_mem_region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: kernel/resource: fix locking in request_free_mem_region

request_free_mem_region() is used to find an empty range of physical
addresses for hotplugging ZONE_DEVICE memory.  It does this by iterating
over the range of possible addresses using region_intersects() to see if
the range is free before calling request_mem_region() to allocate the
region.

However the resource_lock is dropped between these two calls meaning by
the time request_mem_region() is called in request_free_mem_region()
another thread may have already reserved the requested region.  This
results in unexpected failures and a message in the kernel log from
hitting this condition:

        /*
         * mm/hmm.c reserves physical addresses which then
         * become unavailable to other users.  Conflicts are
         * not expected.  Warn to aid debugging if encountered.
         */
        if (conflict->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY) {
                pr_warn("Unaddressable device %s %pR conflicts with %pR",
                        conflict->name, conflict, res);

These unexpected failures can be corrected by holding resource_lock across
the two calls.  This also requires memory allocation to be performed prior
to taking the lock.

Link: https://lkml.kernel.org/r/20210419070109.4780-3-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Muchun Song <smuchun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   45 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

--- a/kernel/resource.c~kernel-resource-fix-locking-in-request_free_mem_region
+++ a/kernel/resource.c
@@ -1780,25 +1780,56 @@ static struct resource *__request_free_m
 {
 	resource_size_t end, addr;
 	struct resource *res;
+	struct region_devres *dr = NULL;
 
 	size = ALIGN(size, 1UL << PA_SECTION_SHIFT);
 	end = min_t(unsigned long, base->end, (1UL << MAX_PHYSMEM_BITS) - 1);
 	addr = end - size + 1UL;
 
+	res = alloc_resource(GFP_KERNEL);
+	if (!res)
+		return ERR_PTR(-ENOMEM);
+
+	if (dev) {
+		dr = devres_alloc(devm_region_release,
+				sizeof(struct region_devres), GFP_KERNEL);
+		if (!dr) {
+			free_resource(res);
+			return ERR_PTR(-ENOMEM);
+		}
+	}
+
+	write_lock(&resource_lock);
 	for (; addr > size && addr >= base->start; addr -= size) {
-		if (region_intersects(addr, size, 0, IORES_DESC_NONE) !=
+		if (__region_intersects(addr, size, 0, IORES_DESC_NONE) !=
 				REGION_DISJOINT)
 			continue;
 
-		if (dev)
-			res = devm_request_mem_region(dev, addr, size, name);
-		else
-			res = request_mem_region(addr, size, name);
-		if (!res)
-			return ERR_PTR(-ENOMEM);
+		if (!__request_region_locked(res, &iomem_resource, addr, size,
+						name, 0))
+			break;
+
+		if (dev) {
+			dr->parent = &iomem_resource;
+			dr->start = addr;
+			dr->n = size;
+			devres_add(dev, dr);
+		}
+
 		res->desc = IORES_DESC_DEVICE_PRIVATE_MEMORY;
+		write_unlock(&resource_lock);
+
+		/*
+		 * A driver is claiming this region so revoke any mappings.
+		 */
+		revoke_iomem(res);
 		return res;
 	}
+	write_unlock(&resource_lock);
+
+	free_resource(res);
+	if (dr)
+		devres_free(dr);
 
 	return ERR_PTR(-ERANGE);
 }
_

Patches currently in -mm which might be from apopple@nvidia.com are



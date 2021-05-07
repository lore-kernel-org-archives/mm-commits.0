Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7BBDC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE3C0613D8
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbhEGBGc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231297AbhEGBGb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:06:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0FD861289;
        Fri,  7 May 2021 01:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349531;
        bh=brZ9xkB7+GP4q07L2w+/BS9CwlZgMzL0lrghYvb3+EE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R29qoHsymC7UDq7FQdoPtSuHs+ha+cq6JPXbFs8JN7ZUUdJ4mPKOlWo2HCXZYrct7
         elzRdoZUCRoFqjV03TCdfxIa3ACWA2qnsxI2D3kO3nXLZZddSGBXGmCNmaDna33QB2
         PlvMJKRLkA5d8Q7FZT29ClITVhuVrG8AdzBUbtok=
Date:   Thu, 06 May 2021 18:05:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com,
        bsingharora@gmail.com, dan.j.williams@intel.com,
        daniel.vetter@ffwll.ch, david@redhat.com,
        gregkh@linuxfoundation.org, jglisse@redhat.com,
        jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, smuchun@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 66/91] kernel/resource: fix locking in
 request_free_mem_region
Message-ID: <20210507010530.uEl5utzt5%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

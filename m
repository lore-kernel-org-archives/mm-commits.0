Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3856FC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 174DB613C8
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbhEGBGY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231297AbhEGBGY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:06:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69B0E61289;
        Fri,  7 May 2021 01:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349524;
        bh=XAQQ8XwILTG/INR9nzM1dESbW0zYjavvpuimq4NvWpc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=am9WsPI4Oiwy3Cnmb7jisDGkZpTM3zpnOegNl5sifr8ySI+VwhS7p4OpoOzwoBRtj
         KJ0R+rnDgmN6jrpqGP/WQezE9eTwZoVWGoEVuH6+KL3rqvjbEVapzyAkfqEmOzW5XN
         Zc1nSuP41nwzfqF9cCpJ3++S8zalOH/9kFi/yLSM=
Date:   Thu, 06 May 2021 18:05:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com,
        bsingharora@gmail.com, dan.j.williams@intel.com,
        daniel.vetter@ffwll.ch, david@redhat.com,
        gregkh@linuxfoundation.org, jglisse@redhat.com,
        jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, smuchun@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 64/91] kernel/resource: allow region_intersects
 users to hold resource_lock
Message-ID: <20210507010524.md9CmXvZW%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alistair Popple <apopple@nvidia.com>
Subject: kernel/resource: allow region_intersects users to hold resource_lock

Introduce a version of region_intersects() that can be called with the
resource_lock already held. This is used in a future fix to
__request_free_mem_region().

[akpm@linux-foundation.org: make __region_intersects static]
Link: https://lkml.kernel.org/r/20210419070109.4780-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Muchun Song <smuchun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   52 ++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 21 deletions(-)

--- a/kernel/resource.c~kernel-resource-allow-region_intersects-users-to-hold-resource_lock
+++ a/kernel/resource.c
@@ -502,6 +502,34 @@ int __weak page_is_ram(unsigned long pfn
 }
 EXPORT_SYMBOL_GPL(page_is_ram);
 
+static int __region_intersects(resource_size_t start, size_t size,
+			unsigned long flags, unsigned long desc)
+{
+	struct resource res;
+	int type = 0; int other = 0;
+	struct resource *p;
+
+	res.start = start;
+	res.end = start + size - 1;
+
+	for (p = iomem_resource.child; p ; p = p->sibling) {
+		bool is_type = (((p->flags & flags) == flags) &&
+				((desc == IORES_DESC_NONE) ||
+				 (desc == p->desc)));
+
+		if (resource_overlaps(p, &res))
+			is_type ? type++ : other++;
+	}
+
+	if (type == 0)
+		return REGION_DISJOINT;
+
+	if (other == 0)
+		return REGION_INTERSECTS;
+
+	return REGION_MIXED;
+}
+
 /**
  * region_intersects() - determine intersection of region with known resources
  * @start: region start address
@@ -525,31 +553,13 @@ EXPORT_SYMBOL_GPL(page_is_ram);
 int region_intersects(resource_size_t start, size_t size, unsigned long flags,
 		      unsigned long desc)
 {
-	struct resource res;
-	int type = 0; int other = 0;
-	struct resource *p;
-
-	res.start = start;
-	res.end = start + size - 1;
+	int ret;
 
 	read_lock(&resource_lock);
-	for (p = iomem_resource.child; p ; p = p->sibling) {
-		bool is_type = (((p->flags & flags) == flags) &&
-				((desc == IORES_DESC_NONE) ||
-				 (desc == p->desc)));
-
-		if (resource_overlaps(p, &res))
-			is_type ? type++ : other++;
-	}
+	ret = __region_intersects(start, size, flags, desc);
 	read_unlock(&resource_lock);
 
-	if (type == 0)
-		return REGION_DISJOINT;
-
-	if (other == 0)
-		return REGION_INTERSECTS;
-
-	return REGION_MIXED;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(region_intersects);
 
_

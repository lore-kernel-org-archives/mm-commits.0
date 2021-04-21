Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BBCC433ED
	for <mm-commits@archiver.kernel.org>; Wed, 21 Apr 2021 03:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9A4361418
	for <mm-commits@archiver.kernel.org>; Wed, 21 Apr 2021 03:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhDUDAg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Apr 2021 23:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233874AbhDUDAf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Apr 2021 23:00:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CD3861415;
        Wed, 21 Apr 2021 03:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618974002;
        bh=aoOBXeVWZqBtBKG52LCv4ZVW54RJb6p96304DHGpYYI=;
        h=Date:From:To:Subject:From;
        b=IcYRqL4E7pQMEZnPsOswyalDboVJijbMdmJZGH54gAIeRKkpNlu0PfBeGzsOkuwsm
         BGd/ghBWqFo3mQPFzp7xvPjJ2CYHTjE6OXI7MmcKgw46IXjnAvS+bHBH+XCCDSsisW
         acvaGrBZKCYRj+zW5a/AZsUmPYr7+dtucdbI4EgU=
Date:   Tue, 20 Apr 2021 20:00:01 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, bsingharora@gmail.com,
        dan.j.williams@intel.com, daniel.vetter@ffwll.ch, david@redhat.com,
        gregkh@linuxfoundation.org, jglisse@redhat.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org, smuchun@gmail.com
Subject:  +
 kernel-resource-allow-region_intersects-users-to-hold-resource_lock.patch
 added to -mm tree
Message-ID: <20210421030001.RAJOsEFEs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: allow region_intersects users to hold resource_lock
has been added to the -mm tree.  Its filename is
     kernel-resource-allow-region_intersects-users-to-hold-resource_lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-resource-allow-region_intersects-users-to-hold-resource_lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-resource-allow-region_intersects-users-to-hold-resource_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: kernel/resource: allow region_intersects users to hold resource_lock

Introduce a version of region_intersects() that can be called with the
resource_lock already held. This is used in a future fix to
__request_free_mem_region().

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
 
+int __region_intersects(resource_size_t start, size_t size, unsigned long flags,
+			unsigned long desc)
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

Patches currently in -mm which might be from apopple@nvidia.com are

kernel-resource-allow-region_intersects-users-to-hold-resource_lock.patch
kernel-resource-refactor-__request_region-to-allow-external-locking.patch
kernel-resource-fix-locking-in-request_free_mem_region.patch


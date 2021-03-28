Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17450C433C1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE2D56197E
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhC1TMP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231586AbhC1TLp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E22361958;
        Sun, 28 Mar 2021 19:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616958704;
        bh=vBn3GFWUPM1yvyEZqog89jRYUymz8qXwY6TDU2GPZfE=;
        h=Date:From:To:Subject:From;
        b=iqCyVQFRWrMXbzZN6omPsMn5npElg+L65jOJveRInPihmpB70J8UiIar0mM7i8mmf
         1I5UTvXzHxc96u9HyNDCAp7UTI8LM0saKlhFTZ/Yrdb+l9/hwW+/1eP3dZUSboLp1H
         uc2FqmnrY2R5QtL3Hv7zp95TigMMRJjUuIxe0/WI=
Date:   Sun, 28 Mar 2021 12:11:44 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, dan.j.williams@intel.com,
        daniel.vetter@ffwll.ch, david@redhat.com,
        gregkh@linuxfoundation.org, jbarnes@virtuousgeek.org,
        jglisse@redhat.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org
Subject:  +
 kernel-resource-fix-locking-in-request_free_mem_region.patch added to -mm
 tree
Message-ID: <20210328191144.okUhn91YM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: Fix locking in request_free_mem_region
has been added to the -mm tree.  Its filename is
     kernel-resource-fix-locking-in-request_free_mem_region.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-resource-fix-locking-in-request_free_mem_region.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-resource-fix-locking-in-request_free_mem_region.patch

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
Subject: kernel/resource: Fix locking in request_free_mem_region

request_free_mem_region() is used to find an empty range of physical
addresses for hotplugging ZONE_DEVICE memory. It does this by iterating
over the range of possible addresses using region_intersects() to see if
the range is free.

region_intersects() obtains a read lock before walking the resource tree
to protect against concurrent changes. However it drops the lock prior
to returning. This means by the time request_mem_region() is called in
request_free_mem_region() another thread may have already reserved the
requested region resulting in unexpected failures and a message in the
kernel log from hitting this condition:

        /*
         * mm/hmm.c reserves physical addresses which then
         * become unavailable to other users.  Conflicts are
         * not expected.  Warn to aid debugging if encountered.
         */
        if (conflict->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY) {
                pr_warn("Unaddressable device %s %pR conflicts with %pR",
                        conflict->name, conflict, res);

To fix this create versions of region_intersects() and
request_mem_region() that allow the caller to take the appropriate lock
such that it may be held over the required calls.

Instead of creating another version of devm_request_mem_region() that
doesn't take the lock open-code it to allow the caller to pre-allocate
the required memory prior to taking the lock.

Link: https://lkml.kernel.org/r/20210326012035.3853-1-apopple@nvidia.com
Fixes: 0c385190392d8 ("resource: add a not device managed request_free_mem_region variant")
Fixes: 0092908d16c60 ("mm: factor out a devm_request_free_mem_region helper")
Fixes: 4ef589dc9b10c ("mm/hmm/devmem: device memory hotplug using ZONE_DEVICE")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |  146 ++++++++++++++++++++++++++++----------------
 1 file changed, 94 insertions(+), 52 deletions(-)

--- a/kernel/resource.c~kernel-resource-fix-locking-in-request_free_mem_region
+++ a/kernel/resource.c
@@ -523,6 +523,34 @@ int __weak page_is_ram(unsigned long pfn
 }
 EXPORT_SYMBOL_GPL(page_is_ram);
 
+static int __region_intersects(resource_size_t start, size_t size,
+			       unsigned long flags, unsigned long desc)
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
@@ -546,31 +574,12 @@ EXPORT_SYMBOL_GPL(page_is_ram);
 int region_intersects(resource_size_t start, size_t size, unsigned long flags,
 		      unsigned long desc)
 {
-	struct resource res;
-	int type = 0; int other = 0;
-	struct resource *p;
-
-	res.start = start;
-	res.end = start + size - 1;
+	int rc;
 
 	read_lock(&resource_lock);
-	for (p = iomem_resource.child; p ; p = p->sibling) {
-		bool is_type = (((p->flags & flags) == flags) &&
-				((desc == IORES_DESC_NONE) ||
-				 (desc == p->desc)));
-
-		if (resource_overlaps(p, &res))
-			is_type ? type++ : other++;
-	}
+	rc = __region_intersects(start, size, flags, desc);
 	read_unlock(&resource_lock);
-
-	if (type == 0)
-		return REGION_DISJOINT;
-
-	if (other == 0)
-		return REGION_INTERSECTS;
-
-	return REGION_MIXED;
+	return rc;
 }
 EXPORT_SYMBOL_GPL(region_intersects);
 
@@ -1171,31 +1180,17 @@ struct address_space *iomem_get_mapping(
 	return smp_load_acquire(&iomem_inode)->i_mapping;
 }
 
-/**
- * __request_region - create a new busy resource region
- * @parent: parent resource descriptor
- * @start: resource start address
- * @n: resource region size
- * @name: reserving caller's ID string
- * @flags: IO resource flags
- */
-struct resource * __request_region(struct resource *parent,
-				   resource_size_t start, resource_size_t n,
-				   const char *name, int flags)
+static bool request_region_locked(struct resource *parent,
+				    struct resource *res, resource_size_t start,
+				    resource_size_t n, const char *name, int flags)
 {
-	DECLARE_WAITQUEUE(wait, current);
-	struct resource *res = alloc_resource(GFP_KERNEL);
 	struct resource *orig_parent = parent;
-
-	if (!res)
-		return NULL;
+	DECLARE_WAITQUEUE(wait, current);
 
 	res->name = name;
 	res->start = start;
 	res->end = start + n - 1;
 
-	write_lock(&resource_lock);
-
 	for (;;) {
 		struct resource *conflict;
 
@@ -1230,16 +1225,39 @@ struct resource * __request_region(struc
 			write_lock(&resource_lock);
 			continue;
 		}
-		/* Uhhuh, that didn't work out.. */
-		free_resource(res);
-		res = NULL;
-		break;
+		return false;
 	}
-	write_unlock(&resource_lock);
 
 	if (res && orig_parent == &iomem_resource)
 		revoke_iomem(res);
 
+	return true;
+}
+
+/**
+ * __request_region - create a new busy resource region
+ * @parent: parent resource descriptor
+ * @start: resource start address
+ * @n: resource region size
+ * @name: reserving caller's ID string
+ * @flags: IO resource flags
+ */
+struct resource *__request_region(struct resource *parent,
+				  resource_size_t start, resource_size_t n,
+				  const char *name, int flags)
+{
+	struct resource *res = alloc_resource(GFP_KERNEL);
+
+	if (!res)
+		return NULL;
+
+	write_lock(&resource_lock);
+	if (!request_region_locked(parent, res, start, n, name, flags)) {
+		/* Uhhuh, that didn't work out.. */
+		free_resource(res);
+		res = NULL;
+	}
+	write_unlock(&resource_lock);
 	return res;
 }
 EXPORT_SYMBOL(__request_region);
@@ -1779,26 +1797,50 @@ static struct resource *__request_free_m
 {
 	resource_size_t end, addr;
 	struct resource *res;
+	struct region_devres *dr = NULL;
+
+	res = alloc_resource(GFP_KERNEL);
+	if (!res)
+		return ERR_PTR(-ENOMEM);
+
+	if (dev) {
+		dr = devres_alloc(devm_region_release, sizeof(struct region_devres),
+				  GFP_KERNEL);
+		if (!dr) {
+			free_resource(res);
+			return ERR_PTR(-ENOMEM);
+		}
+	}
 
 	size = ALIGN(size, 1UL << PA_SECTION_SHIFT);
 	end = min_t(unsigned long, base->end, (1UL << MAX_PHYSMEM_BITS) - 1);
 	addr = end - size + 1UL;
 
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
+		if (!request_region_locked(&iomem_resource, res, addr,
+						   size, name, 0))
+			break;
+
 		res->desc = IORES_DESC_DEVICE_PRIVATE_MEMORY;
+		if (dev) {
+			dr->parent = &iomem_resource;
+			dr->start = addr;
+			dr->n = size;
+			devres_add(dev, dr);
+		}
+
+		write_unlock(&resource_lock);
 		return res;
 	}
 
+	write_unlock(&resource_lock);
+	free_resource(res);
+
 	return ERR_PTR(-ERANGE);
 }
 
_

Patches currently in -mm which might be from apopple@nvidia.com are

kernel-resource-fix-locking-in-request_free_mem_region.patch


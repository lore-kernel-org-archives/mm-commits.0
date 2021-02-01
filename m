Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B114CC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DE4364ECC
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBAXuJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 18:50:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbhBAXuI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 18:50:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59FA564E93;
        Mon,  1 Feb 2021 23:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612223367;
        bh=D8hR+PcpY0iCGHHxvh5XDFTWBKf56W9FE5LGjqkuwQA=;
        h=Date:From:To:Subject:From;
        b=So5GEa50XP/LKwhXOTNculXxC8SivYRVWKdRGJ8J2nu8KUSIT0b2ooNHeMMwkLANh
         3CDG7WI5gmv8U4RkfWqpe97pyAZopJ00JetM2Tk91HGWYMTIERqVf+fCLVV1Q+rsse
         2gdX+91Us9aGQE9tsN9xN8qxJHnGM6KTtN9859ts=
Date:   Mon, 01 Feb 2021 15:49:25 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, ardb@kernel.org,
        catalin.marinas@arm.com, david@redhat.com, gor@linux.ibm.com,
        hca@linux.ibm.com, jasowang@redhat.com,
        Jonathan.Cameron@huawei.com, mark.rutland@arm.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        pankaj.gupta@cloud.ionos.com, richard.weiyang@linux.alibaba.com,
        teawaterz@linux.alibaba.com, will@kernel.org
Subject:  +
 =?US-ASCII?Q?mm-memory=5Fhotplug-prevalidate-the-address-range-being-a?=
 =?US-ASCII?Q?dded-with-platform.patch?= added to -mm tree
Message-ID: <20210201234925.0vQik7nmk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: prevalidate the address range being added with platform
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/memory_hotplug: prevalidate the address range being added with platform

Patch series "mm/memory_hotplug: Pre-validate the address range with platform", v5.

This series adds a mechanism allowing platforms to weigh in and
prevalidate incoming address range before proceeding further with the
memory hotplug.  This helps prevent potential platform errors for the
given address range, down the hotplug call chain, which inevitably fails
the hotplug itself.

This mechanism was suggested by David Hildenbrand during another
discussion with respect to a memory hotplug fix on arm64 platform.

https://lore.kernel.org/linux-arm-kernel/1600332402-30123-1-git-send-email-anshuman.khandual@arm.com/

This mechanism focuses on the addressibility aspect and not [sub] section
alignment aspect.  Hence check_hotplug_memory_range() and check_pfn_span()
have been left unchanged.


This patch (of 4):


This introduces mhp_range_allowed() which can be called in various memory
hotplug paths to prevalidate the address range which is being added, with
the platform.  Then mhp_range_allowed() calls mhp_get_pluggable_range()
which provides applicable address range depending on whether linear
mapping is required or not.  For ranges that require linear mapping, it
calls a new arch callback arch_get_mappable_range() which the platform can
override.  So the new callback, in turn provides the platform an
opportunity to configure acceptable memory hotplug address ranges in case
there are constraints.

This mechanism will help prevent platform specific errors deep down during
hotplug calls.  This drops now redundant
check_hotplug_memory_addressable() check in __add_pages() but instead adds
a VM_BUG_ON() check which would ensure that the range has been validated
with mhp_range_allowed() earlier in the call chain.  Besides
mhp_get_pluggable_range() also can be used by potential memory hotplug
callers to avail the allowed physical range which would go through on a
given platform.

This does not really add any new range check in generic memory hotplug but
instead compensates for lost checks in arch_add_memory() where applicable
and check_hotplug_memory_addressable(), with unified mhp_range_allowed().

Link: https://lkml.kernel.org/r/1612149902-7867-1-git-send-email-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/1612149902-7867-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com> # s390
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: teawater <teawaterz@linux.alibaba.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |   10 +++
 mm/memory_hotplug.c            |   78 +++++++++++++++++++++++--------
 mm/memremap.c                  |    6 +-
 3 files changed, 74 insertions(+), 20 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform
+++ a/include/linux/memory_hotplug.h
@@ -66,6 +66,9 @@ struct mhp_params {
 	pgprot_t pgprot;
 };
 
+bool mhp_range_allowed(u64 start, u64 size, bool need_mapping);
+struct range mhp_get_pluggable_range(bool need_mapping);
+
 /*
  * Zone resizing functions
  *
@@ -266,6 +269,13 @@ static inline bool movable_node_is_enabl
 }
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
+/*
+ * Keep this declaration outside CONFIG_MEMORY_HOTPLUG as some
+ * platforms might override and use arch_get_mappable_range()
+ * for internal non memory hotplug purposes.
+ */
+struct range arch_get_mappable_range(void);
+
 #if defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 /*
  * pgdat resizing functions
--- a/mm/memory_hotplug.c~mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform
+++ a/mm/memory_hotplug.c
@@ -107,6 +107,9 @@ static struct resource *register_memory_
 	if (strcmp(resource_name, "System RAM"))
 		flags |= IORESOURCE_SYSRAM_DRIVER_MANAGED;
 
+	if (!mhp_range_allowed(start, size, true))
+		return ERR_PTR(-E2BIG);
+
 	/*
 	 * Make sure value parsed from 'mem=' only restricts memory adding
 	 * while booting, so that memory hotplug won't be impacted. Please
@@ -284,22 +287,6 @@ static int check_pfn_span(unsigned long
 	return 0;
 }
 
-static int check_hotplug_memory_addressable(unsigned long pfn,
-					    unsigned long nr_pages)
-{
-	const u64 max_addr = PFN_PHYS(pfn + nr_pages) - 1;
-
-	if (max_addr >> MAX_PHYSMEM_BITS) {
-		const u64 max_allowed = (1ull << (MAX_PHYSMEM_BITS + 1)) - 1;
-		WARN(1,
-		     "Hotplugged memory exceeds maximum addressable address, range=%#llx-%#llx, maximum=%#llx\n",
-		     (u64)PFN_PHYS(pfn), max_addr, max_allowed);
-		return -E2BIG;
-	}
-
-	return 0;
-}
-
 /*
  * Return page for the valid pfn only if the page is online. All pfn
  * walkers which rely on the fully initialized page->flags and others
@@ -365,9 +352,7 @@ int __ref __add_pages(int nid, unsigned
 	if (WARN_ON_ONCE(!params->pgprot.pgprot))
 		return -EINVAL;
 
-	err = check_hotplug_memory_addressable(pfn, nr_pages);
-	if (err)
-		return err;
+	VM_BUG_ON(!mhp_range_allowed(PFN_PHYS(pfn), nr_pages * PAGE_SIZE, false));
 
 	if (altmap) {
 		/*
@@ -1248,6 +1233,61 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(add_memory_driver_managed);
 
+/*
+ * Platforms should define arch_get_mappable_range() that provides
+ * maximum possible addressable physical memory range for which the
+ * linear mapping could be created. The platform returned address
+ * range must adhere to these following semantics.
+ *
+ * - range.start <= range.end
+ * - Range includes both end points [range.start..range.end]
+ *
+ * There is also a fallback definition provided here, allowing the
+ * entire possible physical address range in case any platform does
+ * not define arch_get_mappable_range().
+ */
+struct range __weak arch_get_mappable_range(void)
+{
+	struct range mhp_range = {
+		.start = 0UL,
+		.end = -1ULL,
+	};
+	return mhp_range;
+}
+
+struct range mhp_get_pluggable_range(bool need_mapping)
+{
+	const u64 max_phys = (1ULL << MAX_PHYSMEM_BITS) - 1;
+	struct range mhp_range;
+
+	if (need_mapping) {
+		mhp_range = arch_get_mappable_range();
+		if (mhp_range.start > max_phys) {
+			mhp_range.start = 0;
+			mhp_range.end = 0;
+		}
+		mhp_range.end = min_t(u64, mhp_range.end, max_phys);
+	} else {
+		mhp_range.start = 0;
+		mhp_range.end = max_phys;
+	}
+	return mhp_range;
+}
+EXPORT_SYMBOL_GPL(mhp_get_pluggable_range);
+
+bool mhp_range_allowed(u64 start, u64 size, bool need_mapping)
+{
+	struct range mhp_range = mhp_get_pluggable_range(need_mapping);
+	u64 end = start + size;
+
+	if (start < end && start >= mhp_range.start && (end - 1) <= mhp_range.end)
+		return true;
+
+	pr_warn("Hotplug memory [%#llx-%#llx] exceeds maximum addressable range [%#llx-%#llx]\n",
+		start, end, mhp_range.start, mhp_range.end);
+	return false;
+}
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /*
  * Confirm all pages in a range [start, end) belong to the same zone (skipping
--- a/mm/memremap.c~mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform
+++ a/mm/memremap.c
@@ -220,6 +220,7 @@ static void dev_pagemap_percpu_release(s
 static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params *params,
 		int range_id, int nid)
 {
+	const bool is_private = pgmap->type == MEMORY_DEVICE_PRIVATE;
 	struct range *range = &pgmap->ranges[range_id];
 	struct dev_pagemap *conflict_pgmap;
 	int error, is_ram;
@@ -265,6 +266,9 @@ static int pagemap_range(struct dev_page
 	if (error)
 		goto err_pfn_remap;
 
+	if (!mhp_range_allowed(range->start, range_len(range), !is_private))
+		goto err_pfn_remap;
+
 	mem_hotplug_begin();
 
 	/*
@@ -278,7 +282,7 @@ static int pagemap_range(struct dev_page
 	 * the CPU, we do want the linear mapping and thus use
 	 * arch_add_memory().
 	 */
-	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
+	if (is_private) {
 		error = add_pages(nid, PHYS_PFN(range->start),
 				PHYS_PFN(range_len(range)), params);
 	} else {
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-basic-add-validation-for-dirtiness-after-write-protect.patch
mm-debug_vm_pgtable-basic-iterate-over-entire-protection_map.patch
mm-memory_hotplug-rename-all-existing-memhp-into-mhp.patch
mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform.patch
arm64-mm-define-arch_get_mappable_range.patch
s390-mm-define-arch_get_mappable_range.patch


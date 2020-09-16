Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C127C43461
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA0E622209
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600299139;
	bh=rL9HZKvCibbrccj+0y3WW8f3MwfaBcp4qzqIMHvB4VA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dTa0cSPD9oqJrMKWbeKrsHgxMNrEw3bdfGX2pp9aW8stDES6vePYy0CnkXfL4KeMc
	 Xo/1iMwCIiLUz4ukXy0Ay63+nBiUHH3xtPrk7omvT0vuRnGUIdt20ikAYvfKlAI7TD
	 apIFD66mqJV/Py+6V5wreXstvnoYO08e2x2fBaS0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgIPXcS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 19:32:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgIPXcR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 19:32:17 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2060722207;
        Wed, 16 Sep 2020 23:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600299136;
        bh=rL9HZKvCibbrccj+0y3WW8f3MwfaBcp4qzqIMHvB4VA=;
        h=Date:From:To:Subject:From;
        b=HZnPfd+G/12idZ35oJ4eqc7I+XmBoFTJw3elP9O/nHoy1fBjhBc12Umr6BZqbWCZU
         laSjC8TK4GuudWhOACvqJYc/MXkq4V5bYm1Kv6A9QxpEY/EUoApaW7iySX7Sm1hFyz
         0oIpzGWX8Opnpah58VeaHub1gQs4AxuBo1pu/y3Q=
Date:   Wed, 16 Sep 2020 16:32:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        pankaj.gupta.linux@gmail.com, mhocko@suse.com,
        keescook@chromium.org, jgg@ziepe.ca, dan.j.williams@intel.com,
        bhe@redhat.com, ardb@kernel.org, david@redhat.com
Subject:  +
 =?us-ascii?Q?kernel-resource-make-iomem=5Fresource-implicit-in-release?=
 =?us-ascii?Q?=5Fmem=5Fregion=5Fadjustable.patch?= added to -mm tree
Message-ID: <20200916233215.LoIFt%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: make iomem_resource implicit in release_mem_region_adjustable()
has been added to the -mm tree.  Its filename is
     kernel-resource-make-iomem_resource-implicit-in-release_mem_region_adjustable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-resource-make-iomem_resource-implicit-in-release_mem_region_adjustable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-resource-make-iomem_resource-implicit-in-release_mem_region_adjustable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: kernel/resource: make iomem_resource implicit in release_mem_region_adjustable()

"mem" in the name already indicates the root, similar to
release_mem_region() and devm_request_mem_region().  Make it implicit. 
The only single caller always passes iomem_resource, other parents are not
applicable.

Link: https://lkml.kernel.org/r/20200916073041.10355-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    3 +--
 kernel/resource.c      |    5 ++---
 mm/memory_hotplug.c    |    2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

--- a/include/linux/ioport.h~kernel-resource-make-iomem_resource-implicit-in-release_mem_region_adjustable
+++ a/include/linux/ioport.h
@@ -251,8 +251,7 @@ extern struct resource * __request_regio
 extern void __release_region(struct resource *, resource_size_t,
 				resource_size_t);
 #ifdef CONFIG_MEMORY_HOTREMOVE
-extern void release_mem_region_adjustable(struct resource *, resource_size_t,
-					  resource_size_t);
+extern void release_mem_region_adjustable(resource_size_t, resource_size_t);
 #endif
 #ifdef CONFIG_MEMORY_HOTPLUG
 extern void merge_system_ram_resource(struct resource *res);
--- a/kernel/resource.c~kernel-resource-make-iomem_resource-implicit-in-release_mem_region_adjustable
+++ a/kernel/resource.c
@@ -1240,7 +1240,6 @@ EXPORT_SYMBOL(__release_region);
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /**
  * release_mem_region_adjustable - release a previously reserved memory region
- * @parent: parent resource descriptor
  * @start: resource start address
  * @size: resource region size
  *
@@ -1258,9 +1257,9 @@ EXPORT_SYMBOL(__release_region);
  *   assumes that all children remain in the lower address entry for
  *   simplicity.  Enhance this logic when necessary.
  */
-void release_mem_region_adjustable(struct resource *parent,
-				   resource_size_t start, resource_size_t size)
+void release_mem_region_adjustable(resource_size_t start, resource_size_t size)
 {
+	struct resource *parent = &iomem_resource;
 	struct resource *new_res = NULL;
 	bool alloc_nofail = false;
 	struct resource **p;
--- a/mm/memory_hotplug.c~kernel-resource-make-iomem_resource-implicit-in-release_mem_region_adjustable
+++ a/mm/memory_hotplug.c
@@ -1769,7 +1769,7 @@ static int __ref try_remove_memory(int n
 		memblock_remove(start, size);
 	}
 
-	release_mem_region_adjustable(&iomem_resource, start, size);
+	release_mem_region_adjustable(start, size);
 
 	try_offline_node(nid);
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-tweak-comments-in-has_unmovable_pages.patch
mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate.patch
mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch
mm-page_isolation-cleanup-set_migratetype_isolate.patch
virtio-mem-dont-special-case-zone_movable.patch
mm-document-semantics-of-zone_movable.patch
mm-memory_hotplug-inline-__offline_pages-into-offline_pages.patch
mm-memory_hotplug-enforce-section-granularity-when-onlining-offlining.patch
mm-memory_hotplug-simplify-page-offlining.patch
mm-page_alloc-simplify-__offline_isolated_pages.patch
mm-memory_hotplug-drop-nr_isolate_pageblock-in-offline_pages.patch
mm-page_isolation-simplify-return-value-of-start_isolate_page_range.patch
mm-memory_hotplug-simplify-page-onlining.patch
mm-page_alloc-drop-stale-pageblock-comment-in-memmap_init_zone.patch
mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone.patch
mm-memory_hotplug-mark-pageblocks-migrate_isolate-while-onlining-memory.patch
kernel-resource-make-release_mem_region_adjustable-never-fail.patch
kernel-resource-move-and-rename-ioresource_mem_driver_managed.patch
mm-memory_hotplug-guard-more-declarations-by-config_memory_hotplug.patch
mm-memory_hotplug-prepare-passing-flags-to-add_memory-and-friends.patch
mm-memory_hotplug-memhp_merge_resource-to-specify-merging-of-system-ram-resources.patch
virtio-mem-try-to-merge-system-ram-resources.patch
xen-balloon-try-to-merge-system-ram-resources.patch
hv_balloon-try-to-merge-system-ram-resources.patch
kernel-resource-make-iomem_resource-implicit-in-release_mem_region_adjustable.patch


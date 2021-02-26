Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EB5C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EA9A64F24
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbhBZAl2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:41:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232398AbhBZAlZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:41:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E2A360202;
        Fri, 26 Feb 2021 00:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300044;
        bh=jBi9soNkA38YRDJCzYTKRovaxBHEN7B9qKhkgfUJZuc=;
        h=Date:From:To:Subject:From;
        b=vam0/VYUMbuzIlMSIWW5jocF8GloKhX4Yf6giUOLVN8LXAMlSdzl2343tiAa1rISz
         LkO9aa1jmyo8mO6tFiQJOo1XH0fdY/24BInpiD/OBICpyNnStP3n41SjJtVyE7spEQ
         NoCIV2yMbwl6WjfYQVQryE07/UqEfo8QomtHNyw0=
Date:   Thu, 25 Feb 2021 16:40:43 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        osalvador@suse.de, peterz@infradead.org,
        richard.weiyang@linux.alibaba.com, rientjes@google.com,
        rppt@kernel.org, tglx@linutronix.de, ziy@nvidia.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-page=5Falloc-count-cma-pages-per-zone-and-print-them-i?=
 =?US-ASCII?Q?n-proc-zoneinfo-v2.patch?= removed from -mm tree
Message-ID: <20210226004043.TAgKtQrjZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v2
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v2.patch

This patch was dropped because it was folded into mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v2

- Print/track only with CONFIG_CMA
- Extend patch description

Link: https://lkml.kernel.org/r/20210128164533.18566-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/vmstat.c            |    9 ++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v2
+++ a/include/linux/mmzone.h
@@ -530,7 +530,9 @@ struct zone {
 	atomic_long_t		managed_pages;
 	unsigned long		spanned_pages;
 	unsigned long		present_pages;
+#ifdef CONFIG_CMA
 	unsigned long		cma_pages;
+#endif
 
 	const char		*name;
 
--- a/mm/vmstat.c~mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v2
+++ a/mm/vmstat.c
@@ -1637,16 +1637,19 @@ static void zoneinfo_show_print(struct s
 		   "\n        high     %lu"
 		   "\n        spanned  %lu"
 		   "\n        present  %lu"
-		   "\n        managed  %lu"
-		   "\n        cma      %lu",
+		   "\n        managed  %lu",
 		   zone_page_state(zone, NR_FREE_PAGES),
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
 		   zone->spanned_pages,
 		   zone->present_pages,
-		   zone_managed_pages(zone),
+		   zone_managed_pages(zone));
+#ifdef CONFIG_CMA
+	seq_printf(m,
+		   "\n        cma      %lu",
 		   zone->cma_pages);
+#endif
 
 	seq_printf(m,
 		   "\n        protection: (%ld",
_

Patches currently in -mm which might be from david@redhat.com are

mm-cma-expose-all-pages-to-the-buddy-if-activation-of-an-area-fails.patch
mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo.patch
mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v3.patch
mm-memory_hotplug-memhp_merge_resource-mhp_merge_resource.patch
drivers-base-memory-dont-store-phys_device-in-memory-blocks.patch
documentation-sysfs-memory-clarify-some-memory-block-device-properties.patch
virtio-mem-check-against-mhp_get_pluggable_range-which-memory-we-can-hotplug.patch


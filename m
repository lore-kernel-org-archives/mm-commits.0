Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81472C4338F
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CA5160551
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhHGTOB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Aug 2021 15:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhHGTOB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Aug 2021 15:14:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B9D46103B;
        Sat,  7 Aug 2021 19:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628363623;
        bh=DeyU87JgBgGxY60JkhNnInsdAZuLtRoFntp33bPuSvw=;
        h=Date:From:To:Subject:From;
        b=mRT1MMnd1hYO5MB/zkTQBIoIn4SuOFV2wWWygcqYxNeIJAsoAyU7T9QOMbm69nWia
         080ZTHxWl5FVy2sjHk9ya2yt/fdxDFDNnX3wZ8PuihWO5EkT54OBLmrFGM9a8FwmX4
         uq5CSpQGW0+4P9HqsXN+O4xZBKXFnya7PNzPrXZk=
Date:   Sat, 07 Aug 2021 12:13:43 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, david@redhat.com
Subject:  [to-be-updated]
 mm-memory_hotplug-memory-group-aware-auto-movable-online-policy-fix.patch
 removed from -mm tree
Message-ID: <20210807191343.KXgBc%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-memory-group-aware-auto-movable-online-policy-fix
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-memory-group-aware-auto-movable-online-policy-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-memory_hotplug-memory-group-aware-auto-movable-online-policy-fix

fix warning

> ../mm/memory_hotplug.c: In function `auto_movable_stats_account_zone':
> ../mm/memory_hotplug.c:748:33: error: `struct zone' has no member named `cma_pages'; did you mean `managed_pages'?
>     stats->movable_pages += zone->cma_pages;
>                                   ^~~~~~~~~
>                                   managed_pages
> ../mm/memory_hotplug.c:750:38: error: `struct zone' has no member named `cma_pages'; did you mean `managed_pages'?
>     stats->kernel_early_pages -= zone->cma_pages;
>                                        ^~~~~~~~~
>                                        managed_pages
>
>

Link: https://lkml.kernel.org/r/5394da5e-29f0-ff7d-e614-e2805400a8bb@redhat.com
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-memory-group-aware-auto-movable-online-policy-fix
+++ a/mm/memory_hotplug.c
@@ -741,13 +741,15 @@ static void auto_movable_stats_account_z
 	if (zone_idx(zone) == ZONE_MOVABLE) {
 		stats->movable_pages += zone->present_pages;
 	} else {
+		stats->kernel_early_pages += zone->present_early_pages;
+#ifdef CONFIG_CMA
 		/*
 		 * CMA pages (never on hotplugged memory) behave like
 		 * ZONE_MOVABLE.
 		 */
 		stats->movable_pages += zone->cma_pages;
-		stats->kernel_early_pages += zone->present_early_pages;
 		stats->kernel_early_pages -= zone->cma_pages;
+#endif /* CONFIG_CMA */
 	}
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-report-sigbus-as-efault-for-madv_populate_readwrite.patch
memory-hotplugrst-remove-locking-details-from-admin-guide.patch
memory-hotplugrst-complete-admin-guide-overhaul.patch
mm-memory_hotplug-use-unsigned-long-for-pfn-in-zone_for_pfn_range.patch
mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory.patch
mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends.patch
acpi-memhotplug-memory-resources-cannot-be-enabled-yet.patch
mm-memory_hotplug-improved-dynamic-memory-group-aware-auto-movable-online-policy.patch


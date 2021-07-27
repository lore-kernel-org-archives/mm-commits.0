Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF062C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9E5060F57
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhG0Ueo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:34:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231135AbhG0Ueo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 16:34:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97F9860F37;
        Tue, 27 Jul 2021 20:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627418083;
        bh=fPcnsu4XO9908gX8Tky1//D/pSnjK/0+Sj6cJSoWqc4=;
        h=Date:From:To:Subject:From;
        b=r48Y3AU0+wAr3DEAcL9VEmgvMe5Tgs4u3Rzzt3PjfvsQKfNBBogmT+jm5Hp21LPuV
         NfGY1SJsmiIQ9T/pycK5rlbrBoWlpOra8ZVnJ5vOjKwZoWHceI8pumb5j1sBlx0dAn
         qmIIkO9l59t17uyv9OnHFji/gVz0rwlAYMPUcL1M=
Date:   Tue, 27 Jul 2021 13:34:43 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, david@redhat.com
Subject:  +
 mm-memory_hotplug-memory-group-aware-auto-movable-online-policy-fix.patch
 added to -mm tree
Message-ID: <20210727203443.0Ufqa%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-memory-group-aware-auto-movable-online-policy-fix
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-memory-group-aware-auto-movable-online-policy-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-memory-group-aware-auto-movable-online-policy-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-memory-group-aware-auto-movable-online-policy-fix.patch

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

memory-hotplugrst-remove-locking-details-from-admin-guide.patch
memory-hotplugrst-complete-admin-guide-overhaul.patch
mm-memory_hotplug-use-unsigned-long-for-pfn-in-zone_for_pfn_range.patch
mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory.patch
mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends.patch
acpi-memhotplug-memory-resources-cannot-be-enabled-yet.patch
mm-track-present-early-pages-per-zone.patch
mm-memory_hotplug-introduce-auto-movable-online-policy.patch
drivers-base-memory-introduce-memory-groups-to-logically-group-memory-blocks.patch
mm-memory_hotplug-track-present-pages-in-memory-groups.patch
acpi-memhotplug-use-a-single-static-memory-group-for-a-single-memory-device.patch
dax-kmem-use-a-single-static-memory-group-for-a-single-probed-unit.patch
virtio-mem-use-a-single-dynamic-memory-group-for-a-single-virtio-mem-device.patch
mm-memory_hotplug-memory-group-aware-auto-movable-online-policy.patch
mm-memory_hotplug-memory-group-aware-auto-movable-online-policy-fix.patch
mm-memory_hotplug-improved-dynamic-memory-group-aware-auto-movable-online-policy.patch


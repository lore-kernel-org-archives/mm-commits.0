Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E20A3C2D0E4
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F1D521D7F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:26:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="I648aw6l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgKLX0R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:26:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgKLX0Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 18:26:16 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE241216C4;
        Thu, 12 Nov 2020 23:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605223576;
        bh=oBQb0DRfU69JNoi78O3eue02fj84sQiYSznXQVutp/o=;
        h=Date:From:To:Subject:From;
        b=I648aw6llB0XJZeQLV2LUSE8527TX/p3IhCP8O6u5rKi+ue5/rs3AiQAJ+9BIvhTq
         2FrTZJZhIHazW4ZZ7toWcjbpR3o+N/PKO0W8SkOo6lhIdEdKEk3VBpeeTjQBtNT6y/
         aOSY5BvSZzuX5dvYQeSjDev7Q/Oud0jXOTZ5Fn7o=
Date:   Thu, 12 Nov 2020 15:26:15 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org,
        rafael.j.wysocki@intel.com, vbabka@suse.cz
Subject:  [folded-merged]
 kernel-power-allow-hibernation-with-page_poison-sanity-checking-fix.patch
 removed from -mm tree
Message-ID: <20201112232615.hqRXsg7Z7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Date: kernel/power: allow hibernation with page_poison sanity checking-fix
has been removed from the -mm tree.  Its filename was
     kernel-power-allow-hibernation-with-page_poison-sanity-checking-fix.patch

This patch was dropped because it was folded into kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Date: kernel/power: allow hibernation with page_poison sanity checking-fix

Adapt to __kernel_unpoison_pages fixup.  Split out
clear_or_poison_free_page() per David Hildenbrand.

Link: https://lkml.kernel.org/r/7811e5ec-c7ae-09a9-7f90-45e14956c4c4@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    1 +
 kernel/power/snapshot.c |   18 ++++++++++--------
 2 files changed, 11 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~kernel-power-allow-hibernation-with-page_poison-sanity-checking-fix
+++ a/include/linux/mm.h
@@ -2871,6 +2871,7 @@ static inline bool page_poisoning_enable
 #else
 static inline bool page_poisoning_enabled(void) { return false; }
 static inline bool page_poisoning_enabled_static(void) { return false; }
+static inline void __kernel_poison_pages(struct page *page, int nunmpages) { }
 static inline void kernel_poison_pages(struct page *page, int numpages) { }
 static inline void kernel_unpoison_pages(struct page *page, int numpages) { }
 #endif
--- a/kernel/power/snapshot.c~kernel-power-allow-hibernation-with-page_poison-sanity-checking-fix
+++ a/kernel/power/snapshot.c
@@ -1178,6 +1178,14 @@ void free_basic_memory_bitmaps(void)
 	pr_debug("Basic memory bitmaps freed\n");
 }
 
+static void clear_or_poison_free_page(struct page *page)
+{
+	if (page_poisoning_enabled_static())
+		__kernel_poison_pages(page, 1);
+	else if (want_init_on_free())
+		clear_highpage(page);
+}
+
 void clear_or_poison_free_pages(void)
 {
 	struct memory_bitmap *bm = free_pages_map;
@@ -1190,14 +1198,8 @@ void clear_or_poison_free_pages(void)
 		memory_bm_position_reset(bm);
 		pfn = memory_bm_next_pfn(bm);
 		while (pfn != BM_END_OF_MAP) {
-			if (pfn_valid(pfn)) {
-				struct page *page = pfn_to_page(pfn);
-				if (page_poisoning_enabled_static())
-					kernel_poison_pages(page, 1);
-				else if (want_init_on_free())
-					clear_highpage(page);
-
-			}
+			if (pfn_valid(pfn))
+				clear_or_poison_free_page(pfn_to_page(pfn));
 
 			pfn = memory_bm_next_pfn(bm);
 		}
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters.patch
mm-page_poison-use-static-key-more-efficiently.patch
kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch
mm-page_poison-remove-config_page_poisoning_no_sanity.patch
mm-page_poison-remove-config_page_poisoning_zero.patch


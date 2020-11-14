Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E55BC55ABD
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E99E22225F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:08:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1siuuImO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgKNBHu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgKNBHu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 20:07:50 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3A092225F;
        Sat, 14 Nov 2020 01:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605316069;
        bh=5h1rfVY4Xd6KMUwHpjXq+RDvGD34dDRYKX8LAzOdKic=;
        h=Date:From:To:Subject:From;
        b=1siuuImODGRuJoj6HJH1CB3JOH04J5nXc5r7IkSsa9YTsWnNoEzE1nmY68s0UGkkl
         TI7F1aMCZas7uA9zzl6tQlvgT8unFyWuoV/7dJklsOF2maKKkZ9Zc314ouLHa/e3x+
         CstS7VPp6j9LDhQwEJ5LJrNmG0wgkbCtZRyOi5hw=
Date:   Fri, 13 Nov 2020 17:07:48 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, glider@google.com, keescook@chromium.org,
        labbott@kernel.org, mateusznosek0@gmail.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com,
        rppt@linux.ibm.com, vbabka@suse.cz
Subject:  +
 kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch added
 to -mm tree
Message-ID: <20201114010748.WJ1QzZJcn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/power: allow hibernation with page_poison sanity checking
has been added to the -mm tree.  Its filename is
     kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: kernel/power: allow hibernation with page_poison sanity checking

Page poisoning used to be incompatible with hibernation, as the state of
poisoned pages was lost after resume, thus enabling CONFIG_HIBERNATION
forces CONFIG_PAGE_POISONING_NO_SANITY.  For the same reason, the
poisoning with zeroes variant CONFIG_PAGE_POISONING_ZERO used to disable
hibernation.  The latter restriction was removed by commit 1ad1410f632d
("PM / Hibernate: allow hibernation with PAGE_POISONING_ZERO") and
similarly for init_on_free by commit 18451f9f9e58 ("PM: hibernate: fix
crashes with init_on_free=1") by making sure free pages are cleared after
resume.

We can use the same mechanism to instead poison free pages with
PAGE_POISON after resume.  This covers both zero and 0xAA patterns.  Thus
we can remove the Kconfig restriction that disables page poison sanity
checking when hibernation is enabled.

Link: https://lkml.kernel.org/r/20201113104033.22907-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>	[hibernation]
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@kernel.org>
Cc: Mateusz Nosek <mateusznosek0@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    1 +
 kernel/power/hibernate.c |    2 +-
 kernel/power/power.h     |    2 +-
 kernel/power/snapshot.c  |   14 +++++++++++---
 mm/Kconfig.debug         |    1 -
 5 files changed, 14 insertions(+), 6 deletions(-)

--- a/include/linux/mm.h~kernel-power-allow-hibernation-with-page_poison-sanity-checking
+++ a/include/linux/mm.h
@@ -2903,6 +2903,7 @@ static inline void kernel_unpoison_pages
 #else
 static inline bool page_poisoning_enabled(void) { return false; }
 static inline bool page_poisoning_enabled_static(void) { return false; }
+static inline void __kernel_poison_pages(struct page *page, int nunmpages) { }
 static inline void kernel_poison_pages(struct page *page, int numpages) { }
 static inline void kernel_unpoison_pages(struct page *page, int numpages) { }
 #endif
--- a/kernel/power/hibernate.c~kernel-power-allow-hibernation-with-page_poison-sanity-checking
+++ a/kernel/power/hibernate.c
@@ -326,7 +326,7 @@ static int create_image(int platform_mod
 
 	if (!in_suspend) {
 		events_check_enabled = false;
-		clear_free_pages();
+		clear_or_poison_free_pages();
 	}
 
 	platform_leave(platform_mode);
--- a/kernel/power/power.h~kernel-power-allow-hibernation-with-page_poison-sanity-checking
+++ a/kernel/power/power.h
@@ -106,7 +106,7 @@ extern int create_basic_memory_bitmaps(v
 extern void free_basic_memory_bitmaps(void);
 extern int hibernate_preallocate_memory(void);
 
-extern void clear_free_pages(void);
+extern void clear_or_poison_free_pages(void);
 
 /**
  *	Auxiliary structure used for reading the snapshot image data and
--- a/kernel/power/snapshot.c~kernel-power-allow-hibernation-with-page_poison-sanity-checking
+++ a/kernel/power/snapshot.c
@@ -1178,7 +1178,15 @@ void free_basic_memory_bitmaps(void)
 	pr_debug("Basic memory bitmaps freed\n");
 }
 
-void clear_free_pages(void)
+static void clear_or_poison_free_page(struct page *page)
+{
+	if (page_poisoning_enabled_static())
+		__kernel_poison_pages(page, 1);
+	else if (want_init_on_free())
+		clear_highpage(page);
+}
+
+void clear_or_poison_free_pages(void)
 {
 	struct memory_bitmap *bm = free_pages_map;
 	unsigned long pfn;
@@ -1186,12 +1194,12 @@ void clear_free_pages(void)
 	if (WARN_ON(!(free_pages_map)))
 		return;
 
-	if (IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) || want_init_on_free()) {
+	if (page_poisoning_enabled() || want_init_on_free()) {
 		memory_bm_position_reset(bm);
 		pfn = memory_bm_next_pfn(bm);
 		while (pfn != BM_END_OF_MAP) {
 			if (pfn_valid(pfn))
-				clear_highpage(pfn_to_page(pfn));
+				clear_or_poison_free_page(pfn_to_page(pfn));
 
 			pfn = memory_bm_next_pfn(bm);
 		}
--- a/mm/Kconfig.debug~kernel-power-allow-hibernation-with-page_poison-sanity-checking
+++ a/mm/Kconfig.debug
@@ -64,7 +64,6 @@ config PAGE_OWNER
 
 config PAGE_POISONING
 	bool "Poison pages after freeing"
-	select PAGE_POISONING_NO_SANITY if HIBERNATION
 	help
 	  Fill the pages with poison patterns after free_pages() and verify
 	  the patterns before alloc_pages. The filling of the memory helps
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch
mm-page_alloc-clean-up-pageset-high-and-batch-update.patch
mm-page_alloc-calculate-pageset-high-and-batch-once-per-zone.patch
mm-page_alloc-remove-setup_pageset.patch
mm-page_alloc-simplify-pageset_update.patch
mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone.patch
mm-page_alloc-move-draining-pcplists-to-page-isolation-users.patch
mm-page_alloc-disable-pcplists-during-memory-offline.patch
mm-page_alloc-disable-pcplists-during-memory-offline-fix.patch
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters.patch
mm-page_poison-use-static-key-more-efficiently.patch
kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch
mm-page_poison-remove-config_page_poisoning_no_sanity.patch
mm-page_poison-remove-config_page_poisoning_zero.patch


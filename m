Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B29C47434
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10BA82076C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgLPAA1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727445AbgLOX1t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:27:49 -0500
Date:   Tue, 15 Dec 2020 15:23:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074630;
        bh=f3VAR3WuCcRt/1V41q0j2JTwE9d0HAHwemJ5DvYIPNc=;
        h=From:To:Subject:From;
        b=SNex68Fg7/YtAOCVLhL7XBbOMSqe6BDeqPkTkhcBsDGmotnB5W3SM6H1EdkenixZ3
         YwwnoFcmULRjS/ObBWm8N5w5baZ99EHCmkLA67PhzDFMC6f5sSIlKCpJnVzXnQmNIV
         4Xlm0whkuPXG0DKKkNX1F5fcLylxS2N067l1PInk=
From:   akpm@linux-foundation.org
To:     david@redhat.com, glider@google.com, keescook@chromium.org,
        labbott@kernel.org, mateusznosek0@gmail.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com,
        rppt@linux.ibm.com, vbabka@suse.cz
Subject:  [merged]
 kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch
 removed from -mm tree
Message-ID: <20201215232349.xsIllA_NY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/power: allow hibernation with page_poison sanity checking
has been removed from the -mm tree.  Its filename was
     kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



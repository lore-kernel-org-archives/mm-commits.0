Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D975BC388F7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 01:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87CF32065E
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 01:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604451978;
	bh=eMOtDM32ieYNPJDJmHrIDiljTCuN/cDrijX1bKSsYbk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LFrqqw8hVfiDFPsZ6UWrdT2qveS1jLfTogNzFx61+6oFhfguTWbZEZ92hBYH6y4Ym
	 AmXu7gF2AZer3vBcJOsvb93bI+Hx3FicFuQQqPR1DOHMo0bdVae85+GSwEXeT57EiA
	 7CvrX4mtnzgadEJjryNE2HVNaHr3BtknxIbZzZhs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbgKDBGS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 20:06:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730119AbgKDBGR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 20:06:17 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35C70223AB;
        Wed,  4 Nov 2020 01:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604451976;
        bh=eMOtDM32ieYNPJDJmHrIDiljTCuN/cDrijX1bKSsYbk=;
        h=Date:From:To:Subject:From;
        b=IeMlbpYedcjbNzs83A+EVsYVnYsZnuYIvGvLntXdeOMQbWKi+IvtUxgts8Q9FOBGt
         YNLfz6MD/qV4iSdvSbcu5H4cVmJFSusb4BqVs8dQ68XDGhqUr2fWSTGflQ4rPpyiup
         1Og6RgwOfJ81WFcryrtt2KZ1rWc0wiu1l3tFsKb8=
Date:   Tue, 03 Nov 2020 17:06:15 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, rjw@rjwysocki.net,
        pavel@ucw.cz, mhocko@kernel.org, mateusznosek0@gmail.com,
        len.brown@intel.com, labbott@kernel.org, keescook@chromium.org,
        glider@google.com, david@redhat.com, akinobu.mita@gmail.com,
        vbabka@suse.cz
Subject:  +
 kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch added
 to -mm tree
Message-ID: <20201104010615.1XzcD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
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

Link: https://lkml.kernel.org/r/20201103152237.9853-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@kernel.org>
Cc: Mateusz Nosek <mateusznosek0@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/hibernate.c |    2 +-
 kernel/power/power.h     |    2 +-
 kernel/power/snapshot.c  |   14 ++++++++++----
 mm/Kconfig.debug         |    1 -
 4 files changed, 12 insertions(+), 7 deletions(-)

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
@@ -1172,7 +1172,7 @@ void free_basic_memory_bitmaps(void)
 	pr_debug("Basic memory bitmaps freed\n");
 }
 
-void clear_free_pages(void)
+void clear_or_poison_free_pages(void)
 {
 	struct memory_bitmap *bm = free_pages_map;
 	unsigned long pfn;
@@ -1180,12 +1180,18 @@ void clear_free_pages(void)
 	if (WARN_ON(!(free_pages_map)))
 		return;
 
-	if (IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) || want_init_on_free()) {
+	if (page_poisoning_enabled() || want_init_on_free()) {
 		memory_bm_position_reset(bm);
 		pfn = memory_bm_next_pfn(bm);
 		while (pfn != BM_END_OF_MAP) {
-			if (pfn_valid(pfn))
-				clear_highpage(pfn_to_page(pfn));
+			if (pfn_valid(pfn)) {
+				struct page *page = pfn_to_page(pfn);
+				if (page_poisoning_enabled_static())
+					kernel_poison_pages(page, 1);
+				else if (want_init_on_free())
+					clear_highpage(page);
+
+			}
 
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
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters.patch
mm-page_poison-use-static-key-more-efficiently.patch
kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch
mm-page_poison-remove-config_page_poisoning_no_sanity.patch
mm-page_poison-remove-config_page_poisoning_zero.patch


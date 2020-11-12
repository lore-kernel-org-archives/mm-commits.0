Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D75C5519F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F19BA22227
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:27:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="c7pJc9n+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgKLX1R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:27:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgKLX1R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 18:27:17 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F18E021D7F;
        Thu, 12 Nov 2020 23:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605223636;
        bh=WZWw+ORAwqlDbHmLGLhtwP5tgtwd2OFan0mhFJ0lFBE=;
        h=Date:From:To:Subject:From;
        b=c7pJc9n+YhDQSjwELVqWRjcT2RwpAYrsP70Wj3IW0Dl77WIUMQSoQfe6ksMBhrEKF
         q2hAX5/eJd33x2zEsDoZTaidPMdyQ66l2UCRM5Nb7Iro0SVOk04VZ2ZR3EtT59VTGe
         RUEYwhbFPxafAn0cuIGkUmKssQoZsbBK+1RDeZfM=
Date:   Thu, 12 Nov 2020 15:27:15 -0800
From:   akpm@linux-foundation.org
To:     akinobu.mita@gmail.com, david@redhat.com, glider@google.com,
        keescook@chromium.org, labbott@kernel.org, len.brown@intel.com,
        mateusznosek0@gmail.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, pavel@ucw.cz, rjw@rjwysocki.net,
        rppt@linux.ibm.com, vbabka@suse.cz
Subject:  [to-be-updated]
 kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch
 removed from -mm tree
Message-ID: <20201112232715.WXSclQbd0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/power: allow hibernation with page_poison sanity checking
has been removed from the -mm tree.  Its filename was
     kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch

This patch was dropped because an updated version will be merged

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

[vbabka@suse.cz: adapt to __kernel_unpoison_pages fixup.  Split out clear_or_poison_free_page() per David Hildenbrand]
  Link: https://lkml.kernel.org/r/7811e5ec-c7ae-09a9-7f90-45e14956c4c4@suse.cz
Link: https://lkml.kernel.org/r/20201103152237.9853-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: "Rafael J. Wysocki" <rjw@rjwysocki.net>
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

 include/linux/mm.h       |    1 +
 kernel/power/hibernate.c |    2 +-
 kernel/power/power.h     |    2 +-
 kernel/power/snapshot.c  |   14 +++++++++++---
 mm/Kconfig.debug         |    1 -
 5 files changed, 14 insertions(+), 6 deletions(-)

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
--- a/include/linux/mm.h~kernel-power-allow-hibernation-with-page_poison-sanity-checking
+++ a/include/linux/mm.h
@@ -2881,6 +2881,7 @@ static inline void kernel_unpoison_pages
 #else
 static inline bool page_poisoning_enabled(void) { return false; }
 static inline bool page_poisoning_enabled_static(void) { return false; }
+static inline void __kernel_poison_pages(struct page *page, int nunmpages) { }
 static inline void kernel_poison_pages(struct page *page, int numpages) { }
 static inline void kernel_unpoison_pages(struct page *page, int numpages) { }
 #endif
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch
mm-page_poison-remove-config_page_poisoning_no_sanity.patch
mm-page_poison-remove-config_page_poisoning_zero.patch


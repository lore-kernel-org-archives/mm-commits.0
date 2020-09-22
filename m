Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6D5C4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20D4E2399A
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600794033;
	bh=i8wIhZ5O1V/iP1+gXk8FfLL0XP4elLVtQRRc1mzH9iE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dvK2jGzA/pFRVSoCJqHDpGGZ1hWJ55aryhUhX+LenNF8MyY270D6+6UhOwiYsG/Ml
	 +OYIVasglLJRWEWnBHdU2xooLe+W31i0YFa6pUWzTEZI/8mzlJgQsJaTXprsgNyivP
	 bbaiThkb7u4fMgpyXlbqGMwHF2JRI+Q+4QWPd6sU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIVRAc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgIVRAc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 13:00:32 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E95CA20756;
        Tue, 22 Sep 2020 17:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600794031;
        bh=i8wIhZ5O1V/iP1+gXk8FfLL0XP4elLVtQRRc1mzH9iE=;
        h=Date:From:To:Subject:From;
        b=bHR3dKisv5GhBXcmbhg6nmvLN5Ms7m48GhxbrNArvqHrDhCWIf2f/FfqawUKN4qse
         hlu6+dbq08qUJSsgH+HtyDLGpz/onJJNLd6nXzRCpb+fHHZ9F2nwVAUQU32CuEoAb6
         5vGCvfiJzBnjrdGwZfJmglJGo216F4aLKQooHuwQ=
Date:   Tue, 22 Sep 2020 10:00:30 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zeil@yandex-team.ru,
        tony.luck@intel.com, osalvador@suse.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com,
        dave.hansen@intel.com, cai@lca.pw, aris@ruivo.org,
        aneesh.kumar@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        osalvador@suse.de
Subject:  + mmhwpoison-rework-soft-offline-for-free-pages.patch added
 to -mm tree
Message-ID: <20200922170030.JpG7s%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: rework soft offline for free pages
has been added to the -mm tree.  Its filename is
     mmhwpoison-rework-soft-offline-for-free-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-rework-soft-offline-for-free-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-rework-soft-offline-for-free-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: rework soft offline for free pages

When trying to soft-offline a free page, we need to first take it off the
buddy allocator.  Once we know is out of reach, we can safely flag it as
poisoned.

take_page_off_buddy will be used to take a page meant to be poisoned off
the buddy allocator.  take_page_off_buddy calls break_down_buddy_pages,
which splits a higher-order page in case our page belongs to one.

Once the page is under our control, we call page_handle_poison to set it
as poisoned and grab a refcount on it.

Link: https://lkml.kernel.org/r/20200922135650.1634-9-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Aristeu Rozanski <aris@ruivo.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    1 
 mm/memory-failure.c        |   18 ++++++---
 mm/page_alloc.c            |   68 +++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+), 6 deletions(-)

--- a/include/linux/page-flags.h~mmhwpoison-rework-soft-offline-for-free-pages
+++ a/include/linux/page-flags.h
@@ -429,6 +429,7 @@ PAGEFLAG(HWPoison, hwpoison, PF_ANY)
 TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
 extern bool set_hwpoison_free_buddy_page(struct page *page);
+extern bool take_page_off_buddy(struct page *page);
 #else
 PAGEFLAG_FALSE(HWPoison)
 static inline bool set_hwpoison_free_buddy_page(struct page *page)
--- a/mm/memory-failure.c~mmhwpoison-rework-soft-offline-for-free-pages
+++ a/mm/memory-failure.c
@@ -65,6 +65,13 @@ int sysctl_memory_failure_recovery __rea
 
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
+static void page_handle_poison(struct page *page)
+{
+	SetPageHWPoison(page);
+	page_ref_inc(page);
+	num_poisoned_pages_inc();
+}
+
 #if defined(CONFIG_HWPOISON_INJECT) || defined(CONFIG_HWPOISON_INJECT_MODULE)
 
 u32 hwpoison_filter_enable = 0;
@@ -1884,14 +1891,13 @@ static int soft_offline_in_use_page(stru
 
 static int soft_offline_free_page(struct page *page)
 {
-	int rc = dissolve_free_huge_page(page);
+	int rc = -EBUSY;
 
-	if (!rc) {
-		if (set_hwpoison_free_buddy_page(page))
-			num_poisoned_pages_inc();
-		else
-			rc = -EBUSY;
+	if (!dissolve_free_huge_page(page) && take_page_off_buddy(page)) {
+		page_handle_poison(page);
+		rc = 0;
 	}
+
 	return rc;
 }
 
--- a/mm/page_alloc.c~mmhwpoison-rework-soft-offline-for-free-pages
+++ a/mm/page_alloc.c
@@ -8759,6 +8759,74 @@ bool is_free_buddy_page(struct page *pag
 
 #ifdef CONFIG_MEMORY_FAILURE
 /*
+ * Break down a higher-order page in sub-pages, and keep our target out of
+ * buddy allocator.
+ */
+static void break_down_buddy_pages(struct zone *zone, struct page *page,
+				   struct page *target, int low, int high,
+				   int migratetype)
+{
+	unsigned long size = 1 << high;
+	struct page *current_buddy, *next_page;
+
+	while (high > low) {
+		high--;
+		size >>= 1;
+
+		if (target >= &page[size]) {
+			next_page = page + size;
+			current_buddy = page;
+		} else {
+			next_page = page;
+			current_buddy = page + size;
+		}
+
+		if (set_page_guard(zone, current_buddy, high, migratetype))
+			continue;
+
+		if (current_buddy != target) {
+			add_to_free_list(current_buddy, zone, high, migratetype);
+			set_page_order(current_buddy, high);
+			page = next_page;
+		}
+	}
+}
+
+/*
+ * Take a page that will be marked as poisoned off the buddy allocator.
+ */
+bool take_page_off_buddy(struct page *page)
+{
+	struct zone *zone = page_zone(page);
+	unsigned long pfn = page_to_pfn(page);
+	unsigned long flags;
+	unsigned int order;
+	bool ret = false;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	for (order = 0; order < MAX_ORDER; order++) {
+		struct page *page_head = page - (pfn & ((1 << order) - 1));
+		int buddy_order = page_order(page_head);
+
+		if (PageBuddy(page_head) && buddy_order >= order) {
+			unsigned long pfn_head = page_to_pfn(page_head);
+			int migratetype = get_pfnblock_migratetype(page_head,
+								   pfn_head);
+
+			del_page_from_free_list(page_head, zone, buddy_order);
+			break_down_buddy_pages(zone, page_head, page, 0,
+						buddy_order, migratetype);
+			ret = true;
+			break;
+		}
+		if (page_count(page_head) > 0)
+			break;
+	}
+	spin_unlock_irqrestore(&zone->lock, flags);
+	return ret;
+}
+
+/*
  * Set PG_hwpoison flag if a given page is confirmed to be a free page.  This
  * test is performed under the zone lock to prevent a race against page
  * allocation.
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-unexport-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-try-to-narrow-window-race-for-free-pages.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-remove-stale-code.patch


From: akpm@linux-foundation.org
Subject: +
 mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites.patch added to -mm tree
Date: Mon, 23 May 2016 14:10:42 -0700
Message-ID: <574371d2.QiBCrFIGBV/4MX45%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbcEWVKn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 17:10:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@linaro.org, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: check the return value of lookup_page_ext for all call sites
has been added to the -mm tree.  Its filename is
     mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linaro.org>
Subject: mm: check the return value of lookup_page_ext for all call sites

Per the discussion with Joonsoo Kim [1], we need check the return value of
lookup_page_ext() for all call sites since it might return NULL in some
cases, although it is unlikely, i.e.  memory hotplug.

Tested with ltp with "page_owner=0".

[1] http://lkml.kernel.org/r/20160519002809.GA10245@js1304-P5Q-DELUXE

Link: http://lkml.kernel.org/r/1464023768-31025-1-git-send-email-yang.shi@linaro.org
Signed-off-by: Yang Shi <yang.shi@linaro.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_idle.h |   43 ++++++++++++++++++++++++++++++------
 mm/page_alloc.c           |    6 +++++
 mm/page_owner.c           |   27 ++++++++++++++++++++++
 mm/page_poison.c          |    8 +++++-
 mm/vmstat.c               |    2 +
 5 files changed, 78 insertions(+), 8 deletions(-)

diff -puN include/linux/page_idle.h~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites include/linux/page_idle.h
--- a/include/linux/page_idle.h~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites
+++ a/include/linux/page_idle.h
@@ -46,33 +46,62 @@ extern struct page_ext_operations page_i
 
 static inline bool page_is_young(struct page *page)
 {
-	return test_bit(PAGE_EXT_YOUNG, &lookup_page_ext(page)->flags);
+	struct page_ext *page_ext;
+	page_ext = lookup_page_ext(page);
+	if (unlikely(!page_ext)
+		return false;
+
+	return test_bit(PAGE_EXT_YOUNG, &page_ext->flags);
 }
 
 static inline void set_page_young(struct page *page)
 {
-	set_bit(PAGE_EXT_YOUNG, &lookup_page_ext(page)->flags);
+	struct page_ext *page_ext;
+	page_ext = lookup_page_ext(page);
+	if (unlikely(!page_ext)
+		return;
+
+	set_bit(PAGE_EXT_YOUNG, &page_ext->flags);
 }
 
 static inline bool test_and_clear_page_young(struct page *page)
 {
-	return test_and_clear_bit(PAGE_EXT_YOUNG,
-				  &lookup_page_ext(page)->flags);
+	struct page_ext *page_ext;
+	page_ext = lookup_page_ext(page);
+	if (unlikely(!page_ext)
+		return false;
+
+	return test_and_clear_bit(PAGE_EXT_YOUNG, &page_ext->flags);
 }
 
 static inline bool page_is_idle(struct page *page)
 {
-	return test_bit(PAGE_EXT_IDLE, &lookup_page_ext(page)->flags);
+	struct page_ext *page_ext;
+	page_ext = lookup_page_ext(page);
+	if (unlikely(!page_ext)
+		return false;
+
+	return test_bit(PAGE_EXT_IDLE, &page_ext->flags);
 }
 
 static inline void set_page_idle(struct page *page)
 {
-	set_bit(PAGE_EXT_IDLE, &lookup_page_ext(page)->flags);
+	struct page_ext *page_ext;
+	page_ext = lookup_page_ext(page);
+	if (unlikely(!page_ext)
+		return;
+
+	set_bit(PAGE_EXT_IDLE, &page_ext->flags);
 }
 
 static inline void clear_page_idle(struct page *page)
 {
-	clear_bit(PAGE_EXT_IDLE, &lookup_page_ext(page)->flags);
+	struct page_ext *page_ext;
+	page_ext = lookup_page_ext(page);
+	if (unlikely(!page_ext)
+		return;
+
+	clear_bit(PAGE_EXT_IDLE, &page_ext->flags);
 }
 #endif /* CONFIG_64BIT */
 
diff -puN mm/page_alloc.c~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites mm/page_alloc.c
--- a/mm/page_alloc.c~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites
+++ a/mm/page_alloc.c
@@ -656,6 +656,9 @@ static inline void set_page_guard(struct
 		return;
 
 	page_ext = lookup_page_ext(page);
+	if (unlikely(!page_ext))
+		return;
+
 	__set_bit(PAGE_EXT_DEBUG_GUARD, &page_ext->flags);
 
 	INIT_LIST_HEAD(&page->lru);
@@ -673,6 +676,9 @@ static inline void clear_page_guard(stru
 		return;
 
 	page_ext = lookup_page_ext(page);
+	if (unlikely(!page_ext))
+		return;
+
 	__clear_bit(PAGE_EXT_DEBUG_GUARD, &page_ext->flags);
 
 	set_page_private(page, 0);
diff -puN mm/page_owner.c~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites mm/page_owner.c
--- a/mm/page_owner.c~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites
+++ a/mm/page_owner.c
@@ -55,6 +55,8 @@ void __reset_page_owner(struct page *pag
 
 	for (i = 0; i < (1 << order); i++) {
 		page_ext = lookup_page_ext(page + i);
+		if (unlikely(!page_ext))
+			continue;
 		__clear_bit(PAGE_EXT_OWNER, &page_ext->flags);
 	}
 }
@@ -62,6 +64,10 @@ void __reset_page_owner(struct page *pag
 void __set_page_owner(struct page *page, unsigned int order, gfp_t gfp_mask)
 {
 	struct page_ext *page_ext = lookup_page_ext(page);
+
+	if (unlikely(!page_ext))
+		return;
+
 	struct stack_trace trace = {
 		.nr_entries = 0,
 		.max_entries = ARRAY_SIZE(page_ext->trace_entries),
@@ -82,6 +88,8 @@ void __set_page_owner(struct page *page,
 void __set_page_owner_migrate_reason(struct page *page, int reason)
 {
 	struct page_ext *page_ext = lookup_page_ext(page);
+	if (unlikely(!page_ext))
+		return;
 
 	page_ext->last_migrate_reason = reason;
 }
@@ -89,6 +97,12 @@ void __set_page_owner_migrate_reason(str
 gfp_t __get_page_owner_gfp(struct page *page)
 {
 	struct page_ext *page_ext = lookup_page_ext(page);
+	if (unlikely(!page_ext))
+		/*
+		 * The caller just returns 0 if no valid gfp
+		 * So return 0 here too.
+		 */
+		return 0;
 
 	return page_ext->gfp_mask;
 }
@@ -97,6 +111,10 @@ void __copy_page_owner(struct page *oldp
 {
 	struct page_ext *old_ext = lookup_page_ext(oldpage);
 	struct page_ext *new_ext = lookup_page_ext(newpage);
+
+	if (unlikely(!old_ext || !new_ext))
+		return;
+
 	int i;
 
 	new_ext->order = old_ext->order;
@@ -186,6 +204,11 @@ err:
 void __dump_page_owner(struct page *page)
 {
 	struct page_ext *page_ext = lookup_page_ext(page);
+	if (unlikely(!page_ext)) {
+		pr_alert("There is not page extension available.\n");
+		return;
+	}
+
 	struct stack_trace trace = {
 		.nr_entries = page_ext->nr_entries,
 		.entries = &page_ext->trace_entries[0],
@@ -251,6 +274,8 @@ read_page_owner(struct file *file, char
 		}
 
 		page_ext = lookup_page_ext(page);
+		if (unlikely(!page_ext))
+			continue;
 
 		/*
 		 * Some pages could be missed by concurrent allocation or free,
@@ -317,6 +342,8 @@ static void init_pages_in_zone(pg_data_t
 				continue;
 
 			page_ext = lookup_page_ext(page);
+			if (unlikely(!page_ext))
+				continue;
 
 			/* Maybe overraping zone */
 			if (test_bit(PAGE_EXT_OWNER, &page_ext->flags))
diff -puN mm/page_poison.c~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites mm/page_poison.c
--- a/mm/page_poison.c~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites
+++ a/mm/page_poison.c
@@ -54,6 +54,9 @@ static inline void set_page_poison(struc
 	struct page_ext *page_ext;
 
 	page_ext = lookup_page_ext(page);
+	if (unlikely(!page_ext))
+		return;
+
 	__set_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
 }
 
@@ -62,6 +65,9 @@ static inline void clear_page_poison(str
 	struct page_ext *page_ext;
 
 	page_ext = lookup_page_ext(page);
+	if (unlikely(!page_ext))
+		return;
+
 	__clear_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
 }
 
@@ -70,7 +76,7 @@ bool page_is_poisoned(struct page *page)
 	struct page_ext *page_ext;
 
 	page_ext = lookup_page_ext(page);
-	if (!page_ext)
+	if (unlikely(!page_ext))
 		return false;
 
 	return test_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
diff -puN mm/vmstat.c~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites mm/vmstat.c
--- a/mm/vmstat.c~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites
+++ a/mm/vmstat.c
@@ -1061,6 +1061,8 @@ static void pagetypeinfo_showmixedcount_
 				continue;
 
 			page_ext = lookup_page_ext(page);
+			if (unlikely(!page_ext))
+				continue;
 
 			if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags))
 				continue;
_

Patches currently in -mm which might be from yang.shi@linaro.org are

mm-make-config_deferred_struct_page_init-depends-on-flatmem-explicitly.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites.patch


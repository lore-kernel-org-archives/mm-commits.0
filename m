Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8573FC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CD5461131
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347433AbhIHC51 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347363AbhIHC5X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:57:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C4FD60E52;
        Wed,  8 Sep 2021 02:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069776;
        bh=Oyc+RZg/ztk1J1N2juFUypfdueBmdAFVdR0dv7mgI7g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VJRUqR9QJURri+gaifguG4WS4hM/OHlC6xyJA1hfZ7LOMUAlK2vlbFlUs+2ndX1Kj
         8Ccp20+LWugV2WG1a5qNLc3pznwX0Cw+1G7dwV0RBTnDoivkKsT74V3SegLEYtbHqf
         MsBund+qgMwdV2al00plsrYNlCIgNtePX4c//Avc=
Date:   Tue, 07 Sep 2021 19:56:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com,
        willy@infradead.org
Subject:  [patch 059/147] mm: introduce PAGEFLAGS_MASK to replace
 ((1UL << NR_PAGEFLAGS) - 1)
Message-ID: <20210908025615.DJcNBCtW-%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: introduce PAGEFLAGS_MASK to replace ((1UL << NR_PAGEFLAGS) - 1)

Instead of hard-coding ((1UL << NR_PAGEFLAGS) - 1) everywhere, introducing
PAGEFLAGS_MASK to make the code clear to get the page flags.

Link: https://lkml.kernel.org/r/20210819150712.59948-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h      |    4 +++-
 include/trace/events/page_ref.h |    4 ++--
 lib/test_printf.c               |    2 +-
 lib/vsprintf.c                  |    2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

--- a/include/linux/page-flags.h~mm-introduce-pageflags_mask-to-replace-1ul-nr_pageflags-1
+++ a/include/linux/page-flags.h
@@ -178,6 +178,8 @@ enum pageflags {
 	PG_reported = PG_uptodate,
 };
 
+#define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
+
 #ifndef __GENERATING_BOUNDS_H
 
 static inline unsigned long _compound_head(const struct page *page)
@@ -868,7 +870,7 @@ static inline void ClearPageSlabPfmemall
  * alloc-free cycle to prevent from reusing the page.
  */
 #define PAGE_FLAGS_CHECK_AT_PREP	\
-	(((1UL << NR_PAGEFLAGS) - 1) & ~__PG_HWPOISON)
+	(PAGEFLAGS_MASK & ~__PG_HWPOISON)
 
 #define PAGE_FLAGS_PRIVATE				\
 	(1UL << PG_private | 1UL << PG_private_2)
--- a/include/trace/events/page_ref.h~mm-introduce-pageflags_mask-to-replace-1ul-nr_pageflags-1
+++ a/include/trace/events/page_ref.h
@@ -38,7 +38,7 @@ DECLARE_EVENT_CLASS(page_ref_mod_templat
 
 	TP_printk("pfn=0x%lx flags=%s count=%d mapcount=%d mapping=%p mt=%d val=%d",
 		__entry->pfn,
-		show_page_flags(__entry->flags & ((1UL << NR_PAGEFLAGS) - 1)),
+		show_page_flags(__entry->flags & PAGEFLAGS_MASK),
 		__entry->count,
 		__entry->mapcount, __entry->mapping, __entry->mt,
 		__entry->val)
@@ -88,7 +88,7 @@ DECLARE_EVENT_CLASS(page_ref_mod_and_tes
 
 	TP_printk("pfn=0x%lx flags=%s count=%d mapcount=%d mapping=%p mt=%d val=%d ret=%d",
 		__entry->pfn,
-		show_page_flags(__entry->flags & ((1UL << NR_PAGEFLAGS) - 1)),
+		show_page_flags(__entry->flags & PAGEFLAGS_MASK),
 		__entry->count,
 		__entry->mapcount, __entry->mapping, __entry->mt,
 		__entry->val, __entry->ret)
--- a/lib/test_printf.c~mm-introduce-pageflags_mask-to-replace-1ul-nr_pageflags-1
+++ a/lib/test_printf.c
@@ -614,7 +614,7 @@ page_flags_test(int section, int node, i
 	bool append = false;
 	int i;
 
-	flags &= BIT(NR_PAGEFLAGS) - 1;
+	flags &= PAGEFLAGS_MASK;
 	if (flags) {
 		page_flags |= flags;
 		snprintf(cmp_buf + size, BUF_SIZE - size, "%s", name);
--- a/lib/vsprintf.c~mm-introduce-pageflags_mask-to-replace-1ul-nr_pageflags-1
+++ a/lib/vsprintf.c
@@ -2019,7 +2019,7 @@ static const struct page_flags_fields pf
 static
 char *format_page_flags(char *buf, char *end, unsigned long flags)
 {
-	unsigned long main_flags = flags & (BIT(NR_PAGEFLAGS) - 1);
+	unsigned long main_flags = flags & PAGEFLAGS_MASK;
 	bool append = false;
 	int i;
 
_

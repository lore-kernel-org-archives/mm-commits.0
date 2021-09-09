Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C08C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 986E2611C9
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347756AbhIIVEY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348628AbhIIVDm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:03:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F5D1611C9;
        Thu,  9 Sep 2021 21:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221340;
        bh=BY1ErntJfjhsRFWzkdkpjBYeLA3sYjxrtZfH78EZKr0=;
        h=Date:From:To:Subject:From;
        b=OLUbyZC/cfBs6KytD1wAL8lgG4fhcP/I36oA6jjSB6S4ELZ9wDlGwZjO5Z07MvgOY
         T1d/VAHy8kdgayB4vXeYkuwxCY94YPJJ7ldZducf4crfNYOkrG11aAzlZfRiOrh2C2
         G7SXGATW9eFXGoLZlUaf6VA14ADw0tAWZONfzWAA=
Date:   Thu, 09 Sep 2021 14:02:20 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com,
        willy@infradead.org
Subject:  [merged]
 mm-introduce-pageflags_mask-to-replace-1ul-nr_pageflags-1.patch removed
 from -mm tree
Message-ID: <20210909210220.hMRmtpx__%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce PAGEFLAGS_MASK to replace ((1UL << NR_PAGEFLAGS) - 1)
has been removed from the -mm tree.  Its filename was
     mm-introduce-pageflags_mask-to-replace-1ul-nr_pageflags-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from songmuchun@bytedance.com are



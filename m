Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152B5C4320A
	for <mm-commits@archiver.kernel.org>; Thu, 19 Aug 2021 21:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2AC76108F
	for <mm-commits@archiver.kernel.org>; Thu, 19 Aug 2021 21:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbhHSVmf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Aug 2021 17:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233664AbhHSVme (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 19 Aug 2021 17:42:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F4D561029;
        Thu, 19 Aug 2021 21:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629409317;
        bh=q553DMRncaNO4UN8W2gimKxTMcjHOsqN8Owv/nq/QhU=;
        h=Date:From:To:Subject:From;
        b=jNhyJ2uLdZY6CU2LA7m013oQ/ixf8BShSTh7NJFoCH3tge956VYXUaPqNsO8Gy/Ew
         BhMxwDHDJ2SwFTYApDHWr1pOm9d9FylRHl36to+M6QvWBXMKfdVPSleErsAL050Vys
         ns6xqW/yzTcv80Rg8ilnfWy3fMTgbwMYBYrmkuRs=
Date:   Thu, 19 Aug 2021 14:41:55 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vdavydov.dev@gmail.com, shakeelb@google.com, mhocko@kernel.org,
        hannes@cmpxchg.org, guro@fb.com, songmuchun@bytedance.com
Subject:  +
 mm-introduce-pageflags_mask-to-replace-1ul-nr_pageflags-1.patch added to -mm
 tree
Message-ID: <20210819214155.-zjRb%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce PAGEFLAGS_MASK to replace ((1UL << NR_PAGEFLAGS) - 1)
has been added to the -mm tree.  Its filename is
     mm-introduce-pageflags_mask-to-replace-1ul-nr_pageflags-1.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-pageflags_mask-to-replace-1ul-nr_pageflags-1.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-pageflags_mask-to-replace-1ul-nr_pageflags-1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-bootmem_info-mark-__init-on-register_page_bootmem_info_section.patch
mm-remove-redundant-compound_head-calling.patch
mm-introduce-pageflags_mask-to-replace-1ul-nr_pageflags-1.patch


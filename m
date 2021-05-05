Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E337C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8458B61426
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhEEBkC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232037AbhEEBkB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:40:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1E50610A1;
        Wed,  5 May 2021 01:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178745;
        bh=8KghoL+V4T0F8mgoFlbMEl65mptfB8StNuMemyqY7Ro=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Km1q+2lpLHFkuf0r+yOzVyl0gVPrLQCKVrQocSPELw79ashNxnHInkwX8A6J4QzA3
         BqDuWuCzP4F6bSK+doku0ITwStMvoIR0EegRsZK12ckOCsaSCWYIxmgqhCrI7uFSum
         Rt1OeFLXiva7XKHkk1/YrsWOgSZt4amG7OL5m2xo=
Date:   Tue, 04 May 2021 18:39:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        david@redhat.com, iamjoonsoo.kim@lge.com, ira.weiny@intel.com,
        jgg@nvidia.com, jgg@ziepe.ca, jhubbard@nvidia.com,
        jmorris@namei.org, linux-mm@kvack.org, mgorman@suse.de,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, peterz@infradead.org,
        rientjes@google.com, rostedt@goodmis.org, sashal@kernel.org,
        torvalds@linux-foundation.org, tyhicks@linux.microsoft.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  [patch 117/143] mm/gup: do not migrate zero page
Message-ID: <20210505013904.v5O1y3qmR%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: mm/gup: do not migrate zero page

On some platforms ZERO_PAGE(0) might end-up in a movable zone.  Do not
migrate zero page in gup during longterm pinning as migration of zero page
is not allowed.

For example, in x86 QEMU with 16G of memory and kernelcore=5G parameter, I
see the following:

Boot#1: zero_pfn  0x48a8d zero_pfn zone: ZONE_DMA32
Boot#2: zero_pfn 0x20168d zero_pfn zone: ZONE_MOVABLE

On x86, empty_zero_page is declared in .bss and depending on the loader
may end up in different physical locations during boots.

Also, move is_zero_pfn() my_zero_pfn() functions under CONFIG_MMU, because
zero_pfn that they are using is declared in memory.c which is compiled
with CONFIG_MMU.

Link: https://lkml.kernel.org/r/20210215161349.246722-9-pasha.tatashin@soleen.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    3 ++-
 include/linux/mmzone.h  |    4 ++++
 include/linux/pgtable.h |   12 ++++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-gup-do-not-migrate-zero-page
+++ a/include/linux/mm.h
@@ -1559,7 +1559,8 @@ static inline unsigned long page_to_sect
 #ifdef CONFIG_MIGRATION
 static inline bool is_pinnable_page(struct page *page)
 {
-	return !is_zone_movable_page(page) && !is_migrate_cma_page(page);
+	return !(is_zone_movable_page(page) || is_migrate_cma_page(page)) ||
+		is_zero_pfn(page_to_pfn(page));
 }
 #else
 static inline bool is_pinnable_page(struct page *page)
--- a/include/linux/mmzone.h~mm-gup-do-not-migrate-zero-page
+++ a/include/linux/mmzone.h
@@ -427,6 +427,10 @@ enum zone_type {
 	 *    techniques might use alloc_contig_range() to hide previously
 	 *    exposed pages from the buddy again (e.g., to implement some sort
 	 *    of memory unplug in virtio-mem).
+	 * 6. ZERO_PAGE(0), kernelcore/movablecore setups might create
+	 *    situations where ZERO_PAGE(0) which is allocated differently
+	 *    on different platforms may end up in a movable zone. ZERO_PAGE(0)
+	 *    cannot be migrated.
 	 *
 	 * In general, no unmovable allocations that degrade memory offlining
 	 * should end up in ZONE_MOVABLE. Allocators (like alloc_contig_range())
--- a/include/linux/pgtable.h~mm-gup-do-not-migrate-zero-page
+++ a/include/linux/pgtable.h
@@ -1111,6 +1111,7 @@ extern void untrack_pfn(struct vm_area_s
 extern void untrack_pfn_moved(struct vm_area_struct *vma);
 #endif
 
+#ifdef CONFIG_MMU
 #ifdef __HAVE_COLOR_ZERO_PAGE
 static inline int is_zero_pfn(unsigned long pfn)
 {
@@ -1134,6 +1135,17 @@ static inline unsigned long my_zero_pfn(
 	return zero_pfn;
 }
 #endif
+#else
+static inline int is_zero_pfn(unsigned long pfn)
+{
+	return 0;
+}
+
+static inline unsigned long my_zero_pfn(unsigned long addr)
+{
+	return 0;
+}
+#endif /* CONFIG_MMU */
 
 #ifdef CONFIG_MMU
 
_

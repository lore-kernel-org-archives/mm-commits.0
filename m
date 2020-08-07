Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE2A9C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 998BC22CAE
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781553;
	bh=SvzeFn3o62Y/9aH4YLJhx7RlHqEyaVpM1cc6wDYgjYg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=2nKX6hpEL6TEmwWE0vvAzQ3VQpeiP2Vo81LFOkn3/4lk+WucRyath09XDFzY38ZyO
	 ljmFNuH3kDsYDwOwdg5UFLE9mckQL8forDF6Hf/DSdOQ5U6fg0yCGFIWn5lTDqscE/
	 rOkcSqdNxJANffwfQbLeXbucMY7iDBfDMyB7CZjA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgHGGZx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGGZx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0A3322D00;
        Fri,  7 Aug 2020 06:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781552;
        bh=SvzeFn3o62Y/9aH4YLJhx7RlHqEyaVpM1cc6wDYgjYg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=h667uw0uWgf4dSG19i7P4nVsNFrOX0qYLvxgUlnRGNrAUSiJAZ5I/ni1siBkeMeeH
         ccFgfmoF5ryxPoLNLbHF2X0zSb+hlU9/uknS+F4RBznHk8MGREL9WgDIow7P7ginjb
         f445slR1wdSId/CBa6BeELjj+3tQsGrduJBxphmg=
Date:   Thu, 06 Aug 2020 23:25:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mgorman@suse.de,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        torvalds@linux-foundation.org
Subject:  [patch 151/163] mm/page_alloc.c: remove unnecessary
 end_bitidx for [set|get]_pfnblock_flags_mask()
Message-ID: <20200807062551.B589dCxZG%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/page_alloc.c: remove unnecessary end_bitidx for [set|get]_pfnblock_flags_mask()

After previous cleanup, the end_bitidx is not necessary any more.

Link: http://lkml.kernel.org/r/20200623124201.8199-4-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h          |    3 +--
 include/linux/pageblock-flags.h |    8 +++-----
 mm/page_alloc.c                 |   15 +++++----------
 3 files changed, 9 insertions(+), 17 deletions(-)

--- a/include/linux/mmzone.h~mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask
+++ a/include/linux/mmzone.h
@@ -91,8 +91,7 @@ extern int page_group_by_mobility_disabl
 #define MIGRATETYPE_MASK ((1UL << PB_migratetype_bits) - 1)
 
 #define get_pageblock_migratetype(page)					\
-	get_pfnblock_flags_mask(page, page_to_pfn(page),		\
-			PB_migrate_end, MIGRATETYPE_MASK)
+	get_pfnblock_flags_mask(page, page_to_pfn(page), MIGRATETYPE_MASK)
 
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
--- a/include/linux/pageblock-flags.h~mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask
+++ a/include/linux/pageblock-flags.h
@@ -56,27 +56,25 @@ struct page;
 
 unsigned long get_pfnblock_flags_mask(struct page *page,
 				unsigned long pfn,
-				unsigned long end_bitidx,
 				unsigned long mask);
 
 void set_pfnblock_flags_mask(struct page *page,
 				unsigned long flags,
 				unsigned long pfn,
-				unsigned long end_bitidx,
 				unsigned long mask);
 
 /* Declarations for getting and setting flags. See mm/page_alloc.c */
 #ifdef CONFIG_COMPACTION
 #define get_pageblock_skip(page) \
 	get_pfnblock_flags_mask(page, page_to_pfn(page),	\
-			PB_migrate_skip, (1 << (PB_migrate_skip)))
+			(1 << (PB_migrate_skip)))
 #define clear_pageblock_skip(page) \
 	set_pfnblock_flags_mask(page, 0, page_to_pfn(page),	\
-			PB_migrate_skip, (1 << PB_migrate_skip))
+			(1 << PB_migrate_skip))
 #define set_pageblock_skip(page) \
 	set_pfnblock_flags_mask(page, (1 << PB_migrate_skip),	\
 			page_to_pfn(page),			\
-			PB_migrate_skip, (1 << PB_migrate_skip))
+			(1 << PB_migrate_skip))
 #else
 static inline bool get_pageblock_skip(struct page *page)
 {
--- a/mm/page_alloc.c~mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask
+++ a/mm/page_alloc.c
@@ -469,14 +469,13 @@ static inline int pfn_to_bitidx(struct p
  * get_pfnblock_flags_mask - Return the requested group of flags for the pageblock_nr_pages block of pages
  * @page: The page within the block of interest
  * @pfn: The target page frame number
- * @end_bitidx: The last bit of interest to retrieve
  * @mask: mask of bits that the caller is interested in
  *
  * Return: pageblock_bits flags
  */
-static __always_inline unsigned long __get_pfnblock_flags_mask(struct page *page,
+static __always_inline
+unsigned long __get_pfnblock_flags_mask(struct page *page,
 					unsigned long pfn,
-					unsigned long end_bitidx,
 					unsigned long mask)
 {
 	unsigned long *bitmap;
@@ -493,15 +492,14 @@ static __always_inline unsigned long __g
 }
 
 unsigned long get_pfnblock_flags_mask(struct page *page, unsigned long pfn,
-					unsigned long end_bitidx,
 					unsigned long mask)
 {
-	return __get_pfnblock_flags_mask(page, pfn, end_bitidx, mask);
+	return __get_pfnblock_flags_mask(page, pfn, mask);
 }
 
 static __always_inline int get_pfnblock_migratetype(struct page *page, unsigned long pfn)
 {
-	return __get_pfnblock_flags_mask(page, pfn, PB_migrate_end, MIGRATETYPE_MASK);
+	return __get_pfnblock_flags_mask(page, pfn, MIGRATETYPE_MASK);
 }
 
 /**
@@ -509,12 +507,10 @@ static __always_inline int get_pfnblock_
  * @page: The page within the block of interest
  * @flags: The flags to set
  * @pfn: The target page frame number
- * @end_bitidx: The last bit of interest
  * @mask: mask of bits that the caller is interested in
  */
 void set_pfnblock_flags_mask(struct page *page, unsigned long flags,
 					unsigned long pfn,
-					unsigned long end_bitidx,
 					unsigned long mask)
 {
 	unsigned long *bitmap;
@@ -550,8 +546,7 @@ void set_pageblock_migratetype(struct pa
 		migratetype = MIGRATE_UNMOVABLE;
 
 	set_pfnblock_flags_mask(page, (unsigned long)migratetype,
-				page_to_pfn(page), PB_migrate_end,
-				MIGRATETYPE_MASK);
+				page_to_pfn(page), MIGRATETYPE_MASK);
 }
 
 #ifdef CONFIG_DEBUG_VM
_

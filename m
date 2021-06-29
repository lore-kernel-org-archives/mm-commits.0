Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4450CC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E4E8611AE
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhF2Cnp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:43:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231332AbhF2Cno (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:43:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ACE061D0E;
        Tue, 29 Jun 2021 02:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934477;
        bh=fTJpccaMe94o4VE6FiQyT/9j6M0jVjWJtvb1JECyl10=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vk0Dr8UgA/aROzb9IoK2dN8apQF8+r+96QFg5tkVHLB7uF7YwZuD1VQu/i8jwXPcH
         4TvWbB6ED6Y/asoB3rTFFF3RkhLbdGEnXmueeZnFZ+kzXtoOcN6StI/Y4kCKPLS7OO
         bRClw9CFYVK/u9NbHGD+MvMYU2EPER0QqjMGEJs0=
Date:   Mon, 28 Jun 2021 19:41:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 153/192] mm/page_owner: constify dump_page_owner
Message-ID: <20210629024116.fCp0fe46Q%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_owner: constify dump_page_owner

dump_page_owner() only uses struct page to find the page_ext, and
lookup_page_ext() already takes a const argument.

Link: https://lkml.kernel.org/r/20210416231531.2521383-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_owner.h |    6 +++---
 mm/page_owner.c            |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/page_owner.h~mm-page_owner-constify-dump_page_owner
+++ a/include/linux/page_owner.h
@@ -14,7 +14,7 @@ extern void __set_page_owner(struct page
 extern void __split_page_owner(struct page *page, unsigned int nr);
 extern void __copy_page_owner(struct page *oldpage, struct page *newpage);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
-extern void __dump_page_owner(struct page *page);
+extern void __dump_page_owner(const struct page *page);
 extern void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone);
 
@@ -46,7 +46,7 @@ static inline void set_page_owner_migrat
 	if (static_branch_unlikely(&page_owner_inited))
 		__set_page_owner_migrate_reason(page, reason);
 }
-static inline void dump_page_owner(struct page *page)
+static inline void dump_page_owner(const struct page *page)
 {
 	if (static_branch_unlikely(&page_owner_inited))
 		__dump_page_owner(page);
@@ -69,7 +69,7 @@ static inline void copy_page_owner(struc
 static inline void set_page_owner_migrate_reason(struct page *page, int reason)
 {
 }
-static inline void dump_page_owner(struct page *page)
+static inline void dump_page_owner(const struct page *page)
 {
 }
 #endif /* CONFIG_PAGE_OWNER */
--- a/mm/page_owner.c~mm-page_owner-constify-dump_page_owner
+++ a/mm/page_owner.c
@@ -392,7 +392,7 @@ err:
 	return -ENOMEM;
 }
 
-void __dump_page_owner(struct page *page)
+void __dump_page_owner(const struct page *page)
 {
 	struct page_ext *page_ext = lookup_page_ext(page);
 	struct page_owner *page_owner;
_

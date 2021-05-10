Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11879C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E25FC61090
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhEJEh4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:37:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229569AbhEJEhz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:37:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C67856108B;
        Mon, 10 May 2021 04:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620621411;
        bh=5Vh8cZCN7G9c4yVUBp6UlixojvFAt5SFQ3fYZ3Qntxc=;
        h=Date:From:To:Subject:From;
        b=cN1qTaaNzTWi9KfAFw5Uv3vNiJTF1rZn/i5qyLjHAW2P+m8Crp1FS2LEv8V8OzPBf
         kG3+J6QNrORzYDIsAJOgIVKx3IN9n1Ca+q1t+5ypUlbdQ0JRkzvhpBMbZWZ6Wm5ICh
         +PbDaofqPpaw1xIL0mpmM3odL4q/AxxxtJZoEd0w=
Date:   Sun, 09 May 2021 21:36:50 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz, william.kucharski@oracle.com, willy@infradead.org
Subject:  + mm-page_owner-constify-dump_page_owner.patch added to
 -mm tree
Message-ID: <20210510043650.0tKMAfy-Q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: constify dump_page_owner
has been added to the -mm tree.  Its filename is
     mm-page_owner-constify-dump_page_owner.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-constify-dump_page_owner.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-constify-dump_page_owner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are

mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch


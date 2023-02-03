Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0900BC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbjBCGgj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjBCGf7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE878B340
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C9127CE2ED8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF31C433D2;
        Fri,  3 Feb 2023 06:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406156;
        bh=K1vUCOSXJIkBTvliYPsIc9Uv528KkGGaPmPYnQ+Mhzw=;
        h=Date:To:From:Subject:From;
        b=Nt9erqcn24aFsI4u7/Wo2GGgCh7KpBrHKmNor1DicV3s5s8ZGUGvwLH374AwtzCrB
         ODJ9XAT388NDzaoJEqkgXOCcENvuMpnMqyOzgQhw4dANRP5hNvk67AAEzksIXtJEb2
         xfVYyjYCKIkD99HnNY4eaD7GdHbSl4epQLQojyZA=
Date:   Thu, 02 Feb 2023 22:35:55 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-first-tail-page-members-from-struct-page.patch removed from -mm tree
Message-Id: <20230203063556.4EF31C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove 'First tail page' members from struct page
has been removed from the -mm tree.  Its filename was
     mm-remove-first-tail-page-members-from-struct-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove 'First tail page' members from struct page
Date: Wed, 11 Jan 2023 14:29:08 +0000

All former users now use the folio equivalents, so remove them from the
definition of struct page.

Link: https://lkml.kernel.org/r/20230111142915.1001531-23-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm_types.h~mm-remove-first-tail-page-members-from-struct-page
+++ a/include/linux/mm_types.h
@@ -140,16 +140,6 @@ struct page {
 		};
 		struct {	/* Tail pages of compound page */
 			unsigned long compound_head;	/* Bit zero is set */
-
-			/* First tail page only */
-			unsigned char compound_dtor;
-			unsigned char compound_order;
-			atomic_t compound_mapcount;
-			atomic_t subpages_mapcount;
-			atomic_t compound_pincount;
-#ifdef CONFIG_64BIT
-			unsigned int compound_nr; /* 1 << compound_order */
-#endif
 		};
 		struct {	/* Second tail page of transparent huge page */
 			unsigned long _compound_pad_1;	/* compound_head */
@@ -401,14 +391,6 @@ FOLIO_MATCH(memcg_data, memcg_data);
 			offsetof(struct page, pg) + sizeof(struct page))
 FOLIO_MATCH(flags, _flags_1);
 FOLIO_MATCH(compound_head, _head_1);
-FOLIO_MATCH(compound_dtor, _folio_dtor);
-FOLIO_MATCH(compound_order, _folio_order);
-FOLIO_MATCH(compound_mapcount, _entire_mapcount);
-FOLIO_MATCH(subpages_mapcount, _nr_pages_mapped);
-FOLIO_MATCH(compound_pincount, _pincount);
-#ifdef CONFIG_64BIT
-FOLIO_MATCH(compound_nr, _folio_nr_pages);
-#endif
 #undef FOLIO_MATCH
 #define FOLIO_MATCH(pg, fl)						\
 	static_assert(offsetof(struct folio, fl) ==			\
--- a/kernel/crash_core.c~mm-remove-first-tail-page-members-from-struct-page
+++ a/kernel/crash_core.c
@@ -455,8 +455,8 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(page, lru);
 	VMCOREINFO_OFFSET(page, _mapcount);
 	VMCOREINFO_OFFSET(page, private);
-	VMCOREINFO_OFFSET(page, compound_dtor);
-	VMCOREINFO_OFFSET(page, compound_order);
+	VMCOREINFO_OFFSET(folio, _folio_dtor);
+	VMCOREINFO_OFFSET(folio, _folio_order);
 	VMCOREINFO_OFFSET(page, compound_head);
 	VMCOREINFO_OFFSET(pglist_data, node_zones);
 	VMCOREINFO_OFFSET(pglist_data, nr_zones);
_

Patches currently in -mm which might be from willy@infradead.org are



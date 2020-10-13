Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B463C43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3CC92223F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633340;
	bh=0hDRpUAG63XyV/aNyqkcxSU20qECbHCBTKh5Mg+3A14=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=qqshdRVqNP25FVowxrG595G6v6AioIsGOApxolrXeW9Kw8etlO/j4aKR92/OLTDqp
	 EeTS7y1AsoNuCM/cVzMDN1CqXy/LgwDPRzKiEnYY6LSOpk80aixNmNWb/hC/M1Y56G
	 k5eAhkZi0W1nYzvtCl+VuMK6AqoJB4kTzKn0QScI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388485AbgJMXzk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXzk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:55:40 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ACA82222F;
        Tue, 13 Oct 2020 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633339;
        bh=0hDRpUAG63XyV/aNyqkcxSU20qECbHCBTKh5Mg+3A14=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=x/i/74UR16Fu6fziqW5CdSkX8ZC8g1eWwrcgUP25yEg7Ca4IUTBxI/95MvyRQI5dt
         XQLbHx9dBh6NSSXyyH50+ODPCbZT9EPC+ZjE9bS8T8WoL9TIxZoeE5m0NM4JqF84o1
         w6EeUVE0en5UwjBUvjXRgOtzdAFcmj+5Wv8OX58k=
Date:   Tue, 13 Oct 2020 16:55:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        lixinhai.lxh@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        torvalds@linux-foundation.org
Subject:  [patch 131/181] mm, isolation: avoid checking unmovable
 pages across pageblock boundary
Message-ID: <20201013235539.mI1-vBZTB%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm, isolation: avoid checking unmovable pages across pageblock boundary

In has_unmovable_pages(), the page parameter would not always be the first
page within a pageblock (see how the page pointer is passed in from
start_isolate_page_range() after call __first_valid_page()), so that would
cause checking unmovable pages span two pageblocks.

After this patch, the checking is enforced within one pageblock no matter
the page is first one or not, and obey the semantics of this function.

This issue is found by code inspection.

Michal said "this might lead to false negatives when an unrelated block
would cause an isolation failure".

Link: https://lkml.kernel.org/r/20200824065811.383266-1-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-isolation-avoid-checking-unmovable-pages-across-pageblock-boundary
+++ a/mm/page_alloc.c
@@ -8234,6 +8234,7 @@ struct page *has_unmovable_pages(struct
 {
 	unsigned long iter = 0;
 	unsigned long pfn = page_to_pfn(page);
+	unsigned long offset = pfn % pageblock_nr_pages;
 
 	if (is_migrate_cma_page(page)) {
 		/*
@@ -8247,7 +8248,7 @@ struct page *has_unmovable_pages(struct
 		return page;
 	}
 
-	for (; iter < pageblock_nr_pages; iter++) {
+	for (; iter < pageblock_nr_pages - offset; iter++) {
 		if (!pfn_valid_within(pfn + iter))
 			continue;
 
_

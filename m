Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B2EC43381
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B43BB64F1D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbhBXUDH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:03:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235225AbhBXUC1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E812C64E09;
        Wed, 24 Feb 2021 20:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196900;
        bh=HztGbotrskxQl5YEUxl1erJfoM7EIYD5NNsM7KtS8xY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2r7H+2/4FpJpBFhJDHIWauRQ01dJvKczCP4jqVCZRF12mYCD9sfimyf6y9f9q17W9
         DeOvJuojHTyaDiOj4B5nwhBZpzJfo4ev2lJUmQ0FkFvawz4Mnq4CgHYTcYE9Iqmfgl
         KlG0EEFBINis18cPiq0clQz7+0/Z4a7aAZ0QrCMo=
Date:   Wed, 24 Feb 2021 12:01:39 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 027/173] mm/page_owner: use helper function
 zone_end_pfn() to get end_pfn
Message-ID: <20210224200139.gHZVOOVcn%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_owner: use helper function zone_end_pfn() to get end_pfn

Commit 108bcc96ef70 ("mm: add & use zone_end_pfn() and zone_spans_pfn()")
introduced the helper zone_end_pfn() to calculate the zone end pfn.  But
pagetypeinfo_showmixedcount_print forgot to use it.  And the
initialization of local variable pfn is duplicated, remove one.

Link: https://lkml.kernel.org/r/20210123070538.5861-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn
+++ a/mm/page_owner.c
@@ -263,8 +263,8 @@ void pagetypeinfo_showmixedcount_print(s
 	struct page *page;
 	struct page_ext *page_ext;
 	struct page_owner *page_owner;
-	unsigned long pfn = zone->zone_start_pfn, block_end_pfn;
-	unsigned long end_pfn = pfn + zone->spanned_pages;
+	unsigned long pfn, block_end_pfn;
+	unsigned long end_pfn = zone_end_pfn(zone);
 	unsigned long count[MIGRATE_TYPES] = { 0, };
 	int pageblock_mt, page_mt;
 	int i;
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADFBDC2BBCF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69C5C224F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgLODNK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:13:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbgLODNG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:06 -0500
Date:   Mon, 14 Dec 2020 19:12:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001929;
        bh=YR+HLARGKGu1OwO3aC0MwgXK6hhL1mZFqxvo/8cnMNo=;
        h=From:To:Subject:In-Reply-To:From;
        b=FxHrk0thH46a15g8KX34r1nOn/8GpNir9UQTlLaEho8HW3NvM8wVNhPUocIBOHVHZ
         47wYMkX/S+yEHDQ+UbWUZ8T6YId5gm8N/ZLMuzyyDSRhIoD4SkF5ahteIioaGYgv75
         5vkYxSAPEdHG8nITgJMjDC9PhSN+SCyrxYOBBYw8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, torvalds@linux-foundation.org
Subject:  [patch 150/200] mm,hugetlb: remove unneeded
 initialization
Message-ID: <20201215031208.YYUD23D02%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hugetlb: remove unneeded initialization

hugetlb_add_hstate initializes nr_huge_pages and free_huge_pages to 0, but
since hstates[] is a global variable, all its fields are defined to 0
already.

Link: https://lkml.kernel.org/r/20201119112141.6452-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-remove-unneded-initialization
+++ a/mm/hugetlb.c
@@ -3198,8 +3198,6 @@ void __init hugetlb_add_hstate(unsigned
 	h = &hstates[hugetlb_max_hstate++];
 	h->order = order;
 	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
-	h->nr_huge_pages = 0;
-	h->free_huge_pages = 0;
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 	INIT_LIST_HEAD(&h->hugepage_activelist);
_

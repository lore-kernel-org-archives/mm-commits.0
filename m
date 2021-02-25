Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C18C1C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74B3D64E21
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbhBYTUu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234322AbhBYTRf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:17:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7DF064F45;
        Thu, 25 Feb 2021 19:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280346;
        bh=b6pBQSV3ZSOOBV98QKzmPPUMUMMjGfIde/qdg5+d2ZQ=;
        h=Date:From:To:Subject:From;
        b=mPWDWTW+uLbnOeLwqQil0dJseIiLKprP8+gpy2HytEQYeoiMIXbLjhLne+4Uuf1aY
         BpAW6c1t88YARsW77Iq6A8y9mx+SqEraWr84qVbA/w7HnshW6X/F4I0K9+vx1cm+in
         ksx5lbvIBEtadUOWePy5EIPIBGPc+20opmUgfnT4=
Date:   Thu, 25 Feb 2021 11:12:26 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch removed
 from -mm tree
Message-ID: <20210225191226.RSQ1ak5VR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: use helper function zone_end_pfn() to get end_pfn
has been removed from the -mm tree.  Its filename was
     mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch


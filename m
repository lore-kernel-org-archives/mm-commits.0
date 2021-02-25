Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4504EC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E908F64F29
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhBYTeB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:34:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234453AbhBYTaB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:30:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC1BA64F9D;
        Thu, 25 Feb 2021 19:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280601;
        bh=G4eBkuabPYo17WMIfsQ0jclV2ousT+TdQB0/nTustOU=;
        h=Date:From:To:Subject:From;
        b=r8DDsHUYcqkWMFOCntS4MQ1ra6czJEQ0Sa2aT5/G8yS3csgqv1PTQBRzvoz1fGYys
         l1Era6e34MxY94WDEr0wXKIsjbXghHOpMixmCpiLhBGAOqwc3Wa5jHbfuvCixO+IsL
         zhZ7mrTjFFAtal3ZKSd4jr4gtdN+zhHMTIrCh1Fk=
Date:   Thu, 25 Feb 2021 11:16:40 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de
Subject:  [merged]
 mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch removed from
 -mm tree
Message-ID: <20210225191640.Li-ONp11O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: avoid unnecessary hugetlb_acct_memory() call
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: avoid unnecessary hugetlb_acct_memory() call

When reservation accounting remains unchanged, hugetlb_acct_memory() will
do nothing except holding and releasing hugetlb_lock.  We should avoid
this unnecessary hugetlb_lock lock/unlock cycle which is happening on
'most' hugetlb munmap operations by check delta against 0 at the beginning
of hugetlb_acct_memory.

Link: https://lkml.kernel.org/r/20210115092013.61012-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call
+++ a/mm/hugetlb.c
@@ -3591,6 +3591,9 @@ static int hugetlb_acct_memory(struct hs
 {
 	int ret = -ENOMEM;
 
+	if (!delta)
+		return 0;
+
 	spin_lock(&hugetlb_lock);
 	/*
 	 * When cpuset is configured, it breaks the strict hugetlb page
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


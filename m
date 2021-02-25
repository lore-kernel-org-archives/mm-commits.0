Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA95BC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 994E864F18
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhBYTdz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:33:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234864AbhBYTaN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:30:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A353E64F2C;
        Thu, 25 Feb 2021 19:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280638;
        bh=Dyr4sQatzkrg2+5ImvWRUbcQWlAAPXRiPNRGwFA/KU4=;
        h=Date:From:To:Subject:From;
        b=teBJNIVcxEsbmDXScs63lJmyfjXL5kLnIMo6vn+AUxPeFTFfr6QDD7VGxfKUB243Y
         9I59L7PbImSdm2cjaDHiwLhj0KC43YSsU1BkxPSilay+iWmDWDELfBEmPsdKngOtJ0
         DOmrfb6jcg9ayYTe0nLxg4rc+/SbGxthetpjQ0GY=
Date:   Thu, 25 Feb 2021 11:17:18 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de
Subject:  [merged]
 =?US-ASCII?Q?mm-hugetlb-remove-unnecessary-vm=5Fbug=5Fon=5Fpage-on-putba?=
 =?US-ASCII?Q?ck=5Factive=5Fhugepage.patch?= removed from -mm tree
Message-ID: <20210225191718.6vHGClUQF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: remove unnecessary VM_BUG_ON_PAGE on putback_active_hugepage()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-unnecessary-vm_bug_on_page-on-putback_active_hugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: remove unnecessary VM_BUG_ON_PAGE on putback_active_hugepage()

All callers know they are operating on a hugetlb head page.  So this
VM_BUG_ON_PAGE can not catch anything useful.

Link: https://lkml.kernel.org/r/20210209071151.44731-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-unnecessary-vm_bug_on_page-on-putback_active_hugepage
+++ a/mm/hugetlb.c
@@ -5622,7 +5622,6 @@ unlock:
 
 void putback_active_hugepage(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageHead(page), page);
 	spin_lock(&hugetlb_lock);
 	set_page_huge_active(page);
 	list_move_tail(&page->lru, &(page_hstate(page))->hugepage_activelist);
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


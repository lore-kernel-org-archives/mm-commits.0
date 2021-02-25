Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C6CC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 931FE64F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhBYTcS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:32:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234827AbhBYTaE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:30:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9893964F9F;
        Thu, 25 Feb 2021 19:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280606;
        bh=fYDGXm+2ANoS4/8xCLd7XryuFiBBeAMfFlU329h8IbU=;
        h=Date:From:To:Subject:From;
        b=bjhkoiVdbtKITov0GxIiTmALpc6YXViUohDCcCrv3Dk/8nn2tBCppEDyKZUS80fdk
         y1JRnSs7ZNTUKsLyjt39hGWMbRFuq0/9Bgmc2aKaDXj65AEid5qep9oQjz7Znwz/F/
         cuMnf7T77B/7bkLlayoB7CLASQz22Ng/LOR9pe88=
Date:   Thu, 25 Feb 2021 11:16:46 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, louhongxiang@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-hugetlb-fix-use-after-free-when-subpool-max=5Fhpages-acc?=
 =?US-ASCII?Q?ounting-is-not-enabled.patch?= removed from -mm tree
Message-ID: <20210225191646.o00J67iNs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix use after free when subpool max_hpages accounting is not enabled
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix use after free when subpool max_hpages accounting is not enabled

If a hugetlbfs filesystem is created with the min_size option and
without the size option, used_hpages is always 0 and might lead to
release subpool prematurely because it indicates no pages are used now
while there might be.

In order to fix this issue, we should check used_hpages == 0 iff
max_hpages accounting is enabled.  As max_hpages accounting should be
enabled in most common case, this is not worth a Cc stable.

[mike.kravetz@oracle.com: new changelog]
Link: https://lkml.kernel.org/r/20210126115510.53374-1-linmiaohe@huawei.com
Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled
+++ a/mm/hugetlb.c
@@ -97,16 +97,26 @@ static inline void ClearPageHugeFreed(st
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
 
-static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
+static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
-	bool free = (spool->count == 0) && (spool->used_hpages == 0);
+	if (spool->count)
+		return false;
+	if (spool->max_hpages != -1)
+		return spool->used_hpages == 0;
+	if (spool->min_hpages != -1)
+		return spool->rsv_hpages == spool->min_hpages;
+
+	return true;
+}
 
+static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
+{
 	spin_unlock(&spool->lock);
 
 	/* If no pages are used, and no other handles to the subpool
 	 * remain, give up any reservations based on minimum size and
 	 * free the subpool */
-	if (free) {
+	if (subpool_is_free(spool)) {
 		if (spool->min_hpages != -1)
 			hugetlb_acct_memory(spool->hstate,
 						-spool->min_hpages);
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


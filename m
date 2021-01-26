Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23AA1C4332D
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0144206C3
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhA0Csm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jan 2021 21:48:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:42980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405827AbhAZU4G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 26 Jan 2021 15:56:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFF2B221EC;
        Tue, 26 Jan 2021 20:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611694526;
        bh=PhTIjBUXx7SIdj/rtvGKDn38qlUeummqGqLi6ED7+LQ=;
        h=Date:From:To:Subject:From;
        b=kTqC6eQBP4ga2crucvimT6mOc9eCYsulKpefPnkcgxW6FNbYqmZ87CfbWtiPZrgCA
         mBPkhChgB3VIjYlHkjfMfG+z2MruM6IhB/6hYAlrvub//PRV8JBHcO6RIbGRyerQTx
         5wjzWYVI8JTP5KhF852837kxSBwOxt6dnIxrbGdM=
Date:   Tue, 26 Jan 2021 12:55:25 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, louhongxiang@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-hugetlb-fix-use-after-free-when-subpool-max=5Fhpages-acc?=
 =?US-ASCII?Q?ounting-is-not-enabled.patch?= added to -mm tree
Message-ID: <20210126205525.HbsyVykbz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix use after free when subpool max_hpages accounting is not enabled
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix use after free when subpool max_hpages accounting is not enabled

When subpool max_hpages accounting is not enabled, used_hpages is always 0
and might lead to release subpool prematurely because it indicates no
pages are used now while there might be.

In order to fix this issue, we should check used_hpages == 0 iff
max_hpages accounting is enabled.  As max_hpages accounting should be
enabled in most common case, this is not worth a Cc stable.

Link: https://lkml.kernel.org/r/20210126115510.53374-1-linmiaohe@huawei.com
Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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

mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-fix-potential-pte_unmap_unlock-pte-error.patch
mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled.patch
mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes.patch
z3fold-remove-unused-attribute-for-release_z3fold_page.patch
z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
hugetlbfs-make-hugepage-size-conversion-more-readable.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch


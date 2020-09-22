Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE4FC4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 18:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CA812388B
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 18:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600798173;
	bh=X8tY3nXEflhEH2LXL1lqTJotIaNhkfnb/PHIPHlnxGE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TZ7xSqbVURChvLLe+7cxriu23HL/eq6VX/tG9Pb4j7HG/NAoPx2ymgl8F/Ee7cf0J
	 pEYJO1XA6cmvN0Aeo8P6GiEs7HYy0c/VA6mwc6kBbrfCoMCL5YJrrCetibURoLUQb4
	 WikV8iNJ7KTo+qv6gRO7fCWZp/zxTa7vWsxOPkJc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgIVSJc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 14:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgIVSJc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 14:09:32 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA7142376F;
        Tue, 22 Sep 2020 18:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600798171;
        bh=X8tY3nXEflhEH2LXL1lqTJotIaNhkfnb/PHIPHlnxGE=;
        h=Date:From:To:Subject:From;
        b=GT98GOmFt55nbQuc+RiB9WmkK/ql0gEuTopDzglapflP2HsYZny3oh0oTkopptec1
         HMUTnqeT2N1RtzY+HyJKpegEmI9rn3PHh4dN+o43ewrFDt2qMA7YGidVKAel+WQtxN
         qvfynMR3UaHcz4aTFkfA+bJn6e8R8AQDLCTb8XQs=
Date:   Tue, 22 Sep 2020 11:09:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        richard.weiyang@linux.alibaba.com
Subject:  + mm-remove-unused-alloc_page_vma_node.patch added to -mm
 tree
Message-ID: <20200922180931.vucir%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unused alloc_page_vma_node()
has been added to the -mm tree.  Its filename is
     mm-remove-unused-alloc_page_vma_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unused-alloc_page_vma_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unused-alloc_page_vma_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm: remove unused alloc_page_vma_node()

No one use this macro anymore.

Also fix code style of policy_node().

Link: https://lkml.kernel.org/r/20200921021401.84508-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 --
 mm/mempolicy.c      |    3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/include/linux/gfp.h~mm-remove-unused-alloc_page_vma_node
+++ a/include/linux/gfp.h
@@ -560,8 +560,6 @@ extern struct page *alloc_pages_vma(gfp_
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 #define alloc_page_vma(gfp_mask, vma, addr)			\
 	alloc_pages_vma(gfp_mask, 0, vma, addr, numa_node_id(), false)
-#define alloc_page_vma_node(gfp_mask, vma, addr, node)		\
-	alloc_pages_vma(gfp_mask, 0, vma, addr, node, false)
 
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
--- a/mm/mempolicy.c~mm-remove-unused-alloc_page_vma_node
+++ a/mm/mempolicy.c
@@ -1882,8 +1882,7 @@ nodemask_t *policy_nodemask(gfp_t gfp, s
 }
 
 /* Return the node id preferred by the given mempolicy, or the given id */
-static int policy_node(gfp_t gfp, struct mempolicy *policy,
-								int nd)
+static int policy_node(gfp_t gfp, struct mempolicy *policy, int nd)
 {
 	if (policy->mode == MPOL_PREFERRED && !(policy->flags & MPOL_F_LOCAL))
 		nd = policy->v.preferred_node;
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch
mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch
mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number.patch
mm-mmap-not-necessary-to-check-mapping-separately.patch
mm-mmap-check-on-file-instead-of-the-rb_root_cached-of-its-address_space.patch
mm-hugetlb-not-necessary-to-coalesce-regions-recursively.patch
mm-hugetlb-remove-vm_bug_onnrg-in-get_file_region_entry_from_cache.patch
mm-hugetlb-use-list_splice-to-merge-two-list-at-once.patch
mm-hugetlb-count-file_region-to-be-added-when-regions_needed-=-null.patch
mm-hugetlb-a-page-from-buddy-is-not-on-any-list.patch
mm-hugetlb-narrow-the-hugetlb_lock-protection-area-during-preparing-huge-page.patch
mm-hugetlb-take-the-free-hpage-during-the-iteration-directly.patch
mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4.patch
mm-mempolicy-remove-or-narrow-the-lock-on-current.patch
mm-remove-unused-alloc_page_vma_node.patch
mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch


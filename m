Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15028C433DB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 21:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7EAB64F92
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 21:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbhBEVyE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 16:54:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232954AbhBEVxm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 16:53:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC5D464F92;
        Fri,  5 Feb 2021 21:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612561981;
        bh=ZeQAhf3JKZJcKPyJ3wdUJZ6zbOwrmrGADGnw6QS43mA=;
        h=Date:From:To:Subject:From;
        b=x0xP9HyXM33Wq1ipNRKng9cqyUrbRzfsvIxxrnF/dvm0Ei1K5ftuHj7n/++r7YgOd
         o1Q4rZi+7JAtwDdJABGKhO6HVEvcvM4JHjtXqm4CGyo2qDIcdZGSDSzPL3BUH4wYaN
         LUv3YfbL0ToNitskPI2s0XuDTuDhp8uJey+11B3s=
Date:   Fri, 05 Feb 2021 13:53:01 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  +
 hugetlb_cgroup-use-helper-pages_per_huge_page-in-hugetlb_cgroup.patch added
 to -mm tree
Message-ID: <20210205215301.03Hi764qA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: use helper pages_per_huge_page() in hugetlb_cgroup
has been added to the -mm tree.  Its filename is
     hugetlb_cgroup-use-helper-pages_per_huge_page-in-hugetlb_cgroup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb_cgroup-use-helper-pages_per_huge_page-in-hugetlb_cgroup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb_cgroup-use-helper-pages_per_huge_page-in-hugetlb_cgroup.patch

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
Subject: hugetlb_cgroup: use helper pages_per_huge_page() in hugetlb_cgroup

We could use helper function pages_per_huge_page() to get the number of
pages in a hstate to simplify the code slightly.

Link: https://lkml.kernel.org/r/20210205084513.29624-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-use-helper-pages_per_huge_page-in-hugetlb_cgroup
+++ a/mm/hugetlb_cgroup.c
@@ -113,7 +113,7 @@ static void hugetlb_cgroup_init(struct h
 			rsvd_parent);
 
 		limit = round_down(PAGE_COUNTER_MAX,
-				   1 << huge_page_order(&hstates[idx]));
+				   pages_per_huge_page(&hstates[idx]));
 
 		ret = page_counter_set_max(
 			hugetlb_cgroup_counter_from_cgroup(h_cgroup, idx),
@@ -460,7 +460,7 @@ static int hugetlb_cgroup_read_u64_max(s
 	counter = &h_cg->hugepage[idx];
 
 	limit = round_down(PAGE_COUNTER_MAX,
-			   1 << huge_page_order(&hstates[idx]));
+			   pages_per_huge_page(&hstates[idx]));
 
 	switch (MEMFILE_ATTR(cft->private)) {
 	case RES_RSVD_USAGE:
@@ -507,7 +507,7 @@ static ssize_t hugetlb_cgroup_write(stru
 		return ret;
 
 	idx = MEMFILE_IDX(of_cft(of)->private);
-	nr_pages = round_down(nr_pages, 1 << huge_page_order(&hstates[idx]));
+	nr_pages = round_down(nr_pages, pages_per_huge_page(&hstates[idx]));
 
 	switch (MEMFILE_ATTR(of_cft(of)->private)) {
 	case RES_RSVD_LIMIT:
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-fix-potential-pte_unmap_unlock-pte-error.patch
mm-simplify-the-vm_bug_on-condition-in-pmdp_huge_clear_flush.patch
mm-pgtable-genericc-optimize-the-vm_bug_on-condition-in-pmdp_huge_clear_flush.patch
mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled.patch
mm-hugetlb-fix-some-comment-typos.patch
mm-remove-unused-return-value-of-set_huge_zero_page.patch
hugetlb_cgroup-use-helper-pages_per_huge_page-in-hugetlb_cgroup.patch
mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes.patch
z3fold-remove-unused-attribute-for-release_z3fold_page.patch
z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
mm-mempolicy-use-helper-range_in_vma-in-queue_pages_test_walk.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
hugetlbfs-make-hugepage-size-conversion-more-readable.patch
hugetlbfs-correct-some-obsolete-comments-about-inode-i_mutex.patch
hugetlbfs-fix-some-comment-typos.patch
mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch


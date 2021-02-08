Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E04C433E0
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 21:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DD5364E8F
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 21:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbhBHVr5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Feb 2021 16:47:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236850AbhBHVqi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Feb 2021 16:46:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1F2564EA1;
        Mon,  8 Feb 2021 21:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612820756;
        bh=N9VpbADMsHviR8uibg27XbRWO/IXgKoXWXqmayyn+nE=;
        h=Date:From:To:Subject:From;
        b=YPGjL1PFos2gevvQ/NPBOpSVid43kCAqcILXKOQ9/foDeSezKvwT1RtecRM1GADwx
         Bl3ZO71Ylsps345mBW+YByRXns6onn6tyttWr0cnTkUJ+WqEHw1ck0nHQapXQBwopw
         iO3beqWt1yf+r+aT07rLMxCAFHEyYd3bMdDkA9Zc=
Date:   Mon, 08 Feb 2021 13:45:55 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size.patch added to
 -mm tree
Message-ID: <20210208214555.klkOm7_oK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use helper huge_page_size() to get hugepage size
has been added to the -mm tree.  Its filename is
     mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size.patch

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
Subject: mm/hugetlb: use helper huge_page_size() to get hugepage size

We can use helper huge_page_size() to get the hugepage size directly to
simplify the code slightly.

Link: https://lkml.kernel.org/r/20210208082450.15716-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size
+++ a/mm/hugetlb.c
@@ -3248,7 +3248,7 @@ void __init hugetlb_add_hstate(unsigned
 	BUG_ON(order == 0);
 	h = &hstates[hugetlb_max_hstate++];
 	h->order = order;
-	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
+	h->mask = ~(huge_page_size(h) - 1);
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 	INIT_LIST_HEAD(&h->hugepage_activelist);
@@ -3523,7 +3523,7 @@ void hugetlb_report_meminfo(struct seq_f
 	for_each_hstate(h) {
 		unsigned long count = h->nr_huge_pages;
 
-		total += (PAGE_SIZE << huge_page_order(h)) * count;
+		total += huge_page_size(h) * count;
 
 		if (h == &default_hstate)
 			seq_printf(m,
@@ -3536,10 +3536,10 @@ void hugetlb_report_meminfo(struct seq_f
 				   h->free_huge_pages,
 				   h->resv_huge_pages,
 				   h->surplus_huge_pages,
-				   (PAGE_SIZE << huge_page_order(h)) / 1024);
+				   huge_page_size(h) / SZ_1K);
 	}
 
-	seq_printf(m, "Hugetlb:        %8lu kB\n", total / 1024);
+	seq_printf(m, "Hugetlb:        %8lu kB\n", total / SZ_1K);
 }
 
 int hugetlb_report_node_meminfo(char *buf, int len, int nid)
@@ -3573,7 +3573,7 @@ void hugetlb_show_meminfo(void)
 				h->nr_huge_pages_node[nid],
 				h->free_huge_pages_node[nid],
 				h->surplus_huge_pages_node[nid],
-				1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
+				huge_page_size(h) >> 10);
 }
 
 void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm)
@@ -3696,9 +3696,7 @@ static int hugetlb_vm_op_split(struct vm
 
 static unsigned long hugetlb_vm_op_pagesize(struct vm_area_struct *vma)
 {
-	struct hstate *hstate = hstate_vma(vma);
-
-	return 1UL << huge_page_shift(hstate);
+	return huge_page_size(hstate_vma(vma));
 }
 
 /*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-fix-potential-pte_unmap_unlock-pte-error.patch
mm-simplify-the-vm_bug_on-condition-in-pmdp_huge_clear_flush.patch
mm-pgtable-genericc-optimize-the-vm_bug_on-condition-in-pmdp_huge_clear_flush.patch
mm-memoryc-fix-potential-pte_unmap_unlock-pte-error.patch
mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled.patch
mm-hugetlb-fix-some-comment-typos.patch
mm-remove-unused-return-value-of-set_huge_zero_page.patch
hugetlb_cgroup-use-helper-pages_per_huge_page-in-hugetlb_cgroup.patch
mm-hugetlb-use-helper-function-range_in_vma-in-page_table_shareable.patch
mm-hugetlb-remove-redundant-vm_bug_on_page-on-putback_active_hugepage.patch
mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size.patch
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
hugetlbfs-remove-unneeded-return-value-of-hugetlb_vmtruncate.patch
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


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC866C433E0
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 21:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6049B64E6B
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 21:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbhBIVBV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Feb 2021 16:01:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233898AbhBIUl5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Feb 2021 15:41:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB5BC64EC6;
        Tue,  9 Feb 2021 20:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612901353;
        bh=vDY2uwa0Y5bG/820WVuKWMGjeSUUU/vzBVldPpm1EPw=;
        h=Date:From:To:Subject:From;
        b=vsdmbqlcUGWSN1SjVjEs4wRpHDGrxEWBDxQX8zBz1dFzGonFPGyzS12k7cbpu7H0Y
         TEFXt7iOeT1bqwLTKdrIzWhGhme7yt1PyTb7V00+cLYlKvfTPHWFhUXXbPt+TDPuUM
         hddWWRiymb3264OrgTFbD/XIA9hcvlAoWGtY4PYo=
Date:   Tue, 09 Feb 2021 12:09:12 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size-v2.patch added to
 -mm tree
Message-ID: <20210209200912.za6weC0v6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use helper huge_page_size() to get hugepage size
has been added to the -mm tree.  Its filename is
     mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size-v2.patch

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

change huge_page_size(h) >> 10 to huge_page_size(h) / SZ_1K

Link: https://lkml.kernel.org/r/20210209021803.49211-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size-v2
+++ a/mm/hugetlb.c
@@ -3573,7 +3573,7 @@ void hugetlb_show_meminfo(void)
 				h->nr_huge_pages_node[nid],
 				h->free_huge_pages_node[nid],
 				h->surplus_huge_pages_node[nid],
-				huge_page_size(h) >> 10);
+				huge_page_size(h) / SZ_1K);
 }
 
 void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm)
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
mm-hugetlb-remove-unnecessary-vm_bug_on_page-on-putback_active_hugepage.patch
mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size.patch
mm-hugetlb-use-helper-huge_page_size-to-get-hugepage-size-v2.patch
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


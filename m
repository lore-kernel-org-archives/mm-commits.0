Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99DEC433E0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 740B464F65
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbhBDA3Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Feb 2021 19:29:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233702AbhBDA3X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Feb 2021 19:29:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7F0164F4D;
        Thu,  4 Feb 2021 00:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612398522;
        bh=iQ3BnvH6hMHIF64u3Slzx6JB5ibQeVk3ALP44HLf35w=;
        h=Date:From:To:Subject:From;
        b=oGEGEGlMER3OilqsPDZBQKOSC4xt5zTjcewr1MECTZ/6QprRrOZAngrtpfBjkTUpd
         +DhAYAxDY4oNvsVqW6/sNp/XbOB+VOENiEGu6JpHy8JfCs9rof/VU3R/XKonpsDal5
         DKc2yKGvQG2TeSbvVROH3XVpj2l8B+OUyI5MtZfE=
Date:   Wed, 03 Feb 2021 16:28:41 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, ngupta@vflare.org
Subject:  +
 mm-zsmallocc-use-page_private-to-access-page-private.patch added to -mm
 tree
Message-ID: <20210204002841.BWgFaDnHF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: use page_private() to access page->private
has been added to the -mm tree.  Its filename is
     mm-zsmallocc-use-page_private-to-access-page-private.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zsmallocc-use-page_private-to-access-page-private.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmallocc-use-page_private-to-access-page-private.patch

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
Subject: mm/zsmalloc.c: use page_private() to access page->private

It's recommended to use helper macro page_private() to access the private
field of page.  Use such helper to eliminate direct access.

Link: https://lkml.kernel.org/r/20210203091857.20017-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmallocc-use-page_private-to-access-page-private
+++ a/mm/zsmalloc.c
@@ -816,7 +816,7 @@ static int get_pages_per_zspage(int clas
 
 static struct zspage *get_zspage(struct page *page)
 {
-	struct zspage *zspage = (struct zspage *)page->private;
+	struct zspage *zspage = (struct zspage *)page_private(page);
 
 	BUG_ON(zspage->magic != ZSPAGE_MAGIC);
 	return zspage;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-fix-potential-pte_unmap_unlock-pte-error.patch
mm-simplify-the-vm_bug_on-condition-in-pmdp_huge_clear_flush.patch
mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled.patch
mm-hugetlb-fix-some-comment-typos.patch
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


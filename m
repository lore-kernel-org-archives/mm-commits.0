Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9D3C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 31 Jan 2021 03:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47D5264E1F
	for <mm-commits@archiver.kernel.org>; Sun, 31 Jan 2021 03:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhAaD5M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 30 Jan 2021 22:57:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229692AbhAaD5M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 30 Jan 2021 22:57:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A18B364E1F;
        Sun, 31 Jan 2021 03:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612065391;
        bh=faRwsWtZJyltyJpwA1WvShneAx+v4yda2ujtr2Xwt14=;
        h=Date:From:To:Subject:From;
        b=suDtJmixde5ItCaCMc+3AEyWvlGZFh36TIaRpSesKVRN4Pou8YUwwVQKyGBaaWVGM
         9TckroIWOEqn0Coylk1YTTHajpk/UrEeizY62+h4G4JH9cmhl404E53TrzcMJvehqk
         QnCfYl2m6lVub4nVsMFY1cbPszOb6YxNW7TjlgoM=
Date:   Sat, 30 Jan 2021 19:56:31 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  + mm-rmap-use-page_not_mapped-in-try_to_unmap.patch added
 to -mm tree
Message-ID: <20210131035631.VL9rYo2zc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: use page_not_mapped in try_to_unmap()
has been added to the -mm tree.  Its filename is
     mm-rmap-use-page_not_mapped-in-try_to_unmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-use-page_not_mapped-in-try_to_unmap.patch

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
Subject: mm/rmap: use page_not_mapped in try_to_unmap()

page_mapcount_is_zero() calculates accurately how many mappings a hugepage
has in order to check against 0 only.  This is a waste of cpu time.  We
can do this via page_not_mapped() to save some possible atomic_read
cycles.  Remove the function page_mapcount_is_zero() as it's not used
anymore and move page_not_mapped() above try_to_unmap() to avoid
identifier undeclared compilation error.

Link: https://lkml.kernel.org/r/20210130084904.35307-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/mm/rmap.c~mm-rmap-use-page_not_mapped-in-try_to_unmap
+++ a/mm/rmap.c
@@ -1736,9 +1736,9 @@ static bool invalid_migration_vma(struct
 	return vma_is_temporary_stack(vma);
 }
 
-static int page_mapcount_is_zero(struct page *page)
+static int page_not_mapped(struct page *page)
 {
-	return !total_mapcount(page);
+	return !page_mapped(page);
 }
 
 /**
@@ -1756,7 +1756,7 @@ bool try_to_unmap(struct page *page, enu
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
 		.arg = (void *)flags,
-		.done = page_mapcount_is_zero,
+		.done = page_not_mapped,
 		.anon_lock = page_lock_anon_vma_read,
 	};
 
@@ -1780,11 +1780,6 @@ bool try_to_unmap(struct page *page, enu
 	return !page_mapcount(page) ? true : false;
 }
 
-static int page_not_mapped(struct page *page)
-{
-	return !page_mapped(page);
-}
-
 /**
  * try_to_munlock - try to munlock a page
  * @page: the page to be munlocked
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-fix-potential-pte_unmap_unlock-pte-error.patch
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
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch


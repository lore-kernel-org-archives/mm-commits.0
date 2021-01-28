Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE1AC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 21:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7D2764DF0
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 21:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhA1VUP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jan 2021 16:20:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229596AbhA1VUO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Jan 2021 16:20:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5F9C64DEF;
        Thu, 28 Jan 2021 21:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611868771;
        bh=I3z6kOF2JQkiKKkEB5rzZz1gg+PBF2sqAcEclxbd77I=;
        h=Date:From:To:Subject:From;
        b=ulFyXUQba4ZTaC4QcQVNmAvEC0MB0ZW5tJdcIew+ZB50Rf8B+ZrRdhJQm+1OR9pEV
         BXaSHqO2y7pebPfzk5cCdiEzJ8fOg3GKTyab7MaMGpmKRTFg+3lSW9OIhpEGtIUYL4
         t46vVSux+5tzXPSg1T0p1BLsy8s2f3th/zhRH0rk=
Date:   Thu, 28 Jan 2021 13:19:31 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  +
 mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch added to -mm
 tree
Message-ID: <20210128211931.ELKdLktwT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix obsolete comment in __page_check_anon_rmap()
has been added to the -mm tree.  Its filename is
     mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch

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
Subject: mm/rmap: fix obsolete comment in __page_check_anon_rmap()

Commit 21333b2b66b8 ("ksm: no debug in page_dup_rmap()") has reverted
page_dup_rmap() to an inline atomic_inc of mapcount.  So page_dup_rmap()
does not call __page_check_anon_rmap() anymore.

Link: https://lkml.kernel.org/r/20210128110209.50857-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/rmap.c~mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap
+++ a/mm/rmap.c
@@ -1086,8 +1086,7 @@ static void __page_check_anon_rmap(struc
 	 * be set up correctly at this point.
 	 *
 	 * We have exclusion against page_add_anon_rmap because the caller
-	 * always holds the page locked, except if called from page_dup_rmap,
-	 * in which case the page is already known to be setup.
+	 * always holds the page locked.
 	 *
 	 * We have exclusion against page_add_new_anon_rmap because those pages
 	 * are initially only visible via the pagetables, and the pte is locked
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
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
hugetlbfs-make-hugepage-size-conversion-more-readable.patch
hugetlbfs-correct-some-obsolete-comments-about-inode-i_mutex.patch
mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59671C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 31 Jan 2021 03:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CC5A64DCC
	for <mm-commits@archiver.kernel.org>; Sun, 31 Jan 2021 03:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhAaDzO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 30 Jan 2021 22:55:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhAaDzN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 30 Jan 2021 22:55:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C57CB64E1F;
        Sun, 31 Jan 2021 03:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612065272;
        bh=jHrbf663sG/iqXC8w4qP7ZNqGH6yZ5h9NIOhoQF7BtE=;
        h=Date:From:To:Subject:From;
        b=i/w7lclcVm7fgit3FNWB69QUNiG/Yx06Mzt8dGwqULgBfxLH/plcF0V8+pJpyJPSO
         oG5zlwNpD2y4unNZlAIKKvaFwAIam6kI+2LR8Iyk0iIdVAGvqbPhQ3Cb8hGH2A/l8i
         kT/0y+MjKzCzkrocE2o2bTu949yx0FqpOYCZsVHs=
Date:   Sat, 30 Jan 2021 19:54:32 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  + hugetlbfs-fix-some-comment-typos.patch added to -mm
 tree
Message-ID: <20210131035432.xISv5cQF3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: fix some comment typos
has been added to the -mm tree.  Its filename is
     hugetlbfs-fix-some-comment-typos.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-fix-some-comment-typos.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-fix-some-comment-typos.patch

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
Subject: hugetlbfs: fix some comment typos

Fix typos reserv to reserve, minimim to minimum. No functional change
intended.

Link: https://lkml.kernel.org/r/20210130092351.28072-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-some-comment-typos
+++ a/fs/hugetlbfs/inode.c
@@ -442,15 +442,15 @@ hugetlb_vmdelete_list(struct rb_root_cac
  *
  * truncation is indicated by end of range being LLONG_MAX
  *	In this case, we first scan the range and release found pages.
- *	After releasing pages, hugetlb_unreserve_pages cleans up region/reserv
+ *	After releasing pages, hugetlb_unreserve_pages cleans up region/reserve
  *	maps and global counts.  Page faults can not race with truncation
  *	in this routine.  hugetlb_no_page() holds i_mmap_rwsem and prevents
  *	page faults in the truncated range by checking i_size.  i_size is
  *	modified while holding i_mmap_rwsem.
  * hole punch is indicated if end is not LLONG_MAX
  *	In the hole punch case we scan the range and release found pages.
- *	Only when releasing a page is the associated region/reserv map
- *	deleted.  The region/reserv map for ranges without associated
+ *	Only when releasing a page is the associated region/reserve map
+ *	deleted.  The region/reserve map for ranges without associated
  *	pages are not modified.  Page faults can race with hole punch.
  *	This is indicated if we find a mapped page.
  * Note: If the passed end of range value is beyond the end of file, but
@@ -1336,7 +1336,7 @@ hugetlbfs_fill_super(struct super_block
 
 	/*
 	 * Allocate and initialize subpool if maximum or minimum size is
-	 * specified.  Any needed reservations (for minimim size) are taken
+	 * specified.  Any needed reservations (for minimum size) are taken
 	 * taken when the subpool is created.
 	 */
 	if (ctx->max_hpages != -1 || ctx->min_hpages != -1) {
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
hugetlbfs-fix-some-comment-typos.patch
mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37AEECAAD1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 19:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiIATKn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 15:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbiIATKm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 15:10:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA375283C
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 12:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 135A3B828CE
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 19:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EF3C433D6;
        Thu,  1 Sep 2022 19:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662059438;
        bh=m8PWfk+DBz4swgx5UsiFrO814iXF3d/vhQJ+5a81Bcc=;
        h=Date:To:From:Subject:From;
        b=Dyhj54PA6xlFgFHisKNFmjkSFr+ZSSk8qcNLuXG9N20VwkB1BODLk/lOSRcTe9sef
         q7vx0SxXQujF4z/jeVZw0aps/S7S+tqze62q6kiOpYpQvmCyNQbHWiVAFtihq9F3u0
         SojY9uxkciJ9WV+8FgTBhcuqItpRa3CwHmTlyV90=
Date:   Thu, 01 Sep 2022 12:10:37 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-make-hugetlb_cma_check-static.patch added to mm-unstable branch
Message-Id: <20220901191038.C4EF3C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: make hugetlb_cma_check() static
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-make-hugetlb_cma_check-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-make-hugetlb_cma_check-static.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb: make hugetlb_cma_check() static
Date: Thu, 1 Sep 2022 20:00:21 +0800

Patch series "A few cleanup patches for hugetlb", v2.

This series contains a few cleanup patches to use helper functions to
simplify the codes, remove unneeded nid parameter and so on. More
details can be found in the respective changelogs.


This patch (of 10):

Make hugetlb_cma_check() static as it's only used inside mm/hugetlb.c.

Link: https://lkml.kernel.org/r/20220901120030.63318-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220901120030.63318-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ----
 mm/hugetlb.c            |   10 +++++++++-
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/include/linux/hugetlb.h~hugetlb-make-hugetlb_cma_check-static
+++ a/include/linux/hugetlb.h
@@ -1155,14 +1155,10 @@ static inline spinlock_t *huge_pte_lock(
 
 #if defined(CONFIG_HUGETLB_PAGE) && defined(CONFIG_CMA)
 extern void __init hugetlb_cma_reserve(int order);
-extern void __init hugetlb_cma_check(void);
 #else
 static inline __init void hugetlb_cma_reserve(int order)
 {
 }
-static inline __init void hugetlb_cma_check(void)
-{
-}
 #endif
 
 bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr);
--- a/mm/hugetlb.c~hugetlb-make-hugetlb_cma_check-static
+++ a/mm/hugetlb.c
@@ -4058,6 +4058,14 @@ static void hugetlb_register_all_nodes(v
 
 #endif
 
+#ifdef CONFIG_CMA
+static void __init hugetlb_cma_check(void);
+#else
+static inline __init void hugetlb_cma_check(void)
+{
+}
+#endif
+
 static int __init hugetlb_init(void)
 {
 	int i;
@@ -7546,7 +7554,7 @@ void __init hugetlb_cma_reserve(int orde
 		hugetlb_cma_size = 0;
 }
 
-void __init hugetlb_cma_check(void)
+static void __init hugetlb_cma_check(void)
 {
 	if (!hugetlb_cma_size || cma_reserve_called)
 		return;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
hugetlb_cgroup-remove-unneeded-nr_pages-0-check.patch
hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch
hugetlb_cgroup-remove-unneeded-return-value.patch
hugetlb_cgroup-use-helper-macro-numa_no_node.patch
hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch
mm-hugetlb-fix-incorrect-update-of-max_huge_pages.patch
mm-hugetlb-fix-warn_onkobj-in-sysfs_create_group.patch
mm-hugetlb-fix-missing-call-to-restore_reserve_on_error.patch
mm-hugetlb-fix-missing-call-to-restore_reserve_on_error-v2.patch
mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch
mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch
mm-hugetlb-make-detecting-shared-pte-more-reliable.patch
mm-hwpoison-fix-page-refcnt-leaking-in-try_memory_failure_hugetlb.patch
mm-hwpoison-fix-page-refcnt-leaking-in-unpoison_memory.patch
mm-hwpoison-fix-extra-put_page-in-soft_offline_page.patch
mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs-v2.patch
mm-hwpoison-kill-procs-if-unmap-fails.patch
mm-hwpoison-kill-procs-if-unmap-fails-v2.patch
mm-hwpoison-avoid-trying-to-unpoison-reserved-page.patch
mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
hugetlb-make-hugetlb_cma_check-static.patch
hugetlb-use-helper-macro-sz_1k.patch
hugetlb-use-list_head-to-define-a-list-head.patch
hugetlb-use-sizeof-to-get-the-array-size.patch
hugetlb-use-helper-huge_ptepmd_lock.patch
hugetlb-pass-null-to-kobj_to_hstate-if-nid-is-unused.patch
hugetlb-kill-hugetlbfs_pagecache_page.patch
hugetlb-add-comment-for-subtle-sethpagevmemmapoptimized.patch
hugetlb-remove-meaningless-bug_onhuge_pte_none.patch
hugetlb-make-hugetlb-depends-on-sysfs-or-sysctl.patch


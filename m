Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365C2ECAAD5
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 19:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiIATK6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 15:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbiIATKv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 15:10:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEA75FAC3
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 12:10:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57789B828FF
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 19:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B9DC433C1;
        Thu,  1 Sep 2022 19:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662059447;
        bh=fdzk9inkdE+uwRk4F/wGxMC/ok+D7iZyT/s1iuqP90s=;
        h=Date:To:From:Subject:From;
        b=2SFUbo51MuY/Q1yatNgza2mUgmSm7Ujk2CD7gjqdUQhwXbPq5HM2ZFwk3XZBqNeh7
         j5VyJy8GYqiho0B/s7f4cjsoJywsnxE3+8Jsr1xevgUY/wusgyvJ+O7TANI1JwOjmC
         rUGVUFBs5emWCbH+z4mSSS0kkGne9YGRGpf3q4HE=
Date:   Thu, 01 Sep 2022 12:10:46 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-use-helper-huge_ptepmd_lock.patch added to mm-unstable branch
Message-Id: <20220901191047.11B9DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: use helper {huge_pte|pmd}_lock()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-use-helper-huge_ptepmd_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-use-helper-huge_ptepmd_lock.patch

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
Subject: hugetlb: use helper {huge_pte|pmd}_lock()
Date: Thu, 1 Sep 2022 20:00:25 +0800

Use helper huge_pte_lock and pmd_lock to simplify the code. No functional
change intended.

Link: https://lkml.kernel.org/r/20220901120030.63318-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~hugetlb-use-helper-huge_ptepmd_lock
+++ a/mm/hugetlb.c
@@ -6094,8 +6094,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		page_in_pagecache = true;
 	}
 
-	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
-	spin_lock(ptl);
+	ptl = huge_pte_lock(h, dst_mm, dst_pte);
 
 	/*
 	 * We allow to overwrite a pte marker: consider when both MISSING|WP
@@ -7176,8 +7175,7 @@ follow_huge_pmd(struct mm_struct *mm, un
 		return NULL;
 
 retry:
-	ptl = pmd_lockptr(mm, pmd);
-	spin_lock(ptl);
+	ptl = pmd_lock(mm, pmd);
 	/*
 	 * make sure that the address range covered by this pmd is not
 	 * unmapped from other threads.
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


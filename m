Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C40BECAAD5
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 01:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiHaBVi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 21:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiHaBVh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 21:21:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C188AD98A
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 18:21:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9C9D615EF
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 01:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B490C433D6;
        Wed, 31 Aug 2022 01:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661908895;
        bh=RSwaGhWqGxLN7eZVlsWLqKIh5YOF/PpSpmemlx/Srcs=;
        h=Date:To:From:Subject:From;
        b=NP2SEenti8MaGYSk9P5axlI3eP3EDD2gMAJGhCj4VrUaQLAl8h0Nf+fn078lkx5gO
         bqnZj1Yy2Jx/I1f6v+TJu2+mx94RlQdK7VzRuDQbK8Dpp42aY8A13/L5lJpVr/0dGP
         ZrmYBAvfV+582HQSp0JbCdrHB0Iyq3EgAO/mVYLg=
Date:   Tue, 30 Aug 2022 18:21:34 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch added to mm-unstable branch
Message-Id: <20220831012135.4B490C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: use num_poisoned_pages_sub() to decrease num_poisoned_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch

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
Subject: mm, hwpoison: use num_poisoned_pages_sub() to decrease num_poisoned_pages
Date: Tue, 30 Aug 2022 20:36:01 +0800

Use num_poisoned_pages_sub() to combine multiple atomic ops into one. Also
num_poisoned_pages_dec() can be killed as there's no caller now.

Link: https://lkml.kernel.org/r/20220830123604.25763-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    5 -----
 mm/memory-failure.c     |    6 ++++--
 2 files changed, 4 insertions(+), 7 deletions(-)

--- a/include/linux/swapops.h~mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages
+++ a/include/linux/swapops.h
@@ -602,11 +602,6 @@ static inline void num_poisoned_pages_in
 	atomic_long_inc(&num_poisoned_pages);
 }
 
-static inline void num_poisoned_pages_dec(void)
-{
-	atomic_long_dec(&num_poisoned_pages);
-}
-
 static inline void num_poisoned_pages_sub(long i)
 {
 	atomic_long_sub(i, &num_poisoned_pages);
--- a/mm/memory-failure.c~mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages
+++ a/mm/memory-failure.c
@@ -2596,7 +2596,7 @@ retry:
 
 void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
 {
-	int i;
+	int i, total = 0;
 
 	/*
 	 * A further optimization is to have per section refcounted
@@ -2609,8 +2609,10 @@ void clear_hwpoisoned_pages(struct page
 
 	for (i = 0; i < nr_pages; i++) {
 		if (PageHWPoison(&memmap[i])) {
-			num_poisoned_pages_dec();
+			total++;
 			ClearPageHWPoison(&memmap[i]);
 		}
 	}
+	if (total)
+		num_poisoned_pages_sub(total);
 }
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


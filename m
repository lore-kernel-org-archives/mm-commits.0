Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6331CECAAA1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 01:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiHaBV3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 21:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiHaBV2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 21:21:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645A782753
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 18:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0BB46189F
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 01:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D108C433C1;
        Wed, 31 Aug 2022 01:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661908886;
        bh=yTo2G8UVZ7qu/8nvjVnO/A9M89vNSobsXMH3U++JmlI=;
        h=Date:To:From:Subject:From;
        b=yUEl4EnDVgn2iE0DFVN8SVDvbFa4wQckkVSYSJfGgog4MMrGUASUiz71XKHMZzAsE
         T8RVukouS/wS6P1Ju6Fl1bdgRUViyC4CeSTmSMOlcFtI+bvt+x2EteL9XNJEAb/wfH
         VKBb5SN6momTqEjUtoEPrOWBuE58cdAY4vS4k5Y8=
Date:   Tue, 30 Aug 2022 18:21:25 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch added to mm-unstable branch
Message-Id: <20220831012126.4D108C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: use ClearPageHWPoison() in memory_failure()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch

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
Subject: mm, hwpoison: use ClearPageHWPoison() in memory_failure()
Date: Tue, 30 Aug 2022 20:35:59 +0800

Patch series "A few cleanup patches for memory-failure".

his series contains a few cleanup patches to use __PageMovable() to detect
non-lru movable pages, use num_poisoned_pages_sub() to reduce multiple
atomic ops overheads and so on.  More details can be found in the
respective changelogs.


This patch (of 6):

Use ClearPageHWPoison() instead of TestClearPageHWPoison() to clear page
hwpoison flags to avoid unneeded full memory barrier overhead.

Link: https://lkml.kernel.org/r/20220830123604.25763-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220830123604.25763-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-hwpoison-use-clearpagehwpoison-in-memory_failure
+++ a/mm/memory-failure.c
@@ -2128,7 +2128,7 @@ try_again:
 	page_flags = p->flags;
 
 	if (hwpoison_filter(p)) {
-		TestClearPageHWPoison(p);
+		ClearPageHWPoison(p);
 		unlock_page(p);
 		put_page(p);
 		res = -EOPNOTSUPP;
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


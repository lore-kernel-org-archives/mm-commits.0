Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6F4C00140
	for <mm-commits@archiver.kernel.org>; Thu, 18 Aug 2022 23:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244328AbiHRXzz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Aug 2022 19:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244994AbiHRXzw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Aug 2022 19:55:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ACFDDB71
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 16:55:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9932FB82370
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 23:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2D4C433C1;
        Thu, 18 Aug 2022 23:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660866948;
        bh=HqhJi61nv6apsIa6sDiF//Cz+c9D5SIUtshbFxkb0JQ=;
        h=Date:To:From:Subject:From;
        b=jyTxvm/jQMzrhGRnbMylkC944PXzJcJgSH1gMDJirynCX4eoiDprJkZDwpdP7xiQ/
         wHYuUIGVGj2dAG3cF0riD7hTC+I61Ma6hjl5BscDm8eW+sAX0bRrXgKiFDijhkwInc
         /OiDqkh7n1R3wpcutJQIsDuQ2G7HW04vV1uy46ts=
Date:   Thu, 18 Aug 2022 16:55:47 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-fix-extra-put_page-in-soft_offline_page.patch added to mm-unstable branch
Message-Id: <20220818235548.3B2D4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: fix extra put_page() in soft_offline_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-fix-extra-put_page-in-soft_offline_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-fix-extra-put_page-in-soft_offline_page.patch

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
Subject: mm, hwpoison: fix extra put_page() in soft_offline_page()
Date: Thu, 18 Aug 2022 21:00:13 +0800

When hwpoison_filter() refuses to soft offline a page, the page refcnt
incremented previously by MF_COUNT_INCREASED would have been consumed via
get_hwpoison_page() if ret <= 0.  So the put_ref_page() here will put the
extra one.  Remove it to fix the issue.

Link: https://lkml.kernel.org/r/20220818130016.45313-4-linmiaohe@huawei.com
Fixes: 9113eaf331bf ("mm/memory-failure.c: add hwpoison_filter for soft offline")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-extra-put_page-in-soft_offline_page
+++ a/mm/memory-failure.c
@@ -2591,8 +2591,6 @@ retry:
 	if (hwpoison_filter(page)) {
 		if (ret > 0)
 			put_page(page);
-		else
-			put_ref_page(ref_page);
 
 		mutex_unlock(&mf_mutex);
 		return -EOPNOTSUPP;
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
mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch
mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch
mm-hugetlb-make-detecting-shared-pte-more-reliable.patch
mm-hwpoison-fix-page-refcnt-leaking-in-try_memory_failure_hugetlb.patch
mm-hwpoison-fix-page-refcnt-leaking-in-unpoison_memory.patch
mm-hwpoison-fix-extra-put_page-in-soft_offline_page.patch
mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs.patch
mm-hwpoison-kill-procs-if-unmap-fails.patch
mm-hwpoison-avoid-trying-to-unpoison-reserved-page.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CC6C25B0E
	for <mm-commits@archiver.kernel.org>; Thu, 18 Aug 2022 23:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245272AbiHRXz4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Aug 2022 19:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245649AbiHRXzy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Aug 2022 19:55:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303EADEA46
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 16:55:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAAAE615DC
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 23:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDDDC433D6;
        Thu, 18 Aug 2022 23:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660866952;
        bh=0dBXT2WvlLvjGKhZxKYSguayeZXa5qNqIdEx7/HG20o=;
        h=Date:To:From:Subject:From;
        b=dIcuWWrUMZZDG/pTJkUc04HBxsXRIfVye5EMDFGZCrEdNuKQaatArN1hxc3Zgk5l/
         8hA6fzuM2fuU9UbFEjTAwJ4/vXPDiSGEy35QHl7mPTS8jr5+dEUQn6TQTGCbAvsqM3
         8faOA1RiZnF0QS2nRCF+uAONXJnhTOAsIV0ZEF3M=
Date:   Thu, 18 Aug 2022 16:55:51 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-kill-procs-if-unmap-fails.patch added to mm-unstable branch
Message-Id: <20220818235552.1CDDDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: kill procs if unmap fails
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-kill-procs-if-unmap-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-kill-procs-if-unmap-fails.patch

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
Subject: mm, hwpoison: kill procs if unmap fails
Date: Thu, 18 Aug 2022 21:00:15 +0800

If try_to_unmap() fails, the hwpoisoned page still resides in the address
space of some processes.  We should kill these processes or the hwpoisoned
page might be consumed later.  collect_procs() is always called to collect
relevant processes now so they can be killed later if unmap fails.

Link: https://lkml.kernel.org/r/20220818130016.45313-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-kill-procs-if-unmap-fails
+++ a/mm/memory-failure.c
@@ -1396,7 +1396,7 @@ static bool hwpoison_user_mappings(struc
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	bool unmap_success;
-	int kill = 1, forcekill;
+	int forcekill;
 	bool mlocked = PageMlocked(hpage);
 
 	/*
@@ -1437,7 +1437,6 @@ static bool hwpoison_user_mappings(struc
 		if (page_mkclean(hpage)) {
 			SetPageDirty(hpage);
 		} else {
-			kill = 0;
 			ttu |= TTU_IGNORE_HWPOISON;
 			pr_info("%#lx: corrupted page was clean: dropped without side effects\n",
 				pfn);
@@ -1452,8 +1451,7 @@ static bool hwpoison_user_mappings(struc
 	 * Error handling: We ignore errors here because
 	 * there's nothing that can be done.
 	 */
-	if (kill)
-		collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
+	collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
 
 	if (PageHuge(hpage) && !PageAnon(hpage)) {
 		/*
@@ -1495,7 +1493,8 @@ static bool hwpoison_user_mappings(struc
 	 * use a more force-full uncatchable kill to prevent
 	 * any accesses to the poisoned memory.
 	 */
-	forcekill = PageDirty(hpage) || (flags & MF_MUST_KILL);
+	forcekill = PageDirty(hpage) || (flags & MF_MUST_KILL) ||
+		    !unmap_success;
 	kill_procs(&tokill, forcekill, !unmap_success, pfn, flags);
 
 	return unmap_success;
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


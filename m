Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D08C00140
	for <mm-commits@archiver.kernel.org>; Thu, 18 Aug 2022 23:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245649AbiHRXz6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Aug 2022 19:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245567AbiHRXz5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Aug 2022 19:55:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947BBD59AF
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 16:55:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52B1EB80E08
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 23:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCE1C433D6;
        Thu, 18 Aug 2022 23:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660866954;
        bh=k6JTmL6TXAKZY//QyIIJ++BYVPy/DrXjHArKz0WE32s=;
        h=Date:To:From:Subject:From;
        b=st9amu3yDClSHznWOUq1VkNu8HaE5rKJ6Zm/KOkzV4jmi1jmJBj4nBM3Jdd2O1xrm
         KuzrBk/fb78qOp/4M+4rjre1Gj+dlnz+bhoSaIauOUgpDE+mhm9gxi58PznIo5OSJJ
         ce3f7fmLP9HYoI3RJyG6YfLcsn6tgj0T4AHea+Lk=
Date:   Thu, 18 Aug 2022 16:55:53 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-avoid-trying-to-unpoison-reserved-page.patch added to mm-unstable branch
Message-Id: <20220818235554.0DCE1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: avoid trying to unpoison reserved page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-avoid-trying-to-unpoison-reserved-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-avoid-trying-to-unpoison-reserved-page.patch

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
Subject: mm, hwpoison: avoid trying to unpoison reserved page
Date: Thu, 18 Aug 2022 21:00:16 +0800

For reserved pages, HWPoison flag will be set without increasing the page
refcnt.  So we shouldn't even try to unpoison these pages and thus
decrease the page refcnt unexpectly.  Add a PageReserved() check to filter
this case out and remove the below unneeded zero page (zero page is
reserved) check.

Link: https://lkml.kernel.org/r/20220818130016.45313-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-avoid-trying-to-unpoison-reserved-page
+++ a/mm/memory-failure.c
@@ -2355,7 +2355,7 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
-	if (PageSlab(page) || PageTable(page))
+	if (PageSlab(page) || PageTable(page) || PageReserved(page))
 		goto unlock_mutex;
 
 	ret = get_hwpoison_page(p, MF_UNPOISON);
@@ -2386,7 +2386,7 @@ int unpoison_memory(unsigned long pfn)
 		freeit = !!TestClearPageHWPoison(p);
 
 		put_page(page);
-		if (freeit && !(pfn == my_zero_pfn(0) && page_count(p) == 1)) {
+		if (freeit) {
 			put_page(page);
 			ret = 0;
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
mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch
mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch
mm-hugetlb-make-detecting-shared-pte-more-reliable.patch
mm-hwpoison-fix-page-refcnt-leaking-in-try_memory_failure_hugetlb.patch
mm-hwpoison-fix-page-refcnt-leaking-in-unpoison_memory.patch
mm-hwpoison-fix-extra-put_page-in-soft_offline_page.patch
mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs.patch
mm-hwpoison-kill-procs-if-unmap-fails.patch
mm-hwpoison-avoid-trying-to-unpoison-reserved-page.patch


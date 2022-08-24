Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70699C04AA5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 20:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237608AbiHXUBN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 16:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbiHXUBM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 16:01:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09E97C1DC
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 13:01:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BFC561781
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 20:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB0FC433D7;
        Wed, 24 Aug 2022 20:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661371270;
        bh=mXTdvU6HFjTsNMYF6LXGhDd7aUgVbAhrsDu1aZjucvo=;
        h=Date:To:From:Subject:From;
        b=1J93kry96phvmYIegPfSykrkIz82SpT3Jy2bz+PpLoDelc0nEV4NHIXsTad++vzzj
         n9SRnfDDiSy97tTlY2aHF+ixMQ1TaJiECiNa0TKvAEDf7pXKXFVPIPmW7TCb9xSvbY
         znBjP/UyFUTyfOCC6qOekfMOeHqCjNiIzk4uZU0g=
Date:   Wed, 24 Aug 2022 13:01:10 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-missing-call-to-restore_reserve_on_error-v2.patch added to mm-unstable branch
Message-Id: <20220824200110.CEB0FC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-fix-missing-call-to-restore_reserve_on_error-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-missing-call-to-restore_reserve_on_error-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-missing-call-to-restore_reserve_on_error-v2.patch

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
Subject: mm-hugetlb-fix-missing-call-to-restore_reserve_on_error-v2
Date: Tue, 23 Aug 2022 11:02:06 +0800

remove err == -EEXIST check and retry logic

Link: https://lkml.kernel.org/r/20220823030209.57434-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-missing-call-to-restore_reserve_on_error-v2
+++ a/mm/hugetlb.c
@@ -5548,7 +5548,6 @@ static vm_fault_t hugetlb_no_page(struct
 	if (idx >= size)
 		goto out;
 
-retry:
 	new_page = false;
 	page = find_lock_page(mapping, idx);
 	if (!page) {
@@ -5588,10 +5587,15 @@ retry:
 		if (vma->vm_flags & VM_MAYSHARE) {
 			int err = huge_add_to_page_cache(page, mapping, idx);
 			if (err) {
+				/*
+				 * err can't be -EEXIST which implies someone
+				 * else consumed the reservation since hugetlb
+				 * fault mutex is held when add a hugetlb page
+				 * to the page cache. So it's safe to call
+				 * restore_reserve_on_error() here.
+				 */
 				restore_reserve_on_error(h, vma, haddr, page);
 				put_page(page);
-				if (err == -EEXIST)
-					goto retry;
 				goto out;
 			}
 			new_pagecache_page = true;
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


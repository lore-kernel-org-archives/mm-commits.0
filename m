Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB0F0C43334
	for <mm-commits@archiver.kernel.org>; Sat, 11 Jun 2022 22:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbiFKWDm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Jun 2022 18:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiFKWDl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Jun 2022 18:03:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBEC109C
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 15:03:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A032B80B4D
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 22:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32009C34116;
        Sat, 11 Jun 2022 22:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654985017;
        bh=4LcIvE4JHImDyiTc4UKCKw+JA/J93lw/s3zA9KtcJaU=;
        h=Date:To:From:Subject:From;
        b=Z5my698AP7LA9sIuCzRJmtUJsYjiqwKtIng3AIBP8cO5cCX+gM+batBEQeV1BeM/S
         gB0yH9Ip5K0DRFEh0pklrSbOwps/icSmbJlkeQiUi3YKk5rZ5Dyo5zfhir5oJ12fiv
         IGOJE3t2ARnbrKYdfmjs0U3OX5F/af3U80V3wgkI=
Date:   Sat, 11 Jun 2022 15:03:36 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch added to mm-unstable branch
Message-Id: <20220611220337.32009C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: make security_vm_enough_memory_mm() work as expected
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch

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
Subject: mm/swapfile: make security_vm_enough_memory_mm() work as expected
Date: Wed, 8 Jun 2022 22:40:29 +0800

Patch series "A few cleanup and fixup patches for swap", v2.

This series contains a cleaup patch to remove unneeded swap_cache_info
statistics, and two bugfix patches to avoid possible data races of
inuse_pages and so on.  More details can be found in the respective
changelogs.


This patch (of 3):

security_vm_enough_memory_mm() checks whether a process has enough memory
to allocate a new virtual mapping.  And total_swap_pages is considered as
available memory while swapoff tries to make sure there's enough memory
that can hold the swapped out memory.  But total_swap_pages contains the
swap space that is being swapoff.  So security_vm_enough_memory_mm() will
success even if there's no memory to hold the swapped out memory because
total_swap_pages always greater than or equal to p->pages.

In order to fix it, p->pages should be subtracted from total_swap_pages
first and then check whether there's enough memory for inuse swap pages.

Link: https://lkml.kernel.org/r/20220608144031.829-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220608144031.829-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected
+++ a/mm/swapfile.c
@@ -2398,6 +2398,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	struct filename *pathname;
 	int err, found = 0;
 	unsigned int old_block_size;
+	unsigned int inuse_pages;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -2428,9 +2429,13 @@ SYSCALL_DEFINE1(swapoff, const char __us
 		spin_unlock(&swap_lock);
 		goto out_dput;
 	}
-	if (!security_vm_enough_memory_mm(current->mm, p->pages))
-		vm_unacct_memory(p->pages);
+
+	total_swap_pages -= p->pages;
+	inuse_pages = READ_ONCE(p->inuse_pages);
+	if (!security_vm_enough_memory_mm(current->mm, inuse_pages))
+		vm_unacct_memory(inuse_pages);
 	else {
+		total_swap_pages += p->pages;
 		err = -ENOMEM;
 		spin_unlock(&swap_lock);
 		goto out_dput;
@@ -2453,7 +2458,6 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	}
 	plist_del(&p->list, &swap_active_head);
 	atomic_long_sub(p->pages, &nr_swap_pages);
-	total_swap_pages -= p->pages;
 	p->flags &= ~SWP_WRITEOK;
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

maintainers-add-myself-as-a-memory-failure-reviewer.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-memremap-fix-wrong-function-name-above-memremap_pages.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
lib-test_hmm-avoid-accessing-uninitialized-pages.patch
mm-memremap-fix-memunmap_pages-race-with-get_dev_pagemap.patch
mm-khugepaged-remove-unneeded-shmem_huge_enabled-check.patch
mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch
mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch


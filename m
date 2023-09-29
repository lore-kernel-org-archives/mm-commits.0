Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 297ADE77347
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 22:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbjI2W4H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 18:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjI2W4H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 18:56:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB8DDD
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 15:56:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE886C433C8;
        Fri, 29 Sep 2023 22:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696028164;
        bh=D4B0HTZWmV7xwEaib9nXsGTmIGQWQnWYYL0gPMYybDU=;
        h=Date:To:From:Subject:From;
        b=v49ghZJ6Khg0os8g7pk23C1P38A5YrXvQ3t98gkEqS1QxEp7GjPGfKQUBf63NDXfl
         ZLflou2FeHy1OPe3TLhyQjRokf3bDyLyi7vCbHizJmCxZ/0PBGzgnoLgX8GrhUJh84
         aXgV2iKC47w8/Sum3jwTFF3mrlAvxY0f/S+0zfs8=
Date:   Fri, 29 Sep 2023 15:56:03 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, ryan.roberts@arm.com, rientjes@google.com,
        mcgrof@kernel.org, kirill.shutemov@linux.intel.com,
        jhubbard@nvidia.com, itaru.kitayama@gmail.com, hughd@google.com,
        fengwei.yin@intel.com, david@redhat.com, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files-fix.patch added to mm-unstable branch
Message-Id: <20230929225603.EE886C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files-fix
Date: Fri Sep 29 03:40:25 PM PDT 2023

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files-fix
+++ a/mm/huge_memory.c
@@ -74,7 +74,7 @@ static unsigned long deferred_split_scan
 static atomic_t huge_zero_refcount;
 struct page *huge_zero_page __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
-unsigned int huge_anon_orders __read_mostly = BIT(PMD_ORDER);
+unsigned int huge_anon_orders __read_mostly;
 static unsigned int huge_anon_always_mask __read_mostly;
 
 /**
@@ -528,6 +528,9 @@ static int __init hugepage_init_sysfs(st
 {
 	int err;
 
+	/* powerpc's PMD_ORDER isn't a compile-time constant */
+	huge_anon_orders = BIT(PMD_ORDER);
+
 	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
 	if (unlikely(!*hugepage_kobj)) {
 		pr_err("failed to create transparent hugepage kobject\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix.patch
mm-shrinker-convert-shrinker_rwsem-to-mutex-fix.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-ksm-add-smart-page-scanning-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix-2.patch
mm-kmem-scoped-objcg-protection-checkpatch-fixes.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap-fix.patch
mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files-fix.patch
kthread-add-kthread_stop_put-v2-fix.patch


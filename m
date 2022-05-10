Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE28AC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbiEJERv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbiEJEQl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6058423F39F
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57BF861744
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE79C385C2;
        Tue, 10 May 2022 04:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155934;
        bh=twv5M0d6krmQOXGhtGFIirQhxs+Nmo83NNniZXzS7Zw=;
        h=Date:To:From:Subject:From;
        b=OSeGiCKLvE90viw30oI44cY6G7R7tdSLwcS6IT03oP8NpPglh/x/7+3af9j2+kZBW
         r5Lquyd0SDJM/kD0H6HfYcvn3EIAKaMdzrb93JU47wkZR+HDCihgMwbmOegScajq54
         v/FckDbrUfHA88T4Yye7P0hs+WBANfzUOzmM549E=
Date:   Mon, 09 May 2022 21:12:14 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com, apopple@nvidia.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-stub-for-non_swap_entry.patch removed from -mm tree
Message-Id: <20220510041214.AAE79C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/linux/swapops.h: remove stub for non_swap_entry()
has been removed from the -mm tree.  Its filename was
     mm-remove-stub-for-non_swap_entry.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: include/linux/swapops.h: remove stub for non_swap_entry()

The stub for non_swap_entry() may not help much, because MAX_SWAPFILES has
already contained all the information to decide whether a swap entry is
real swap entry or pesudo ones (migrations, ...).

There can be some performance influences on non_swap_entry() with below
conditions all met:

  !CONFIG_MIGRATION && !CONFIG_MEMORY_FAILURE && !CONFIG_DEVICE_PRIVATE

But that's definitely not the major config most machines will use, at the
meantime it's already in a slow path of swap entry (being parsed from a
swap pte), so IMHO it shouldn't be a major issue.  Also according to the
analysis from Alistair, somehow the stub didn't do the job right [1].

To make the code cleaner, let's drop the stub.

[1] https://lore.kernel.org/lkml/8735ihbw6g.fsf@nvdebian.thelocal/

Note: the uffd-wp shmem & hugetlbfs series will need this patch to make
sure swap entries work as expected with below config as spotted by
Alistair:

  !CONFIG_MIGRATION &&
  !CONFIG_MEMORY_FAILURE &&
  !CONFIG_DEVICE_PRIVATE &&
  CONFIG_PTE_MARKER

(PS: this config should mostly never gonna happen, though, afaict..)

Link: https://lkml.kernel.org/r/20220413191147.66645-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/swapops.h~mm-remove-stub-for-non_swap_entry
+++ a/include/linux/swapops.h
@@ -387,18 +387,10 @@ static inline void num_poisoned_pages_in
 }
 #endif
 
-#if defined(CONFIG_MEMORY_FAILURE) || defined(CONFIG_MIGRATION) || \
-    defined(CONFIG_DEVICE_PRIVATE)
 static inline int non_swap_entry(swp_entry_t entry)
 {
 	return swp_type(entry) >= MAX_SWAPFILES;
 }
-#else
-static inline int non_swap_entry(swp_entry_t entry)
-{
-	return 0;
-}
-#endif
 
 #endif /* CONFIG_MMU */
 #endif /* _LINUX_SWAPOPS_H */
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-introduce-pte_marker-swap-entry.patch
mm-introduce-pte_marker-swap-entry-fix.patch
mm-teach-core-mm-about-pte-markers.patch
mm-teach-core-mm-about-pte-markers-fix.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-check-against-orig_pte-for-finish_fault-fix.patch
mm-uffd-pte_marker_uffd_wp.patch
mm-uffd-pte_marker_uffd_wp-fix.patch
mm-shmem-take-care-of-uffdio_copy_mode_wp.patch
mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch
mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed.patch
mm-shmem-allow-uffd-wr-protect-none-pte-for-file-backed-mem.patch
mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch
mm-shmem-handle-uffd-wp-during-fork.patch
mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch
mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch
mm-hugetlb-take-care-of-uffdio_copy_mode_wp.patch
mm-hugetlb-handle-uffdio_writeprotect.patch
mm-hugetlb-handle-pte-markers-in-page-faults.patch
mm-hugetlb-allow-uffd-wr-protect-none-ptes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix.patch
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
mm-enable-pte-markers-by-default-fix.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch
mm-uffd-move-userfaultfd-configs-into-mm.patch


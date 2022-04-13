Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81298C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 13 Apr 2022 21:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239069AbiDMVYh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Apr 2022 17:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238973AbiDMVYb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Apr 2022 17:24:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECC665480
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 14:22:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE961B8251D
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 21:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FB2C385A6;
        Wed, 13 Apr 2022 21:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649884926;
        bh=nHVcvVK7F/heHN9Z0/FOJGrZPkZ5MFHwhM3OvSsFYNg=;
        h=Date:To:From:Subject:From;
        b=uBEscdyE1l6x8iLq41xBzLQu+OKaD0pw12YrDz47k8opmxilBHq7Va2QIK7WKk5am
         lSs3juOZB4f0+Ml+ASE/dV4xIWwfnEvodVmsF9lshzJvb5BILbISglLxpXc7MXXcDB
         msB2rPc5gSxLtugNjOQNkxmAXP0tWGUsba7yFRuY=
Date:   Wed, 13 Apr 2022 14:22:05 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com, apopple@nvidia.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-stub-for-non_swap_entry.patch added to -mm tree
Message-Id: <20220413212206.66FB2C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/swapops.h: remove stub for non_swap_entry()
has been added to the -mm tree.  Its filename is
     mm-remove-stub-for-non_swap_entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-stub-for-non_swap_entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-stub-for-non_swap_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/swapops.h~mm-remove-stub-for-non_swap_entry
+++ a/include/linux/swapops.h
@@ -414,18 +414,10 @@ static inline void num_poisoned_pages_in
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

mm-remove-stub-for-non_swap_entry.patch
mm-introduce-pte_marker-swap-entry.patch
mm-introduce-pte_marker-swap-entry-fix.patch
mm-teach-core-mm-about-pte-markers.patch
mm-check-against-orig_pte-for-finish_fault.patch
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
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch


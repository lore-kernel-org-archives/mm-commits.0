Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA22C19F2D
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 21:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbiHKVR7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 17:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbiHKVR4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 17:17:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D342C9AFF4
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 14:17:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B88AB8229F
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 21:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361BCC433C1;
        Thu, 11 Aug 2022 21:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660252673;
        bh=bMqi4vS4vE4bFMRTQR4f8PFlnnzuaG6AmtOqqCYCAD4=;
        h=Date:To:From:Subject:From;
        b=zD+g+0FP9kN2S1JRhxKx0tC3RgG35l1LVLBKYJaLAaUnLEgDOSpGMl6U+J66TOzCJ
         HYzEkif0CMOms2PxM75+UVBV5S7LvKiBwYG10grz7/JjlRSab7wDBJG9HVxi5UF6lY
         gSg6Sk7UfxXIuFwyzTKIXPBJtoPO8FAa+63ZwwIQ=
Date:   Thu, 11 Aug 2022 14:17:52 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        nadav.amit@gmail.com, minchan@kernel.org, kirill@shutemov.name,
        hughd@google.com, david@redhat.com, apopple@nvidia.com,
        andi.kleen@intel.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-cache-swap-migration-a-d-bits-support.patch added to mm-unstable branch
Message-Id: <20220811211753.361BCC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: cache swap migration A/D bits support
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-cache-swap-migration-a-d-bits-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-cache-swap-migration-a-d-bits-support.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/swap: cache swap migration A/D bits support
Date: Thu, 11 Aug 2022 12:13:31 -0400

Introduce a variable swap_migration_ad_supported to cache whether the arch
supports swap migration A/D bits.

Here one thing to mention is that SWP_MIG_TOTAL_BITS will internally
reference the other macro MAX_PHYSMEM_BITS, which is a function call on
x86 (constant on all the rest of archs).

It's safe to reference it in swapfile_init() because when reaching here
we're already during initcalls level 4 so we must have initialized 5-level
pgtable for x86_64 (right after early_identify_cpu() finishes).

- start_kernel
  - setup_arch
    - early_cpu_init
      - get_cpu_cap --> fetch from CPUID (including X86_FEATURE_LA57)
      - early_identify_cpu --> clear X86_FEATURE_LA57 (if early lvl5 not enabled (USE_EARLY_PGTABLE_L5))
  - arch_call_rest_init
    - rest_init
      - kernel_init
        - kernel_init_freeable
          - do_basic_setup
            - do_initcalls --> calls swapfile_init() (initcall level 4)

This should slightly speed up the migration swap entry handlings.

Link: https://lkml.kernel.org/r/20220811161331.37055-8-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapfile.h |    2 ++
 include/linux/swapops.h  |    7 +------
 mm/swapfile.c            |    8 ++++++++
 3 files changed, 11 insertions(+), 6 deletions(-)

--- a/include/linux/swapfile.h~mm-swap-cache-swap-migration-a-d-bits-support
+++ a/include/linux/swapfile.h
@@ -10,5 +10,7 @@ extern struct swap_info_struct *swap_inf
 extern unsigned long generic_max_swapfile_size(void);
 /* Maximum swapfile size supported for the arch (not inclusive). */
 extern unsigned long swapfile_maximum_size;
+/* Whether swap migration entry supports storing A/D bits for the arch */
+extern bool swap_migration_ad_supported;
 
 #endif /* _LINUX_SWAPFILE_H */
--- a/include/linux/swapops.h~mm-swap-cache-swap-migration-a-d-bits-support
+++ a/include/linux/swapops.h
@@ -301,13 +301,8 @@ static inline swp_entry_t make_writable_
  */
 static inline bool migration_entry_supports_ad(void)
 {
-	/*
-	 * max_swapfile_size() returns the max supported swp-offset plus 1.
-	 * We can support the migration A/D bits iff the pfn swap entry has
-	 * the offset large enough to cover all of them (PFN, A & D bits).
-	 */
 #ifdef CONFIG_SWAP
-	return swapfile_maximum_size >= (1UL << SWP_MIG_TOTAL_BITS);
+	return swap_migration_ad_supported;
 #else  /* CONFIG_SWAP */
 	return false;
 #endif	/* CONFIG_SWAP */
--- a/mm/swapfile.c~mm-swap-cache-swap-migration-a-d-bits-support
+++ a/mm/swapfile.c
@@ -64,6 +64,9 @@ EXPORT_SYMBOL_GPL(nr_swap_pages);
 long total_swap_pages;
 static int least_priority = -1;
 unsigned long swapfile_maximum_size;
+#ifdef CONFIG_MIGRATION
+bool swap_migration_ad_supported;
+#endif	/* CONFIG_MIGRATION */
 
 static const char Bad_file[] = "Bad swap file entry ";
 static const char Unused_file[] = "Unused swap file entry ";
@@ -3680,6 +3683,11 @@ static int __init swapfile_init(void)
 
 	swapfile_maximum_size = arch_max_swapfile_size();
 
+#ifdef CONFIG_MIGRATION
+	if (swapfile_maximum_size >= (1UL << SWP_MIG_TOTAL_BITS))
+		swap_migration_ad_supported = true;
+#endif	/* CONFIG_MIGRATION */
+
 	return 0;
 }
 subsys_initcall(swapfile_init);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-smaps-dont-access-young-dirty-bit-if-pte-unpresent.patch
mm-uffd-reset-write-protection-when-unregister-with-wp-mode.patch
mm-x86-use-swp_type_bits-in-3-level-swap-macros.patch
mm-swap-comment-all-the-ifdef-in-swapopsh.patch
mm-swap-add-swp_offset_pfn-to-fetch-pfn-from-swap-entry.patch
mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch
mm-remember-young-dirty-bit-for-page-migrations.patch
mm-swap-cache-maximum-swapfile-size-when-init-swap.patch
mm-swap-cache-swap-migration-a-d-bits-support.patch


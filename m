Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A604C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiI0Cr7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiI0Cro (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B6162AB6
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C47561559
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720DBC433D6;
        Tue, 27 Sep 2022 02:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246854;
        bh=VQyO6CrK6UOuTpHyEBlqkqKnOTGpHZif1YsF+CYnc64=;
        h=Date:To:From:Subject:From;
        b=ZSJNfi7eQAvcHZpuvtxa4qNhqBdKlVEm/FxtC3lans2nOPEwAYZsu6ba1mUgxil7H
         iZo9GUYXQModZnxt5b+dDDkVw8KtE2kGe3LEEGMybKLWSf9TqzJRT8nSdUpV/jdsfU
         XJWZbHP1EZEsVefJXWwJ4wGz7pPHWX95AkDTWmfA=
Date:   Mon, 26 Sep 2022 19:47:33 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        nadav.amit@gmail.com, minchan@kernel.org, kirill@shutemov.name,
        hughd@google.com, david@redhat.com, dave.hansen@intel.com,
        apopple@nvidia.com, andi.kleen@intel.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-cache-swap-migration-a-d-bits-support.patch removed from -mm tree
Message-Id: <20220927024734.720DBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: cache swap migration A/D bits support
has been removed from the -mm tree.  Its filename was
     mm-swap-cache-swap-migration-a-d-bits-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapfile.h |    2 ++
 include/linux/swapops.h  |    7 +------
 mm/swapfile.c            |    8 ++++++++
 3 files changed, 11 insertions(+), 6 deletions(-)

--- a/include/linux/swapfile.h~mm-swap-cache-swap-migration-a-d-bits-support
+++ a/include/linux/swapfile.h
@@ -12,5 +12,7 @@ unsigned long arch_max_swapfile_size(voi
 
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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71CA8C6FA82
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiI0CsA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiI0Cro (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EE161B2E
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 827A5B81904
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2B0C433B5;
        Tue, 27 Sep 2022 02:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246853;
        bh=UVUL1ULKa7zPE+DN6/KLCIMhgEDgXH4wNIeYD/yForw=;
        h=Date:To:From:Subject:From;
        b=VmYjPUXXLNm9GlW/V4e3rlAUSuk+9nBywfQ0jMGn59KBfAfvheDF+Bdpl0xu7VuVQ
         r2KSrAJ2MuwGBGbGA90p6bIk2RhvrNj6rdGxm5rct0smukmiVf8ZzjhHO868AtsaiS
         u0J/xpazln5Sy9tGL/1TqVGaADurrvcjOIJuSL8Y=
Date:   Mon, 26 Sep 2022 19:47:32 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        nadav.amit@gmail.com, minchan@kernel.org, kirill@shutemov.name,
        hughd@google.com, david@redhat.com, dave.hansen@intel.com,
        apopple@nvidia.com, andi.kleen@intel.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-cache-maximum-swapfile-size-when-init-swap.patch removed from -mm tree
Message-Id: <20220927024733.2D2B0C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: cache maximum swapfile size when init swap
has been removed from the -mm tree.  Its filename was
     mm-swap-cache-maximum-swapfile-size-when-init-swap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/swap: cache maximum swapfile size when init swap
Date: Thu, 11 Aug 2022 12:13:30 -0400

We used to have swapfile_maximum_size() fetching a maximum value of
swapfile size per-arch.

As the caller of max_swapfile_size() grows, this patch introduce a
variable "swapfile_maximum_size" and cache the value of old
max_swapfile_size(), so that we don't need to calculate the value every
time.

Caching the value in swapfile_init() is safe because when reaching the
phase we should have initialized all the relevant information.  Here the
major arch to take care of is x86, which defines the max swapfile size
based on L1TF mitigation.

Here both X86_BUG_L1TF or l1tf_mitigation should have been setup properly
when reaching swapfile_init().  As a reference, the code path looks like
this for x86:

- start_kernel
  - setup_arch
    - early_cpu_init
      - early_identify_cpu --> setup X86_BUG_L1TF
  - parse_early_param
    - l1tf_cmdline --> set l1tf_mitigation
  - check_bugs
    - l1tf_select_mitigation --> set l1tf_mitigation
  - arch_call_rest_init
    - rest_init
      - kernel_init
        - kernel_init_freeable
          - do_basic_setup
            - do_initcalls --> calls swapfile_init() (initcall level 4)

The swapfile size only depends on swp pte format on non-x86 archs, so
caching it is safe too.

Since at it, rename max_swapfile_size() to arch_max_swapfile_size()
because arch can define its own function, so it's more straightforward to
have "arch_" as its prefix.  At the meantime, export swapfile_maximum_size
to replace the old usages of max_swapfile_size().

[peterx@redhat.com: declare arch_max_swapfile_size) in swapfile.h]
  Link: https://lkml.kernel.org/r/YxTh1GuC6ro5fKL5@xz-m1.local
Link: https://lkml.kernel.org/r/20220811161331.37055-7-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c       |    2 +-
 include/linux/swapfile.h |    5 ++++-
 include/linux/swapops.h  |    2 +-
 mm/swapfile.c            |    7 +++++--
 4 files changed, 11 insertions(+), 5 deletions(-)

--- a/arch/x86/mm/init.c~mm-swap-cache-maximum-swapfile-size-when-init-swap
+++ a/arch/x86/mm/init.c
@@ -1054,7 +1054,7 @@ void update_cache_mode_entry(unsigned en
 }
 
 #ifdef CONFIG_SWAP
-unsigned long max_swapfile_size(void)
+unsigned long arch_max_swapfile_size(void)
 {
 	unsigned long pages;
 
--- a/include/linux/swapfile.h~mm-swap-cache-maximum-swapfile-size-when-init-swap
+++ a/include/linux/swapfile.h
@@ -8,6 +8,9 @@
  */
 extern struct swap_info_struct *swap_info[];
 extern unsigned long generic_max_swapfile_size(void);
-extern unsigned long max_swapfile_size(void);
+unsigned long arch_max_swapfile_size(void);
+
+/* Maximum swapfile size supported for the arch (not inclusive). */
+extern unsigned long swapfile_maximum_size;
 
 #endif /* _LINUX_SWAPFILE_H */
--- a/include/linux/swapops.h~mm-swap-cache-maximum-swapfile-size-when-init-swap
+++ a/include/linux/swapops.h
@@ -307,7 +307,7 @@ static inline bool migration_entry_suppo
 	 * the offset large enough to cover all of them (PFN, A & D bits).
 	 */
 #ifdef CONFIG_SWAP
-	return max_swapfile_size() >= (1UL << SWP_MIG_TOTAL_BITS);
+	return swapfile_maximum_size >= (1UL << SWP_MIG_TOTAL_BITS);
 #else  /* CONFIG_SWAP */
 	return false;
 #endif	/* CONFIG_SWAP */
--- a/mm/swapfile.c~mm-swap-cache-maximum-swapfile-size-when-init-swap
+++ a/mm/swapfile.c
@@ -63,6 +63,7 @@ EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
 static int least_priority = -1;
+unsigned long swapfile_maximum_size;
 
 static const char Bad_file[] = "Bad swap file entry ";
 static const char Unused_file[] = "Unused swap file entry ";
@@ -2816,7 +2817,7 @@ unsigned long generic_max_swapfile_size(
 }
 
 /* Can be overridden by an architecture for additional checks. */
-__weak unsigned long max_swapfile_size(void)
+__weak unsigned long arch_max_swapfile_size(void)
 {
 	return generic_max_swapfile_size();
 }
@@ -2856,7 +2857,7 @@ static unsigned long read_swap_header(st
 	p->cluster_next = 1;
 	p->cluster_nr = 0;
 
-	maxpages = max_swapfile_size();
+	maxpages = swapfile_maximum_size;
 	last_page = swap_header->info.last_page;
 	if (!last_page) {
 		pr_warn("Empty swap-file\n");
@@ -3677,6 +3678,8 @@ static int __init swapfile_init(void)
 	for_each_node(nid)
 		plist_head_init(&swap_avail_heads[nid]);
 
+	swapfile_maximum_size = arch_max_swapfile_size();
+
 	return 0;
 }
 subsys_initcall(swapfile_init);
_

Patches currently in -mm which might be from peterx@redhat.com are



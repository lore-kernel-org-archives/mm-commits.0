From: akpm@linux-foundation.org
Subject: + mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch added to -mm tree
Date: Thu, 18 Jan 2018 13:58:37 -0800
Message-ID: <5a61188d.N32CKE/0Ji1cUIIL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40970 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932191AbeARV6i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jan 2018 16:58:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, osalvador@techadventures.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_owner-clean-up-init_pages_in_zone-v3-fix
has been added to the -mm tree.  Its filename is
     mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_owner-clean-up-init_pages_in_zone-v3-fix

coding style tweaks

Cc: Oscar Salvador <osalvador@techadventures.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_owner.c~mm-page_owner-clean-up-init_pages_in_zone-v3-fix mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-clean-up-init_pages_in_zone-v3-fix
+++ a/mm/page_owner.c
@@ -539,6 +539,7 @@ static void init_pages_in_zone(pg_data_t
 	 */
 	for (; pfn < end_pfn; ) {
 		unsigned long block_end_pfn;
+
 		if (!pfn_valid(pfn)) {
 			pfn = ALIGN(pfn + 1, MAX_ORDER_NR_PAGES);
 			continue;
@@ -550,6 +551,7 @@ static void init_pages_in_zone(pg_data_t
 		for (; pfn < block_end_pfn; pfn++) {
 			struct page *page;
 			struct page_ext *page_ext;
+
 			if (!pfn_valid_within(pfn))
 				continue;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


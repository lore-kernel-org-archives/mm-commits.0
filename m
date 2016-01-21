From: akpm@linux-foundation.org
Subject: + fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch added to -mm tree
Date: Thu, 21 Jan 2016 13:01:11 -0800
Message-ID: <56a14717.ZZCsrLs4RoFvGSOU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbcAUVBM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 16:01:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/mpage.c:mpage_readpages(): use lru_to_page() helper
has been added to the -mm tree.  Its filename is
     fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch

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
Subject: fs/mpage.c:mpage_readpages(): use lru_to_page() helper


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/mpage.c~fs-mpagec-mpage_readpages-use-lru_to_page-helper fs/mpage.c
--- a/fs/mpage.c~fs-mpagec-mpage_readpages-use-lru_to_page-helper
+++ a/fs/mpage.c
@@ -366,7 +366,7 @@ mpage_readpages(struct address_space *ma
 	map_bh.b_state = 0;
 	map_bh.b_size = 0;
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
-		struct page *page = list_entry(pages->prev, struct page, lru);
+		struct page *page = lru_to_page(pages);
 
 		prefetchw(&page->flags);
 		list_del(&page->lru);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-overlayfs-superc-needs-pagemaph.patch
fs-adfs-adfsh-tidy-up-comments.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-fix-kernel-crash-in-khugepaged-thread-fix.patch
numa-fix-proc-pid-numa_maps-on-s390-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch


From: akpm@linux-foundation.org
Subject: [merged] include-linux-mmh-complete-the-mm_walk-definition.patch removed from -mm tree
Date: Wed, 08 May 2013 11:34:25 -0700
Message-ID: <20130508183425.6EDFD5A4251@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:35021 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab3EHSe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:34:26 -0400
Received: by mail-vb0-f74.google.com with SMTP id q16so207674vbe.1
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:34:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave.hansen@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mm.h: complete the mm_walk definition
has been removed from the -mm tree.  Its filename was
     include-linux-mmh-complete-the-mm_walk-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/mm.h: complete the mm_walk definition

That nameless-function-arguments thing drives me batty.  Fix.

Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~include-linux-mmh-complete-the-mm_walk-definition include/linux/mm.h
--- a/include/linux/mm.h~include-linux-mmh-complete-the-mm_walk-definition
+++ a/include/linux/mm.h
@@ -951,13 +951,19 @@ void unmap_vmas(struct mmu_gather *tlb,
  * (see walk_page_range for more details)
  */
 struct mm_walk {
-	int (*pgd_entry)(pgd_t *, unsigned long, unsigned long, struct mm_walk *);
-	int (*pud_entry)(pud_t *, unsigned long, unsigned long, struct mm_walk *);
-	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, struct mm_walk *);
-	int (*pte_entry)(pte_t *, unsigned long, unsigned long, struct mm_walk *);
-	int (*pte_hole)(unsigned long, unsigned long, struct mm_walk *);
-	int (*hugetlb_entry)(pte_t *, unsigned long,
-			     unsigned long, unsigned long, struct mm_walk *);
+	int (*pgd_entry)(pgd_t *pgd, unsigned long addr,
+			 unsigned long next, struct mm_walk *walk);
+	int (*pud_entry)(pud_t *pud, unsigned long addr,
+	                 unsigned long next, struct mm_walk *walk);
+	int (*pmd_entry)(pmd_t *pmd, unsigned long addr,
+			 unsigned long next, struct mm_walk *walk);
+	int (*pte_entry)(pte_t *pte, unsigned long addr,
+			 unsigned long next, struct mm_walk *walk);
+	int (*pte_hole)(unsigned long addr, unsigned long next,
+			struct mm_walk *walk);
+	int (*hugetlb_entry)(pte_t *pte, unsigned long hmask,
+			     unsigned long addr, unsigned long next,
+			     struct mm_walk *walk);
 	struct mm_struct *mm;
 	void *private;
 };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
generic-dynamic-per-cpu-refcounting.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


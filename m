From: akpm@linux-foundation.org
Subject: + mm-compaction-cleanup-isolate_freepages-fix.patch added to -mm
 tree
Date: Mon, 21 Apr 2014 12:41:56 -0700
Message-ID: <53557484.Rks46BJEswRPEXzD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaDUTl6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 15:41:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, sunghwan.yun@samsung.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, d.j.shin@samsung.com, cl@linux.com, b.zolnierkie@samsung.com, akpm@linux-foundation.org

Subject: + mm-compaction-cleanup-isolate_freepages-fix.patch added to -mm tree
To: akpm@linux-foundation.org,b.zolnierkie@samsung.com,cl@linux.com,d.j.shin@samsung.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,sunghwan.yun@samsung.com,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 12:41:56 -0700


The patch titled
     Subject: mm-compaction-cleanup-isolate_freepages-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-cleanup-isolate_freepages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-cleanup-isolate_freepages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-cleanup-isolate_freepages-fix.patch

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
Subject: mm-compaction-cleanup-isolate_freepages-fix

comment fixes, per Minchan

Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-cleanup-isolate_freepages-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-cleanup-isolate_freepages-fix
+++ a/mm/compaction.c
@@ -662,7 +662,10 @@ static void isolate_freepages(struct zon
 				struct compact_control *cc)
 {
 	struct page *page;
-	unsigned long pfn, low_pfn, next_free_pfn, z_end_pfn;
+	unsigned long pfn;	     /* scanning cursor */
+	unsigned long low_pfn;	     /* lowest pfn scanner is able to scan */
+	unsigned long next_free_pfn; /* start pfn for scaning at next round */
+	unsigned long z_end_pfn;     /* zone's end pfn */
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
@@ -679,8 +682,8 @@ static void isolate_freepages(struct zon
 	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
 
 	/*
-	 * Seed the value for max(next_free_pfn, pfn) updates. If there are
-	 * none, the pfn < low_pfn check will kick in.
+	 * Seed the value for max(next_free_pfn, pfn) updates. If no pages are
+	 * isolated, the pfn < low_pfn check will kick in.
 	 */
 	next_free_pfn = 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-gupc-tweaks.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


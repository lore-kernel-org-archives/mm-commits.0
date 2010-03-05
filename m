From: akpm@linux-foundation.org
Subject: [folded] mm-remove-function-free_hot_page-fix.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:16:25 -0800
Message-ID: <201003052116.o25LGPiP028076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462Ab0CEVSc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:18:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, lihong.hi@gmail.com, lwoodman@redhat.com, macli@brc.ubc.ca, mel@csn.ul.ie, mingo@elte.hu, peterz@infradead.org, riel@redhat.


The patch titled
     mm-remove-function-free_hot_page-fix
has been removed from the -mm tree.  Its filename was
     mm-remove-function-free_hot_page-fix.patch

This patch was dropped because it was folded into mm-remove-function-free_hot_page.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-remove-function-free_hot_page-fix
From: Andrew Morton <akpm@linux-foundation.org>

hm, that couldn't possible have worked for you :(

Cc: Americo Wang <xiyou.wangcong@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Li Hong <lihong.hi@gmail.com>
Cc: Li Ming Chun <macli@brc.ubc.ca>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 mm/page_alloc.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~mm-remove-function-free_hot_page-fix include/linux/gfp.h
--- a/include/linux/gfp.h~mm-remove-function-free_hot_page-fix
+++ a/include/linux/gfp.h
@@ -325,7 +325,7 @@ void free_pages_exact(void *virt, size_t
 
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
-extern void free_hot_page(struct page *page);
+extern void free_hot_cold_page(struct page *page, int cold);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr),0)
diff -puN mm/page_alloc.c~mm-remove-function-free_hot_page-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-function-free_hot_page-fix
+++ a/mm/page_alloc.c
@@ -1095,7 +1095,7 @@ void mark_free_pages(struct zone *zone)
  * Free a 0-order page
  * cold == 1 ? free a cold page : free a hot page
  */
-static void free_hot_cold_page(struct page *page, int cold)
+void free_hot_cold_page(struct page *page, int cold)
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-count-swap-usage.patch
vmscan-check-high-watermark-after-shrink-zone.patch
mm-remove-function-free_hot_page.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
gpio-cs5535-gpio-fix-input-direction.patch


From: akpm@linux-foundation.org
Subject: + mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix-2.patch added to -mm tree
Date: Wed, 21 Dec 2011 12:33:40 -0800
Message-ID: <20111221211527.65A8B5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41993 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1LUVPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2011 16:15:30 -0500
Received: by eekc1 with SMTP id c1so246126eek.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2011 13:15:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, mgorman@suse.de, minchan@kernel.org, nai.xia@gmail.com, riel@redhat.com


The patch titled
     Subject: mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix-2
has been added to the -mm tree.  Its filename is
     mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix-2

mm/swap.c: In function 'pagevec_putback_from_immediate_fn':
mm/swap.c:271: error: 'struct zone' has no member named 'lru'
mm/swap.c: In function 'rotate_reclaimable_page':
mm/swap.c:323: error: 'struct zone' has no member named 'lru'
mm/swap.c:331: error: 'struct zone' has no member named 'lru'
mm/swap.c: In function 'lru_deactivate_fn':
mm/swap.c:546: error: 'struct zone' has no member named 'lru'

Fix it against mm-collect-lru-list-heads-into-struct-lruvec.patch

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/swap.c~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix-2 mm/swap.c
--- a/mm/swap.c~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix-2
+++ a/mm/swap.c
@@ -268,7 +268,7 @@ static void pagevec_putback_from_immedia
 
 	if (PageLRU(page)) {
 		enum lru_list lru = page_lru(page);
-		list_move(&page->lru, &zone->lru[lru].list);
+		list_move(&page->lru, &zone->lruvec.lists[lru]);
 	}
 }
 
@@ -285,7 +285,6 @@ static void pagevec_putback_from_immedia
 void rotate_reclaimable_page(struct page *page)
 {
 	struct zone *zone = page_zone(page);
-	struct list_head *list;
 	struct pagevec *pvec;
 	unsigned long flags;
 
@@ -320,7 +319,7 @@ void rotate_reclaimable_page(struct page
 	 */
 	if (!zone_page_state(zone, NR_IMMEDIATE)) {
 		struct page *page;
-		list = &zone->lru[LRU_IMMEDIATE].list;
+		struct list_head *list = &zone->lruvec.lists[LRU_IMMEDIATE];
 
 		if (!list_empty(list)) {
 			spin_lock(&zone->lru_lock);
@@ -328,7 +327,7 @@ void rotate_reclaimable_page(struct page
 				int lru;
 				page = list_entry(list->prev, struct page, lru);
 				lru = page_lru(page);
-				list_move(&page->lru, &zone->lru[lru].list);
+				list_move(&page->lru, &zone->lruvec.lists[lru]);
 				__count_vm_event(PGRESCUED);
 			}
 			spin_unlock(&zone->lru_lock);
@@ -543,7 +542,7 @@ static void lru_deactivate_fn(struct pag
 		 * Move to the LRU_IMMEDIATE list to avoid being scanned
 		 * by page reclaim uselessly.
 		 */
-		list_move_tail(&page->lru, &zone->lru[LRU_IMMEDIATE].list);
+		list_move_tail(&page->lru, &zone->lruvec.lists[LRU_IMMEDIATE]);
 		__mod_zone_page_state(zone, NR_IMMEDIATE, 1);
 	} else {
 		struct lruvec *lruvec;
_
Subject: Subject: mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix-2

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-procfs-do-not-confuse-jiffies-with-cputime64_t.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-checkpatch-fixes.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch
slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-simplify-find_vma_prev-fix.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
leds-add-driver-for-tca6507-led-controller.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix-2.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


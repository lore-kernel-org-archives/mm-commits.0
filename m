From: akpm@linux-foundation.org
Subject: + mm-thp-avoid-unnecessary-swapin-in-khugepaged.patch added to
 -mm tree
Date: Wed, 27 Apr 2016 14:17:20 -0700
Message-ID: <57212c60.fUSE244UFwhXE+az%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbcD0VRW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 17:17:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, boaz@plexistor.com, gorcunov@openvz.org, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: avoid unnecessary swapin in khugepaged
has been added to the -mm tree.  Its filename is
     mm-thp-avoid-unnecessary-swapin-in-khugepaged.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-avoid-unnecessary-swapin-in-khugepaged.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-avoid-unnecessary-swapin-in-khugepaged.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Subject: mm, thp: avoid unnecessary swapin in khugepaged

Currently khugepaged makes swapin readahead to improve THP collapse rate. 
This patch checks vm statistics to avoid workload of swapin, if
unnecessary.  So that when system under pressure, khugepaged won't consume
resources to swapin and won't trigger direct reclaim when swapin
readahead.

The patch was tested with a test program that allocates 800MB of memory,
writes to it, and then sleeps.  The system was forced to swap out all. 
Afterwards, the test program touches the area by writing, it skips a page
in each 20 pages of the area.  When waiting to swapin readahead left part
of the test, the memory forced to be busy doing page reclaim.  There was
enough free memory during test, khugepaged did not swapin readahead due to
business.

Test results:

                        After swapped out
-------------------------------------------------------------------
              | Anonymous | AnonHugePages | Swap      | Fraction  |
-------------------------------------------------------------------
With patch    | 0 kB      |  0 kB         | 800000 kB |    %100   |
-------------------------------------------------------------------
Without patch | 0 kB      |  0 kB         | 800000 kB |    %100   |
-------------------------------------------------------------------

                        After swapped in
-------------------------------------------------------------------
              | Anonymous | AnonHugePages | Swap      | Fraction  |
-------------------------------------------------------------------
With patch    | 385120 kB | 102400 kB     | 414880 kB |    %26    |
-------------------------------------------------------------------
Without patch | 389728 kB | 194560 kB     | 410272 kB |    %49    |
-------------------------------------------------------------------

Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Boaz Harrosh <boaz@plexistor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-avoid-unnecessary-swapin-in-khugepaged mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-avoid-unnecessary-swapin-in-khugepaged
+++ a/mm/huge_memory.c
@@ -102,6 +102,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepage
  */
 static unsigned int khugepaged_max_ptes_none __read_mostly;
 static unsigned int khugepaged_max_ptes_swap __read_mostly = HPAGE_PMD_NR/8;
+static unsigned long allocstall;
 
 static int khugepaged(void *none);
 static int khugepaged_slab_init(void);
@@ -2429,7 +2430,7 @@ static void collapse_huge_page(struct mm
 	struct page *new_page;
 	spinlock_t *pmd_ptl, *pte_ptl;
 	int isolated = 0, result = 0;
-	unsigned long hstart, hend;
+	unsigned long hstart, hend, swap, curr_allocstall;
 	struct mem_cgroup *memcg;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
@@ -2484,7 +2485,14 @@ static void collapse_huge_page(struct mm
 		goto out;
 	}
 
-	__collapse_huge_page_swapin(mm, vma, address, pmd);
+	swap = get_mm_counter(mm, MM_SWAPENTS);
+	curr_allocstall = sum_vm_event(ALLOCSTALL);
+	/*
+	 * When system under pressure, don't swapin readahead.
+	 * So that avoid unnecessary resource consuming.
+	 */
+	if (allocstall == curr_allocstall && swap != 0)
+		__collapse_huge_page_swapin(mm, vma, address, pmd);
 
 	anon_vma_lock_write(vma->anon_vma);
 
@@ -2878,14 +2886,17 @@ static void khugepaged_wait_work(void)
 		if (!khugepaged_scan_sleep_millisecs)
 			return;
 
+		allocstall = sum_vm_event(ALLOCSTALL);
 		wait_event_freezable_timeout(khugepaged_wait,
 					     kthread_should_stop(),
 			msecs_to_jiffies(khugepaged_scan_sleep_millisecs));
 		return;
 	}
 
-	if (khugepaged_enabled())
+	if (khugepaged_enabled()) {
+		allocstall = sum_vm_event(ALLOCSTALL);
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
+	}
 }
 
 static int khugepaged(void *none)
@@ -2894,6 +2905,7 @@ static int khugepaged(void *none)
 
 	set_freezable();
 	set_user_nice(current, MAX_NICE);
+	allocstall = sum_vm_event(ALLOCSTALL);
 
 	while (!kthread_should_stop()) {
 		khugepaged_do_scan();
_

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are

mm-make-optimistic-check-for-swapin-readahead.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch
mm-vmstat-calculate-particular-vm-event.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged.patch


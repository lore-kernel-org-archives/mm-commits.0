From: akpm@linux-foundation.org
Subject: [merged] mm-free-swp_entry-in-madvise_free.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:12:34 -0800
Message-ID: <569e98b2.CvB1d+pOar4XQYRH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbcASUMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:12:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aarcange@redhat.com, arnd@arndb.de, benh@kernel.crashing.org, catalin.marinas@arm.com, chris@zankel.net, danielmicay@gmail.com, darrick.wong@oracle.com, davem@davemloft.net, deller@gmx.de, fengguang.wu@intel.com, gang.chen.5i5j@gmail.com, hannes@cmpxchg.org, hughd@google.com, ink@jurassic.park.msu.ru, jcmvbkbc@gmail.com, je@fb.com, jejb@parisc-linux.org, kirill@shutemov.name, kosaki.motohiro@jp.fujitsu.com, luto@amacapital.net, mattst88@gmail.com, mgorman@suse.de, mhocko@suse.com, mika.penttila@nextfour.com, mtk.manpages@gmail.com, ralf@linux-mips.org, riel@redhat.com, rmk@arm.linux.org.uk, roland@kernel.org, rth@twiddle.net, shli@kernel.org, will.deacon@arm.com, yalin.wang2010@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise.c: free swp_entry in madvise_free
has been removed from the -mm tree.  Its filename was
     mm-free-swp_entry-in-madvise_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm/madvise.c: free swp_entry in madvise_free

When I test below piece of code with 12 processes(ie, 512M * 12 = 6G
consume) on my (3G ram + 12 cpu + 8G swap, the madvise_free is siginficat
slower (ie, 2x times) than madvise_dontneed.

loop = 5;
mmap(512M);
while (loop--) {
        memset(512M);
        madvise(MADV_FREE or MADV_DONTNEED);
}

The reason is lots of swapin.

1) dontneed: 1,612 swapin
2) madvfree: 879,585 swapin

If we find hinted pages were already swapped out when syscall is called,
it's pointless to keep the swapped-out pages in pte.  Instead, let's free
the cold page because swapin is more expensive than (alloc page +
zeroing).

With this patch, it reduced swapin from 879,585 to 1,878 so elapsed time

1) dontneed: 6.10user 233.50system 0:50.44elapsed
2) madvfree: 6.03user 401.17system 1:30.67elapsed
2) madvfree + below patch: 6.70user 339.14system 1:04.45elapsed

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Shaohua Li <shli@kernel.org>
Cc: <yalin.wang2010@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jason Evans <je@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Mika Penttil <mika.penttila@nextfour.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Shaohua Li <shli@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff -puN mm/madvise.c~mm-free-swp_entry-in-madvise_free mm/madvise.c
--- a/mm/madvise.c~mm-free-swp_entry-in-madvise_free
+++ a/mm/madvise.c
@@ -270,6 +270,7 @@ static int madvise_free_pte_range(pmd_t
 	spinlock_t *ptl;
 	pte_t *orig_pte, *pte, ptent;
 	struct page *page;
+	int nr_swap = 0;
 
 	split_huge_pmd(vma, pmd, addr);
 	if (pmd_trans_unstable(pmd))
@@ -280,8 +281,24 @@ static int madvise_free_pte_range(pmd_t
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = *pte;
 
-		if (!pte_present(ptent))
+		if (pte_none(ptent))
 			continue;
+		/*
+		 * If the pte has swp_entry, just clear page table to
+		 * prevent swap-in which is more expensive rather than
+		 * (page allocation + zeroing).
+		 */
+		if (!pte_present(ptent)) {
+			swp_entry_t entry;
+
+			entry = pte_to_swp_entry(ptent);
+			if (non_swap_entry(entry))
+				continue;
+			nr_swap--;
+			free_swap_and_cache(entry);
+			pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+			continue;
+		}
 
 		page = vm_normal_page(vma, addr, ptent);
 		if (!page)
@@ -355,6 +372,12 @@ static int madvise_free_pte_range(pmd_t
 		}
 	}
 out:
+	if (nr_swap) {
+		if (current->mm == mm)
+			sync_mm_rss(mm);
+
+		add_mm_counter(mm, MM_SWAPENTS, nr_swap);
+	}
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(orig_pte, ptl);
 	cond_resched();
_

Patches currently in -mm which might be from minchan@kernel.org are



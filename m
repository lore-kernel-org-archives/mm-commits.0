From: akpm@linux-foundation.org
Subject: + mm-proc-add-workaround-for-old-compilers.patch added to -mm
 tree
Date: Tue, 19 Jan 2016 15:14:24 -0800
Message-ID: <569ec350.dfbjdy088CyogVYj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197AbcASXOY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 18:14:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: add workaround for old compilers
has been added to the -mm tree.  Its filename is
     mm-proc-add-workaround-for-old-compilers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-proc-add-workaround-for-old-compilers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-proc-add-workaround-for-old-compilers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: fs/proc/task_mmu.c: add workaround for old compilers

For THP=n, HPAGE_PMD_NR in smaps_account() expands to BUILD_BUG().  That's
fine since this codepath is eliminated by modern compilers.

But older compilers have not that efficient dead code elimination.  It
causes problem at least with gcc 4.1.2 on m68k:

   fs/built-in.o: In function `smaps_account':
   task_mmu.c:(.text+0x4f8fa): undefined reference to `__compiletime_assert_471'

Let's replace HPAGE_PMD_NR with 1 << compound_order(page).

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~mm-proc-add-workaround-for-old-compilers fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-proc-add-workaround-for-old-compilers
+++ a/fs/proc/task_mmu.c
@@ -468,7 +468,7 @@ struct mem_size_stats {
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		bool compound, bool young, bool dirty)
 {
-	int i, nr = compound ? HPAGE_PMD_NR : 1;
+	int i, nr = compound ? 1 << compound_order(page) : 1;
 	unsigned long size = nr * PAGE_SIZE;
 
 	if (PageAnon(page))
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-softirq-safe-softirq-unsafe-lock-order-detected-in-split_huge_page_to_list.patch
mm-proc-add-workaround-for-old-compilers.patch
thp-change-pmd_trans_huge_lock-interface-to-return-ptl.patch
mlocked-pages-statistics-shows-bogus-value.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch


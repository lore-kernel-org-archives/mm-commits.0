From: akpm@linux-foundation.org
Subject: [folded-merged] mm-support-madvisemadv_free-fix-6.patch removed
 from -mm tree
Date: Mon, 02 Nov 2015 14:49:41 -0800
Message-ID: <5637e885.pJyECRywt6Ja5pWw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbbKBWtm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 17:49:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clear PG_dirty to mark page freeable
has been removed from the -mm tree.  Its filename was
     mm-support-madvisemadv_free-fix-6.patch

This patch was dropped because it was folded into mm-support-madvisemadv_free.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: clear PG_dirty to mark page freeable

Basically, MADV_FREE relies on dirty bit in page table entry to decide
whether VM allows to discard the page or not.  IOW, if page table entry
includes marked dirty bit, VM shouldn't discard the page.

However, as a example, if swap-in by read fault happens, page table entry
doesn't have dirty bit so MADV_FREE could discard the page wrongly.

For avoiding the problem, MADV_FREE did more checks with PageDirty
and PageSwapCache. It worked out because swapped-in page lives on
swap cache and since it is evicted from the swap cache, the page has
PG_dirty flag. So both page flags check effectively prevent
wrong discarding by MADV_FREE.

However, a problem in above logic is that swapped-in page has
PG_dirty still after they are removed from swap cache so VM cannot
consider the page as freeable any more even if madvise_free is
called in future.

Look at below example for detail.

    ptr = malloc();
    memset(ptr);
    ..
    ..
    .. heavy memory pressure so all of pages are swapped out
    ..
    ..
    var = *ptr; -> a page swapped-in and could be removed from
                   swapcache. Then, page table doesn't mark
                   dirty bit and page descriptor includes PG_dirty
    ..
    ..
    madvise_free(ptr); -> It doesn't clear PG_dirty of the page.
    ..
    ..
    ..
    .. heavy memory pressure again.
    .. In this time, VM cannot discard the page because the page
    .. has *PG_dirty*

To solve the problem, this patch clears PG_dirty if only the page is owned
exclusively by current process when madvise is called because PG_dirty
represents ptes's dirtiness in several processes so we could clear it only
if we own it exclusively.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/madvise.c~mm-support-madvisemadv_free-fix-6 mm/madvise.c
--- a/mm/madvise.c~mm-support-madvisemadv_free-fix-6
+++ a/mm/madvise.c
@@ -287,11 +287,19 @@ static int madvise_free_pte_range(pmd_t
 		if (!page)
 			continue;
 
-		if (PageSwapCache(page)) {
+		if (PageSwapCache(page) || PageDirty(page)) {
 			if (!trylock_page(page))
 				continue;
+			/*
+			 * If page is shared with others, we couldn't clear
+			 * PG_dirty of the page.
+			 */
+			if (page_count(page) != 1 + !!PageSwapCache(page)) {
+				unlock_page(page);
+				continue;
+			}
 
-			if (!try_to_free_swap(page)) {
+			if (PageSwapCache(page) && !try_to_free_swap(page)) {
 				unlock_page(page);
 				continue;
 			}
_

Patches currently in -mm which might be from minchan@kernel.org are

x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-mark-stable-page-dirty-in-ksm.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-5.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-6.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch


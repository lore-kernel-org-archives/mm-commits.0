From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-swapfilec-fix-nr_good_pages-calculation.patch removed from -mm tree
Date: Mon, 01 Feb 2010 13:17:09 -0800
Message-ID: <201002012117.o11LH996012904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754680Ab0BAVRV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 16:17:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkko.lavinen@nokia.com, hugh.dickins@tiscali.co.uk, mm-commits@vger.kernel.org


The patch titled
     mm/swapfile.c: fix nr_good_pages calculation
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-fix-nr_good_pages-calculation.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/swapfile.c: fix nr_good_pages calculation
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

On x86 example machine A, swap partition is 15631245 kB.  /proc/swaps says
the swap space is 15631236 KB, 9 KB less than the partition size or two
page difference.  One page for the swap header, and the other for what?

On another x86 macine B, swap partition is 409626 KB, /proc/swaps says it
is 409616 KB, 10 KB difference or two pages and alignment bytes.  Again I
can understand the need for one header page, but not two.

However swapon system call intends to use all the space available except
the header.  This can be seen from swap_map allocation:

  SYSCALL_DEFINE2(swapon, ...
        ...			
	maxpages = swp_offset(pte_to_swp_entry(
			swp_entry_to_pte(swp_entry(0, ~0UL)))) - 1;
	if (maxpages > swap_header->info.last_page)
		maxpages = swap_header->info.last_page;
	p->highest_bit = maxpages - 1;
	...
	swap_map = vmalloc(maxpages);

This way the swap_map has entries for the whole swap space
except for the header.

Then the nr_good_pages could be calculated with:

-	nr_good_pages = swap_header->info.last_page -
-			swap_header->info.nr_badpages -
-			1 /* header page */;
+	nr_good_pages = maxpages - swap_header->info.nr_badpages;

This change corrects the last swap file page never used problem.  If the
last_page is ever greater than maxpages, this would also avoid setting
nr_good_pages to too large value.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-swapfilec-fix-nr_good_pages-calculation mm/swapfile.c
--- a/mm/swapfile.c~mm-swapfilec-fix-nr_good_pages-calculation
+++ a/mm/swapfile.c
@@ -1966,7 +1966,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	if (error)
 		goto bad_swap;
 
-	nr_good_pages = swap_header->info.last_page -
+	nr_good_pages = swap_header->info.last_page + 1 -
 			swap_header->info.nr_badpages -
 			1 /* header page */;
 
_

Patches currently in -mm which might be from jarkko.lavinen@nokia.com are

mm-swapfilec-fix-nr_good_pages-calculation.patch


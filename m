From: akpm@linux-foundation.org
Subject: [merged] mm-swapfilec-fix-swapon-size-off-by-one.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:19 -0800
Message-ID: <201003091904.o29J4JdI031035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755613Ab0CITE6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:04:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, jarkko.lavinen@nokia.com, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     mm/swapfile.c: fix swapon size off-by-one
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-fix-swapon-size-off-by-one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/swapfile.c: fix swapon size off-by-one
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

There's an off-by-one disagreement between mkswap and swapon about the
meaning of swap_header last_page: mkswap (in all versions I've looked at:
util-linux-ng and BusyBox and old util-linux; probably as far back as
1999) consistently means the offset (in page units) of the last page of
the swap area, whereas kernel sys_swapon (as far back as 2.2 and 2.3)
strangely takes it to mean the size (in page units) of the swap area.

This disagreement is the safe way round; but it's worrying people, and
loses us one page of swap.

The fix is not just to add one to nr_good_pages: we need to get maxpages
(the size of the swap_map array) right before that; and though that is an
unsigned long, be careful not to overflow the unsigned int p->max which
later holds it (probably why header uses __u32 last_page instead of size).

Why did we subtract one from the maximum swp_offset to calculate maxpages?
 Though it was probably me who made that change in 2.4.10, I don't get it:
and now we should be adding one (without risk of overflow in this case).

Fix the handling of swap_header badpages: it could have overrun the
swap_map when very large swap area used on a more limited architecture.

Remove pre-initializations of swap_header, nr_good_pages and maxpages:
those date from when sys_swapon was supporting other versions of header.

Reported-by: Nitin Gupta <ngupta@vflare.org>
Reported-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff -puN mm/swapfile.c~mm-swapfilec-fix-swapon-size-off-by-one mm/swapfile.c
--- a/mm/swapfile.c~mm-swapfilec-fix-swapon-size-off-by-one
+++ a/mm/swapfile.c
@@ -1760,11 +1760,11 @@ SYSCALL_DEFINE2(swapon, const char __use
 	unsigned int type;
 	int i, prev;
 	int error;
-	union swap_header *swap_header = NULL;
-	unsigned int nr_good_pages = 0;
+	union swap_header *swap_header;
+	unsigned int nr_good_pages;
 	int nr_extents = 0;
 	sector_t span;
-	unsigned long maxpages = 1;
+	unsigned long maxpages;
 	unsigned long swapfilepages;
 	unsigned char *swap_map = NULL;
 	struct page *page = NULL;
@@ -1923,9 +1923,13 @@ SYSCALL_DEFINE2(swapon, const char __use
 	 * swap pte.
 	 */
 	maxpages = swp_offset(pte_to_swp_entry(
-			swp_entry_to_pte(swp_entry(0, ~0UL)))) - 1;
-	if (maxpages > swap_header->info.last_page)
-		maxpages = swap_header->info.last_page;
+			swp_entry_to_pte(swp_entry(0, ~0UL)))) + 1;
+	if (maxpages > swap_header->info.last_page) {
+		maxpages = swap_header->info.last_page + 1;
+		/* p->max is an unsigned int: don't overflow it */
+		if ((unsigned int)maxpages == 0)
+			maxpages = UINT_MAX;
+	}
 	p->highest_bit = maxpages - 1;
 
 	error = -EINVAL;
@@ -1949,23 +1953,24 @@ SYSCALL_DEFINE2(swapon, const char __use
 	}
 
 	memset(swap_map, 0, maxpages);
+	nr_good_pages = maxpages - 1;	/* omit header page */
+
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
-		int page_nr = swap_header->info.badpages[i];
-		if (page_nr <= 0 || page_nr >= swap_header->info.last_page) {
+		unsigned int page_nr = swap_header->info.badpages[i];
+		if (page_nr == 0 || page_nr > swap_header->info.last_page) {
 			error = -EINVAL;
 			goto bad_swap;
 		}
-		swap_map[page_nr] = SWAP_MAP_BAD;
+		if (page_nr < maxpages) {
+			swap_map[page_nr] = SWAP_MAP_BAD;
+			nr_good_pages--;
+		}
 	}
 
 	error = swap_cgroup_swapon(type, maxpages);
 	if (error)
 		goto bad_swap;
 
-	nr_good_pages = swap_header->info.last_page -
-			swap_header->info.nr_badpages -
-			1 /* header page */;

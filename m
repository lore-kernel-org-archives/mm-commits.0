From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-separate-parsing-of-swapfile-header.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:42 -0700
Message-ID: <201103232041.p2NKfIvd028627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933346Ab1CWUzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: separate parsing of swapfile header
has been removed from the -mm tree.  Its filename was
     sys_swapon-separate-parsing-of-swapfile-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: separate parsing of swapfile header
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Move the code which parses and checks the swapfile header (except for
the bad block list) to a separate function. Only code movement, no
functional changes.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |  140 ++++++++++++++++++++++++++----------------------
 1 file changed, 78 insertions(+), 62 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-separate-parsing-of-swapfile-header mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-separate-parsing-of-swapfile-header
+++ a/mm/swapfile.c
@@ -1918,6 +1918,82 @@ static int claim_swapfile(struct swap_in
 	return 0;
 }
 
+static unsigned long read_swap_header(struct swap_info_struct *p,
+					union swap_header *swap_header,
+					struct inode *inode)
+{
+	int i;
+	unsigned long maxpages;
+	unsigned long swapfilepages;
+
+	if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
+		printk(KERN_ERR "Unable to find swap-space signature\n");
+		goto bad_swap;
+	}
+
+	/* swap partition endianess hack... */
+	if (swab32(swap_header->info.version) == 1) {
+		swab32s(&swap_header->info.version);
+		swab32s(&swap_header->info.last_page);
+		swab32s(&swap_header->info.nr_badpages);
+		for (i = 0; i < swap_header->info.nr_badpages; i++)
+			swab32s(&swap_header->info.badpages[i]);
+	}
+	/* Check the swap header's sub-version */
+	if (swap_header->info.version != 1) {
+		printk(KERN_WARNING
+		       "Unable to handle swap header version %d\n",
+		       swap_header->info.version);
+		goto bad_swap;
+	}
+
+	p->lowest_bit  = 1;
+	p->cluster_next = 1;
+	p->cluster_nr = 0;
+
+	/*
+	 * Find out how many pages are allowed for a single swap
+	 * device. There are two limiting factors: 1) the number of
+	 * bits for the swap offset in the swp_entry_t type and
+	 * 2) the number of bits in the a swap pte as defined by
+	 * the different architectures. In order to find the
+	 * largest possible bit mask a swap entry with swap type 0
+	 * and swap offset ~0UL is created, encoded to a swap pte,
+	 * decoded to a swp_entry_t again and finally the swap
+	 * offset is extracted. This will mask all the bits from
+	 * the initial ~0UL mask that can't be encoded in either
+	 * the swp_entry_t or the architecture definition of a
+	 * swap pte.
+	 */
+	maxpages = swp_offset(pte_to_swp_entry(
+			swp_entry_to_pte(swp_entry(0, ~0UL)))) + 1;
+	if (maxpages > swap_header->info.last_page) {
+		maxpages = swap_header->info.last_page + 1;
+		/* p->max is an unsigned int: don't overflow it */
+		if ((unsigned int)maxpages == 0)
+			maxpages = UINT_MAX;
+	}
+	p->highest_bit = maxpages - 1;
+
+	if (!maxpages)
+		goto bad_swap;
+	swapfilepages = i_size_read(inode) >> PAGE_SHIFT;
+	if (swapfilepages && maxpages > swapfilepages) {
+		printk(KERN_WARNING
+		       "Swap area shorter than signature indicates\n");
+		goto bad_swap;
+	}
+	if (swap_header->info.nr_badpages && S_ISREG(inode->i_mode))
+		goto bad_swap;
+	if (swap_header->info.nr_badpages > MAX_SWAP_BADPAGES)
+		goto bad_swap;
+
+	return maxpages;
+
+bad_swap:
+	return 0;
+}
+
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct *p;
@@ -1931,7 +2007,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 	int nr_extents = 0;
 	sector_t span;
 	unsigned long maxpages;
-	unsigned long swapfilepages;
 	unsigned char *swap_map = NULL;
 	struct page *page = NULL;
 	struct inode *inode = NULL;
@@ -1989,71 +2064,12 @@ SYSCALL_DEFINE2(swapon, const char __use
 	}
 	swap_header = kmap(page);
 
-	if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
-		printk(KERN_ERR "Unable to find swap-space signature\n");
+	maxpages = read_swap_header(p, swap_header, inode);
+	if (unlikely(!maxpages)) {
 		error = -EINVAL;
 		goto bad_swap;
 	}
 
-	/* swap partition endianess hack... */
-	if (swab32(swap_header->info.version) == 1) {
-		swab32s(&swap_header->info.version);
-		swab32s(&swap_header->info.last_page);
-		swab32s(&swap_header->info.nr_badpages);
-		for (i = 0; i < swap_header->info.nr_badpages; i++)
-			swab32s(&swap_header->info.badpages[i]);
-	}
-	/* Check the swap header's sub-version */
-	if (swap_header->info.version != 1) {
-		printk(KERN_WARNING
-		       "Unable to handle swap header version %d\n",
-		       swap_header->info.version);
-		error = -EINVAL;
-		goto bad_swap;
-	}
-
-	p->lowest_bit  = 1;
-	p->cluster_next = 1;
-	p->cluster_nr = 0;
-
-	/*
-	 * Find out how many pages are allowed for a single swap
-	 * device. There are two limiting factors: 1) the number of
-	 * bits for the swap offset in the swp_entry_t type and
-	 * 2) the number of bits in the a swap pte as defined by
-	 * the different architectures. In order to find the
-	 * largest possible bit mask a swap entry with swap type 0
-	 * and swap offset ~0UL is created, encoded to a swap pte,
-	 * decoded to a swp_entry_t again and finally the swap
-	 * offset is extracted. This will mask all the bits from
-	 * the initial ~0UL mask that can't be encoded in either
-	 * the swp_entry_t or the architecture definition of a
-	 * swap pte.
-	 */
-	maxpages = swp_offset(pte_to_swp_entry(
-			swp_entry_to_pte(swp_entry(0, ~0UL)))) + 1;
-	if (maxpages > swap_header->info.last_page) {
-		maxpages = swap_header->info.last_page + 1;
-		/* p->max is an unsigned int: don't overflow it */
-		if ((unsigned int)maxpages == 0)
-			maxpages = UINT_MAX;
-	}
-	p->highest_bit = maxpages - 1;
-
-	error = -EINVAL;
-	if (!maxpages)
-		goto bad_swap;
-	swapfilepages = i_size_read(inode) >> PAGE_SHIFT;
-	if (swapfilepages && maxpages > swapfilepages) {
-		printk(KERN_WARNING
-		       "Swap area shorter than signature indicates\n");
-		goto bad_swap;
-	}
-	if (swap_header->info.nr_badpages && S_ISREG(inode->i_mode))
-		goto bad_swap;
-	if (swap_header->info.nr_badpages > MAX_SWAP_BADPAGES)
-		goto bad_swap;

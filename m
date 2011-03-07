From: akpm@linux-foundation.org
Subject: + sys_swapon-separate-parsing-of-bad-blocks-and-extents.patch added to -mm tree
Date: Mon, 07 Mar 2011 14:10:24 -0800
Message-ID: <201103072210.p27MAPMu030034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756444Ab1CGWLW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 17:11:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org


The patch titled
     sys_swapon: separate parsing of bad blocks and extents
has been added to the -mm tree.  Its filename is
     sys_swapon-separate-parsing-of-bad-blocks-and-extents.patch

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
Subject: sys_swapon: separate parsing of bad blocks and extents
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Move the code which parses the bad block list and the extents to a
separate function. Only code movement, no functional changes.

This change uses the fact that, after the success path, nr_good_pages ==
p->pages.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   83 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 29 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-separate-parsing-of-bad-blocks-and-extents mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-separate-parsing-of-bad-blocks-and-extents
+++ a/mm/swapfile.c
@@ -1991,6 +1991,54 @@ static unsigned long read_swap_header(st
 	return maxpages;
 }
 
+static int setup_swap_map_and_extents(struct swap_info_struct *p,
+					union swap_header *swap_header,
+					unsigned char *swap_map,
+					unsigned long maxpages,
+					sector_t *span)
+{
+	int i;
+	int error;
+	unsigned int nr_good_pages;
+	int nr_extents;
+
+	nr_good_pages = maxpages - 1;	/* omit header page */
+
+	for (i = 0; i < swap_header->info.nr_badpages; i++) {
+		unsigned int page_nr = swap_header->info.badpages[i];
+		if (page_nr == 0 || page_nr > swap_header->info.last_page) {
+			error = -EINVAL;
+			goto bad_swap;
+		}
+		if (page_nr < maxpages) {
+			swap_map[page_nr] = SWAP_MAP_BAD;
+			nr_good_pages--;
+		}
+	}
+
+	if (nr_good_pages) {
+		swap_map[0] = SWAP_MAP_BAD;
+		p->max = maxpages;
+		p->pages = nr_good_pages;
+		nr_extents = setup_swap_extents(p, span);
+		if (nr_extents < 0) {
+			error = nr_extents;
+			goto bad_swap;
+		}
+		nr_good_pages = p->pages;
+	}
+	if (!nr_good_pages) {
+		printk(KERN_WARNING "Empty swap-file\n");
+		error = -EINVAL;
+		goto bad_swap;
+	}
+
+	return nr_extents;
+
+bad_swap:
+	return error;
+}
+
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct *p;
@@ -2001,7 +2049,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	int error;
 	union swap_header *swap_header;
 	unsigned int nr_good_pages;
-	int nr_extents = 0;
+	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
 	unsigned char *swap_map = NULL;
@@ -2078,36 +2126,13 @@ SYSCALL_DEFINE2(swapon, const char __use
 	if (error)
 		goto bad_swap;
 
-	nr_good_pages = maxpages - 1;	/* omit header page */
-
-	for (i = 0; i < swap_header->info.nr_badpages; i++) {
-		unsigned int page_nr = swap_header->info.badpages[i];
-		if (page_nr == 0 || page_nr > swap_header->info.last_page) {
-			error = -EINVAL;
-			goto bad_swap;
-		}
-		if (page_nr < maxpages) {
-			swap_map[page_nr] = SWAP_MAP_BAD;
-			nr_good_pages--;
-		}
-	}
-
-	if (nr_good_pages) {
-		swap_map[0] = SWAP_MAP_BAD;
-		p->max = maxpages;
-		p->pages = nr_good_pages;
-		nr_extents = setup_swap_extents(p, &span);
-		if (nr_extents < 0) {
-			error = nr_extents;
-			goto bad_swap;
-		}
-		nr_good_pages = p->pages;
-	}
-	if (!nr_good_pages) {
-		printk(KERN_WARNING "Empty swap-file\n");
-		error = -EINVAL;
+	nr_extents = setup_swap_map_and_extents(p, swap_header, swap_map,
+		maxpages, &span);
+	if (unlikely(nr_extents < 0)) {
+		error = nr_extents;
 		goto bad_swap;
 	}
+	nr_good_pages = p->pages;
 
 	if (p->bdev) {
 		if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
_

Patches currently in -mm which might be from cesarb@cesarb.net are

sys_swapon-use-vzalloc-instead-of-vmalloc-memset.patch
sys_swapon-remove-changelog-from-function-comment.patch
sys_swapon-do-not-depend-on-type-after-allocation.patch
sys_swapon-separate-swap_info-allocation.patch
sys_swapon-simplify-error-return-from-swap_info-allocation.patch
sys_swapon-simplify-error-flow-in-alloc_swap_info.patch
sys_swapon-remove-initial-value-of-name-variable.patch
sys_swapon-move-setting-of-error-nearer-use.patch
sys_swapon-remove-did_down-variable.patch
sys_swapon-remove-bdev-variable.patch
sys_swapon-do-only-cleanup-in-the-cleanup-blocks.patch
sys_swapon-use-a-single-error-label.patch
sys_swapon-separate-bdev-claim-and-inode-lock.patch
sys_swapon-simplify-error-flow-in-claim_swapfile.patch
sys_swapon-move-setting-of-swapfilepages-near-use.patch
sys_swapon-separate-parsing-of-swapfile-header.patch
sys_swapon-simplify-error-flow-in-read_swap_header.patch
sys_swapon-call-swap_cgroup_swapon-earlier.patch
sys_swapon-separate-parsing-of-bad-blocks-and-extents.patch
sys_swapon-simplify-error-flow-in-setup_swap_map_and_extents.patch
sys_swapon-remove-nr_good_pages-variable.patch
sys_swapon-move-printk-outside-lock.patch
sys_swapoff-change-order-to-match-sys_swapon.patch
sys_swapon-separate-final-enabling-of-the-swapfile.patch


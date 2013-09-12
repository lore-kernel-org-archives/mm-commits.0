From: akpm@linux-foundation.org
Subject: [merged]
 swap-warn-when-a-swap-area-overflows-the-maximum-size.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:42:15 -0700
Message-ID: <52321917.QvNuE/volozcQYjL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3ILTmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, valdis.kletnieks@vt.edu, riel@redhat.com, hughd@google.com, shentino@gmail.com

Subject: [merged] swap-warn-when-a-swap-area-overflows-the-maximum-size.patch removed from -mm tree
To: shentino@gmail.com,hughd@google.com,riel@redhat.com,valdis.kletnieks@vt.edu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:15 -0700


The patch titled
     Subject: swap: warn when a swap area overflows the maximum size
has been removed from the -mm tree.  Its filename was
     swap-warn-when-a-swap-area-overflows-the-maximum-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Raymond Jennings <shentino@gmail.com>
Subject: swap: warn when a swap area overflows the maximum size

It is possible to swapon a swap area that is too big for the pte width
to handle.

Presently this failure happens silently.

Instead, emit a diagnostic to warn the user.

Testing results, root prompt commands and kernel log messages:

# lvresize /dev/system/swap --size 16G
# mkswap /dev/system/swap
# swapon /dev/system/swap

Jul  7 04:27:22 warfang kernel: Adding 16777212k swap
on /dev/mapper/system-swap.  Priority:-1 extents:1 across:16777212k 

# lvresize /dev/system/swap --size 64G
# mkswap /dev/system/swap
# swapon /dev/system/swap

Jul  7 04:27:22 warfang kernel: Truncating oversized swap area, only
using 33554432k out of 67108860k
Jul  7 04:27:22 warfang kernel: Adding 33554428k swap
on /dev/mapper/system-swap.  Priority:-1 extents:1 across:33554428k 

[akpm@linux-foundation.org: fix warning]
Signed-off-by: Raymond Jennings <shentino@gmail.com>
Acked-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/swapfile.c~swap-warn-when-a-swap-area-overflows-the-maximum-size mm/swapfile.c
--- a/mm/swapfile.c~swap-warn-when-a-swap-area-overflows-the-maximum-size
+++ a/mm/swapfile.c
@@ -1926,6 +1926,7 @@ static unsigned long read_swap_header(st
 	int i;
 	unsigned long maxpages;
 	unsigned long swapfilepages;
+	unsigned long last_page;
 
 	if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
 		printk(KERN_ERR "Unable to find swap-space signature\n");
@@ -1968,8 +1969,15 @@ static unsigned long read_swap_header(st
 	 */
 	maxpages = swp_offset(pte_to_swp_entry(
 			swp_entry_to_pte(swp_entry(0, ~0UL)))) + 1;
-	if (maxpages > swap_header->info.last_page) {
-		maxpages = swap_header->info.last_page + 1;
+	last_page = swap_header->info.last_page;
+	if (last_page > maxpages) {
+		printk(KERN_WARNING
+			"Truncating oversized swap area, only using %luk out of %luk\n",
+			maxpages << (PAGE_SHIFT - 10),
+			last_page << (PAGE_SHIFT - 10));
+	}
+	if (maxpages > last_page) {
+		maxpages = last_page + 1;
 		/* p->max is an unsigned int: don't overflow it */
 		if ((unsigned int)maxpages == 0)
 			maxpages = UINT_MAX;
_

Patches currently in -mm which might be from shentino@gmail.com are

origin.patch


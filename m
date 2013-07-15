From: akpm@linux-foundation.org
Subject: + swap-warn-when-a-swap-area-overflows-the-maximum-size.patch
 added to -mm tree
Date: Mon, 15 Jul 2013 14:06:35 -0700
Message-ID: <51e4645b.nQknfGyAOepndZt2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3GOVGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Jul 2013 17:06:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, valdis.kletnieks@vt.edu, hughd@google.com, shentino@gmail.com

Subject: + swap-warn-when-a-swap-area-overflows-the-maximum-size.patch added to -mm tree
To: shentino@gmail.com,hughd@google.com,valdis.kletnieks@vt.edu
From: akpm@linux-foundation.org
Date: Mon, 15 Jul 2013 14:06:35 -0700


The patch titled
     Subject: swap: warn when a swap area overflows the maximum size
has been added to the -mm tree.  Its filename is
     swap-warn-when-a-swap-area-overflows-the-maximum-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap-warn-when-a-swap-area-overflows-the-maximum-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap-warn-when-a-swap-area-overflows-the-maximum-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

# lvresize /dev/system/swap --size 16G
# mkswap /dev/system/swap
# swapon /dev/system/swap

Jul  7 04:27:22 warfang kernel: Truncating oversized swap area, only
using 33554432k out of 67108860k
Jul  7 04:27:22 warfang kernel: Adding 33554428k swap
on /dev/mapper/system-swap.  Priority:-1 extents:1 across:33554428k 

Signed-off-by: Raymond Jennings <shentino@gmail.com>
Acked-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/swapfile.c~swap-warn-when-a-swap-area-overflows-the-maximum-size mm/swapfile.c
--- a/mm/swapfile.c~swap-warn-when-a-swap-area-overflows-the-maximum-size
+++ a/mm/swapfile.c
@@ -1953,6 +1953,12 @@ static unsigned long read_swap_header(st
 	 */
 	maxpages = swp_offset(pte_to_swp_entry(
 			swp_entry_to_pte(swp_entry(0, ~0UL)))) + 1;
+	if (swap_header->info.last_page > maxpages) {
+		printk(KERN_WARNING
+			"Truncating oversized swap area, only using %luk out of %luk\n",
+			maxpages << (PAGE_SHIFT - 10),
+			swap_header->info.last_page << (PAGE_SHIFT - 10));
+	}
 	if (maxpages > swap_header->info.last_page) {
 		maxpages = swap_header->info.last_page + 1;
 		/* p->max is an unsigned int: don't overflow it */
_

Patches currently in -mm which might be from shentino@gmail.com are

swap-warn-when-a-swap-area-overflows-the-maximum-size.patch


From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-simplify-error-flow-in-read_swap_header.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:44 -0700
Message-ID: <201103232041.p2NKfKEo028630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933420Ab1CWUl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:41:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: simplify error flow in read_swap_header()
has been removed from the -mm tree.  Its filename was
     sys_swapon-simplify-error-flow-in-read_swap_header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: simplify error flow in read_swap_header()
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Since there is no cleanup to do, there is no reason to jump to a label.
Return directly instead.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-simplify-error-flow-in-read_swap_header mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-simplify-error-flow-in-read_swap_header
+++ a/mm/swapfile.c
@@ -1928,7 +1928,7 @@ static unsigned long read_swap_header(st
 
 	if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
 		printk(KERN_ERR "Unable to find swap-space signature\n");
-		goto bad_swap;
+		return 0;
 	}
 
 	/* swap partition endianess hack... */
@@ -1944,7 +1944,7 @@ static unsigned long read_swap_header(st
 		printk(KERN_WARNING
 		       "Unable to handle swap header version %d\n",
 		       swap_header->info.version);
-		goto bad_swap;
+		return 0;
 	}
 
 	p->lowest_bit  = 1;
@@ -1976,22 +1976,19 @@ static unsigned long read_swap_header(st
 	p->highest_bit = maxpages - 1;
 
 	if (!maxpages)
-		goto bad_swap;
+		return 0;
 	swapfilepages = i_size_read(inode) >> PAGE_SHIFT;
 	if (swapfilepages && maxpages > swapfilepages) {
 		printk(KERN_WARNING
 		       "Swap area shorter than signature indicates\n");
-		goto bad_swap;
+		return 0;
 	}
 	if (swap_header->info.nr_badpages && S_ISREG(inode->i_mode))
-		goto bad_swap;
+		return 0;
 	if (swap_header->info.nr_badpages > MAX_SWAP_BADPAGES)
-		goto bad_swap;
+		return 0;
 
 	return maxpages;

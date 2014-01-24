From: akpm@linux-foundation.org
Subject: [merged]
 mm-swapfilec-do-not-skip-lowest_bit-in-scan_swap_map-scan-loop.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 10:59:47 -0800
Message-ID: <52e2b823.Yk5Lz4Ft9NZOc7hs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbaAXS7r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shli@fusionio.com, minchan@kernel.org, hughd@google.com, akinobu.mita@gmail.com, jamieliu@google.com

Subject: [merged] mm-swapfilec-do-not-skip-lowest_bit-in-scan_swap_map-scan-loop.patch removed from -mm tree
To: jamieliu@google.com,akinobu.mita@gmail.com,hughd@google.com,minchan@kernel.org,shli@fusionio.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:47 -0800


The patch titled
     Subject: mm/swapfile.c: do not skip lowest_bit in scan_swap_map() scan loop
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-do-not-skip-lowest_bit-in-scan_swap_map-scan-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jamie Liu <jamieliu@google.com>
Subject: mm/swapfile.c: do not skip lowest_bit in scan_swap_map() scan loop

In the second half of scan_swap_map()'s scan loop, offset is set to
si->lowest_bit and then incremented before entering the loop for the first
time, causing si->swap_map[si->lowest_bit] to be skipped.

Signed-off-by: Jamie Liu <jamieliu@google.com>
Cc: Shaohua Li <shli@fusionio.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-swapfilec-do-not-skip-lowest_bit-in-scan_swap_map-scan-loop mm/swapfile.c
--- a/mm/swapfile.c~mm-swapfilec-do-not-skip-lowest_bit-in-scan_swap_map-scan-loop
+++ a/mm/swapfile.c
@@ -616,7 +616,7 @@ scan:
 		}
 	}
 	offset = si->lowest_bit;
-	while (++offset < scan_base) {
+	while (offset < scan_base) {
 		if (!si->swap_map[offset]) {
 			spin_lock(&si->lock);
 			goto checks;
@@ -629,6 +629,7 @@ scan:
 			cond_resched();
 			latency_ration = LATENCY_LIMIT;
 		}
+		offset++;
 	}
 	spin_lock(&si->lock);
 
_

Patches currently in -mm which might be from jamieliu@google.com are

origin.patch


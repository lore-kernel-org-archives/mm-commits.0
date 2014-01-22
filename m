From: akpm@linux-foundation.org
Subject: +
 mm-swapfilec-do-not-skip-lowest_bit-in-scan_swap_map-scan-loop.patch added
 to -mm tree
Date: Wed, 22 Jan 2014 13:22:20 -0800
Message-ID: <52e0368c.v27OUQIyLOwuwguT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55673 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaAVVWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 16:22:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shli@fusionio.com, minchan@kernel.org, hughd@google.com, akinobu.mita@gmail.com, jamieliu@google.com

Subject: + mm-swapfilec-do-not-skip-lowest_bit-in-scan_swap_map-scan-loop.patch added to -mm tree
To: jamieliu@google.com,akinobu.mita@gmail.com,hughd@google.com,minchan@kernel.org,shli@fusionio.com
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 13:22:20 -0800


The patch titled
     Subject: mm/swapfile.c: do not skip lowest_bit in scan_swap_map() scan loop
has been added to the -mm tree.  Its filename is
     mm-swapfilec-do-not-skip-lowest_bit-in-scan_swap_map-scan-loop.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfilec-do-not-skip-lowest_bit-in-scan_swap_map-scan-loop.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfilec-do-not-skip-lowest_bit-in-scan_swap_map-scan-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-swapfilec-do-not-skip-lowest_bit-in-scan_swap_map-scan-loop.patch


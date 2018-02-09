From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled.patch removed from -mm
 tree
Date: Fri, 09 Feb 2018 12:59:36 -0800
Message-ID: <5a7e0bb8.9NI2O8a63PEMzFt2%akpm__37889.2670422376$1518209878$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37266 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752521AbeBIU7i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Feb 2018 15:59:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: huang.ying.caritas@gmail.com, akpm@linux-foundation.org, ddstreet@ieee.org, hannes@cmpxchg.org, konrad.wilk@oracle.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, sergey.senozhatsky@gmail.com, shakeelb@google.com, shli@kernel.org, sjenning@redhat.com, stable@vger.kernel.org, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap, frontswap: Fix THP swap if frontswap enabled
has been removed from the -mm tree.  Its filename was
     mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Huang Ying <huang.ying.caritas@gmail.com>
Subject: mm, swap, frontswap: Fix THP swap if frontswap enabled

It was reported by Sergey Senozhatsky that if THP (Transparent Huge Page)
and frontswap (via zswap) are both enabled, when memory goes low so that
swap is triggered, segfault and memory corruption will occur in random
user space applications as follow,

kernel: urxvt[338]: segfault at 20 ip 00007fc08889ae0d sp 00007ffc73a7fc40 error 6 in libc-2.26.so[7fc08881a000+1ae000]
 #0  0x00007fc08889ae0d _int_malloc (libc.so.6)
 #1  0x00007fc08889c2f3 malloc (libc.so.6)
 #2  0x0000560e6004bff7 _Z14rxvt_wcstoutf8PKwi (urxvt)
 #3  0x0000560e6005e75c n/a (urxvt)
 #4  0x0000560e6007d9f1 _ZN16rxvt_perl_interp6invokeEP9rxvt_term9hook_typez (urxvt)
 #5  0x0000560e6003d988 _ZN9rxvt_term9cmd_parseEv (urxvt)
 #6  0x0000560e60042804 _ZN9rxvt_term6pty_cbERN2ev2ioEi (urxvt)
 #7  0x0000560e6005c10f _Z17ev_invoke_pendingv (urxvt)
 #8  0x0000560e6005cb55 ev_run (urxvt)
 #9  0x0000560e6003b9b9 main (urxvt)
 #10 0x00007fc08883af4a __libc_start_main (libc.so.6)
 #11 0x0000560e6003f9da _start (urxvt)

After bisection, it was found the first bad commit is bd4c82c22c367e068
("mm, THP, swap: delay splitting THP after swapped out").

The root cause is as follows:

When the pages are written to swap device during swapping out in
swap_writepage(), zswap (fontswap) is tried to compress the pages instead
to improve the performance.  But zswap (frontswap) will treat THP as
normal page, so only the head page is saved.  After swapping in, tail
pages will not be restored to its original contents, so cause the memory
corruption in the applications.

This is fixed via splitting THP before writing the page to swap device if
frontswap is enabled.  To deal with the situation where frontswap is
enabled at runtime, whether the page is THP is checked before using
frontswap during swapping out too.

Link: http://lkml.kernel.org/r/20180207070035.30302-1-ying.huang@intel.com
Fixes: bd4c82c22c367e068 ("mm, THP, swap: delay splitting THP after swapped out")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Shaohua Li <shli@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>	[4.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c  |    2 +-
 mm/swapfile.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/page_io.c~mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled mm/page_io.c
--- a/mm/page_io.c~mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled
+++ a/mm/page_io.c
@@ -250,7 +250,7 @@ int swap_writepage(struct page *page, st
 		unlock_page(page);
 		goto out;
 	}
-	if (frontswap_store(page) == 0) {
+	if (!PageTransHuge(page) && frontswap_store(page) == 0) {
 		set_page_writeback(page);
 		unlock_page(page);
 		end_page_writeback(page);
diff -puN mm/swapfile.c~mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled
+++ a/mm/swapfile.c
@@ -934,6 +934,9 @@ int get_swap_pages(int n_goal, bool clus
 
 	/* Only single cluster request supported */
 	WARN_ON_ONCE(n_goal > 1 && cluster);
+	/* Frontswap doesn't support THP */
+	if (frontswap_enabled() && cluster)
+		goto noswap;
 
 	avail_pgs = atomic_long_read(&nr_swap_pages) / nr_pages;
 	if (avail_pgs <= 0)
_

Patches currently in -mm which might be from huang.ying.caritas@gmail.com are

mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled-v3.patch


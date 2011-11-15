From: akpm@linux-foundation.org
Subject: + thp-reduce-khugepaged-freezing-latency.patch added to -mm tree
Date: Mon, 14 Nov 2011 16:34:56 -0800
Message-ID: <201111150034.pAF0YuDW007351@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:60035 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab1KOAfE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 19:35:04 -0500
Received: by faap16 with SMTP id p16so84147faa.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 16:35:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, jslaby@suse.cz, oleg@redhat.com, rjw@suse.com, srivatsa.bhat@linux.vnet.ibm.com, tj@kernel.org


The patch titled
     Subject: thp: reduce khugepaged freezing latency
has been added to the -mm tree.  Its filename is
     thp-reduce-khugepaged-freezing-latency.patch

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
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: thp: reduce khugepaged freezing latency

Use wait_event_freezable_timeout() instead of
schedule_timeout_interruptible() to avoid missing freezer wakeups.  A
try_to_freeze() would have been needed in the khugepaged_alloc_hugepage
tight loop too in case of the allocation failing repeatedly, and
wait_event_freezable_timeout will provide it too.

khugepaged would still freeze just fine by trying again the next minute
but it's better if it freezes immediately.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Tested-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@suse.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN mm/huge_memory.c~thp-reduce-khugepaged-freezing-latency mm/huge_memory.c
--- a/mm/huge_memory.c~thp-reduce-khugepaged-freezing-latency
+++ a/mm/huge_memory.c
@@ -2259,12 +2259,8 @@ static void khugepaged_do_scan(struct pa
 
 static void khugepaged_alloc_sleep(void)
 {
-	DEFINE_WAIT(wait);
-	add_wait_queue(&khugepaged_wait, &wait);
-	schedule_timeout_interruptible(
-		msecs_to_jiffies(
-			khugepaged_alloc_sleep_millisecs));
-	remove_wait_queue(&khugepaged_wait, &wait);
+	wait_event_freezable_timeout(khugepaged_wait, false,
+			msecs_to_jiffies(khugepaged_alloc_sleep_millisecs));
 }
 
 #ifndef CONFIG_NUMA
@@ -2313,14 +2309,10 @@ static void khugepaged_loop(void)
 		if (unlikely(kthread_should_stop()))
 			break;
 		if (khugepaged_has_work()) {
-			DEFINE_WAIT(wait);
 			if (!khugepaged_scan_sleep_millisecs)
 				continue;
-			add_wait_queue(&khugepaged_wait, &wait);
-			schedule_timeout_interruptible(
-				msecs_to_jiffies(
-					khugepaged_scan_sleep_millisecs));
-			remove_wait_queue(&khugepaged_wait, &wait);
+			wait_event_freezable_timeout(khugepaged_wait, false,
+			    msecs_to_jiffies(khugepaged_scan_sleep_millisecs));
 		} else if (khugepaged_enabled())
 			wait_event_freezable(khugepaged_wait,
 					     khugepaged_wait_event());
_
Subject: Subject: thp: reduce khugepaged freezing latency

Patches currently in -mm which might be from aarcange@redhat.com are

hugetlb-release-pages-in-the-error-path-of-hugetlb_cow.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3.patch
mm-avoid-livelock-on-__gfp_fs-allocations.patch
mm-avoid-livelock-on-__gfp_fs-allocations-fix.patch
thp-reduce-khugepaged-freezing-latency.patch


From: akpm@linux-foundation.org
Subject: + add-cond_resched-to-refresh_cpu_vm_stats.patch added to -mm tree
Date: Sun, 27 Apr 2008 11:55:26 -0700
Message-ID: <200804271855.m3RItQQE019978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbYD0Sz3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 14:55:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sivanich@sgi.com, clameter@sgi.com


The patch titled
     vmstats: add cond_resched() to refresh_cpu_vm_stats()
has been added to the -mm tree.  Its filename is
     add-cond_resched-to-refresh_cpu_vm_stats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmstats: add cond_resched() to refresh_cpu_vm_stats()
From: Dimitri Sivanich <sivanich@sgi.com>

We've found that it can take quite a bit of time (100's of usec) to get
through the zone loop in refresh_cpu_vm_stats().

Adding a cond_resched() to allow other threads to run in the non-preemptive
case.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmstat.c~add-cond_resched-to-refresh_cpu_vm_stats mm/vmstat.c
--- a/mm/vmstat.c~add-cond_resched-to-refresh_cpu_vm_stats
+++ a/mm/vmstat.c
@@ -322,6 +322,7 @@ void refresh_cpu_vm_stats(int cpu)
 				p->expire = 3;
 #endif
 			}
+		cond_resched();
 #ifdef CONFIG_NUMA
 		/*
 		 * Deal with draining the remote pageset of this
_

Patches currently in -mm which might be from sivanich@sgi.com are

origin.patch
add-cond_resched-to-refresh_cpu_vm_stats.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch


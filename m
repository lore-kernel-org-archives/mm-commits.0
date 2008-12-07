From: akpm@linux-foundation.org
Subject: + percpu_counter-fix-cpu-unplug-race-in-percpu_counter_destroy.patch added to -mm tree
Date: Sat, 06 Dec 2008 19:40:10 -0800
Message-ID: <200812070340.mB73eANk019840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445AbYLGDk2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 22:40:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, a.p.zijlstra@chello.nl, cmm@us.ibm.com, davem@davemloft.net


The patch titled
     percpu_counter: fix CPU unplug race in percpu_counter_destroy()
has been added to the -mm tree.  Its filename is
     percpu_counter-fix-cpu-unplug-race-in-percpu_counter_destroy.patch

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
Subject: percpu_counter: fix CPU unplug race in percpu_counter_destroy()
From: Eric Dumazet <dada1@cosmosbay.com>

We should first delete the counter from percpu_counters list
before freeing memory, or a percpu_counter_hotcpu_callback()
could dereference a NULL pointer.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/percpu_counter.c~percpu_counter-fix-cpu-unplug-race-in-percpu_counter_destroy lib/percpu_counter.c
--- a/lib/percpu_counter.c~percpu_counter-fix-cpu-unplug-race-in-percpu_counter_destroy
+++ a/lib/percpu_counter.c
@@ -104,13 +104,13 @@ void percpu_counter_destroy(struct percp
 	if (!fbc->counters)
 		return;
 
-	free_percpu(fbc->counters);
-	fbc->counters = NULL;
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
 	list_del(&fbc->list);
 	mutex_unlock(&percpu_counters_lock);
 #endif
+	free_percpu(fbc->counters);
+	fbc->counters = NULL;
 }
 EXPORT_SYMBOL(percpu_counter_destroy);
 
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
linux-next.patch
percpu_counter-fix-cpu-unplug-race-in-percpu_counter_destroy.patch
percpu_counter-fix-__percpu_counter_sum.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch


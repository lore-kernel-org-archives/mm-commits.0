From: akpm@linux-foundation.org
Subject: + watchdog-numa-affine-kthreads.patch added to -mm tree
Date: Fri, 26 Aug 2011 13:47:58 -0700
Message-ID: <201108262047.p7QKlwFI010990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202Ab1HZUsu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 16:48:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, dzickus@redhat.com, mingo@elte.hu, tj@kernel.org


The patch titled
     watchdog: NUMA affine kthreads
has been added to the -mm tree.  Its filename is
     watchdog-numa-affine-kthreads.patch

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
Subject: watchdog: NUMA affine kthreads
From: Eric Dumazet <eric.dumazet@gmail.com>

watchdog kthreads can use kthread_create_on_node() to NUMA affine their
stack and task_struct.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/watchdog.c~watchdog-numa-affine-kthreads kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-numa-affine-kthreads
+++ a/kernel/watchdog.c
@@ -439,7 +439,8 @@ static int watchdog_enable(int cpu)
 
 	/* create the watchdog thread */
 	if (!p) {
-		p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
+		p = kthread_create_on_node(watchdog, NULL, cpu_to_node(cpu),
+					   "watchdog/%d", cpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
 			if (!err) {
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

origin.patch
linux-next.patch
watchdog-numa-affine-kthreads.patch
lib-stringc-introduce-memchr_inv.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch


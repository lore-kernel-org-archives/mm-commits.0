From: akpm@linux-foundation.org
Subject: [merged] ipc-semc-cacheline-align-the-semaphore-structures.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:21:53 -0700
Message-ID: <51dc9b11.ikGW1xKZOPFgyBSf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab3GIXVx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: [merged] ipc-semc-cacheline-align-the-semaphore-structures.patch removed from -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:53 -0700


The patch titled
     Subject: ipc/sem.c: cacheline align the semaphore structures
has been removed from the -mm tree.  Its filename was
     ipc-semc-cacheline-align-the-semaphore-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: cacheline align the semaphore structures

As now each semaphore has its own spinlock and parallel operations are
possible, give each semaphore its own cacheline.

On a i3 laptop, this gives up to 28% better performance:

#semscale 10 | grep "interleave 2"
- before:
Cpus 1, interleave 2 delay 0: 36109234 in 10 secs
Cpus 2, interleave 2 delay 0: 55276317 in 10 secs
Cpus 3, interleave 2 delay 0: 62411025 in 10 secs
Cpus 4, interleave 2 delay 0: 81963928 in 10 secs

-after:
Cpus 1, interleave 2 delay 0: 35527306 in 10 secs
Cpus 2, interleave 2 delay 0: 70922909 in 10 secs <<< + 28%
Cpus 3, interleave 2 delay 0: 80518538 in 10 secs
Cpus 4, interleave 2 delay 0: 89115148 in 10 secs <<< + 8.7%

i3, with 2 cores and with hyperthreading enabled.  Interleave 2 in order
use first the full cores.  HT partially hides the delay from cacheline
trashing, thus the improvement is "only" 8.7% if 4 threads are running.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/sem.c~ipc-semc-cacheline-align-the-semaphore-structures ipc/sem.c
--- a/ipc/sem.c~ipc-semc-cacheline-align-the-semaphore-structures
+++ a/ipc/sem.c
@@ -96,7 +96,7 @@ struct sem {
 	int	sempid;		/* pid of last operation */
 	spinlock_t	lock;	/* spinlock for fine-grained semtimedop */
 	struct list_head sem_pending; /* pending single-sop operations */
-};
+} ____cacheline_aligned_in_smp;
 
 /* One queue for each sleeping process in the system. */
 struct sem_queue {
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
slab-leaks3-default-y.patch


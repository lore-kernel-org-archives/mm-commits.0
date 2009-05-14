From: akpm@linux-foundation.org
Subject: + use-round_jiffies-for-slow-work-thread-pools-cull-and-oom-timers.patch added to -mm tree
Date: Thu, 14 May 2009 10:00:23 -0700
Message-ID: <200905141700.n4EH0Nu4009414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754803AbZENRAj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 May 2009 13:00:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cpeterso@cpeterso.com, dhowells@redhat.com


The patch titled
     slow-work: use round_jiffies() for thread pool's cull and OOM timers
has been added to the -mm tree.  Its filename is
     use-round_jiffies-for-slow-work-thread-pools-cull-and-oom-timers.patch

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
Subject: slow-work: use round_jiffies() for thread pool's cull and OOM timers
From: Chris Peterson <cpeterso@cpeterso.com>

Round the slow work queue's cull and OOM timeouts to whole second boundary
with round_jiffies().  The slow work queue uses a pair of timers to cull
idle threads and, after OOM, to delay new thread creation.

This patch also extracts the mod_timer() logic for the cull timer into a
separate helper function.

By rounding non-time-critical timers such as these to whole seconds, they
will be batched up to fire at the same time rather than being spread out. 
This allows the CPU wake up less, which saves power.

Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/slow-work.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff -puN kernel/slow-work.c~use-round_jiffies-for-slow-work-thread-pools-cull-and-oom-timers kernel/slow-work.c
--- a/kernel/slow-work.c~use-round_jiffies-for-slow-work-thread-pools-cull-and-oom-timers
+++ a/kernel/slow-work.c
@@ -319,6 +319,15 @@ cant_get_ref:
 EXPORT_SYMBOL(slow_work_enqueue);
 
 /*
+ * Schedule a cull of the thread pool at some time in the near future
+ */
+static void slow_work_schedule_cull(void)
+{
+	mod_timer(&slow_work_cull_timer,
+		  round_jiffies(jiffies + SLOW_WORK_CULL_TIMEOUT));
+}
+
+/*
  * Worker thread culling algorithm
  */
 static bool slow_work_cull_thread(void)
@@ -335,8 +344,7 @@ static bool slow_work_cull_thread(void)
 		    list_empty(&vslow_work_queue) &&
 		    atomic_read(&slow_work_thread_count) >
 		    slow_work_min_threads) {
-			mod_timer(&slow_work_cull_timer,
-				  jiffies + SLOW_WORK_CULL_TIMEOUT);
+			slow_work_schedule_cull();
 			do_cull = true;
 		}
 	}
@@ -393,8 +401,7 @@ static int slow_work_thread(void *_data)
 			    list_empty(&vslow_work_queue) &&
 			    atomic_read(&slow_work_thread_count) >
 			    slow_work_min_threads)
-				mod_timer(&slow_work_cull_timer,
-					  jiffies + SLOW_WORK_CULL_TIMEOUT);
+				slow_work_schedule_cull();
 			continue;
 		}
 
@@ -458,7 +465,7 @@ static void slow_work_new_thread_execute
 		if (atomic_dec_and_test(&slow_work_thread_count))
 			BUG(); /* we're running on a slow work thread... */
 		mod_timer(&slow_work_oom_timer,
-			  jiffies + SLOW_WORK_OOM_TIMEOUT);
+			  round_jiffies(jiffies + SLOW_WORK_OOM_TIMEOUT));
 	} else {
 		/* ratelimit the starting of new threads */
 		mod_timer(&slow_work_oom_timer, jiffies + 1);
@@ -502,8 +509,7 @@ static int slow_work_min_threads_sysctl(
 			if (n < 0 && !slow_work_may_not_start_new_thread)
 				slow_work_enqueue(&slow_work_new_thread);
 			else if (n > 0)
-				mod_timer(&slow_work_cull_timer,
-					  jiffies + SLOW_WORK_CULL_TIMEOUT);
+				slow_work_schedule_cull();
 		}
 		mutex_unlock(&slow_work_user_lock);
 	}
@@ -529,8 +535,7 @@ static int slow_work_max_threads_sysctl(
 				atomic_read(&slow_work_thread_count);
 
 			if (n < 0)
-				mod_timer(&slow_work_cull_timer,
-					  jiffies + SLOW_WORK_CULL_TIMEOUT);
+				slow_work_schedule_cull();
 		}
 		mutex_unlock(&slow_work_user_lock);
 	}
_

Patches currently in -mm which might be from cpeterso@cpeterso.com are

use-round_jiffies-for-slow-work-thread-pools-cull-and-oom-timers.patch


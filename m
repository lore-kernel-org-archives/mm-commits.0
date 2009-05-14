From: akpm@linux-foundation.org
Subject: [to-be-updated] slow-work-use-round_jiffies-for-the-thread-pools-5-second-cull-timer.patch removed from -mm tree
Date: Thu, 14 May 2009 09:59:33 -0700
Message-ID: <200905141659.n4EGxYBH008782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754602AbZENRAN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 May 2009 13:00:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cpeterso@cpeterso.com, dhowells@redhat.com, richard@rsk.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     slow-work: use round_jiffies() for the thread pool's 5 second cull timer
has been removed from the -mm tree.  Its filename was
     slow-work-use-round_jiffies-for-the-thread-pools-5-second-cull-timer.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slow-work: use round_jiffies() for the thread pool's 5 second cull timer
From: Chris Peterson <cpeterso@cpeterso.com>

Round the slow work queue's 5 second timers to whole seconds with
round_jiffies().  The slow work queue uses 5 second timers to cull idle
threads and, after OOM, to delay new thread creation. This patch also
refactors the mod_timer() logic into a separate helper function.

Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/slow-work.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN kernel/slow-work.c~slow-work-use-round_jiffies-for-the-thread-pools-5-second-cull-timer kernel/slow-work.c
--- a/kernel/slow-work.c~slow-work-use-round_jiffies-for-the-thread-pools-5-second-cull-timer
+++ a/kernel/slow-work.c
@@ -318,6 +318,12 @@ cant_get_ref:
 }
 EXPORT_SYMBOL(slow_work_enqueue);
 
+static void slow_work_defer_cull_time(void)
+{
+	mod_timer(&slow_work_cull_timer,
+			  round_jiffies(jiffies + SLOW_WORK_CULL_TIMEOUT));
+}
+
 /*
  * Worker thread culling algorithm
  */
@@ -335,8 +341,7 @@ static bool slow_work_cull_thread(void)
 		    list_empty(&vslow_work_queue) &&
 		    atomic_read(&slow_work_thread_count) >
 		    slow_work_min_threads) {
-			mod_timer(&slow_work_cull_timer,
-				  jiffies + SLOW_WORK_CULL_TIMEOUT);
+			slow_work_defer_cull_time();
 			do_cull = true;
 		}
 	}
@@ -393,8 +398,7 @@ static int slow_work_thread(void *_data)
 			    list_empty(&vslow_work_queue) &&
 			    atomic_read(&slow_work_thread_count) >
 			    slow_work_min_threads)
-				mod_timer(&slow_work_cull_timer,
-					  jiffies + SLOW_WORK_CULL_TIMEOUT);
+				slow_work_defer_cull_time();
 			continue;
 		}
 
@@ -458,7 +462,7 @@ static void slow_work_new_thread_execute
 		if (atomic_dec_and_test(&slow_work_thread_count))
 			BUG(); /* we're running on a slow work thread... */
 		mod_timer(&slow_work_oom_timer,
-			  jiffies + SLOW_WORK_OOM_TIMEOUT);
+				round_jiffies(jiffies + SLOW_WORK_OOM_TIMEOUT));
 	} else {
 		/* ratelimit the starting of new threads */
 		mod_timer(&slow_work_oom_timer, jiffies + 1);
@@ -502,8 +506,7 @@ static int slow_work_min_threads_sysctl(
 			if (n < 0 && !slow_work_may_not_start_new_thread)
 				slow_work_enqueue(&slow_work_new_thread);
 			else if (n > 0)
-				mod_timer(&slow_work_cull_timer,
-					  jiffies + SLOW_WORK_CULL_TIMEOUT);
+				slow_work_defer_cull_time();
 		}
 		mutex_unlock(&slow_work_user_lock);
 	}
@@ -529,8 +532,7 @@ static int slow_work_max_threads_sysctl(
 				atomic_read(&slow_work_thread_count);
 
 			if (n < 0)
-				mod_timer(&slow_work_cull_timer,
-					  jiffies + SLOW_WORK_CULL_TIMEOUT);
+				slow_work_defer_cull_time();
 		}
 		mutex_unlock(&slow_work_user_lock);
 	}
_

Patches currently in -mm which might be from cpeterso@cpeterso.com are

slow-work-use-round_jiffies-for-the-thread-pools-5-second-cull-timer.patch


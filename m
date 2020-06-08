From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-check-kcov_softirq-in-kcov_remote_stop.patch added
 to -mm tree
Date: Sun, 07 Jun 2020 17:57:41 -0700
Message-ID: <20200608005741.eDho_3iPP%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728001AbgFHA5o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 7 Jun 2020 20:57:44 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, dvyukov@google.com, elver@google.com, glider@google.com, mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp


The patch titled
     Subject: kcov: check kcov_softirq in kcov_remote_stop()
has been added to the -mm tree.  Its filename is
     kcov-check-kcov_softirq-in-kcov_remote_stop.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-check-kcov_softirq-in-kcov_remote_stop.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-check-kcov_softirq-in-kcov_remote_stop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kcov: check kcov_softirq in kcov_remote_stop()

kcov_remote_stop() should check that the corresponding kcov_remote_start()
actually found the specified remote handle and started collecting
coverage.  This is done by checking the per thread kcov_softirq flag.

A particular failure scenario where this was observed involved a softirq
with a remote coverage collection section coming between check_kcov_mode()
and the access to t->kcov_area in __sanitizer_cov_trace_pc().  In that
softirq kcov_remote_start() bailed out after kcov_remote_find() check, but
the matching kcov_remote_stop() didn't check if kcov_remote_start()
succeeded, and overwrote per thread kcov parameters with invalid (zero)
values.

Link: http://lkml.kernel.org/r/fcd1cd16eac1d2c01a66befd8ea4afc6f8d09833.1591576806.git.andreyknvl@google.com
Fixes: 5ff3b30ab57d ("kcov: collect coverage from interrupts")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/kernel/kcov.c~kcov-check-kcov_softirq-in-kcov_remote_stop
+++ a/kernel/kcov.c
@@ -427,7 +427,8 @@ void kcov_task_exit(struct task_struct *
 	 *        WARN_ON(!kcov->remote && kcov->t != t);
 	 *
 	 * For KCOV_REMOTE_ENABLE devices, the exiting task is either:
-	 * 2. A remote task between kcov_remote_start() and kcov_remote_stop().
+	 *
+	 * 1. A remote task between kcov_remote_start() and kcov_remote_stop().
 	 *    In this case we should print a warning right away, since a task
 	 *    shouldn't be exiting when it's in a kcov coverage collection
 	 *    section. Here t points to the task that is collecting remote
@@ -437,7 +438,7 @@ void kcov_task_exit(struct task_struct *
 	 *        WARN_ON(kcov->remote && kcov->t != t);
 	 *
 	 * 2. The task that created kcov exiting without calling KCOV_DISABLE,
-	 *    and then again we can make sure that t->kcov->t == t:
+	 *    and then again we make sure that t->kcov->t == t:
 	 *        WARN_ON(kcov->remote && kcov->t != t);
 	 *
 	 * By combining all three checks into one we get:
@@ -764,7 +765,7 @@ static const struct file_operations kcov
  * Internally, kcov_remote_start() looks up the kcov device associated with the
  * provided handle, allocates an area for coverage collection, and saves the
  * pointers to kcov and area into the current task_struct to allow coverage to
- * be collected via __sanitizer_cov_trace_pc()
+ * be collected via __sanitizer_cov_trace_pc().
  * In turns kcov_remote_stop() clears those pointers from task_struct to stop
  * collecting coverage and copies all collected coverage into the kcov area.
  */
@@ -972,16 +973,25 @@ void kcov_remote_stop(void)
 		local_irq_restore(flags);
 		return;
 	}
-	kcov = t->kcov;
-	area = t->kcov_area;
-	size = t->kcov_size;
-	sequence = t->kcov_sequence;

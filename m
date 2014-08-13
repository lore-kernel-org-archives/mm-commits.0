From: akpm@linux-foundation.org
Subject: + kernel-async-fixed-coding-style-issues.patch added to -mm tree
Date: Wed, 13 Aug 2014 14:48:28 -0700
Message-ID: <53ebdd2c.6WQCkdym/Wq+m5DP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:50952 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaHMVs3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 17:48:29 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so98548oah.2
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 14:48:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ionut.m.alexa@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/async.c: switch to pr_foo()
has been added to the -mm tree.  Its filename is
     kernel-async-fixed-coding-style-issues.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-async-fixed-coding-style-issues.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-async-fixed-coding-style-issues.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ionut Alexa <ionut.m.alexa@gmail.com>
Subject: kernel/async.c: switch to pr_foo()

Signed-off-by: Ionut Alexa <ionut.m.alexa@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/async.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/async.c~kernel-async-fixed-coding-style-issues kernel/async.c
--- a/kernel/async.c~kernel-async-fixed-coding-style-issues
+++ a/kernel/async.c
@@ -115,7 +115,7 @@ static void async_run_entry_fn(struct wo
 
 	/* 1) run (and print duration) */
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk(KERN_DEBUG "calling  %lli_%pF @ %i\n",
+		pr_debug("calling  %lli_%pF @ %i\n",
 			(long long)entry->cookie,
 			entry->func, task_pid_nr(current));
 		calltime = ktime_get();
@@ -124,7 +124,7 @@ static void async_run_entry_fn(struct wo
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		rettime = ktime_get();
 		delta = ktime_sub(rettime, calltime);
-		printk(KERN_DEBUG "initcall %lli_%pF returned 0 after %lld usecs\n",
+		pr_debug("initcall %lli_%pF returned 0 after %lld usecs\n",
 			(long long)entry->cookie,
 			entry->func,
 			(long long)ktime_to_ns(delta) >> 10);
@@ -285,7 +285,7 @@ void async_synchronize_cookie_domain(asy
 	ktime_t uninitialized_var(starttime), delta, endtime;
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk(KERN_DEBUG "async_waiting @ %i\n", task_pid_nr(current));
+		pr_debug("async_waiting @ %i\n", task_pid_nr(current));
 		starttime = ktime_get();
 	}
 
@@ -295,7 +295,7 @@ void async_synchronize_cookie_domain(asy
 		endtime = ktime_get();
 		delta = ktime_sub(endtime, starttime);
 
-		printk(KERN_DEBUG "async_continuing @ %i after %lli usec\n",
+		pr_debug("async_continuing @ %i after %lli usec\n",
 			task_pid_nr(current),
 			(long long)ktime_to_ns(delta) >> 10);
 	}
_

Patches currently in -mm which might be from ionut.m.alexa@gmail.com are

origin.patch
kernel-async-fixed-coding-style-issues.patch
linux-next.patch


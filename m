From: akpm@linux-foundation.org
Subject: [merged] kernel-async-fixed-coding-style-issues.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:22:22 -0700
Message-ID: <543c185e.sWIWiB1jPyG1qRrd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbaJMSWx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:22:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ionut.m.alexa@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/async.c: switch to pr_foo()
has been removed from the -mm tree.  Its filename was
     kernel-async-fixed-coding-style-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch


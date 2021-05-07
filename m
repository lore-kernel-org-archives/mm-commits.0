Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EFBDC43461
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3443F613CD
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhEGBGg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234137AbhEGBGg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:06:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD5B3610FA;
        Fri,  7 May 2021 01:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349537;
        bh=H633ZYYULVJd9QCojkuWybcz8yjlALQ2k37TF0X+Tm0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eTAjX9ObuLtUR+l0ThzA62o2GcAhD4JwIJtVh6wJb9zmBgJyavOoPLETVmHY/f7vW
         hH7/44iFB4BwiH+4s+p+PGmIziJzN6UPW4Mx4kmTNFmbgyf4lCAXCps36HV0/7niJI
         HQ3O7o0W2XHEy9eF2vU44DJRC5ur/AKSnbSqaH0Y=
Date:   Thu, 06 May 2021 18:05:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org,
        tj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 68/91] kernel/async.c: stop guarding pr_debug()
 statements
Message-ID: <20210507010536.Ou0SvwhLm%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: kernel/async.c: stop guarding pr_debug() statements

It's currently nigh impossible to get these pr_debug()s to print
something.  Being guarded by initcall_debug means one has to enable tons
of other debug output during boot, and the system_state condition further
means it's impossible to get them when loading modules later.

Also, the compiler can't know that these global conditions do not change,
so there are W=2 warnings

kernel/async.c:125:9: warning: `calltime' may be used uninitialized in this function [-Wmaybe-uninitialized]
kernel/async.c:300:9: warning: `starttime' may be used uninitialized in this function [-Wmaybe-uninitialized]

Make it possible, for a DYNAMIC_DEBUG kernel, to get these to print their
messages by booting with appropriate 'dyndbg="file async.c +p"' command
line argument.  For a non-DYNAMIC_DEBUG kernel, pr_debug() compiles to
nothing.

This does cost doing an unconditional ktime_get() for the starttime value,
but the corresponding ktime_get for the end time can be elided by
factoring it into a function which only gets called if the printk()
arguments end up being evaluated.

Link: https://lkml.kernel.org/r/20210309151723.1907838-1-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/async.c |   48 +++++++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

--- a/kernel/async.c~kernel-asyncc-stop-guarding-pr_debug-statements
+++ a/kernel/async.c
@@ -78,6 +78,12 @@ static DECLARE_WAIT_QUEUE_HEAD(async_don
 
 static atomic_t entry_count;
 
+static long long microseconds_since(ktime_t start)
+{
+	ktime_t now = ktime_get();
+	return ktime_to_ns(ktime_sub(now, start)) >> 10;
+}
+
 static async_cookie_t lowest_in_progress(struct async_domain *domain)
 {
 	struct async_entry *first = NULL;
@@ -111,24 +117,18 @@ static void async_run_entry_fn(struct wo
 	struct async_entry *entry =
 		container_of(work, struct async_entry, work);
 	unsigned long flags;
-	ktime_t calltime, delta, rettime;
+	ktime_t calltime;
 
 	/* 1) run (and print duration) */
-	if (initcall_debug && system_state < SYSTEM_RUNNING) {
-		pr_debug("calling  %lli_%pS @ %i\n",
-			(long long)entry->cookie,
-			entry->func, task_pid_nr(current));
-		calltime = ktime_get();
-	}
+	pr_debug("calling  %lli_%pS @ %i\n", (long long)entry->cookie,
+		 entry->func, task_pid_nr(current));
+	calltime = ktime_get();
+
 	entry->func(entry->data, entry->cookie);
-	if (initcall_debug && system_state < SYSTEM_RUNNING) {
-		rettime = ktime_get();
-		delta = ktime_sub(rettime, calltime);
-		pr_debug("initcall %lli_%pS returned after %lld usecs\n",
-			(long long)entry->cookie,
-			entry->func,
-			(long long)ktime_to_ns(delta) >> 10);
-	}
+
+	pr_debug("initcall %lli_%pS returned after %lld usecs\n",
+		 (long long)entry->cookie, entry->func,
+		 microseconds_since(calltime));
 
 	/* 2) remove self from the pending queues */
 	spin_lock_irqsave(&async_lock, flags);
@@ -287,23 +287,15 @@ EXPORT_SYMBOL_GPL(async_synchronize_full
  */
 void async_synchronize_cookie_domain(async_cookie_t cookie, struct async_domain *domain)
 {
-	ktime_t starttime, delta, endtime;
+	ktime_t starttime;
 
-	if (initcall_debug && system_state < SYSTEM_RUNNING) {
-		pr_debug("async_waiting @ %i\n", task_pid_nr(current));
-		starttime = ktime_get();
-	}
+	pr_debug("async_waiting @ %i\n", task_pid_nr(current));
+	starttime = ktime_get();
 
 	wait_event(async_done, lowest_in_progress(domain) >= cookie);
 
-	if (initcall_debug && system_state < SYSTEM_RUNNING) {
-		endtime = ktime_get();
-		delta = ktime_sub(endtime, starttime);
-
-		pr_debug("async_continuing @ %i after %lli usec\n",
-			task_pid_nr(current),
-			(long long)ktime_to_ns(delta) >> 10);
-	}
+	pr_debug("async_continuing @ %i after %lli usec\n", task_pid_nr(current),
+		 microseconds_since(starttime));
 }
 EXPORT_SYMBOL_GPL(async_synchronize_cookie_domain);
 
_

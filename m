From: akpm@linux-foundation.org
Subject: + cpusets-allocate-heap-only-when-required.patch added to -mm
 tree
Date: Thu, 23 Jan 2014 14:43:07 -0800
Message-ID: <52e19afb.rbb+A/vLTkNB2whQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaAWWnI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 17:43:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rientjes@google.com, lizf@cn.fujitsu.com, viresh.kumar@linaro.org

Subject: + cpusets-allocate-heap-only-when-required.patch added to -mm tree
To: viresh.kumar@linaro.org,lizf@cn.fujitsu.com,rientjes@google.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 14:43:07 -0800


The patch titled
     Subject: cpusets: allocate heap only when required
has been added to the -mm tree.  Its filename is
     cpusets-allocate-heap-only-when-required.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpusets-allocate-heap-only-when-required.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpusets-allocate-heap-only-when-required.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: cpusets: allocate heap only when required

update_flag() routine uses heap only when spread_flag_changed is true. 
Otherwise heap isn't used, but is allocated and freed unnecessarily.

Fix this by allocating heap only when required.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN kernel/cpuset.c~cpusets-allocate-heap-only-when-required kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-allocate-heap-only-when-required
+++ a/kernel/cpuset.c
@@ -1326,16 +1326,18 @@ static int update_flag(cpuset_flagbits_t
 	if (err < 0)
 		goto out;
 
-	err = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
-	if (err < 0)
-		goto out;
-
 	balance_flag_changed = (is_sched_load_balance(cs) !=
 				is_sched_load_balance(trialcs));
 
 	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
 			|| (is_spread_page(cs) != is_spread_page(trialcs)));
 
+	if (spread_flag_changed) {
+		err = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
+		if (err < 0)
+			goto out;
+	}
+
 	mutex_lock(&callback_mutex);
 	cs->flags = trialcs->flags;
 	mutex_unlock(&callback_mutex);
@@ -1343,9 +1345,10 @@ static int update_flag(cpuset_flagbits_t
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
 		rebuild_sched_domains_locked();
 
-	if (spread_flag_changed)
+	if (spread_flag_changed) {
 		update_tasks_flags(cs, &heap);
-	heap_free(&heap);
+		heap_free(&heap);
+	}
 out:
 	free_trial_cpuset(trialcs);
 	return err;
_

Patches currently in -mm which might be from viresh.kumar@linaro.org are

origin.patch
cpusets-allocate-heap-only-when-required.patch


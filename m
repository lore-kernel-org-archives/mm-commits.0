Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B641428E7
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 20:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747861141; cv=none; b=Dk+6cS6grAu+wlzztB0lIxZVKUI7MbIPiBYdjc1gbQeSrdhgWgUz1KhfVKnTua4FzASQp0HO2C2NLpi2e/dbZqP8uQCRfocbVCBaKWmk8EzbzcLSkpC/dp3EGtQZyfFt4iiwubbOGngoZ3rAAVTnBmjec9cBkZhOTxqWXqU0r24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747861141; c=relaxed/simple;
	bh=l5S/NDTEZtSIC9fd6WAbUzhasigaxC/1TRed1lp1+6Q=;
	h=Date:To:From:Subject:Message-Id; b=cmPBHQa+Y3LZIJsXwHJf/H4yfS4m32tCoG1PdU1GjwCUxN6oiPmcKaw0VLHHEEmJuxchcdhJ9+BeyLGEq0qwryx6eEVnSuNhNXEir0su+GwW+dchfi8XmOgjoepthlAFDEiciizjmOQdtb15+2lRSdTF0gMLB9qOitFFLCPF13A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IuUGii8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IuUGii8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229C4C4CEE4;
	Wed, 21 May 2025 20:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747861141;
	bh=l5S/NDTEZtSIC9fd6WAbUzhasigaxC/1TRed1lp1+6Q=;
	h=Date:To:From:Subject:From;
	b=IuUGii8UZTr4SiLA6f0SbUg04+be3tGC53SQqc+f1il2leldz1NJXqKL3gZmNxdpf
	 STgZB4PrFyHZI3ROm/IywExEcraau8mW9B/vY34TAWsiUej4DbHm169pNIHeqW8hxk
	 0pJsuqR/DTRQqqKhqP4iskbWHw0Mit3szQq07yko=
Date: Wed, 21 May 2025 13:59:00 -0700
To: mm-commits@vger.kernel.org,yu.c.chen@intel.com,vineethr@linux.ibm.com,tj@kernel.org,tim.c.chen@intel.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,mhocko@kernel.org,mgorman@suse.de,libo.chen@oracle.com,kprateek.nayak@amd.com,hannes@cmpxchg.org,corbet@lwn.net,ayush.jain3@amd.com,aubrey.li@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + task_numa_compare-fix-check-for-kernel-thread.patch added to mm-unstable branch
Message-Id: <20250521205901.229C4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: task_numa_compare: fix check for kernel thread
has been added to the -mm mm-unstable branch.  Its filename is
     task_numa_compare-fix-check-for-kernel-thread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/task_numa_compare-fix-check-for-kernel-thread.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: task_numa_compare: fix check for kernel thread
Date: Wed May 21 01:54:00 PM PDT 2025

Peter points out "!cur->mm is not the right way to determine a kernel
thread, PF_KTHREAD is.  Notably, there are kernel threads that have ->mm".

Link: https://lkml.kernel.org/r/20250521191114.GE24938@noisy.programming.kicks-ass.net
Fixes: 69cebdfa253b sched/numa: fix task swap by skipping kernel threads
Cc: Aubrey Li <aubrey.li@intel.com>
Cc: Ayush Jain <ayush.jain3@amd.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: Chen, Yu C <yu.c.chen@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Libo Chen <libo.chen@oracle.com>
Cc: Madadi Vineeth Reddy <vineethr@linux.ibm.com>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/fair.c~task_numa_compare-fix-check-for-kernel-thread
+++ a/kernel/sched/fair.c
@@ -2274,7 +2274,7 @@ static bool task_numa_compare(struct tas
 	rcu_read_lock();
 	cur = rcu_dereference(dst_rq->curr);
 	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur) ||
-		    !cur->mm))
+		    !(cur->flags & PF_KTHREAD)))
 		cur = NULL;
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

task_numa_compare-fix-check-for-kernel-thread.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-2-fix.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch


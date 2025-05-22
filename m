Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EE41EB5DC
	for <mm-commits@vger.kernel.org>; Thu, 22 May 2025 21:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747951031; cv=none; b=slciN0daDxRqhAg9s8mVSKKdAX1HEA53waXE6f3pCpcfNPGwgnQUK3gKoxkNA8+6DGUEN4ZN3+635xw5mDUY6R+ZpjnoKKbU35YgcQVvTONEaN4jflkd/2dULtMWeOgsFWv834S83X9DqLhk1RRBGCnwKO/mwVsyn/NdOmint9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747951031; c=relaxed/simple;
	bh=eHS5LiCVgMIcFIcY1iErJxF7fj95in/LmSrZgaXg4lw=;
	h=Date:To:From:Subject:Message-Id; b=fJAnm09UByjvFBPekC/e9hdTLqe049LOE/wtRVrnUPqNBo+sEexRQmYypuWI6DyGruEsh6hEHop08CFRJFzjYWjOmFnkJYAbTKBT2y4yGg1SR+M7J1h5rCZilGjhu+NKQgJWj/fwnVXyeYwQtcAu0BLYq/fGZHjIG0uJUdf/R4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FSTHUGdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FSTHUGdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8F8C4CEE4;
	Thu, 22 May 2025 21:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747951031;
	bh=eHS5LiCVgMIcFIcY1iErJxF7fj95in/LmSrZgaXg4lw=;
	h=Date:To:From:Subject:From;
	b=FSTHUGdSxXCsoAYshKDytV4wQRPLx9AMWvJGV2CSp7HlmEUj8ISJKjRGsui99+1VD
	 T2Bw1L8bCviN7WkCYLda7hoTxSNAVgJsY4EeTh5FHpttsn18AJDwMv0/C8UHagnbSl
	 7wHLoaWqBtii8ZjiR0hY7gSYM/8BoIo8tH4Tc0yQ=
Date: Thu, 22 May 2025 14:57:10 -0700
To: mm-commits@vger.kernel.org,yu.c.chen@intel.com,vineethr@linux.ibm.com,tj@kernel.org,tim.c.chen@intel.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,mhocko@kernel.org,mgorman@suse.de,libo.chen@oracle.com,kprateek.nayak@amd.com,hannes@cmpxchg.org,corbet@lwn.net,ayush.jain3@amd.com,aubrey.li@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] task_numa_compare-fix-check-for-kernel-thread.patch removed from -mm tree
Message-Id: <20250522215711.8B8F8C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: task_numa_compare: fix check for kernel thread
has been removed from the -mm tree.  Its filename was
     task_numa_compare-fix-check-for-kernel-thread.patch

This patch was dropped because it is obsolete

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

mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-2-fix.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch


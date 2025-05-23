Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34FC143C69;
	Fri, 23 May 2025 21:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748037292; cv=none; b=irtO0kJUqOaTOfI19lAib/5m+Ef+fMFQ/NTbnybDffVNEWiG7lbZOwAHBTSxZJQhafzJY366H5q03Yh34FtN8HxYxDZH+HNzwBnr4Ucbi8xJ0Dv/AYmH/5eWpdMDuLt64GWB3V82fQjuZwlAnOiLPd8zj//juDeJnoC+KcpHT4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748037292; c=relaxed/simple;
	bh=DlL1EIq0S1dy1uPUm8aA4FntRjT1eIs+455hvQpslFg=;
	h=Date:To:From:Subject:Message-Id; b=qk29RzeVS7hA5kOFj3pc+4zQgK7/IUxzteiz0mvnwCLOYhlIPo7t4r8ekgoB0Jru6nVmDXPXkLOfwgUvxODEUeoisHvFrCT0ciQxu52PgSXo77q8fjz4anSkZqHCkmKO0JjIGWWb3TdJ4pMwK7JGyEUJUdeJ0XdG1k3q+tdpq3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G8FBW7Oj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G8FBW7Oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CB9C4CEE9;
	Fri, 23 May 2025 21:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748037291;
	bh=DlL1EIq0S1dy1uPUm8aA4FntRjT1eIs+455hvQpslFg=;
	h=Date:To:From:Subject:From;
	b=G8FBW7OjHQUDnaW2AlKgBqk48F/Pl0GcODjIwDa7s3JIyHoenx/TTe1msmP+NBOs1
	 nQ71tzzt2SejWLUvGt/US96WaColkcnAQQaiHhbn2xbEzYynFz9I0ivUP40nHfc4Pz
	 c1s4RwpwgEuGVLuc6njt4NuWt942e/kqIC/TU2Pg=
Date: Fri, 23 May 2025 14:54:50 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rmikey@meta.com,riel@surriel.com,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,gregkh@linuxfoundation.org,chenridong@huawei.com,asml.silence@gmail.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-always-call-cond_resched-after-fn.patch added to mm-hotfixes-unstable branch
Message-Id: <20250523215451.33CB9C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: always call cond_resched() after fn()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memcg-always-call-cond_resched-after-fn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-always-call-cond_resched-after-fn.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Breno Leitao <leitao@debian.org>
Subject: memcg: always call cond_resched() after fn()
Date: Fri, 23 May 2025 10:21:06 -0700

I am seeing soft lockup on certain machine types when a cgroup OOMs.  This
is happening because killing the process in certain machine might be very
slow, which causes the soft lockup and RCU stalls.  This happens usually
when the cgroup has MANY processes and memory.oom.group is set.

Example I am seeing in real production:

       [462012.244552] Memory cgroup out of memory: Killed process 3370438 (crosvm) ....
       ....
       [462037.318059] Memory cgroup out of memory: Killed process 4171372 (adb) ....
       [462037.348314] watchdog: BUG: soft lockup - CPU#64 stuck for 26s! [stat_manager-ag:1618982]
       ....

Quick look at why this is so slow, it seems to be related to serial flush
for certain machine types.  For all the crashes I saw, the target CPU was
at console_flush_all().

In the case above, there are thousands of processes in the cgroup, and it
is soft locking up before it reaches the 1024 limit in the code (which
would call the cond_resched()).  So, cond_resched() in 1024 blocks is not
sufficient.

Remove the counter-based conditional rescheduling logic and call
cond_resched() unconditionally after each task iteration, after fn() is
called.  This avoids the lockup independently of how slow fn() is.

Link: https://lkml.kernel.org/r/20250523-memcg_fix-v1-1-ad3eafb60477@debian.org
Fixes: ade81479c7dd ("memcg: fix soft lockup in the OOM process")
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Rik van Riel <riel@surriel.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michael van der Westhuizen <rmikey@meta.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~memcg-always-call-cond_resched-after-fn
+++ a/mm/memcontrol.c
@@ -1168,7 +1168,6 @@ void mem_cgroup_scan_tasks(struct mem_cg
 {
 	struct mem_cgroup *iter;
 	int ret = 0;
-	int i = 0;
 
 	BUG_ON(mem_cgroup_is_root(memcg));
 
@@ -1178,10 +1177,9 @@ void mem_cgroup_scan_tasks(struct mem_cg
 
 		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
 		while (!ret && (task = css_task_iter_next(&it))) {
-			/* Avoid potential softlockup warning */
-			if ((++i & 1023) == 0)
-				cond_resched();
 			ret = fn(task, arg);
+			/* Avoid potential softlockup warning */
+			cond_resched();
 		}
 		css_task_iter_end(&it);
 		if (ret) {
_

Patches currently in -mm which might be from leitao@debian.org are

memcg-always-call-cond_resched-after-fn.patch


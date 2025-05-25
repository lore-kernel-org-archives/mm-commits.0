Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FE1FC1D;
	Sun, 25 May 2025 07:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748159669; cv=none; b=G/pTxfBSrkjAIn8fcJ39B2F+/MWzD8IvbChPMqv/bBz6nvQ6L2DCQdCreCNUEPgxlRoaMmJ3lPzUIZYHOU+y50tjUS+mgxRoGULPueSPpTDUJ9KfHJ6FylqdQg8HO6BimHdMXvvPr151g4GdV7zskvuueA3gPR3wn3hZpFXVyoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748159669; c=relaxed/simple;
	bh=ubLvoOYG7Tv+dMENejFhjCRhw2ev3LjqxEqBBygD3NY=;
	h=Date:To:From:Subject:Message-Id; b=r3NPh3iiQIy16YAsj4i6bZIUVh9ygme9UrY9dcBjZDxluMaIgz9zziZcinnE7cV1V+3kJYRHWlW9hKmZPXRo0C1YGL5Sms8CyagKK4kIpRdYM6U8n/nEJAmFXYV2gSbQjGhmatTNcKlhMXpVGQcnrJIbOwhFElzhhzR8I0FWq3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SfxAaKT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SfxAaKT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6145BC4CEEA;
	Sun, 25 May 2025 07:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748159668;
	bh=ubLvoOYG7Tv+dMENejFhjCRhw2ev3LjqxEqBBygD3NY=;
	h=Date:To:From:Subject:From;
	b=SfxAaKT6+ybFKFkBh9dGJKMMGIzPfmkdsaTQ7Ndy9rq9IJc0qwwPi3HGoro6JTCSa
	 cZDNr24VZrSLXM2033VFREgNcqHm0xb9Bc2y0Hg+yC+MItpv2/YG3ymcf5c5jgF1T9
	 0L9QIh1zArgeFpzHrn0gAKvZ8VbBTd7nlvA3gvXo=
Date: Sun, 25 May 2025 00:54:27 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rmikey@meta.com,riel@surriel.com,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,gregkh@linuxfoundation.org,chenridong@huawei.com,asml.silence@gmail.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] memcg-always-call-cond_resched-after-fn.patch removed from -mm tree
Message-Id: <20250525075428.6145BC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: always call cond_resched() after fn()
has been removed from the -mm tree.  Its filename was
     memcg-always-call-cond_resched-after-fn.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



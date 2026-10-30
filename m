Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793404122;
	b=ghNAXq+uJDQAoNrX3bQ78wcFfmJ3ELcxeyXYRUPXNklsGgmN7065tfcjpIaSbAoac+VT
	 8L4mSTwF0HoN+jfmdD1WthVznPFJcLLE+5nssKdYSN/cvLw3ryJQwhB2qIAwR2nt+CRSI
	 /ZjmlYAfialh49zH7MkGV+tXCe7ykjmgG/83VrqmTHpAq7It+mGRPCDj53bOWnrbbq5ZB
	 H1upiUhPf43kWhT+2II8oOHfkexZYo1KIa+c0GtnPFUOHwU8p5lYlcsLfWCy3yHpFyI3x
	 WA1h+2AGtIsR3y169/5dP4CnX72YjAIY/0LPvmc+IOXpB4ogUuSukH0nmGoiX321q0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793404122;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=HnqPNRguxYyw98fii5FbLAcNDvBKLEoJMemaMes5FYk=;
	b=olCJEuC1OlDglCf9Qm2jMX0iH90aEAxiP9deib8JMAlZ19IpMlR1a4QMbOoLRJy1hn1O
	 jNZNgEtKWMzR5ToTMB6G6s9MCgMrNGRNoefgLLfY7hVg9beD5+xf8JB7QDeNdFSvHtFAF
	 7pFUwnHRj6AMHFNRpzRD+V/SdXiFyBHFktv9DJOF0UF0DO/PUhR6o9HTOyN1x8pqxwdbb
	 8GYBq+2q6xr9QauOc4n5v+bSIFI0DxFyDVMaEswaE+EcnCZFO/JnYbiRVNZUlHj/x03l9
	 nkiHEHygZRYTcjUNh7JwsAkPXQ6R6+hMpJCZmLkoYU39F1enb85ptru7MnSTGTjTrgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HoZzSSBM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B68606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 23:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HoZzSSBM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9FC1F000C1;
	Fri, 30 Oct 2026 23:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793404122;
	bh=HnqPNRguxYyw98fii5FbLAcNDvBKLEoJMemaMes5FYk=;
	h=Date:To:From:Subject;
	b=HoZzSSBMg39LiFAP432VOfi9K89eraHaiEBeiF2OaeKcG6ad8BP87Gs2WnUpQLHPU
	 cCa3evFsnFpg/4tUWQYv7CQB7Hzg0u/1U8prP+8FVPE6TrmrCrYLkuyXy/HrsiT3AH
	 d24uz908pb3RgJaRatEPJNftbDwLZDPzepIwLbdo=
Date: Fri, 30 Oct 2026 16:48:41 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,roman.gushchin@linux.dev,
	muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,harry@kernel.org,
	hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-use-high_work-for-kernel-threads.patch added to mm-new branch
Message-Id: <20261030234841.EB9FC1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: memcg: use high_work for kernel threads
has been added to the -mm mm-new branch.  Its filename is
     memcg-use-high_work-for-kernel-threads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-use-high_work-for-kernel-threads.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: use high_work for kernel threads
Date: Fri, 30 Oct 2026 13:54:14 -0700

Kernel threads never return to userspace, so deferred memory.high
reclaim does not run. Reclaim and throttling during a charge can also
delay work they do for other tasks.

Treat kernel threads like interrupts. Queue high_work for the first
cgroup over memory.high and skip reclaim and throttling in the charging
thread.

User workers created by create_io_thread() and vhost_task_create() keep
their current behavior. Vhost kernel threads use the new path, even when
they borrow the owner's mm.

The worker requests a fixed batch of pages each time. A fast allocator
can keep usage well above memory.high. Kernel threads also skip
memory.swap.high throttling and its high-event reporting. The memory.max
and memory.swap.max checks stay the same.

Link: https://lore.kernel.org/20261030205418.341214-4-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Harry Yoo <harry@kernel.org>
---

 mm/memcontrol.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-use-high_work-for-kernel-threads
+++ a/mm/memcontrol.c
@@ -2714,6 +2714,7 @@ static void memcg_enforce_high(struct me
 			       gfp_t gfp_mask)
 {
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	bool use_worker = !in_task() || (current->flags & PF_KTHREAD);
 
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
@@ -2732,8 +2733,12 @@ static void memcg_enforce_high(struct me
 		swap_high = page_counter_read(&memcg->swap) >
 			READ_ONCE(memcg->swap.high);
 
-		/* Don't bother a random interrupted task */
-		if (!in_task()) {
+		/*
+		 * Don't make an unrelated interrupted task handle this charge.
+		 * Kernel threads may be working for other tasks, so let a worker
+		 * reclaim instead.
+		 */
+		if (use_worker) {
 			if (mem_high) {
 				if (allow_spinning)
 					schedule_work(&memcg->high_work);
@@ -2760,6 +2765,10 @@ static void memcg_enforce_high(struct me
 		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
+	/* Interrupts and kernel threads stop here. */
+	if (use_worker)
+		return;
+
 	/*
 	 * Reclaim is set up above to be called from the userland
 	 * return path. But also attempt synchronous reclaim to avoid
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch
memcg-force-charges-from-reclaim-before-trying-the-limits.patch
memcg-use-high_work-for-kernel-threads.patch
memcg-use-high_work-for-remote-charges.patch
memcg-simplify-high-limit-handling-after-a-charge.patch


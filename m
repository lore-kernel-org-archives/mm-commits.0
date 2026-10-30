Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793404124;
	b=KeqlWS8a5MEx34PryWA+H+TGXZ2uYUVc6y/3x1t+F8ALlI5B2VEA3xxD0OdN/EY/2pf/
	 dUI0g3CQQqV/AvE9wiQscvgdgg6yNwdVD5vZSQnxEFSef2O/2073N2P7TZK++fzsbLySw
	 TjF3jgayAjo+0imY1zoEvHE49mz4mthy8EHvz8rjHmInxX74iyKht3SICJxhOeRSZ0C4s
	 yzblkbRi+RGl91oZLIe2hi4jQtmevYvBdEQSaxNJyhzeIxFAliEyF3ptn+NO45tcNK0Nb
	 QgxcoDIyX45Yts5zU0XEXfsRUoJ2+SOBKMz8jLcrMvVrED3F9DgyYnBh6D/gguRnX/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793404124;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nzKQtc8hYLI8C+8dni0o7ooE/2VwCEg7AxVfptVZBR0=;
	b=h+6QKKPVU7p4oK3UQ6gA20TLXnNxL5PzcgtjXnFXnCEHEAtiddzJ0bvXYc0LnP3fCjNE
	 EOUTMabf7tgZgsR7qspyS3LJxVSF9L0LR1Dsvn1S61XCPIKLABZpHXFCXJheVhojmsjmd
	 4L7k+Dw/IxyeXpzyua1to17sYDzuiAsvgQgvxRh94PFUP0fPG26un32W1TO1BytJgCWex
	 rF8xHNFT7zkgPaR9TolVm55lrs19Z/vZbTDwdHZGvojS6xFPlNT6KgbIdmHNRAbQqLadl
	 3EdAJNDHGTwR+tmtbjMM/FlgRhC4VtJlMZC/5ou+TSBR1x1k5cIsLIXdyidD2knWlwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y5ToOV+k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F283606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 23:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y5ToOV+k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8EE1F000C1;
	Fri, 30 Oct 2026 23:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793404123;
	bh=nzKQtc8hYLI8C+8dni0o7ooE/2VwCEg7AxVfptVZBR0=;
	h=Date:To:From:Subject;
	b=Y5ToOV+kOpe3ZBE/x6E7BXKsY7ZDuttDr1kRuPlhYoTJU+QbDFKiD/pV7Du4XZeqR
	 +vC5ygvTbX0fs+xKKJVGmr6853Seg4jhQ6oZVqsRBJzZETq7oxmZU06GEF2eCq1IsW
	 dy51O5pVT1rpARTeQOW1kHRiqX5GlMaUX36wg9BE=
Date: Fri, 30 Oct 2026 16:48:43 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,roman.gushchin@linux.dev,
	muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,harry@kernel.org,
	hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-use-high_work-for-remote-charges.patch added to mm-new branch
Message-Id: <20261030234843.CB8EE1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: memcg: use high_work for remote charges
has been added to the -mm mm-new branch.  Its filename is
     memcg-use-high_work-for-remote-charges.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-use-high_work-for-remote-charges.patch

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
Subject: memcg: use high_work for remote charges
Date: Fri, 30 Oct 2026 13:54:15 -0700

Some charges go to a cgroup outside the current mm's cgroup and its
ancestors. The high handler uses current->mm, so it cannot handle these
overages. Filesystem notifications and remote page faults can take
this path.

Use mm_match_cgroup() before checking the high limits. If it does not
match, use high_work instead of recording task overage or doing
synchronous reclaim and throttling. Charges to the current mm's cgroup
or one of its ancestors keep their current handling. Tasks without an
mm also use the worker.

Like kernel threads, remote chargers skip memory.swap.high throttling
and its high-event reporting, and a fast allocator can outrun the worker.
The memory.max and memory.swap.max checks stay the same.

Link: https://lore.kernel.org/20261030205418.341214-5-shakeel.butt@linux.dev
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

 mm/memcontrol.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-use-high_work-for-remote-charges
+++ a/mm/memcontrol.c
@@ -2714,7 +2714,8 @@ static void memcg_enforce_high(struct me
 			       gfp_t gfp_mask)
 {
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
-	bool use_worker = !in_task() || (current->flags & PF_KTHREAD);
+	bool use_worker = !in_task() || (current->flags & PF_KTHREAD) ||
+		!current->mm || !mm_match_cgroup(current->mm, memcg);
 
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
@@ -2737,6 +2738,7 @@ static void memcg_enforce_high(struct me
 		 * Don't make an unrelated interrupted task handle this charge.
 		 * Kernel threads may be working for other tasks, so let a worker
 		 * reclaim instead.
+		 * Remote charges need reclaim from their charged hierarchy.
 		 */
 		if (use_worker) {
 			if (mem_high) {
@@ -2765,7 +2767,7 @@ static void memcg_enforce_high(struct me
 		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
-	/* Interrupts and kernel threads stop here. */
+	/* Interrupts, kernel threads, and remote chargers stop here. */
 	if (use_worker)
 		return;
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch
memcg-force-charges-from-reclaim-before-trying-the-limits.patch
memcg-use-high_work-for-kernel-threads.patch
memcg-use-high_work-for-remote-charges.patch
memcg-simplify-high-limit-handling-after-a-charge.patch


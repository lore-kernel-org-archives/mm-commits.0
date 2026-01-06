Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2AA2C21FF
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 18:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725493; cv=none; b=chL42Bfu7dEuBLBVnw/2YJAn8AIW2dFIyO/UbYckFNMRbiFnefI9+CfnmcwRMtmqi9Ofgfxz4211Y016brTcCkA5d4T1B4e6NRvXbnK/sgqCSVQvl6JoOsF3qH6hPbawaVWuac4rRI+qY5rcwm6k2E12E57ZYVY23TIoH3VmBOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725493; c=relaxed/simple;
	bh=0kw52nnSWkbvgp6eGXEkPV9nN9I2fRvLmwqchYvpaYE=;
	h=Date:To:From:Subject:Message-Id; b=EFIlyxkCO/273CwVk1rd0wrxgvrlSaNweiV5lTc2DGO31BXekQTezqRbRQWOs9dhEpc+kWJNDYs75QHF/IgYluMMJZBoqvcZTrAcaO6wIjRKiFZIPXCWzgtMmAY5fGHjV3SyFvyJ4/UHNoNr8u4gGmj2WqL4KoFHSO6FEBlS1m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i0Qwjygc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i0Qwjygc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661D6C19424;
	Tue,  6 Jan 2026 18:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767725491;
	bh=0kw52nnSWkbvgp6eGXEkPV9nN9I2fRvLmwqchYvpaYE=;
	h=Date:To:From:Subject:From;
	b=i0Qwjygc6rpT3rruzP++nj46S8kZ3Iy9sl4YZInpAEMlLPFDnGcDxLxfuHtVwjFzI
	 1QNj/Dw5xaPRvkrOQv4nHjSF2d2aDkzNLcSva/IXFk4nSyIxQRma2/j+pT9KUJQRo0
	 twXJwHuD8zY+SmOCQn19Iw/l+2QHveQ4eLZK74kg=
Date: Tue, 06 Jan 2026 10:51:30 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-use-cgroup-id-instead-of-private-memcg-id-in-lru_gen-interface.patch added to mm-new branch
Message-Id: <20260106185131.661D6C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: use cgroup ID instead of private memcg ID in lru_gen interface
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-use-cgroup-id-instead-of-private-memcg-id-in-lru_gen-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-use-cgroup-id-instead-of-private-memcg-id-in-lru_gen-interface.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: mm/vmscan: use cgroup ID instead of private memcg ID in lru_gen interface
Date: Thu, 25 Dec 2025 15:21:14 -0800

The LRU gen debugfs interface was using the internal private memcg ID
which is meant for tracking kernel objects that outlive their cgroup. 
Switch to using the public cgroup ID instead.

Link: https://lkml.kernel.org/r/20251225232116.294540-7-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-use-cgroup-id-instead-of-private-memcg-id-in-lru_gen-interface
+++ a/mm/vmscan.c
@@ -5440,7 +5440,7 @@ static int lru_gen_seq_show(struct seq_f
 		if (memcg)
 			cgroup_path(memcg->css.cgroup, m->private, PATH_MAX);
 #endif
-		seq_printf(m, "memcg %5hu %s\n", mem_cgroup_id(memcg), path);
+		seq_printf(m, "memcg %llu %s\n", mem_cgroup_ino(memcg), path);
 	}
 
 	seq_printf(m, " node %5d\n", nid);
@@ -5525,7 +5525,7 @@ static int run_eviction(struct lruvec *l
 	return -EINTR;
 }
 
-static int run_cmd(char cmd, int memcg_id, int nid, unsigned long seq,
+static int run_cmd(char cmd, u64 memcg_id, int nid, unsigned long seq,
 		   struct scan_control *sc, int swappiness, unsigned long opt)
 {
 	struct lruvec *lruvec;
@@ -5536,19 +5536,12 @@ static int run_cmd(char cmd, int memcg_i
 		return -EINVAL;
 
 	if (!mem_cgroup_disabled()) {
-		rcu_read_lock();
-
-		memcg = mem_cgroup_from_id(memcg_id);
-		if (!mem_cgroup_tryget(memcg))
-			memcg = NULL;
-
-		rcu_read_unlock();
-
+		memcg = mem_cgroup_get_from_ino(memcg_id);
 		if (!memcg)
 			return -EINVAL;
 	}
 
-	if (memcg_id != mem_cgroup_id(memcg))
+	if (memcg_id != mem_cgroup_ino(memcg))
 		goto done;
 
 	sc->target_mem_cgroup = memcg;
@@ -5615,7 +5608,7 @@ static ssize_t lru_gen_seq_write(struct
 		int n;
 		int end;
 		char cmd, swap_string[5];
-		unsigned int memcg_id;
+		u64 memcg_id;
 		unsigned int nid;
 		unsigned long seq;
 		unsigned int swappiness;
@@ -5625,7 +5618,7 @@ static ssize_t lru_gen_seq_write(struct
 		if (!*cur)
 			continue;
 
-		n = sscanf(cur, "%c %u %u %lu %n %4s %n %lu %n", &cmd, &memcg_id, &nid,
+		n = sscanf(cur, "%c %llu %u %lu %n %4s %n %lu %n", &cmd, &memcg_id, &nid,
 			   &seq, &end, swap_string, &end, &opt, &end);
 		if (n < 4 || cur[end]) {
 			err = -EINVAL;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

lib-buildid-use-__kernel_read-for-sleepable-context.patch
mm-damon-core-get-memcg-reference-before-access.patch
memcg-introduce-private-id-api-for-in-kernel-users.patch
memcg-expose-mem_cgroup_ino-and-mem_cgroup_get_from_ino-unconditionally.patch
memcg-mem_cgroup_get_from_ino-returns-null-on-error.patch
memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id.patch
mm-damon-use-cgroup-id-instead-of-private-memcg-id.patch
mm-vmscan-use-cgroup-id-instead-of-private-memcg-id-in-lru_gen-interface.patch
memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch


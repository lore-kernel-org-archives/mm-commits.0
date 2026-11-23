Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415085;
	b=YKPBpC2iPxRigDoUYaXMLJ6a/49awMfMB6NTdCjtXPIaZqVOmZMIDRg/8E0Df+bNw6XW
	 tu5yYRyyF+ZIoJKfTRc+ZkD0T3+s8ggkJ0IYUFrHemsvmBWHcL8DsRbOpUUAo5QhHmVNB
	 WlnDiIpr5tfScRe1O7N09hL0nm0cX3yMj7ohmn6yNoqw1upq3Q2ouKsej+9dtBBYqSYD2
	 0wLbzmRIIaLl1GtsdXPNNhfIhyM9Mxwf4rhf6Jitw8jb0F2x3l6Xu9/imAIko8dy4a4RZ
	 cINz7WOadhgPUAkkaQ/efhiz+cFWLxqiAdWJ8xBSgczBjKMXiNmH35HtSRlD5vF3aSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415085;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Xv/GkKdmxfqAEbz3VCwV5fwsi7GITCIUvb2swD+8aoQ=;
	b=YqAOpMbHx1Uu3W+YALDEm0s+0AEBnm6Y0/1jv96QcLGbUmMhiLFVfU2joRwFlC3HCJOH
	 QhpVv59qXZxnVmmDbySCyZVEgB2QPLMGr80bSnhX4A6O/DgfeXKURPSc+zJgRfpbJJBJz
	 wP6pK+L9hwk389Izyk8oYkMDhJrokVAgR/2c0d8/o76b/DidQbbeIgzkRD3R/QEKsSMRu
	 qwEMqv1mKb1UD34jWc3YyV2DX+lGv8hY2S8L8lxbqamWGj0/9bjz2RMaEnghcJc71oKzd
	 2WmLFS3be6Qnui8X2qcK/K28nUSv5w7V6Nfee/L0IXAdgSQVNY7798K9nQ3V7EC4tcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="zS1/bDoi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D51606A31A;
	Mon, 23 Nov 2026 06:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zS1/bDoi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3DB1F000C4;
	Mon, 23 Nov 2026 06:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415084;
	bh=Xv/GkKdmxfqAEbz3VCwV5fwsi7GITCIUvb2swD+8aoQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=zS1/bDoi0BD6s7ZY706O0ivD49THaRawWU/4Y1ocsN1hce5xLofCiR/g17TaKkBmR
	 vB0hGyUN2pXn/cM7HAXX0MaUptsFDMTRDfyHJ4ByQoc32BsY/zXoB7DbOuSS5BCvCL
	 b3SYV+EyQHWovBsS2PMKEv5zapWe1fx9+B/hc5+o=
Date: Sun, 22 Nov 2026 22:24:43 -0800
To: mm-commits@vger.kernel.org,zhanxusheng1024@gmail.com,tj@kernel.org,
	stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,
	muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,
	elenchist.dev@gmail.com,bigeasy@linutronix.de,chris@chrisdown.name,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <avA1wXhTMs9eY2NF@chrisdown.name>
References: <avA1wXhTMs9eY2NF@chrisdown.name>
Subject: [merged mm-hotfixes-stable] mm-memcontrol-dont-lose-track-of-exiting-oom-victims.patch removed from -mm tree
Message-Id: <20261123062444.6C3DB1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: memcontrol: don't lose track of exiting OOM victims
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-dont-lose-track-of-exiting-oom-victims.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: mm: memcontrol: don't lose track of exiting OOM victims
Date: Sun, 08 Nov 2026 00:41:37 -0800

When oom_evaluate_task() comes across a victim we've already killed, it
backs off until the victim's mm has MMF_OOM_SKIP.  This gives the victim a
chance to free some memory before we kill anything else.  However, since
commit a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup"),
css_task_iter skips exiting tasks once signal->live reaches zero.  That
happens before exit_mm(), so a single-threaded victim can disappear from
the memcg scan while it still has all its memory.

This can kill another process when the first kill would have been enough
to recover, and we've seen it happen in production.  If the second victim
is in a cgroup with memory.oom.group enabled, the extra kill can take down
the whole workload.

In tests I used a 64 MiB memcg with swap disabled.  I started a process
that faults in 44 MiB of anonymous memory, submits a 4 KiB direct AIO read
to null_blk, and goes to sleep.  I set null_blk to take 10 seconds to
complete the read so the victim would have to wait for it in exit_aio(). 
Two seconds after starting the first process, I started a second one that
tries to fault in 40 MiB.

The 40 MiB allocation hits memory.max partway through and triggers an OOM
kill.  The OOM killer picks the first process, which has more resident
memory.  With the read still pending, the victim blocks in exit_aio()
before it can tear down its address space.

memory.events showed oom_kill 2 in three runs.  In one of them the first
process hadn't submitted the read yet when it was killed.  The slow read
just makes the window easier to hit.

The cgroup iterator hides these tasks so that cgroup.procs doesn't show
processes that waitpid() may already have reaped.  That's fine for
cgroup.procs, but the OOM scan needs to see a victim even after its last
thread has started exiting.  We already have CSS_TASK_ITER_WITH_DEAD for
sched_ext, so use it for mem_cgroup_scan_tasks() as well.

With this applied, OOM selection backs off while the first victim still
has memory to free.  The 40 MiB allocation completes and memory.events
shows oom_kill 1 in three test runs.

Link: https://patch.msgid.link/avA1wXhTMs9eY2NF@chrisdown.name
Fixes: a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: elenchist <elenchist.dev@gmail.com>
  Link: https://lore.kernel.org/6B8E9261-3FF8-441B-8F47-7D35834A8D35@gmail.com
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: <stable@vger.kernel.org>

 mm/memcontrol.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-dont-lose-track-of-exiting-oom-victims
+++ a/mm/memcontrol.c
@@ -1451,7 +1451,13 @@ void mem_cgroup_scan_tasks(struct mem_cg
 		struct css_task_iter it;
 		struct task_struct *task;
 
-		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
+		/*
+		 * An OOM victim can start exiting well before its mm is
+		 * torn down. Keep it visible so oom_evaluate_task() can
+		 * back off while there's still memory to free.
+		 */
+		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS |
+				    CSS_TASK_ITER_WITH_DEAD, &it);
 		while (!ret && (task = css_task_iter_next(&it))) {
 			ret = fn(task, arg);
 			/* Avoid potential softlockup warning */
_

Patches currently in -mm which might be from chris@chrisdown.name are

selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test.patch


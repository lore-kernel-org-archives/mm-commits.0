Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794250935;
	b=ZYmhPCzegTMA+h9DOfJ+3yQCaXADnTu2qPdDPF/Y+je/s8FbXPQJmbPUiG7TXLnHtRoe
	 /p5HJK4608341Sb02vDiVxnX85AJrZcFIvXQ4GdV7INw3noMTEAnbxD63aIJykkGchxHT
	 jt84urgs9hvWes5NAkPCWzo+gfc2tb1vGXEtHLlkp916ZqeeBYpgzbH8zsOUgbey6ixVW
	 nVr7ibRKdXZjHvtV0uEtahnoHs4BDeeeWkeCxVR8LiWghuxCT+Fh9SqXG5ImVv1NkCRj1
	 qwt09tYq3jjn4iMBIm6VlbeF6fY0tAeNZtQ6jlYhWPuGM63XOWEbj1Cu542QPrcVEMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794250935;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=NZHRv7v5lMiOq8tVmpwiL5FO2X3S4uUBj/lydAOCn/g=;
	b=VGEWL89p2WDsZ7lL2YZBGfZbuCCFHCVjY2LDgKbyNBh2yQAg4izgLqB+0am7dX/WLsHM
	 0tFwECjbMRust9qGt8HEJhSGXDYDYUjNrqE4KWRo8guO2Fw6+3wQC+1YFj3pEzHOcGDbt
	 FEhpmJxRxRXdoqtCt7PhOKLgvocoxcNNeK+r9qZ9DYzT+bNTrqQwaarxb8HkkWiIcbm/s
	 /q+VKz199Phczkyc45cdoAprVF9EPpnfmcoipzQWSdSDU1athXZFvoez35doUYWvr41OM
	 8juFPUtakg4m6lcoX2DnHGdj2tnDcqaNZj5GYuj++/l6NPZrBaBAkn5hu6eVn+rapdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=m3Llpqn2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDC6606A31C;
	Mon,  9 Nov 2026 19:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=m3Llpqn2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DB31F0089F;
	Mon,  9 Nov 2026 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794250934;
	bh=NZHRv7v5lMiOq8tVmpwiL5FO2X3S4uUBj/lydAOCn/g=;
	h=Date:To:From:Subject;
	b=m3Llpqn2mgHINOyYDu79RdwOBaZqm0IpnGezM1QNCW2jKm4SxOmKF0hR56Bhf0upR
	 Wrs6QuHSq0kCIpx6eVGmYp7haOi8DxMkT+aMVfkYjPQUbQ6Ar/XEWnUmJ+pQAFkSoe
	 KzQsmQc1iovrYLtGnrcnQ+rVwrrfWA5GnU9q84HM=
Date: Mon, 09 Nov 2026 11:02:14 -0800
To: mm-commits@vger.kernel.org,zhanxusheng1024@gmail.com,tj@kernel.org,
	stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,
	muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,
	bigeasy@linutronix.de,chris@chrisdown.name,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-dont-lose-track-of-exiting-oom-victims.patch added to mm-hotfixes-unstable branch
Message-Id: <20261109190214.B9DB31F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: memcontrol: don't lose track of exiting OOM victims
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcontrol-dont-lose-track-of-exiting-oom-victims.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-dont-lose-track-of-exiting-oom-victims.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/avA1wXhTMs9eY2NF@chrisdown.name
Fixes: a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: <stable@vger.kernel.org>
---

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

mm-memcontrol-dont-lose-track-of-exiting-oom-victims.patch


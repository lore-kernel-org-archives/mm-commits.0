Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD6B3D88EC
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 23:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783036097; cv=none; b=E5m5NHsMOQZdtO9lRmiWzPC2AaBrjpiy6Deku9Rj2us5VCmqe/2NWIQrNHXe6mbBGOEQPiOFJn+Azi7qu2crn69ZEwDIKlXZ4NDBgeoJhyL8qHGvexsVVJt7Py2UilzCmM7Sclv0awxiXL1+U53ExhAZVddoV0+MFoOKoXQ2Fvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783036097; c=relaxed/simple;
	bh=lMk0O/E/aerfvaCzgyoQ6z93dS7je8HQnQMTAsP2gCs=;
	h=Date:To:From:Subject:Message-Id; b=sTt0NXkzkw7pA0Uu601hK4kaGUFCkAfMj2aTZdKijUdr8hjLsir6vuCVLOdPxR5TGw2u+UJdUPB2WN4ZrRpL3VHOP2XVGTJP586DFGXBbEzY9CvToFm4fWpJjyxng0YAwtxge6LJ8zbDKPfINohAsiWI1jSGIfT9Mo1XSg2KPWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B3JZknmO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B3JZknmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AE71F000E9;
	Thu,  2 Jul 2026 23:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783036095;
	bh=uPFKHtLyrcRsyumf4urAd0b7CqnOIjF8rcnt0Ek22q4=;
	h=Date:To:From:Subject;
	b=B3JZknmOvcrlIBMNgIyuujUj3SHMUu2qx8Nd57L41m/XlRBxO+wXB67AR1XJ+75Z+
	 LPj8YXEFsDSUXTn0/tUvc+C0GH0ljzB7iJEKqAk2RovlGatxO6UCIQZ8y1AN4ort8v
	 k3TFdd/UDEhRdbCPw+ZQVjhfd0jbmG0xN6UZF5P0=
Date: Thu, 02 Jul 2026 16:48:14 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,yingfu.zhou@shopee.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-bail-out-memoryhigh-when-memcg-is-dying.patch added to mm-new branch
Message-Id: <20260702234815.48AE71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: bail out memory.high when memcg is dying
has been added to the -mm mm-new branch.  Its filename is
     memcg-bail-out-memoryhigh-when-memcg-is-dying.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-bail-out-memoryhigh-when-memcg-is-dying.patch

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
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: memcg: bail out memory.high when memcg is dying
Date: Thu, 2 Jul 2026 20:02:27 +0800

Patch series "memcg: bail out reclaim when memcg is dying", v3.

This series mitigates a system-wide stall we hit when a cgroup is
removed while one of its memory control files is doing synchronous
reclaim.

Problem Description
===================

Writing to memory.high, memory.max or memory.reclaim runs reclaim
synchronously in the writer's context, looping until the usage drops below
the target (or, for memory.reclaim, until the requested amount has been
reclaimed).  On a large cgroup this can take a long time.  The latency is
especially bad when reclaim has to perform swap I/O, where it is bound by
the swap device write bandwidth, and under thrashing it is effectively
unbounded - each round reclaims a few pages that the workload immediately
faults back in, so the loop keeps making "progress" and never converges.

The legacy (v1) reclaim loops in memory.limit_in_bytes,
memory.memsw.limit_in_bytes and memory.force_empty share the same pattern.

These writes go through cgroup_file_write(), which does not take
cgroup_mutex and does not pin the css.  Instead, kernfs guarantees the
node (and thus the css) stays alive for the duration of the operation by
holding an active reference.  So while the reclaim loop runs, the active
reference on the file is held.

If another task removes the same cgroup in parallel, cgroup_rmdir() takes
cgroup_mutex and then blocks in kernfs_drain() waiting for that active
reference to drain.  Because cgroup_mutex is held throughout the wait,
every other task that needs it piles up behind the remover - in our case
the whole machine ground to a halt, with hung_task reports for the remover
and for unrelated tasks merely reading /proc/<pid>/cgroup:

INFO: task cgdelete:366634 blocked for more than 159 seconds.
      Not tainted 6.6.102+ #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Call Trace:
 <TASK>
 __schedule+0x3da/0x1650
 schedule+0x58/0x100
 kernfs_drain+0xe6/0x150
 __kernfs_remove.part.0+0xd0/0x200
 kernfs_remove_by_name_ns+0x75/0xd0
 cgroup_addrm_files+0x325/0x410
 css_clear_dir+0x50/0xf0
 cgroup_destroy_locked+0xdf/0x1e0
 cgroup_rmdir+0x2d/0xd0
 kernfs_iop_rmdir+0x53/0x90
 vfs_rmdir+0x98/0x240
 do_rmdir+0x172/0x1b0
 __x64_sys_rmdir+0x42/0x70
 x64_sys_call+0xeb0/0x2210
 do_syscall_64+0x56/0x90
 entry_SYSCALL_64_after_hwframe+0x78/0xe2


INFO: task systemd-journal:2352 blocked for more than 182 seconds.
      Not tainted 6.6.102+ #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Call Trace:
 <TASK>
 __schedule+0x3da/0x1650
 schedule+0x58/0x100
 schedule_preempt_disabled+0xe/0x20
 __mutex_lock.constprop.0+0x3bb/0x640
 __mutex_lock_slowpath+0x13/0x20
 mutex_lock+0x3c/0x50
 proc_cgroup_show+0x4d/0x380
 proc_single_show+0x53/0xe0
 seq_read_iter+0x12f/0x4b0
 seq_read+0xcd/0x110
 vfs_read+0xb1/0x360
 ? __seccomp_filter+0x368/0x590
 ksys_read+0x73/0x100
 __x64_sys_read+0x19/0x30
 x64_sys_call+0x18d3/0x2210
 do_syscall_64+0x56/0x90
 entry_SYSCALL_64_after_hwframe+0x78/0xe2

The system recovers only once the reclaim finally finishes and releases
the active reference.  The reclaim itself is pointless here: the cgroup is
being torn down and its remaining pages will be reparented to the parent
anyway.

Even though we check signal_pending(current) in the reclaim loop, the
typical symptom is that cat /proc/<pid>/cgroup gets stuck.  By the time
someone looks for which task is actually stuck in reclaim, the hung task
timeout has already been hit.  This makes the problem particularly nasty
to debug from a hung-task report alone, because the blocked tasks shown
are often the victims, not the reclaim writer itself.

Our Mitigation
==============

cgroup destruction sets CSS_DYING in kill_css_sync() *before*
css_clear_dir() triggers the kernfs_drain() that blocks the remover.  The
in-flight reclaim loop is therefore guaranteed to observe it before
starting another reclaim iteration.  This series checks memcg_is_dying()
in the v2 reclaim loops (memory.high, memory.max and proactive reclaim)
and the v1 reclaim loops (memory.limit_in_bytes,
memory.memsw.limit_in_bytes and memory.force_empty), and bails out early,
so the writer drops the active reference promptly and the remover can make
progress.

Unlike the no-progress guard (MAX_RECLAIM_RETRIES), which only fires when
reclaim makes zero progress, the dying check also covers the slow swap I/O
and thrashing cases, where reclaim keeps succeeding a little and the loop
would otherwise never converge.

For memory.reclaim, bailing out because the memcg is dying means the
requested reclaim amount was not satisfied, so the write returns -EAGAIN.

This is orthogonal to commit c8e6002bd611 ("memcg: introduce non-blocking
limit setting option"): O_NONBLOCK lets a caller avoid the synchronous
reclaim up front, while this series handles the case where reclaim is
already running when the cgroup starts being removed.


This patch (of 4):

memory.high reclaims synchronously in the writer's context, and the
latency can be very high - especially when reclaim performs swap I/O, or
under thrashing where the loop may not converge for a long time.

While this runs the kernfs active reference on the file is held, so a
concurrent removal of the same cgroup blocks in kernfs_drain() under
cgroup_mutex until it finishes.  Reclaiming a dying cgroup is pointless,
as its pages are reparented to the parent anyway.

Mitigate this by bailing out of the reclaim loop once memcg_is_dying().

Link: https://lore.kernel.org/20260702120235.376752-1-jiayuan.chen@linux.dev
Link: https://lore.kernel.org/20260702120235.376752-2-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/memcontrol.c~memcg-bail-out-memoryhigh-when-memcg-is-dying
+++ a/mm/memcontrol.c
@@ -4794,6 +4794,10 @@ static ssize_t memory_high_write(struct
 		if (signal_pending(current))
 			break;
 
+		/* cgroup_rmdir() waits for us with cgroup_mutex held. */
+		if (memcg_is_dying(memcg))
+			break;
+
 		if (!drained) {
 			drain_all_stock(memcg);
 			drained = true;
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are

mm-damon-core-split-a-fraction-of-regions-when-nr_regions-exceeds-max-2.patch
mm-damon-tests-core-kunit-test-split-above-max_nr_regions-2.patch
memcg-bail-out-memoryhigh-when-memcg-is-dying.patch
memcg-bail-out-memorymax-when-memcg-is-dying.patch
memcg-bail-out-proactive-reclaim-when-memcg-is-dying.patch
memcg-v1-bail-out-reclaim-when-memcg-is-dying.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734291DFDE
	for <mm-commits@vger.kernel.org>; Thu, 30 Jul 2026 01:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785374049; cv=none; b=hpKbIdMq9YqEZbkP4aFhGqCb/dgxpKuHJPKiFcAY0DKQMGZWmRZOU6X0MUhq8MOi+0VRdknY0BIlwTmXIztNlExtQRPMKpV4nfgnDe1Zd9l9SSWiDL99LW2WzCAGESe+wV6tzhlslWq5udVx2Td0FjUae7FYlj1EYHGNgPCztsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785374049; c=relaxed/simple;
	bh=gjIjZ6nh4x6ZpRQpCB23/RqoSfl5awHUq9VS3PGXXYo=;
	h=Date:To:From:Subject:Message-Id; b=oznNSagd+Stt48AftOS5P2pm5OfUImkeQrmH67GLNs5YXyGo4frMI7RzkxnuiqQn57TGkPOikYTSra5HhbyIG/EW9ym9cHhDoGXfNOKxwj1EunNHsTLzIBY8KYgMoEq28jxlw6fX5Ir6SWpi1IlSJQ8K8rO2yMCtACb6HPB7wK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=faFDL66j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="faFDL66j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6A51F00A3A;
	Thu, 30 Jul 2026 01:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785374048;
	bh=LAiAhgu+eXWHFtXme80sf52RhX0IWHfH+ZgZl0sJkcc=;
	h=Date:To:From:Subject;
	b=faFDL66jsC0BP3cYGun/kSH2cXr2Ma+sEk9oaJ+eHWHFT2Lo1CvW3OOC1MJzwuzjK
	 9gNzGN1uFsFNUREklu9miEgpWplE464hfK0bmqOFpMEy7A2nkreRw2yVcYcjFeqSpu
	 gPqFIoFFteCC5IR5emw1VKXZeKKgE2rfP5mNbj0o=
Date: Wed, 29 Jul 2026 18:14:07 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,roman.gushchin@linux.dev,rientjes@google.com,riel@surriel.com,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-bypass-the-reclaim-and-oom-killer-for-dying-tasks-once-oom_reaper-is-done.patch added to mm-new branch
Message-Id: <20260730011408.1F6A51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: bypass the reclaim and oom killer for dying tasks once oom_reaper is done
has been added to the -mm mm-new branch.  Its filename is
     memcg-bypass-the-reclaim-and-oom-killer-for-dying-tasks-once-oom_reaper-is-done.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-bypass-the-reclaim-and-oom-killer-for-dying-tasks-once-oom_reaper-is-done.patch

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
Subject: memcg: bypass the reclaim and oom killer for dying tasks once oom_reaper is done
Date: Tue, 28 Jul 2026 19:46:12 -0700

At Meta, we are seeing instances where an OOM killed job is stuck in the
exit path for several hours.  In one particular case, the job was stuck
for more than 8 hours and I had to manually remove the memory.max limits
to allow the process to exit.

The job was a single process job and had ~55 GiB memory.max and zswap
enabled.  It had almost 0 anon in memory and ~111 GiB in zswap compressed
to ~51 GiB zswap pool (i.e.  almost all of memory.current was zswap). 
Nothing was left on the LRUs to reclaim.

On further inspection, I observed ~20k threads of that process stuck with
the following stack:

[<0>] mem_cgroup_out_of_memory+0x4e/0xa0
[<0>] charge_memcg+0x8bf/0x990
[<0>] mem_cgroup_swapin_charge_folio+0x4e/0x80
[<0>] __read_swap_cache_async+0x10c/0x260
[<0>] swapin_readahead+0x116/0x3f0
[<0>] do_swap_page+0x13c/0x1ce0
[<0>] handle_mm_fault+0x61d/0x11f0
[<0>] do_user_addr_fault+0x3e7/0x6d0
[<0>] exc_page_fault+0x8f/0x110
[<0>] asm_exc_page_fault+0x22/0x30
[<0>] __get_user_8+0x14/0x20
[<0>] futex_cleanup+0x27/0x1c0
[<0>] futex_exit_release+0x47/0x60
[<0>] do_exit+0x107/0x940
[<0>] do_group_exit+0x81/0xa0
[<0>] get_signal+0x2b1/0x6e0
[<0>] arch_do_signal_or_restart+0x1a/0x1c0
[<0>] exit_to_user_mode_loop+0xa8/0x1c0
[<0>] do_syscall_64+0x152/0x250
[<0>] entry_SYSCALL_64_after_hwframe+0x4b/0x53

In addition the dmesg was filled with "Out of memory and no killable
processes..." messages.

I have no idea why oom reaper was not able to reap/unmap the process.  My
guess is that since oom reaper tries to acquire mmap_lock in read mode
limited number of times and then gives up, there might be a thread of that
process which had mmap_lock in write mode at that time.

My initial suspicion was the futex_cleanup and kernel page fault causing
infinite fault and charge retries but that was put to rest in previous
discussions happened on similar problem [1].

My current theory is that it is just a simple slow serialization behind
the oom_lock.  Unlike page allocator, memcg charge code takes the oom_lock
without the "try".  Though memcg oom code uses mutex_lock_killable(), note
that in the call stack get_signal() consumes SIGKILL (or
sigdelset(SIGKILL)) before calling do_group_exit().  So this
mutex_lock_killable() is just a mutex_lock() here.  Therefore 10s of
thousands of threads are waiting on oom_lock and one by one they get
-EFAULT from get_user() in the futex cleanup code and bails out.

Discussion from [1] led to commit a75ffa26122b ("memcg, oom: do not bypass
oom killer for dying tasks") which routes dying tasks into the OOM path
precisely so the oom_reaper can reap their mm and free the memory
asynchronously.  But the reaper is best-effort and one-shot: if it cannot
take mmap_lock for read (e.g.  a sibling thread holds it for write) it
sets MMF_OOM_SKIP and never retries, leaving only the glacial
oom_lock-serialized synchronous drain.

Once MMF_OOM_SKIP is set there is no more asynchronous reclaim coming for
the mm, so a dying task charging against it has nothing left to wait for:
it frees its memory only once it finishes exiting.  Running reclaim and
the (no-victim) OOM killer for it is then pointless, and doing it for 10s
of thousands of exiting threads is what serializes them behind oom_lock. 
So before reclaim, if current is an OOM victim whose reaper is done, fail
the charge.

Reproduced with 20k threads, each parking a robust futex head on its own
zswapped page, OOM-group-killed while a sibling holds mmap_lock for write
so the reaper gives up and sets MMF_OOM_SKIP.  Tested on next-20260728 and
baseline show ~90 seconds exit time while with the patch the exit time
reduced to ~3 seconds.

Link: https://lore.kernel.org/20260729024612.3369005-1-shakeel.butt@linux.dev
Link: https://lore.kernel.org/7a4e5591f45df455e6a485fc5400989569d3d22d.camel@surriel.com/ [1]
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/memcontrol.c~memcg-bypass-the-reclaim-and-oom-killer-for-dying-tasks-once-oom_reaper-is-done
+++ a/mm/memcontrol.c
@@ -2693,6 +2693,19 @@ retry:
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
+	/*
+	 * OOM victim still needs to charge memory to exit. OOM reaper should
+	 * help but it might fail on mmap_lock contention. If the victim is a
+	 * large thread group then all exiting threads might compete on oom_lock
+	 * just to learn that there is nothing really killable anymore. Bail
+	 * out early and fail the charge to expedite their exit. They are
+	 * considered fully reclaimed by the oom reaper and they shouldn't
+	 * contribute further charges.
+	 */
+	if (tsk_is_oom_victim(current) &&
+	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
+		goto nomem;
+
 	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 	raised_max_event = true;
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-bypass-the-reclaim-and-oom-killer-for-dying-tasks-once-oom_reaper-is-done.patch


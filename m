Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D0F2853F3;
	Sat,  8 Aug 2026 07:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786174796; cv=none; b=rncqnkL/TIMx9O/VL0ejgzkaUy/tFTeBd/panHqigfNw8k8yM0/3ywd8wRLCwNP7R9PtwOUmp78Q5ES60WDDN89CByTYouT5vcYzxThTAtLFUFjIGEa8eoyP/B9EWwPybT2N4AIV+16LqbjxsbAlk+8rOWHlPrLfp+kepFJjR+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786174796; c=relaxed/simple;
	bh=5Uz/4jZqi7acQJTemN21hjwjwe126XpTueTHR+e7tFA=;
	h=Date:To:From:Subject:Message-Id; b=f2R/Sn1h8Wlns9j5eRow8YIfinQShzj1uwI41WWvbvRjS7+bnAN7DzAiDaHiU+1jjJZJeViVRikoSdnazCDbC9VElKqq+IucQuLisMCVhAy1g21M1OAZij2ebhxEdfs8HQjnBPx8ccQyURiQXjpc7GrfJRIVgWZKNOEiizosXnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qDFxcO44; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qDFxcO44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570B11F000E9;
	Sat,  8 Aug 2026 07:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786174794;
	bh=9BTOeNsTB3YDvmba8T9+VxowMzp4D/f7zHUAEthGP/0=;
	h=Date:To:From:Subject;
	b=qDFxcO44QekmHdlPzBUDDsHzckWIjJpB3W1MTLijfTcaillvAGdYpW96SSas0tvzx
	 Xt4xxF6H0FgWThbofiApYQoZLCxksoQqgiIRiR2ufJSlmlhLtosCzqNhplf/75EU3H
	 2EIwwiiJ5BKHztrRO15oOvg6Dqx69uNYniK9aAyM=
Date: Sat, 08 Aug 2026 00:39:53 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,qiang1.zhang@intel.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,sh_def@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-cache-shrink-race-with-cpu-hotplug.patch added to mm-new branch
Message-Id: <20260808073954.570B11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: fix cache shrink race with CPU hotplug
has been added to the -mm mm-new branch.  Its filename is
     kasan-fix-cache-shrink-race-with-cpu-hotplug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fix-cache-shrink-race-with-cpu-hotplug.patch

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
From: Hui Su <sh_def@163.com>
Subject: kasan: fix cache shrink race with CPU hotplug
Date: Sat, 8 Aug 2026 11:14:59 +0800

kasan_quarantine_remove_cache() first invokes per_cpu_remove_cache() on
all online CPUs.  Each callback moves objects belonging to the cache from
cpu_quarantine to the CPU's shrink_qlist, where they can later be freed
from task context.

kmem_cache_destroy() invokes the quarantine removal path while holding
cpus_read_lock(), but kmem_cache_shrink() does not.  The latter can
therefore race with CPU offlining as follows:

  kmem_cache_shrink()             CPU hotplug
  -------------------             -----------
  on_each_cpu()
    CPU1 moves objects to
    CPU1's shrink_qlist
  on_each_cpu() returns
                                  CPU1 goes offline
                                  kasan_cpu_offline()
                                    drains cpu_quarantine
                                    leaves shrink_qlist untouched
  for_each_online_cpu()
    skips CPU1

The objects left on CPU1's shrink_qlist are not returned to the slab
allocator.  This may prevent kmem_cache_shrink() from releasing slabs that
would otherwise become empty.  If CPU1 remains offline, a later
kmem_cache_destroy() also skips the list and can report that the cache
still contains objects.

An intermittent occurrence was observed with a virtio-9p filesystem.  The
mount and umount commands both returned 0, but the kernel logged the
following during the userspace-triggered teardown:

  [  2994.380134][  T111] BUG 9p-fcall-cache-1 (Tainted: G    B              ): Objects remaining on __kmem_cache_shutdown()
  [  2994.381140][  T111] Object 0xff11000004361118 @offset=4376
  [  2994.381607][  T111] Allocated in p9_fcall_init+0x201/0x400 age=19564 cpu=1 pid=104
  [  2994.382591][  T111]  p9_fcall_init+0x201/0x400
  [  2994.382810][  T111]  p9_tag_alloc+0x12f/0x700
  [  2994.382982][  T111]  p9_client_prepare_req+0x102/0x3e0
  [  2994.383165][  T111]  p9_client_rpc+0x1ab/0xa50
  [  2994.383334][  T111]  p9_client_getattr_dotl+0xb0/0x1a0
  [  2994.383515][  T111]  v9fs_vfs_getattr_dotl+0x115/0x360
  [  2994.383719][  T111]  vfs_getattr_nosec+0x22c/0x3a0
  [  2994.383910][  T111]  vfs_statx+0xd7/0x170
  [  2994.384062][  T111]  vfs_fstatat+0x45/0x80
  [  2994.384215][  T111]  __do_sys_newfstatat+0x84/0xe0
  [  2994.384386][  T111]  do_syscall_64+0x115/0x6a0
  [  2994.384566][  T111]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  [  2994.399720][  T111] WARNING: mm/slub.c:1244 at __kmem_cache_shutdown+0x363/0x500, CPU#0: busybox/111
  [  2994.405655][  T111] Call Trace:
  [  2994.406325][  T111]  kmem_cache_destroy+0x73/0x1b0
  [  2994.406630][  T111]  p9_client_destroy+0x271/0x3c0
  [  2994.407210][  T111]  v9fs_session_close+0x3c/0x260
  [  2994.407409][  T111]  v9fs_kill_super+0x48/0x90
  [  2994.407584][  T111]  deactivate_locked_super+0xa3/0x160
  [  2994.407778][  T111]  cleanup_mnt+0x1dd/0x3e0

Thus, a successful umount left objects in the 9p fcall cache and prevented
the cache from being destroyed cleanly.

Per-CPU shrink_qlist storage exists for every possible CPU, and each list
is protected by its own raw spinlock.  Iterate over possible CPUs so that
a list populated before its CPU went offline is drained as well.

for_each_possible_cpu() can do more work than for_each_online_cpu(), but
this change only affects CONFIG_KASAN_GENERIC kernels.  The extra work is
limited to cache shrink and cache destruction paths and does not affect
the normal allocation/free fast path.  It adds one raw-spinlock-protected
scan of each possible CPU's shrink list.  These lists are normally empty;
a non-empty list is traversed to remove objects belonging to the cache
being shrunk or destroyed.

Link: https://lore.kernel.org/20260808031459.3032812-1-sh_def@163.com
Fixes: 07d067e4f2ce ("kasan: fix sleeping function called from invalid context on RT kernel")
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: "Zhang, Qiang1" <qiang1.zhang@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/kasan/quarantine.c~kasan-fix-cache-shrink-race-with-cpu-hotplug
+++ a/mm/kasan/quarantine.c
@@ -355,7 +355,12 @@ void kasan_quarantine_remove_cache(struc
 	 */
 	on_each_cpu(per_cpu_remove_cache, cache, 1);
 
-	for_each_online_cpu(cpu) {
+	/*
+	 * A CPU can go offline after on_each_cpu() returns, leaving cache
+	 * objects on that CPU's shrink list. Scan all possible CPUs to
+	 * drain those lists.
+	 */
+	for_each_possible_cpu(cpu) {
 		sq = per_cpu_ptr(&shrink_qlist, cpu);
 		raw_spin_lock_irqsave(&sq->lock, flags);
 		qlist_move_cache(&sq->qlist, &to_free, cache);
_

Patches currently in -mm which might be from sh_def@163.com are

kasan-fix-cache-shrink-race-with-cpu-hotplug.patch


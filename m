Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793254323;
	b=335lYqdazNZCsJWDTfS0dsPrykJXJWix+QXcfYEM1tJL3HEMEeEpfeMBEXf4Ktlr0Sth
	 UW97sZd3zXv+xH5Gb6HUYL/l8L/ZyuO6ye1bxZeExNm3QuT3SGkbYevBIoJtttkbK4Aar
	 iII7rsC9hqFjFhjjNiRrEtVqbkBmiljDIkGHG26zcxE8JRox6mHUsEfxn9FkXcQ83u6W2
	 arSKH5qdefMraipsWHiUaahT5v9m30u00CIoNxLQpUW1ofr2KzfP66LPUPXfwEdPeCb6n
	 L513g8pMlpy8OfrsbNUDoxn5QzPJ5zbCSdaN9VOpceSwLPTDWf4/PPsjGUGBL4kQuLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793254323;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=UH19xTwkUHpf8SWNMTOSMoFEJ28fGTT//iFlhNpvEdA=;
	b=r+TMOO7KrV9gTkMmQGdSxImR6iQ1KGODZ5wCbzKSyqqeBg07WaIAVt5Q9i9w99l4ysR5
	 nFtTErzji7MJNGmNoSgdoUQ/S/GWd88Y/HJpcv0UfsRRoHrJeVZiMspFyzY/7rpQRB0gJ
	 w2l4ZonUIF5fhO4QceIKXkVqpjzGJ50OSeQl648Po/hA8o0puer3pKFbUy0hhE3RROR3s
	 W06KTLngsE0ZhLCWTBtrengJfmo0cD88pIYuqHCyDVJtFSCYaJoVKQvueeeuIfJLvVDYh
	 nEHfspZQBMIRdk205vDWny3k6LtlVBlp6wneIo3EpAFeN1tR1nE7P2rt7NQaJ9ozOEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SOG8P1MK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AE260A5BD3
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 06:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SOG8P1MK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BD41F031E2;
	Thu, 29 Oct 2026 06:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793254311;
	bh=UH19xTwkUHpf8SWNMTOSMoFEJ28fGTT//iFlhNpvEdA=;
	h=Date:To:From:Subject;
	b=SOG8P1MKOkF3twVzOrC3YG/XMTEvQYE3t/aR5NSz70QyYbhx+Nlx7pKK981TeLwrP
	 SKLVVsTISdfHulNhqOXSQgUFSH3m6nOAqzYsKwF5vZaXliPlnOm+X9Ah7803knZamz
	 FgTvAaw3rcZVCATeSQxEsyaGZDvhc02H74jeQljA=
Date: Wed, 28 Oct 2026 23:11:51 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	david@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-annotate-data-race-in-zone_page_state_snapshot.patch added to mm-new branch
Message-Id: <20261029061151.A3BD41F031E2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vmstat: annotate data race in zone_page_state_snapshot()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmstat-annotate-data-race-in-zone_page_state_snapshot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-annotate-data-race-in-zone_page_state_snapshot.patch

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
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm/vmstat: annotate data race in zone_page_state_snapshot()
Date: Wed, 28 Oct 2026 18:05:49 +0800

KCSAN reports a data-race on v6.6 which also exists on mainline:

BUG: KCSAN: data-race in zone_page_state_snapshot root/klinux/./include/linux/vmstat.h:232 [inline]
BUG: KCSAN: data-race in allow_direct_reclaim+0x150/0x290 root/klinux/mm/vmscan.c:6328

race at unknown origin, with read to 0xffff9e0575410740 of 1 bytes by task 209280 on cpu 15:
zone_page_state_snapshot root/klinux/./include/linux/vmstat.h:232 [inline]
allow_direct_reclaim+0x150/0x290 root/klinux/mm/vmscan.c:6328
throttle_direct_reclaim+0x1c4/0x480 root/klinux/mm/vmscan.c:6402
try_to_free_pages+0x177/0x590 root/klinux/mm/vmscan.c:6466
__perform_reclaim root/klinux/mm/page_alloc.c:3966 [inline]
__alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3988 [inline]
__alloc_pages_slowpath.constprop.0+0x3b3/0xdf0 root/klinux/mm/page_alloc.c:4395
__alloc_pages_noprof+0x28a/0x2d0 root/klinux/mm/page_alloc.c:4794
alloc_pages_mpol_noprof+0x181/0x470 root/klinux/mm/mempolicy.c:2270
alloc_pages_noprof+0x7a/0xe0 root/klinux/mm/mempolicy.c:2347
io_mem_alloc_compound root/klinux/io_uring/io_uring.c:2848 [inline]
io_pages_map+0xb9/0x330 root/klinux/io_uring/io_uring.c:2892
io_allocate_scq_urings+0x231/0x300 root/klinux/io_uring/io_uring.c:3933
io_uring_create+0x29c/0x9c0 root/klinux/io_uring/io_uring.c:4091
io_uring_setup+0xb6/0x100 root/klinux/io_uring/io_uring.c:4203
__do_sys_io_uring_setup root/klinux/io_uring/io_uring.c:4230 [inline]
__se_sys_io_uring_setup root/klinux/io_uring/io_uring.c:4224 [inline]
__x64_sys_io_uring_setup+0x66/0xe0 root/klinux/io_uring/io_uring.c:4224
x64_sys_call+0x1816/0x1d90 root/klinux/./arch/x86/include/generated/asm/syscalls_64.h:426
do_syscall_x64 root/klinux/arch/x86/entry/common.c:51 [inline]
do_syscall_64+0x70/0x2a0 root/klinux/arch/x86/entry/common.c:81
entry_SYSCALL_64_after_hwframe+0x76/0xe0

value changed: 0xdd -> 0xb6

Reported by Kernel Concurrency Sanitizer on:
CPU: 15 PID: 209280 Comm: syz-executor.13 Tainted: G S ------- ---- 6.6.89+ #1250
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014

Found by KCSAN testing on an older kernel; the same race still exists on
mainline.

zone_page_state_snapshot() sums the per-cpu vm_stat_diff[] deltas of all
online CPUs with a plain load, while the allocation and free fast paths
update the local delta through this_cpu_cmpxchg() and friends.  Those are
inline asm, and page_alloc.o is excluded from KCSAN, so the writer is not
instrumented and the report is of unknown origin.

The race is benign: the function already documents that the result cannot be
exactly accurate, and every consumer is a reclaim or compaction heuristic
that tolerates an estimate.  Annotate the read with data_race(), following
commit af1c31acc853 ("mm/vmstat: annotate data race for
zone->free_area[order].nr_free").

No functional change intended.

Link: https://lore.kernel.org/20261028100549.70689-1-hui.zhu@linux.dev
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 include/linux/vmstat.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/include/linux/vmstat.h~mm-vmstat-annotate-data-race-in-zone_page_state_snapshot
+++ a/include/linux/vmstat.h
@@ -236,9 +236,15 @@ static inline unsigned long zone_page_st
 	long x = atomic_long_read(&zone->vm_stat[item]);
 
 #ifdef CONFIG_SMP
+	struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
 	int cpu;
+
 	for_each_online_cpu(cpu)
-		x += per_cpu_ptr(zone->per_cpu_zonestats, cpu)->vm_stat_diff[item];
+		/*
+		 * Access to vm_stat_diff is lockless as the result is only
+		 * an estimate. Use data_race to avoid KCSAN warning.
+		 */
+		x += data_race(per_cpu_ptr(pzstats, cpu)->vm_stat_diff[item]);
 
 	if (x < 0)
 		x = 0;
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-vmstat-annotate-data-race-in-zone_page_state_snapshot.patch


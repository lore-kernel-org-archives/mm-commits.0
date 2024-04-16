Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E5D1E511;
	Tue, 16 Apr 2024 22:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307227; cv=none; b=cfnMT4iWY94q2ZoJXu19/i5Ojlp6dvwmhBCMsFD4lIeMYGrBmjOKmlZTQOS6bJbfOfWmWH+LFrbI74O3nxsWZGOS4D2q8k8Qyu4YmtixgBmspn0GrBGeT7o2xtxwZ85ZZxh9ih/lmJFB0NsNmG/GvFzSpeTtFBmZDGzR/EDhFh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307227; c=relaxed/simple;
	bh=niFwnjEYEbhbR2Fy1aE7abCDLMSGKHqho+qHDRjrLZY=;
	h=Date:To:From:Subject:Message-Id; b=L+cSoU0f6BNKEFZ+BbtxZolefPcnr06lXLTsmcG9MsCVkKNnL9hGePEkL79WavMkyD7z7nbBXMc0SwqkjHpuRHaenva19H4ug+MfXR3QIlcFck0S6ikxXg9TUY8+dYWlPBZkx1dSJA/abVkpvbt4dpukzXGXh+6x2YphvvEL1s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z/lt4wHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z/lt4wHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD74C113CE;
	Tue, 16 Apr 2024 22:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713307226;
	bh=niFwnjEYEbhbR2Fy1aE7abCDLMSGKHqho+qHDRjrLZY=;
	h=Date:To:From:Subject:From;
	b=Z/lt4wHbTwdJ3AtoPernsTiTfZ9Dd9E3x7bpNVcRBVXJ2oRc3zAbdC5CPxi+/oCMr
	 1e8xMKUdHlRwVcppaaWTz7pfI9xEwN9vkiwrSJo0q9RRJDv4UiE3RN4y39VexnZ9WP
	 RDEJP3dRGPOzTW7znIZS3Qd5k94kFvYjvcl7tRtw=
Date: Tue, 16 Apr 2024 15:40:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,jane.chu@oracle.com,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled.patch removed from -mm tree
Message-Id: <20240416224026.7FD74C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: fix deadlock when hugetlb_optimize_vmemmap is enabled
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: fix deadlock when hugetlb_optimize_vmemmap is enabled
Date: Sun, 7 Apr 2024 16:54:56 +0800

When I did hard offline test with hugetlb pages, below deadlock occurs:

======================================================
WARNING: possible circular locking dependency detected
6.8.0-11409-gf6cef5f8c37f #1 Not tainted
------------------------------------------------------
bash/46904 is trying to acquire lock:
ffffffffabe68910 (cpu_hotplug_lock){++++}-{0:0}, at: static_key_slow_dec+0x16/0x60

but task is already holding lock:
ffffffffabf92ea8 (pcp_batch_high_lock){+.+.}-{3:3}, at: zone_pcp_disable+0x16/0x40

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (pcp_batch_high_lock){+.+.}-{3:3}:
       __mutex_lock+0x6c/0x770
       page_alloc_cpu_online+0x3c/0x70
       cpuhp_invoke_callback+0x397/0x5f0
       __cpuhp_invoke_callback_range+0x71/0xe0
       _cpu_up+0xeb/0x210
       cpu_up+0x91/0xe0
       cpuhp_bringup_mask+0x49/0xb0
       bringup_nonboot_cpus+0xb7/0xe0
       smp_init+0x25/0xa0
       kernel_init_freeable+0x15f/0x3e0
       kernel_init+0x15/0x1b0
       ret_from_fork+0x2f/0x50
       ret_from_fork_asm+0x1a/0x30

-> #0 (cpu_hotplug_lock){++++}-{0:0}:
       __lock_acquire+0x1298/0x1cd0
       lock_acquire+0xc0/0x2b0
       cpus_read_lock+0x2a/0xc0
       static_key_slow_dec+0x16/0x60
       __hugetlb_vmemmap_restore_folio+0x1b9/0x200
       dissolve_free_huge_page+0x211/0x260
       __page_handle_poison+0x45/0xc0
       memory_failure+0x65e/0xc70
       hard_offline_page_store+0x55/0xa0
       kernfs_fop_write_iter+0x12c/0x1d0
       vfs_write+0x387/0x550
       ksys_write+0x64/0xe0
       do_syscall_64+0xca/0x1e0
       entry_SYSCALL_64_after_hwframe+0x6d/0x75

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(pcp_batch_high_lock);
                               lock(cpu_hotplug_lock);
                               lock(pcp_batch_high_lock);
  rlock(cpu_hotplug_lock);

 *** DEADLOCK ***

5 locks held by bash/46904:
 #0: ffff98f6c3bb23f0 (sb_writers#5){.+.+}-{0:0}, at: ksys_write+0x64/0xe0
 #1: ffff98f6c328e488 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0xf8/0x1d0
 #2: ffff98ef83b31890 (kn->active#113){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x100/0x1d0
 #3: ffffffffabf9db48 (mf_mutex){+.+.}-{3:3}, at: memory_failure+0x44/0xc70
 #4: ffffffffabf92ea8 (pcp_batch_high_lock){+.+.}-{3:3}, at: zone_pcp_disable+0x16/0x40

stack backtrace:
CPU: 10 PID: 46904 Comm: bash Kdump: loaded Not tainted 6.8.0-11409-gf6cef5f8c37f #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x68/0xa0
 check_noncircular+0x129/0x140
 __lock_acquire+0x1298/0x1cd0
 lock_acquire+0xc0/0x2b0
 cpus_read_lock+0x2a/0xc0
 static_key_slow_dec+0x16/0x60
 __hugetlb_vmemmap_restore_folio+0x1b9/0x200
 dissolve_free_huge_page+0x211/0x260
 __page_handle_poison+0x45/0xc0
 memory_failure+0x65e/0xc70
 hard_offline_page_store+0x55/0xa0
 kernfs_fop_write_iter+0x12c/0x1d0
 vfs_write+0x387/0x550
 ksys_write+0x64/0xe0
 do_syscall_64+0xca/0x1e0
 entry_SYSCALL_64_after_hwframe+0x6d/0x75
RIP: 0033:0x7fc862314887
Code: 10 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
RSP: 002b:00007fff19311268 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007fc862314887
RDX: 000000000000000c RSI: 000056405645fe10 RDI: 0000000000000001
RBP: 000056405645fe10 R08: 00007fc8623d1460 R09: 000000007fffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000c
R13: 00007fc86241b780 R14: 00007fc862417600 R15: 00007fc862416a00

In short, below scene breaks the lock dependency chain:

 memory_failure
  __page_handle_poison
   zone_pcp_disable -- lock(pcp_batch_high_lock)
   dissolve_free_huge_page
    __hugetlb_vmemmap_restore_folio
     static_key_slow_dec
      cpus_read_lock -- rlock(cpu_hotplug_lock)

Fix this by calling drain_all_pages() instead.

This issue won't occur until commit a6b40850c442 ("mm: hugetlb: replace
hugetlb_free_vmemmap_enabled with a static_key").  As it introduced
rlock(cpu_hotplug_lock) in dissolve_free_huge_page() code path while
lock(pcp_batch_high_lock) is already in the __page_handle_poison().

[linmiaohe@huawei.com: extend comment per Oscar]
[akpm@linux-foundation.org: reflow block comment]
Link: https://lkml.kernel.org/r/20240407085456.2798193-1-linmiaohe@huawei.com
Fixes: a6b40850c442 ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled with a static_key")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled
+++ a/mm/memory-failure.c
@@ -154,11 +154,23 @@ static int __page_handle_poison(struct p
 {
 	int ret;
 
-	zone_pcp_disable(page_zone(page));
+	/*
+	 * zone_pcp_disable() can't be used here. It will
+	 * hold pcp_batch_high_lock and dissolve_free_huge_page() might hold
+	 * cpu_hotplug_lock via static_key_slow_dec() when hugetlb vmemmap
+	 * optimization is enabled. This will break current lock dependency
+	 * chain and leads to deadlock.
+	 * Disabling pcp before dissolving the page was a deterministic
+	 * approach because we made sure that those pages cannot end up in any
+	 * PCP list. Draining PCP lists expels those pages to the buddy system,
+	 * but nothing guarantees that those pages do not get back to a PCP
+	 * queue if we need to refill those.
+	 */
 	ret = dissolve_free_huge_page(page);
-	if (!ret)
+	if (!ret) {
+		drain_all_pages(page_zone(page));
 		ret = take_page_off_buddy(page);
-	zone_pcp_enable(page_zone(page));
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are



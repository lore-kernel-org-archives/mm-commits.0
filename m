Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C815A1448E2;
	Mon,  8 Apr 2024 19:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712604604; cv=none; b=nL7wc0s93EFMMChPnLATPB0eO8NA3WPb3IvQxzhLkpJ0UcbO6YdjqhOpS99gLXoomBU+F0bVvULAtHqh6PvvEfyH8N4tE3ydwG2fCwUjzyjO07wp5Sgz2sJubGjeTe6phPbQalmq2uCVqEhZchIiphT4gvhOgnmYAB7nkQuZTK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712604604; c=relaxed/simple;
	bh=xX128ydMsg0JrC/Hg3WvWKD0QwN7gJ26CnmWwtEW2vw=;
	h=Date:To:From:Subject:Message-Id; b=I1xFmX1KJ8AZtYlUcqrHYkgdy6Splc/NSjslxaNQ4SdRwREX/DRig4q29Odcf/hRmpX4dA8m21x819eU0nklMqmH0WecfOt9cZokluERMY6B4CfRqMfc8Nvc1RdMGPCcB+6bKhCCqrLP6zdbNjwE3b0wCOoU9qPkmjBtqOIrL9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fSAGcUIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fSAGcUIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C547C433C7;
	Mon,  8 Apr 2024 19:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712604604;
	bh=xX128ydMsg0JrC/Hg3WvWKD0QwN7gJ26CnmWwtEW2vw=;
	h=Date:To:From:Subject:From;
	b=fSAGcUIrrbdmeo4R2oiO+z7kOxg21dE3smjB1KGKNjFi7JaKtuiAc6Rkw5IvQ2cVo
	 Vizdt3SyvfHEeU2OipLfAX4gEE5/3dXnVhSo5lJeMQIG3A/4b1A2XE3hxoZ4CfLE71
	 8zbVsqmuxyTmtpmefftdc6t4EVOI1Esz5NRg4NWk=
Date: Mon, 08 Apr 2024 12:30:03 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,naoya.horiguchi@nec.com,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled.patch added to mm-hotfixes-unstable branch
Message-Id: <20240408193004.7C547C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: fix deadlock when hugetlb_optimize_vmemmap is enabled
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

Link: https://lkml.kernel.org/r/20240407085456.2798193-1-linmiaohe@huawei.com
Fixes: 510d25c92ec4a ("mm/hwpoison: disable pcp for page_handle_poison()")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled
+++ a/mm/memory-failure.c
@@ -154,11 +154,17 @@ static int __page_handle_poison(struct p
 {
 	int ret;
 
-	zone_pcp_disable(page_zone(page));
+	/*
+	 * zone_pcp_disable() can't be used here. It will hold pcp_batch_high_lock and
+	 * dissolve_free_huge_page() might hold cpu_hotplug_lock via static_key_slow_dec()
+	 * when hugetlb vmemmap optimization is enabled. This will break current lock
+	 * dependency chain and leads to deadlock.
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

mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled.patch


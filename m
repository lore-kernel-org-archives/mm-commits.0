Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134D8107B2;
	Fri, 19 Apr 2024 21:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713561128; cv=none; b=sfAGww9ELMZZxe/W//QowV7qEgZQd2yjkeNnrmAEL9U4+k4J6CFMkzs7eUrVAGPF+D7FLqqk76GAoo+5L8Npxg0E4OnANbor+1TOF/jnGb/YPsAc+7wJARTLzhBqU6o/fHSL/aNaqkr1iBJM17Z5OitsLAc+qnA8xiMBvgOIsGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713561128; c=relaxed/simple;
	bh=paOwNNaJQx2fFbQ4/IW5ROiDIEogw/laSZEbUOJEBuY=;
	h=Date:To:From:Subject:Message-Id; b=o6juOh24HJOyb0NBLAHEo61+31f+kdGFX6NPAKX0T6JQinx+MHMQA2Ioj6tYx2cPE49TXsFKwcsxxez6iwN8/YKhzjLV7wdj6etw3UMBxs/FNmCJnkUB9eBYv4ttKWnlfF5kRL6MPcfKJY4zXF5EG6iSW3EVaM+31l52yPkuRsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MTjFQmE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MTjFQmE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A917C072AA;
	Fri, 19 Apr 2024 21:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713561127;
	bh=paOwNNaJQx2fFbQ4/IW5ROiDIEogw/laSZEbUOJEBuY=;
	h=Date:To:From:Subject:From;
	b=MTjFQmE9oap3L/V8loy2GN9NiVjYYiwbjofXzAN9vawlSz24I0XmS9DcFMuL4wnQc
	 tuxb8IRDJ3gAZ96kJluVQxnqa2OVqx8G/4H8N/0IOj9F6JcUj4Oy4YbZ97FnmdvUab
	 nHZUg7Vj9PVlV6YZ2nJQoBdoZo6+0Ignc8znzqrs=
Date: Fri, 19 Apr 2024 14:12:06 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-debug_locks_warn_on1-when-dissolve_free_hugetlb_folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20240419211207.6A917C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix DEBUG_LOCKS_WARN_ON(1) when dissolve_free_hugetlb_folio()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-debug_locks_warn_on1-when-dissolve_free_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-debug_locks_warn_on1-when-dissolve_free_hugetlb_folio.patch

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
Subject: mm/hugetlb: fix DEBUG_LOCKS_WARN_ON(1) when dissolve_free_hugetlb_folio()
Date: Fri, 19 Apr 2024 16:58:19 +0800

When I did memory failure tests recently, below warning occurs:

DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 8 PID: 1011 at kernel/locking/lockdep.c:232 __lock_acquire+0xccb/0x1ca0
Modules linked in: mce_inject hwpoison_inject
CPU: 8 PID: 1011 Comm: bash Kdump: loaded Not tainted 6.9.0-rc3-next-20240410-00012-gdb69f219f4be #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
RIP: 0010:__lock_acquire+0xccb/0x1ca0
RSP: 0018:ffffa7a1c7fe3bd0 EFLAGS: 00000082
RAX: 0000000000000000 RBX: eb851eb853975fcf RCX: ffffa1ce5fc1c9c8
RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffffa1ce5fc1c9c0
RBP: ffffa1c6865d3280 R08: ffffffffb0f570a8 R09: 0000000000009ffb
R10: 0000000000000286 R11: ffffffffb0f2ad50 R12: ffffa1c6865d3d10
R13: ffffa1c6865d3c70 R14: 0000000000000000 R15: 0000000000000004
FS:  00007ff9f32aa740(0000) GS:ffffa1ce5fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff9f3134ba0 CR3: 00000008484e4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 lock_acquire+0xbe/0x2d0
 _raw_spin_lock_irqsave+0x3a/0x60
 hugepage_subpool_put_pages.part.0+0xe/0xc0
 free_huge_folio+0x253/0x3f0
 dissolve_free_huge_page+0x147/0x210
 __page_handle_poison+0x9/0x70
 memory_failure+0x4e6/0x8c0
 hard_offline_page_store+0x55/0xa0
 kernfs_fop_write_iter+0x12c/0x1d0
 vfs_write+0x380/0x540
 ksys_write+0x64/0xe0
 do_syscall_64+0xbc/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff9f3114887
RSP: 002b:00007ffecbacb458 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007ff9f3114887
RDX: 000000000000000c RSI: 0000564494164e10 RDI: 0000000000000001
RBP: 0000564494164e10 R08: 00007ff9f31d1460 R09: 000000007fffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000c
R13: 00007ff9f321b780 R14: 00007ff9f3217600 R15: 00007ff9f3216a00
 </TASK>
Kernel panic - not syncing: kernel: panic_on_warn set ...
CPU: 8 PID: 1011 Comm: bash Kdump: loaded Not tainted 6.9.0-rc3-next-20240410-00012-gdb69f219f4be #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 panic+0x326/0x350
 check_panic_on_warn+0x4f/0x50
 __warn+0x98/0x190
 report_bug+0x18e/0x1a0
 handle_bug+0x3d/0x70
 exc_invalid_op+0x18/0x70
 asm_exc_invalid_op+0x1a/0x20
RIP: 0010:__lock_acquire+0xccb/0x1ca0
RSP: 0018:ffffa7a1c7fe3bd0 EFLAGS: 00000082
RAX: 0000000000000000 RBX: eb851eb853975fcf RCX: ffffa1ce5fc1c9c8
RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffffa1ce5fc1c9c0
RBP: ffffa1c6865d3280 R08: ffffffffb0f570a8 R09: 0000000000009ffb
R10: 0000000000000286 R11: ffffffffb0f2ad50 R12: ffffa1c6865d3d10
R13: ffffa1c6865d3c70 R14: 0000000000000000 R15: 0000000000000004
 lock_acquire+0xbe/0x2d0
 _raw_spin_lock_irqsave+0x3a/0x60
 hugepage_subpool_put_pages.part.0+0xe/0xc0
 free_huge_folio+0x253/0x3f0
 dissolve_free_huge_page+0x147/0x210
 __page_handle_poison+0x9/0x70
 memory_failure+0x4e6/0x8c0
 hard_offline_page_store+0x55/0xa0
 kernfs_fop_write_iter+0x12c/0x1d0
 vfs_write+0x380/0x540
 ksys_write+0x64/0xe0
 do_syscall_64+0xbc/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff9f3114887
RSP: 002b:00007ffecbacb458 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007ff9f3114887
RDX: 000000000000000c RSI: 0000564494164e10 RDI: 0000000000000001
RBP: 0000564494164e10 R08: 00007ff9f31d1460 R09: 000000007fffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000c
R13: 00007ff9f321b780 R14: 00007ff9f3217600 R15: 00007ff9f3216a00
 </TASK>

After git bisecting and digging into the code, I believe the root cause is
that _deferred_list field of folio is unioned with _hugetlb_subpool field.
In __update_and_free_hugetlb_folio(), folio->_deferred_list is
initialized leading to corrupted folio->_hugetlb_subpool when folio is
hugetlb.  Later free_huge_folio() will use _hugetlb_subpool and above
warning happens.

But it is assumed hugetlb flag must have been cleared when calling
folio_put() in update_and_free_hugetlb_folio().  This assumption is broken
due to below race:

CPU1					CPU2
dissolve_free_huge_page			update_and_free_pages_bulk
 update_and_free_hugetlb_folio		 hugetlb_vmemmap_restore_folios
					  folio_clear_hugetlb_vmemmap_optimized
  clear_flag = folio_test_hugetlb_vmemmap_optimized
  if (clear_flag) <-- False, it's already cleared.
   __folio_clear_hugetlb(folio) <-- Hugetlb is not cleared.
  folio_put
   free_huge_folio <-- free_the_page is expected.
					 list_for_each_entry()
					  __folio_clear_hugetlb <-- Too late.

Fix this issue by checking whether folio is hugetlb directly instead of
checking clear_flag to close the race window.

Link: https://lkml.kernel.org/r/20240419085819.1901645-1-linmiaohe@huawei.com
Fixes: 32c877191e02 ("hugetlb: do not clear hugetlb dtor until allocating vmemmap")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-debug_locks_warn_on1-when-dissolve_free_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -1781,7 +1781,7 @@ static void __update_and_free_hugetlb_fo
 	 * If vmemmap pages were allocated above, then we need to clear the
 	 * hugetlb destructor under the hugetlb lock.
 	 */
-	if (clear_dtor) {
+	if (folio_test_hugetlb(folio)) {
 		spin_lock_irq(&hugetlb_lock);
 		__clear_hugetlb_destructor(h, folio);
 		spin_unlock_irq(&hugetlb_lock);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-fix-debug_locks_warn_on1-when-dissolve_free_hugetlb_folio.patch


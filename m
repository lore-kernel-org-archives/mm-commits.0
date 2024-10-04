Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707C225570
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 16:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728060679; cv=none; b=rWfrEhvFJzyEpKRM2yrYvl3y+R58sf0JQo+TTI2DH/PEaW4Uc3cpkBz0KgbwTpWSYkyMSYX18gcW7RhVEHh6/DycCKCh9p6bdBMZwBqjRiB1lJoXUP1p4tT2HQ0cNMuoppdhnnszFm4jLDDHv4jTbXIO0eCGDVvkNRLcnbeDIC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728060679; c=relaxed/simple;
	bh=CxxKykbVU1zqlhwv7EJaj80bzfJc3bHxD+77gbHA0/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:In-Reply-To:
	 Content-Type:References; b=MI2ch6PNnri5qiFvEKhXEWm3lQbBipHrb6IWe4hNtWa1OGkzb1r2V31lHz4QBHzfqBCM7QdSSjBISNe+J/ea2KU4zW//5glqlsObwn66mXKlzKE5XyJzA/stLSeaEspnRWIO62GMoReEkgdL9bsgHp0Tyx4kVzyjMHYMtcfqkEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=tLMa5syD; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tLMa5syD"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20241004165107euoutp01b8b29f299436376e11e4682cf45c3400~7TgVfFvE13154331543euoutp01C
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 16:51:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20241004165107euoutp01b8b29f299436376e11e4682cf45c3400~7TgVfFvE13154331543euoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728060667;
	bh=nZDnZHd/VMEA+X9S9+2qXYsONNu6blqoAR4Hxiwy0HQ=;
	h=Date:Subject:To:From:In-Reply-To:References:From;
	b=tLMa5syDNN0FS8K1X7DNCKkW97+a+Biptl6LfQ5QOGcClDF8y61ehSaurmU2orYEt
	 abJ2DeBk3qItmnayHr+vgtkRZxMfiNn8M//iNW6f7H/grF067Udqw1p2wlBOh9DXAq
	 gHxRDVuyz/TQHMpFtboUcIpCoG3ZIKOr84SVR5Vo=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20241004165106eucas1p13be584b247551ec827d783a391973947~7TgUncnQU2254422544eucas1p1M;
	Fri,  4 Oct 2024 16:51:06 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 5A.9E.09624.9FC10076; Fri,  4
	Oct 2024 17:51:05 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20241004165105eucas1p1f21dfe36e7b1f0384126534dcbbd36c4~7TgUQ5Piv2418124181eucas1p1T;
	Fri,  4 Oct 2024 16:51:05 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241004165105eusmtrp2ec1d1687edc797929ddd60283ecab2cc~7TgUPzFCM2525825258eusmtrp2c;
	Fri,  4 Oct 2024 16:51:05 +0000 (GMT)
X-AuditID: cbfec7f2-c11ff70000002598-9a-67001cf90b6e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 7A.D8.14621.9FC10076; Fri,  4
	Oct 2024 17:51:05 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241004165104eusmtip2300bd03afc8993725cf8f2d0f10114b0~7TgTXDawR0477704777eusmtip2S;
	Fri,  4 Oct 2024 16:51:04 +0000 (GMT)
Message-ID: <c96e6f1b-3abf-454a-8236-360a845b25e9@samsung.com>
Date: Fri, 4 Oct 2024 18:51:04 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-mremap-prevent-racing-change-of-old-pmd-type.patch added
 to mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	willy@infradead.org, stable@vger.kernel.org, hughd@google.com,
	david@redhat.com, jannh@google.com
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20241002224416.42F20C4CEC2@smtp.kernel.org>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsWy7djP87o/ZRjSDc4ftbSYs34Nm8XX9b+Y
	LZ5+6mOxuHRS1+L1xAusFgs2PmK0+P1jDpsDu8eCTaUem1doeZyY8ZvF4/2+q2wenzfJBbBG
	cdmkpOZklqUW6dslcGU0nF7NXrDJomJa9wu2Bsa5Bl2MnBwSAiYSXfveMXYxcnEICaxglJjS
	1MwO4XxhlLjwahErhPOZUWLb3LWsMC1NL9pZIBLLGSW6vn2BqvrIKPHh/2Z2kCpeATuJXy+f
	A1VxcLAIqEgs2WoJERaUODnzCQuILSogL3H/1gywcmGBbIkvbc3MIHNEBDYwSuzsn8wMkmAW
	EJe49WQ+E4jNJmAo0fW2iw3E5hSwlGhZ1M8EUSMv0bx1NlizhMAFDon2Y/uZIE51kdh4YAcb
	hC0s8er4FnYIW0bi/06QoSAN7YwSC37fh3ImMEo0PL/FCFFlLXHn3C82kBeYBTQl1u/Shwg7
	Sqw89o0ZJCwhwCdx460gxBF8EpO2TYcK80p0tAlBVKtJzDq+Dm7twQuXmCFsD4k5p98yT2BU
	nIUULrOQvDwLyWuzEG5YwMiyilE8tbQ4Nz212DAvtVyvODG3uDQvXS85P3cTIzABnf53/NMO
	xrmvPuodYmTiYDzEKMHBrCTCO2/73zQh3pTEyqrUovz4otKc1OJDjNIcLErivKop8qlCAumJ
	JanZqakFqUUwWSYOTqkGpgnJh4zl5/EH86tevHu59o4sf9LLnlMKGw6cZrz7/tFpTseau9yn
	jn+TObBEheelpOr9Dx/dHS9PyzDhtyuf+KLf+s65GNX92d2G5r8TAg/9nPHL7d5agcOxnaxK
	ch9Vu/xiZKYUVJtbhZTOmfaiNGwJs94XyZrfi4uFo5+7ffv1TteX68Nby9USYdXBhj11IYob
	ale/Vmm7LSgrb6jImbhTxX3ZPJv/ekfeLM2cFOmw0efBI+WdUz99+exTtoX154EXnz4nRz54
	1nBhpkammub2kiCnS1MeubL1Fqjrm721WXnY6/OsWaw9P7cE2O5I3jvlgJrw4jq9H8fe+8UU
	Cr9XvK68xD3H3bo6Ve+wrxJLcUaioRZzUXEiACB2xsevAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t/xe7o/ZRjSDW6dULKYs34Nm8XX9b+Y
	LZ5+6mOxuHRS1+L1xAusFgs2PmK0+P1jDpsDu8eCTaUem1doeZyY8ZvF4/2+q2wenzfJBbBG
	6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZmSrp29mkpOZklqUW6dsl6GU0nF7N
	XrDJomJa9wu2Bsa5Bl2MnBwSAiYSTS/aWboYuTiEBJYySjTfvssCkZCRODmtgRXCFpb4c62L
	DaLoPaPE/IuvGEESvAJ2Er9ePgdq4OBgEVCRWLLVEiIsKHFy5hOwOaIC8hL3b81gB7GFBbIl
	Jk/YzwwyR0RgA6PEyv1TmUESQgIWEjte/QMrYhYQl7j1ZD4TiM0mYCjR9RZkMScHp4ClRMui
	fiaIGjOJrq1djBC2vETz1tnMExgFZyHZPQvJqFlIWmYhaVnAyLKKUSS1tDg3PbfYUK84Mbe4
	NC9dLzk/dxMjMK62Hfu5eQfjvFcf9Q4xMnEwHmKU4GBWEuGdt/1vmhBvSmJlVWpRfnxRaU5q
	8SFGU6D/JzJLiSbnAyM7ryTe0MzA1NDEzNLA1NLMWEmc1+3y+TQhgfTEktTs1NSC1CKYPiYO
	TqkGpqzf8nvqXptYRUz/ldTGfVCm9ZC2fhW3W0qsa3ewQsKXH3F3PzE0nlJ5r82f6LtCf+lL
	+4PT1iSr/nvsUrEu4D9L4omUS/1bVafcWJquHO7HoSYXtPX7DGEWh2kVDvrdp1zjbzTdSHIv
	zGBa3XfwEqc848zfxqcCQuRMVuZnti7sf3/zln1b8atVX6X0LXzuvZZ8Vj7f6uL/ZY+vcKxk
	M1FpOv9Is+yR0Sb/usdFTKcM+aTlmaoenWs12uJyW9RadrXpfL/P635OEJy74ejCh2KpR7Me
	rrCtKznwU/Lh9reN8/cWvNHSi7hxR8+M4yAH//01QmY24e082gs5J8WnZHYwHLC4uC7mvKkj
	86pfSizFGYmGWsxFxYkAB4lcWDQDAAA=
X-CMS-MailID: 20241004165105eucas1p1f21dfe36e7b1f0384126534dcbbd36c4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20241004165105eucas1p1f21dfe36e7b1f0384126534dcbbd36c4
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241004165105eucas1p1f21dfe36e7b1f0384126534dcbbd36c4
References: <20241002224416.42F20C4CEC2@smtp.kernel.org>
	<CGME20241004165105eucas1p1f21dfe36e7b1f0384126534dcbbd36c4@eucas1p1.samsung.com>

Dear All,

The original mail with this patch is not available in lore, so I decided 
to reply this one.

On 03.10.2024 00:44, Andrew Morton wrote:
> The patch titled
>       Subject: mm/mremap: prevent racing change of old pmd type
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       mm-mremap-prevent-racing-change-of-old-pmd-type.patch
>
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-prevent-racing-change-of-old-pmd-type.patch
>
> This patch will later appear in the mm-hotfixes-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Jann Horn <jannh@google.com>
> Subject: mm/mremap: prevent racing change of old pmd type
> Date: Wed, 02 Oct 2024 23:07:06 +0200
>
> Prevent move_normal_pmd() in mremap() from racing with
> retract_page_tables() in MADVISE_COLLAPSE such that
>
>      pmd_populate(mm, new_pmd, pmd_pgtable(pmd))
>
> operates on an empty source pmd, causing creation of a new pmd which maps
> physical address 0 as a page table.
>
> This bug is only reachable if either CONFIG_READ_ONLY_THP_FOR_FS is set or
> THP shmem is usable.  (Unprivileged namespaces can be used to set up a
> tmpfs that can contain THP shmem pages with "huge=advise".)
>
> If userspace triggers this bug *in multiple processes*, this could likely
> be used to create stale TLB entries pointing to freed pages or cause
> kernel UAF by breaking an invariant the rmap code relies on.
>
> Fix it by moving the rmap locking up so that it covers the span from
> reading the PMD entry to moving the page table.
>
> Link: https://lkml.kernel.org/r/20241002-move_normal_pmd-vs-collapse-fix-v1-1-78290e5dece6@google.com
> Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
> Signed-off-by: Jann Horn <jannh@google.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

This patch landed in today's linux-next as commit 46c1b3279220 
("mm/mremap: prevent racing change of old pmd type"). In my tests I 
found that it introduces a lockdep warning about possible circular 
locking dependency on ARM64 machines. Reverting $subject together with 
commits a2fbe16f45a8 ("mm: mremap: move_ptes() use 
pte_offset_map_rw_nolock()") and 46c1b3279220 ("mm/mremap: prevent 
racing change of old pmd type") on top of next-20241004 fixes this problem.

Here is the observed lockdep warning:

Freeing unused kernel memory: 13824K
Run /sbin/init as init process

======================================================
WARNING: possible circular locking dependency detected
6.12.0-rc1+ #15391 Not tainted
------------------------------------------------------
init/1 is trying to acquire lock:
ffff000006943588 (&anon_vma->rwsem){+.+.}-{3:3}, at: vma_prepare+0x70/0x158

but task is already holding lock:
ffff0000048c9970 (&mapping->i_mmap_rwsem){+.+.}-{3:3}, at: 
vma_prepare+0x28/0x158

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&mapping->i_mmap_rwsem){+.+.}-{3:3}:
        down_write+0x50/0xe8
        dma_resv_lockdep+0x140/0x300
        do_one_initcall+0x68/0x300
        kernel_init_freeable+0x28c/0x50c
        kernel_init+0x20/0x1d8
        ret_from_fork+0x10/0x20

-> #1 (fs_reclaim){+.+.}-{0:0}:
        fs_reclaim_acquire+0xd0/0xe4
        __alloc_pages_noprof+0xe4/0x10d0
        alloc_pages_mpol_noprof+0x88/0x23c
        alloc_pages_noprof+0x48/0xc0
        __pud_alloc+0x44/0x254
        alloc_new_pud.constprop.0+0x154/0x160
        move_page_tables+0x1b0/0xc38
        relocate_vma_down+0xe4/0x1f8
        setup_arg_pages+0x190/0x370
        load_elf_binary+0x370/0x15c4
        bprm_execve+0x290/0x7a0
        kernel_execve+0xf8/0x16c
        run_init_process+0xa8/0xbc
        kernel_init+0xec/0x1d8
        ret_from_fork+0x10/0x20

-> #0 (&anon_vma->rwsem){+.+.}-{3:3}:
        __lock_acquire+0x1374/0x2224
        lock_acquire+0x200/0x340
        down_write+0x50/0xe8
        vma_prepare+0x70/0x158
        __split_vma+0x26c/0x388
        vma_modify+0x45c/0x7f4
        vma_modify_flags+0x90/0xc4
        mprotect_fixup+0x8c/0x2c0
        do_mprotect_pkey+0x2a8/0x464
        __arm64_sys_mprotect+0x20/0x30
        invoke_syscall+0x48/0x110
        el0_svc_common.constprop.0+0x40/0xe8
        do_el0_svc_compat+0x20/0x3c
        el0_svc_compat+0x44/0xe0
        el0t_32_sync_handler+0x98/0x148
        el0t_32_sync+0x194/0x198

other info that might help us debug this:

Chain exists of:
   &anon_vma->rwsem --> fs_reclaim --> &mapping->i_mmap_rwsem

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&mapping->i_mmap_rwsem);
                                lock(fs_reclaim);
lock(&mapping->i_mmap_rwsem);
   lock(&anon_vma->rwsem);

  *** DEADLOCK ***

2 locks held by init/1:
  #0: ffff000006998188 (&mm->mmap_lock){++++}-{3:3}, at: 
do_mprotect_pkey+0xb4/0x464
  #1: ffff0000048c9970 (&mapping->i_mmap_rwsem){+.+.}-{3:3}, at: 
vma_prepare+0x28/0x158

stack backtrace:
CPU: 1 UID: 0 PID: 1 Comm: init Not tainted 6.12.0-rc1+ #15391
Hardware name: linux,dummy-virt (DT)
Call trace:
  dump_backtrace+0x94/0xec
  show_stack+0x18/0x24
  dump_stack_lvl+0x90/0xd0
  dump_stack+0x18/0x24
  print_circular_bug+0x298/0x37c
  check_noncircular+0x15c/0x170
  __lock_acquire+0x1374/0x2224
  lock_acquire+0x200/0x340
  down_write+0x50/0xe8
  vma_prepare+0x70/0x158
  __split_vma+0x26c/0x388
  vma_modify+0x45c/0x7f4
  vma_modify_flags+0x90/0xc4
  mprotect_fixup+0x8c/0x2c0
  do_mprotect_pkey+0x2a8/0x464
  __arm64_sys_mprotect+0x20/0x30
  invoke_syscall+0x48/0x110
  el0_svc_common.constprop.0+0x40/0xe8
  do_el0_svc_compat+0x20/0x3c
  el0_svc_compat+0x44/0xe0
  el0t_32_sync_handler+0x98/0x148
  el0t_32_sync+0x194/0x198
INIT: version 2.88 booting

> ...

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


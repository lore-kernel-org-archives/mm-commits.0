Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5C923D291
	for <mm-commits@vger.kernel.org>; Tue,  5 Aug 2025 20:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754425779; cv=none; b=a+Sfe0ZGeUQpSl9C/zMEdUstkYKhEgAv4TECt6rhAIqEQZ/YclJBpgoZt4/RxGVq5TENzbw0sQU2kX1ABm2+c8a0LhcKG6N9Aq3jpVrs1BN7r+vyQlbvBscORZ0OUwzt3ZO2qYfTjfX+xP5jpL3alip5KDkhh/DXNywmDUPoTNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754425779; c=relaxed/simple;
	bh=Q7/qY093mDsIQU4b8begwokBIx+oBe8m21r72gOELwk=;
	h=Date:To:From:Subject:Message-Id; b=Y2AX1BfjGxBsZwJDvZ69ylkMGxo5Ja7bskNrqUy0DqSrXUQ06Vklp3o8gSqv3bftHwS4JfQqYHFMasrsXn+waEkbek2Gee8rRNRUylNFD3qIZlkzvzNctIjVeGcfv4f5lrFaFUxqgjugM1Ov4Zj+n05HyU9pEmNUE98rpcxiagM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Onm7JSph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Onm7JSph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2652C4CEF0;
	Tue,  5 Aug 2025 20:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754425779;
	bh=Q7/qY093mDsIQU4b8begwokBIx+oBe8m21r72gOELwk=;
	h=Date:To:From:Subject:From;
	b=Onm7JSphasYuMHXUmFMdg4GtUvRODp3fRLJCQ8rM3l9HZVTtbf9daklXiL0XYCuRp
	 oVMBihwO2EyDi/ZN1HHgKwtH1V5yC3WmvWIAoVYtjw9jMZpGOUZR8xF/hLjobcz88h
	 nTSlK0ZUztUg5nAxiUYqR1XWe7044nbVWDkEx3Ng=
Date: Tue, 05 Aug 2025 13:29:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengtangquan@oppo.com,zhengqi.arch@bytedance.com,yi1.lai@linux.intel.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,jannh@google.com,ioworker0@gmail.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-the-race-between-collapse-and-pt_reclaim-under-per-vma-lock.patch removed from -mm tree
Message-Id: <20250805202938.E2652C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix the race between collapse and PT_RECLAIM under per-vma lock
has been removed from the -mm tree.  Its filename was
     mm-fix-the-race-between-collapse-and-pt_reclaim-under-per-vma-lock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: fix the race between collapse and PT_RECLAIM under per-vma lock
Date: Tue, 5 Aug 2025 11:54:47 +0800

The check_pmd_still_valid() call during collapse is currently only
protected by the mmap_lock in write mode, which was sufficient when
pt_reclaim always ran under mmap_lock in read mode.  However, since
madvise_dontneed can now execute under a per-VMA lock, this assumption is
no longer valid.  As a result, a race condition can occur between collapse
and PT_RECLAIM, potentially leading to a kernel panic.

 [   38.151897] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASI
 [   38.153519] KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
 [   38.154605] CPU: 0 UID: 0 PID: 721 Comm: repro Not tainted 6.16.0-next-20250801-next-2025080 #1 PREEMPT(voluntary)
 [   38.155929] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org4
 [   38.157418] RIP: 0010:kasan_byte_accessible+0x15/0x30
 [   38.158125] Code: 03 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 48 b8 00 00 00 00 00 fc0
 [   38.160461] RSP: 0018:ffff88800feef678 EFLAGS: 00010286
 [   38.161220] RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 1ffffffff0dde60c
 [   38.162232] RDX: 0000000000000000 RSI: ffffffff85da1e18 RDI: dffffc0000000003
 [   38.163176] RBP: ffff88800feef698 R08: 0000000000000001 R09: 0000000000000000
 [   38.164195] R10: 0000000000000000 R11: ffff888016a8ba58 R12: 0000000000000018
 [   38.165189] R13: 0000000000000018 R14: ffffffff85da1e18 R15: 0000000000000000
 [   38.166100] FS:  0000000000000000(0000) GS:ffff8880e3b40000(0000) knlGS:0000000000000000
 [   38.167137] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [   38.167891] CR2: 00007f97fadfe504 CR3: 0000000007088005 CR4: 0000000000770ef0
 [   38.168812] PKRU: 55555554
 [   38.169275] Call Trace:
 [   38.169647]  <TASK>
 [   38.169975]  ? __kasan_check_byte+0x19/0x50
 [   38.170581]  lock_acquire+0xea/0x310
 [   38.171083]  ? rcu_is_watching+0x19/0xc0
 [   38.171615]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
 [   38.172343]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
 [   38.173130]  _raw_spin_lock+0x38/0x50
 [   38.173707]  ? __pte_offset_map_lock+0x1a2/0x3c0
 [   38.174390]  __pte_offset_map_lock+0x1a2/0x3c0
 [   38.174987]  ? __pfx___pte_offset_map_lock+0x10/0x10
 [   38.175724]  ? __pfx_pud_val+0x10/0x10
 [   38.176308]  ? __sanitizer_cov_trace_const_cmp1+0x1e/0x30
 [   38.177183]  unmap_page_range+0xb60/0x43e0
 [   38.177824]  ? __pfx_unmap_page_range+0x10/0x10
 [   38.178485]  ? mas_next_slot+0x133a/0x1a50
 [   38.179079]  unmap_single_vma.constprop.0+0x15b/0x250
 [   38.179830]  unmap_vmas+0x1fa/0x460
 [   38.180373]  ? __pfx_unmap_vmas+0x10/0x10
 [   38.180994]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
 [   38.181877]  exit_mmap+0x1a2/0xb40
 [   38.182396]  ? lock_release+0x14f/0x2c0
 [   38.182929]  ? __pfx_exit_mmap+0x10/0x10
 [   38.183474]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
 [   38.184188]  ? mutex_unlock+0x16/0x20
 [   38.184704]  mmput+0x132/0x370
 [   38.185208]  do_exit+0x7e7/0x28c0
 [   38.185682]  ? __this_cpu_preempt_check+0x21/0x30
 [   38.186328]  ? do_group_exit+0x1d8/0x2c0
 [   38.186873]  ? __pfx_do_exit+0x10/0x10
 [   38.187401]  ? __this_cpu_preempt_check+0x21/0x30
 [   38.188036]  ? _raw_spin_unlock_irq+0x2c/0x60
 [   38.188634]  ? lockdep_hardirqs_on+0x89/0x110
 [   38.189313]  do_group_exit+0xe4/0x2c0
 [   38.189831]  __x64_sys_exit_group+0x4d/0x60
 [   38.190413]  x64_sys_call+0x2174/0x2180
 [   38.190935]  do_syscall_64+0x6d/0x2e0
 [   38.191449]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

This patch moves the vma_start_write() call to precede
check_pmd_still_valid(), ensuring that the check is also properly
protected by the per-VMA lock.

Link: https://lkml.kernel.org/r/20250805035447.7958-1-21cnbao@gmail.com
Fixes: a6fde7add78d ("mm: use per_vma lock for MADV_DONTNEED")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Tested-by: "Lai, Yi" <yi1.lai@linux.intel.com>
Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
Closes: https://lore.kernel.org/all/aJAFrYfyzGpbm+0m@ly-workstation/
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-fix-the-race-between-collapse-and-pt_reclaim-under-per-vma-lock
+++ a/mm/khugepaged.c
@@ -1172,11 +1172,11 @@ static int collapse_huge_page(struct mm_
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
+	vma_start_write(vma);
 	result = check_pmd_still_valid(mm, address, pmd);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 
-	vma_start_write(vma);
 	anon_vma_lock_write(vma->anon_vma);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are



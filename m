Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4E317C235
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340899; cv=none; b=lw7ZYC4o4P1n/yK6JuJNjMFLknYXKXWB7CPsnxAmOuSKQ0Hrg2ppgIuNNvIG4pVN17nSC5/h3x0Ryl/9g4DUz7mGvDhar7xisPtBP5Zn5fHegwsRuGbsD9TL3Ah7wDEyKjzwEWVtFTsQ69HcbhHcdSGFx1PYn/6OzccmSNbfwv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340899; c=relaxed/simple;
	bh=Uq9WtBGK8zFAhYskZ6sGNBGLcs7ZzV6prxGaZtiwKuE=;
	h=Date:To:From:Subject:Message-Id; b=vBKJJMAn0KS23fPCP9AoamPCmdk/x63JBYuHgV6m7n5de9gtGyDGir0ZY+R9Lb6+NiMJJMkDglFRN3WnOgz9fhabhPv2YSfACd9IERrO9fq7xUNatYSjxMQidMGWlDAsDmBbHn3CpQDXvc9yLeqypAB76AarSI08sIC4pv1lNVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vj3XhbL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vj3XhbL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E67C4AF0A;
	Tue, 25 Jun 2024 18:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719340899;
	bh=Uq9WtBGK8zFAhYskZ6sGNBGLcs7ZzV6prxGaZtiwKuE=;
	h=Date:To:From:Subject:From;
	b=Vj3XhbL+p3HiUFNhp4x85zhJGsul38g7aNzG4ULwZdDwLvyeIJDg3T+iT0j2ic2iw
	 +QbwjrDfkWSqaW/Jz3EWsBjgPexxddmTI4q07b461V/S9Sg1cGi+ZZT/v7cr23XwcV
	 VOpNOaOg6+kTuxqru+OPIx0KI6ej6+QTXnU8BhgU=
Date: Tue, 25 Jun 2024 11:41:38 -0700
To: mm-commits@vger.kernel.org,zhenyzha@redhat.com,willy@infradead.org,torvalds@linux-foundation.org,stable@kernel.org,hughd@google.com,djwong@kernel.org,david@redhat.com,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-skip-to-allocate-pmd-sized-folios-if-needed.patch added to mm-unstable branch
Message-Id: <20240625184139.47E67C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: skip to allocate PMD-sized folios if needed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-skip-to-allocate-pmd-sized-folios-if-needed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-skip-to-allocate-pmd-sized-folios-if-needed.patch

This patch will later appear in the mm-unstable branch at
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
From: Gavin Shan <gshan@redhat.com>
Subject: mm/filemap: skip to allocate PMD-sized folios if needed
Date: Tue, 25 Jun 2024 19:06:44 +1000

On ARM64, HPAGE_PMD_ORDER is 13 when the base page size is 64KB.  The
PMD-sized page cache can't be supported by xarray as the following error
messages indicate.

------------[ cut here ]------------
WARNING: CPU: 35 PID: 7484 at lib/xarray.c:1025 xas_split_alloc+0xf8/0x128
Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib  \
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct    \
nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4    \
ip_set rfkill nf_tables nfnetlink vfat fat virtio_balloon drm      \
fuse xfs libcrc32c crct10dif_ce ghash_ce sha2_ce sha256_arm64      \
sha1_ce virtio_net net_failover virtio_console virtio_blk failover \
dimlib virtio_mmio
CPU: 35 PID: 7484 Comm: test Kdump: loaded Tainted: G W 6.10.0-rc5-gavin+ #9
Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20240524-1.el9 05/24/2024
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : xas_split_alloc+0xf8/0x128
lr : split_huge_page_to_list_to_order+0x1c4/0x720
sp : ffff800087a4f6c0
x29: ffff800087a4f6c0 x28: ffff800087a4f720 x27: 000000001fffffff
x26: 0000000000000c40 x25: 000000000000000d x24: ffff00010625b858
x23: ffff800087a4f720 x22: ffffffdfc0780000 x21: 0000000000000000
x20: 0000000000000000 x19: ffffffdfc0780000 x18: 000000001ff40000
x17: 00000000ffffffff x16: 0000018000000000 x15: 51ec004000000000
x14: 0000e00000000000 x13: 0000000000002000 x12: 0000000000000020
x11: 51ec000000000000 x10: 51ece1c0ffff8000 x9 : ffffbeb961a44d28
x8 : 0000000000000003 x7 : ffffffdfc0456420 x6 : ffff0000e1aa6eb8
x5 : 20bf08b4fe778fca x4 : ffffffdfc0456420 x3 : 0000000000000c40
x2 : 000000000000000d x1 : 000000000000000c x0 : 0000000000000000
Call trace:
 xas_split_alloc+0xf8/0x128
 split_huge_page_to_list_to_order+0x1c4/0x720
 truncate_inode_partial_folio+0xdc/0x160
 truncate_inode_pages_range+0x1b4/0x4a8
 truncate_pagecache_range+0x84/0xa0
 xfs_flush_unmap_range+0x70/0x90 [xfs]
 xfs_file_fallocate+0xfc/0x4d8 [xfs]
 vfs_fallocate+0x124/0x2e8
 ksys_fallocate+0x4c/0xa0
 __arm64_sys_fallocate+0x24/0x38
 invoke_syscall.constprop.0+0x7c/0xd8
 do_el0_svc+0xb4/0xd0
 el0_svc+0x44/0x1d8
 el0t_64_sync_handler+0x134/0x150
 el0t_64_sync+0x17c/0x180

Fix it by skipping to allocate PMD-sized page cache when its size is
larger than MAX_PAGECACHE_ORDER.  For this specific case, we will fall to
regular path where the readahead window is determined by BDI's sysfs file
(read_ahead_kb).

Link: https://lkml.kernel.org/r/20240625090646.1194644-3-gshan@redhat.com
Fixes: 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zhenyu Zhang <zhenyzha@redhat.com>
Cc: <stable@kernel.org>	[5.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-skip-to-allocate-pmd-sized-folios-if-needed
+++ a/mm/filemap.c
@@ -3124,7 +3124,7 @@ static struct file *do_sync_mmap_readahe
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	/* Use the readahead code, even if readahead is disabled */
-	if (vm_flags & VM_HUGEPAGE) {
+	if ((vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
 		ra->size = HPAGE_PMD_NR;
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-filemap-make-max_pagecache_order-acceptable-to-xarray.patch
mm-filemap-skip-to-allocate-pmd-sized-folios-if-needed.patch
mm-readahead-limit-page-cache-size-in-page_cache_ra_order.patch
mm-shmem-disable-pmd-sized-page-cache-if-needed.patch


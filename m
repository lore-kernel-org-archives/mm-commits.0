Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A939B148FE4
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340903; cv=none; b=AOY9Oqgim7vmWy/A8J0cqmv0wyEqc9IlDuYE8o6taY8dVcxiS/eLsHUYCMAoedg2FN6PbYhi12J8sQAlZg5O7YK863/Z6Rn/s0Kptym7F++umHhnQ45RIDZOFkVGzccE8pMo64XS4iO0HPpPacBCa/USmdAzBzvTypg/eonWPCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340903; c=relaxed/simple;
	bh=wcL3RadYeFFrMiMDIXx5dqFyjfbBR0aEbknd0/Mb478=;
	h=Date:To:From:Subject:Message-Id; b=miqWeFf5oyPA+KD0yQ3TaIvC4bKRX1PFjbnODMKY9+0QDUj1dem98ynf50wenUQEDAY1xBhskwzUmBGtTq6cz0r6fjbCxjyavXfCk08Y8eNHZdcoyo6O+SPrWgG31ZRGHpn0BwEQQZN06AKT46X2gdTNgtyAd6rzTfEKe2E9hDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cH1/TU/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cH1/TU/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CC0C32782;
	Tue, 25 Jun 2024 18:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719340903;
	bh=wcL3RadYeFFrMiMDIXx5dqFyjfbBR0aEbknd0/Mb478=;
	h=Date:To:From:Subject:From;
	b=cH1/TU/ZmSmKrAPn2YBUbE0pMuUEHn82U6GbpVFNap/xvKMkUHK/kNBe7RlgKI1vk
	 gCEyFhEJHftvOMHjURl5MTu+hhgKttdR2zWhF7qLYVvcAdBO13xHgAkcdEUOBh1gf4
	 jTNRErDd7avXEhtXhxvsyiWd7eHPS44s8X8Xn5ms=
Date: Tue, 25 Jun 2024 11:41:42 -0700
To: mm-commits@vger.kernel.org,zhenyzha@redhat.com,willy@infradead.org,torvalds@linux-foundation.org,hughd@google.com,djwong@kernel.org,david@redhat.com,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-disable-pmd-sized-page-cache-if-needed.patch added to mm-unstable branch
Message-Id: <20240625184143.24CC0C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: disable PMD-sized page cache if needed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-disable-pmd-sized-page-cache-if-needed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-disable-pmd-sized-page-cache-if-needed.patch

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
Subject: mm/shmem: disable PMD-sized page cache if needed
Date: Tue, 25 Jun 2024 19:06:46 +1000

For shmem files, it's possible that PMD-sized page cache can't be
supported by xarray.  For example, 512MB page cache on ARM64 when the base
page size is 64KB can't be supported by xarray.  It leads to errors as the
following messages indicate when this sort of xarray entry is split.

WARNING: CPU: 34 PID: 7578 at lib/xarray.c:1025 xas_split_alloc+0xf8/0x128
Modules linked in: binfmt_misc nft_fib_inet nft_fib_ipv4 nft_fib_ipv6   \
nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject        \
nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4  \
ip_set rfkill nf_tables nfnetlink vfat fat virtio_balloon drm fuse xfs  \
libcrc32c crct10dif_ce ghash_ce sha2_ce sha256_arm64 sha1_ce virtio_net \
net_failover virtio_console virtio_blk failover dimlib virtio_mmio
CPU: 34 PID: 7578 Comm: test Kdump: loaded Tainted: G W 6.10.0-rc5-gavin+ #9
Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20240524-1.el9 05/24/2024
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : xas_split_alloc+0xf8/0x128
lr : split_huge_page_to_list_to_order+0x1c4/0x720
sp : ffff8000882af5f0
x29: ffff8000882af5f0 x28: ffff8000882af650 x27: ffff8000882af768
x26: 0000000000000cc0 x25: 000000000000000d x24: ffff00010625b858
x23: ffff8000882af650 x22: ffffffdfc0900000 x21: 0000000000000000
x20: 0000000000000000 x19: ffffffdfc0900000 x18: 0000000000000000
x17: 0000000000000000 x16: 0000018000000000 x15: 52f8004000000000
x14: 0000e00000000000 x13: 0000000000002000 x12: 0000000000000020
x11: 52f8000000000000 x10: 52f8e1c0ffff6000 x9 : ffffbeb9619a681c
x8 : 0000000000000003 x7 : 0000000000000000 x6 : ffff00010b02ddb0
x5 : ffffbeb96395e378 x4 : 0000000000000000 x3 : 0000000000000cc0
x2 : 000000000000000d x1 : 000000000000000c x0 : 0000000000000000
Call trace:
 xas_split_alloc+0xf8/0x128
 split_huge_page_to_list_to_order+0x1c4/0x720
 truncate_inode_partial_folio+0xdc/0x160
 shmem_undo_range+0x2bc/0x6a8
 shmem_fallocate+0x134/0x430
 vfs_fallocate+0x124/0x2e8
 ksys_fallocate+0x4c/0xa0
 __arm64_sys_fallocate+0x24/0x38
 invoke_syscall.constprop.0+0x7c/0xd8
 do_el0_svc+0xb4/0xd0
 el0_svc+0x44/0x1d8
 el0t_64_sync_handler+0x134/0x150
 el0t_64_sync+0x17c/0x180

Fix it by disabling PMD-sized page cache when HPAGE_PMD_ORDER is larger
than MAX_PAGECACHE_ORDER.

Link: https://lkml.kernel.org/r/20240625090646.1194644-5-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zhenyu Zhang <zhenyzha@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-disable-pmd-sized-page-cache-if-needed
+++ a/mm/shmem.c
@@ -548,8 +548,9 @@ static bool shmem_confirm_swap(struct ad
 
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 
-bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
-		   struct mm_struct *mm, unsigned long vm_flags)
+static bool __shmem_is_huge(struct inode *inode, pgoff_t index,
+			    bool shmem_huge_force, struct mm_struct *mm,
+			    unsigned long vm_flags)
 {
 	loff_t i_size;
 
@@ -580,6 +581,16 @@ bool shmem_is_huge(struct inode *inode,
 	}
 }
 
+bool shmem_is_huge(struct inode *inode, pgoff_t index,
+		   bool shmem_huge_force, struct mm_struct *mm,
+		   unsigned long vm_flags)
+{
+	if (!__shmem_is_huge(inode, index, shmem_huge_force, mm, vm_flags))
+		return false;
+
+	return HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER;
+}
+
 #if defined(CONFIG_SYSFS)
 static int shmem_parse_huge(const char *str)
 {
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-filemap-make-max_pagecache_order-acceptable-to-xarray.patch
mm-filemap-skip-to-allocate-pmd-sized-folios-if-needed.patch
mm-readahead-limit-page-cache-size-in-page_cache_ra_order.patch
mm-shmem-disable-pmd-sized-page-cache-if-needed.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B5680C04
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104153; cv=none; b=DqaMzY1cW+sA2kFBenuZNYGBmSCcpZkxcFTKDKoaZis0d0Oodf1mbF+P4Y7aVMdfvGg1CUSor1F8Lw/e8GsE8VZ74h9mSPShWwRF8xYIuypF2ZHuCSGB1M3pqsSAzxz169ZCSuZqoOr0p3OOu/f4rCfIAsxreXf8A9aXXU0AaSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104153; c=relaxed/simple;
	bh=T9ZwmBhNNrP2H3CfOIpSxeZ6CqSOLpUj5jeeMjlVXTU=;
	h=Date:To:From:Subject:Message-Id; b=cF39JvRud/VNhh9YdmLw0scggm8BYac+dv+8oZAeDUPKxb0pvBhhmvDkVm71pVruKztjqEKhWCuw6BTk9zTiPDBmR07Pc2MtkPoCUDn7gCttXaagTGg+Qei9Yj+Eb1eCgVWQru8/o3T3nevQwqz7VN97bDsL0+W6WBCgXu3ERu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yJbRUzam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yJbRUzam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B827C113CD;
	Fri, 26 Apr 2024 04:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104153;
	bh=T9ZwmBhNNrP2H3CfOIpSxeZ6CqSOLpUj5jeeMjlVXTU=;
	h=Date:To:From:Subject:From;
	b=yJbRUzamoQRbnW9mT/hDpraWt/mmTrZJopWDb15BRh89QstVlKyjsrv1rkUNuC2ZH
	 kyOzvmW+g0gJWTKn+qTVphmnV8l6sTX8uVpyEbLR230paEFRdyjtyl5ljvQOuyBHer
	 PWR6iMgjOIZF2+ITvRKeXSvRsEBI2YJd1FKO8IEk=
Date: Thu, 25 Apr 2024 21:02:32 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,surenb@google.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,luto@kernel.org,linux@armlinux.org.uk,hca@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,aou@eecs.berkeley.edu,agordeev@linux.ibm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-mm-accelerate-pagefault-when-badaccess.patch removed from -mm tree
Message-Id: <20240426040233.5B827C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390: mm: accelerate pagefault when badaccess
has been removed from the -mm tree.  Its filename was
     s390-mm-accelerate-pagefault-when-badaccess.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: s390: mm: accelerate pagefault when badaccess
Date: Wed, 3 Apr 2024 16:38:04 +0800

The vm_flags of vma already checked under per-VMA lock, if it is a bad
access, directly handle error, no need to retry with mmap_lock again. 
Since the page faut is handled under per-VMA lock, count it as a vma lock
event with VMA_LOCK_SUCCESS.

Link: https://lkml.kernel.org/r/20240403083805.1818160-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/fault.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/mm/fault.c~s390-mm-accelerate-pagefault-when-badaccess
+++ a/arch/s390/mm/fault.c
@@ -325,7 +325,8 @@ static void do_exception(struct pt_regs
 		goto lock_mmap;
 	if (!(vma->vm_flags & access)) {
 		vma_end_read(vma);
-		goto lock_mmap;
+		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
+		return handle_fault_error_nolock(regs, SEGV_ACCERR);
 	}
 	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
 	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
mm-move-mm-counter-updating-out-of-set_pte_range.patch
mm-filemap-batch-mm-counter-updating-in-filemap_map_pages.patch
mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch
mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch


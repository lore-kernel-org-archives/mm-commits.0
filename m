Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFE981205
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104151; cv=none; b=nZgJDQGOAc7F9QGKjINRGqcAPLsIc7aS/zsDC+VkC+mAUhMNKqtf9X4Uhc41WUn8DMLha8PHPjiSxbcnbVjRMOXLMkiiaVTITgjgxPkhq+ubZ/QixpI5uvJrtWH48Idq/NQk8VQwsb60CV7YcMVdP2mM1gvrQQDdn5pmSctWwtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104151; c=relaxed/simple;
	bh=ZSiVGxsgVnQBw8HLcIa6y6RLPBoKMse2a0x37KEkKSs=;
	h=Date:To:From:Subject:Message-Id; b=aU6IFHt1YM10TylNawWKgMiggs0GYE0Jy14SIlRYZej5oHgKHdYruTLgX++qemJI/6+7XL3U2Kui3RFpQeJpZb+tbd36QtthRwGkDUXAoCN486iJuwuZdEUVn2EYOREmVfU3oo/UkokLNPaMjuz+MpPs5myf7Oe9YE76Xmapfbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0kfGfRz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0kfGfRz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3027BC2BD11;
	Fri, 26 Apr 2024 04:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104151;
	bh=ZSiVGxsgVnQBw8HLcIa6y6RLPBoKMse2a0x37KEkKSs=;
	h=Date:To:From:Subject:From;
	b=0kfGfRz17fYalJrNCG8f4vUg+Kbw+BoceyCV+HTWhVdAAt/lZui/QnUAsDWjIw1HS
	 RMeMEG9PlGTvhc0kdYtwuuumzg9z1MuUFdDYl0aHUmR2Q86iM+pQTncB4LtBv7BnXO
	 rPufNup3ja6qea5h1JXDwGN54/Ssca6/K3I0n16A=
Date: Thu, 25 Apr 2024 21:02:30 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,surenb@google.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,luto@kernel.org,linux@armlinux.org.uk,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,aou@eecs.berkeley.edu,alexghiti@rivosinc.com,agordeev@linux.ibm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-mm-accelerate-pagefault-when-badaccess.patch removed from -mm tree
Message-Id: <20240426040231.3027BC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: mm: accelerate pagefault when badaccess
has been removed from the -mm tree.  Its filename was
     riscv-mm-accelerate-pagefault-when-badaccess.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: riscv: mm: accelerate pagefault when badaccess
Date: Wed, 3 Apr 2024 16:38:03 +0800

The access_error() of vma already checked under per-VMA lock, if it is a
bad access, directly handle error, no need to retry with mmap_lock again. 
Since the page faut is handled under per-VMA lock, count it as a vma lock
event with VMA_LOCK_SUCCESS.

[wangkefeng.wang@huawei.com: use `cause' rather than SIGSEGV, per Alexandre]
  Link: https://lkml.kernel.org/r/ac978061-ce1a-40a4-8b0a-61883b42bea7@huawei.com
Link: https://lkml.kernel.org/r/20240403083805.1818160-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com
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
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/fault.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/riscv/mm/fault.c~riscv-mm-accelerate-pagefault-when-badaccess
+++ a/arch/riscv/mm/fault.c
@@ -292,7 +292,10 @@ void handle_page_fault(struct pt_regs *r
 
 	if (unlikely(access_error(cause, vma))) {
 		vma_end_read(vma);
-		goto lock_mmap;
+		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
+		tsk->thread.bad_cause = cause;
+		bad_area_nosemaphore(regs, SEGV_ACCERR, addr);
+		return;
 	}
 
 	fault = handle_mm_fault(vma, addr, flags | FAULT_FLAG_VMA_LOCK, regs);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
mm-move-mm-counter-updating-out-of-set_pte_range.patch
mm-filemap-batch-mm-counter-updating-in-filemap_map_pages.patch
mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch
mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch


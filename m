Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D35F7F7C1
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104149; cv=none; b=a0mMAyCKoUyA+vXUUfjC+THPvne/Uk/vPQ1hFvQ3L8wEvZA0K9HNmSd85oyFu3qxMA8pxdQMIMOJqg+ODLc/IGuzpwyAcXxIMCYnYzBK9n56WQOVVz16n+85RPLao6REZsKJ0Rf4rhWgdE2gh/bxWMjSB4hSlMH81IhJqT1Pf7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104149; c=relaxed/simple;
	bh=UkOZD8FZHrY26l7J8jXQC29NJ9uocjPYrZzr4b9uLY0=;
	h=Date:To:From:Subject:Message-Id; b=lFDGMaEyho/Ul3qU1Ur1DFW9e0/gzRrgm8GkXvkoO+OmodnszRdS5mdkUsyOrI6i+Ta7HvKsmibfv+CkWCrTbNH9CFjG1zCCgJ5ePcB1jSLEjyOSWCz4w++01MyoCb0DCEMLoHBbj15Lnz9QyNTAKIojnasiX5GZO4+tLVETVYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pMf/2bxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pMf/2bxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AA4C116B1;
	Fri, 26 Apr 2024 04:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104148;
	bh=UkOZD8FZHrY26l7J8jXQC29NJ9uocjPYrZzr4b9uLY0=;
	h=Date:To:From:Subject:From;
	b=pMf/2bxFTS81BRnnme/qzzfQ8AkIQcf9o/RAocSPVHteSYOZfYVRtJpV8gyzODtyd
	 Pq5d9WZEuBFG76DGmz2rjKhVu4P68fzFjOrC1yoM2kpt22Vl6gKzgiKOQmEMH6H75D
	 YZDQTFLK55YxkG2oRq14FF8EgHkeLCJ77wyRzrig=
Date: Thu, 25 Apr 2024 21:02:28 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,surenb@google.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,luto@kernel.org,linux@armlinux.org.uk,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,aou@eecs.berkeley.edu,agordeev@linux.ibm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm-mm-accelerate-pagefault-when-vm_fault_badaccess.patch removed from -mm tree
Message-Id: <20240426040228.D5AA4C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm: mm: accelerate pagefault when VM_FAULT_BADACCESS
has been removed from the -mm tree.  Its filename was
     arm-mm-accelerate-pagefault-when-vm_fault_badaccess.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: arm: mm: accelerate pagefault when VM_FAULT_BADACCESS
Date: Wed, 3 Apr 2024 16:38:01 +0800

The vm_flags of vma already checked under per-VMA lock, if it is a bad
access, directly set fault to VM_FAULT_BADACCESS and handle error, no need
to retry with mmap_lock again.  Since the page faut is handled under
per-VMA lock, count it as a vma lock event with VMA_LOCK_SUCCESS.

Link: https://lkml.kernel.org/r/20240403083805.1818160-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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

 arch/arm/mm/fault.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm/mm/fault.c~arm-mm-accelerate-pagefault-when-vm_fault_badaccess
+++ a/arch/arm/mm/fault.c
@@ -294,7 +294,9 @@ do_page_fault(unsigned long addr, unsign
 
 	if (!(vma->vm_flags & vm_flags)) {
 		vma_end_read(vma);
-		goto lock_mmap;
+		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
+		fault = VM_FAULT_BADACCESS;
+		goto bad_area;
 	}
 	fault = handle_mm_fault(vma, addr, flags | FAULT_FLAG_VMA_LOCK, regs);
 	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
mm-move-mm-counter-updating-out-of-set_pte_range.patch
mm-filemap-batch-mm-counter-updating-in-filemap_map_pages.patch
mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch
mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch


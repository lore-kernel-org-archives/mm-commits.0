Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038CF7604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103249; cv=none; b=JGeNbJzFszJvZXyqwT8eDcVWfJpYl6UmRvrWdNC0kJR2XM+5vF1BkElSyHQ2VRzkCO9h4lifxdb6Vt8+2uSV4o/LTlRdPNHBn9STdChnojceMSneOCdhE947akEHqM4pm9fKHt9muk7uzF8Uxngk9vT+l6Hzv/kWfIv/qPXVA78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103249; c=relaxed/simple;
	bh=MHdey7xLLKdNY/WsZ7ipOuZ8rtFyZzBIrM3v1NyTtEA=;
	h=Date:To:From:Subject:Message-Id; b=kc6AKq4/jtYWr911O4okJwnQeTuHdD7Pu+K8hw0/pmZaM38jY+VDDcyIF/dESIEFGq0Bqlt7RljZZP3sQeCYIrKUPS50cLqBTwKJ8Yyz4Cl6IiatoIf7q+cza2vFRyM39oS/UaX+pIHNGqReY/OtFY+gybx/3VRVIAGT2T6nHvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A5/8IT6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A5/8IT6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F5CC113CD;
	Fri, 26 Apr 2024 03:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103248;
	bh=MHdey7xLLKdNY/WsZ7ipOuZ8rtFyZzBIrM3v1NyTtEA=;
	h=Date:To:From:Subject:From;
	b=A5/8IT6I5ZE/2wwub1u+qFQ4NDMxmzEhwNo/3Lnpy3Q7Do7cnJgRJ7fekjqFztsZQ
	 Sz9FPyX8U+jF4fxtyYSQK1h8mzB9yP/XeV/5ktgd7LUyTTDnYN73t6KpWksAqND+ik
	 qJnB0vQ793v5IPlB6/fOxoTSfVjlo5IiLpQGRYQA=
Date: Thu, 25 Apr 2024 20:47:27 -0700
To: mm-commits@vger.kernel.org,alexghiti@rivosinc.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] riscv-mm-accelerate-pagefault-when-badaccess-fix.patch removed from -mm tree
Message-Id: <20240426034728.75F5CC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv-mm-accelerate-pagefault-when-badaccess-fix
has been removed from the -mm tree.  Its filename was
     riscv-mm-accelerate-pagefault-when-badaccess-fix.patch

This patch was dropped because it was folded into riscv-mm-accelerate-pagefault-when-badaccess.patch

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: riscv-mm-accelerate-pagefault-when-badaccess-fix
Date: Wed, 10 Apr 2024 16:07:41 +0800

use `cause' rather than SIGSEGV, per Alexandre

Link: https://lkml.kernel.org/r/ac978061-ce1a-40a4-8b0a-61883b42bea7@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/fault.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/mm/fault.c~riscv-mm-accelerate-pagefault-when-badaccess-fix
+++ a/arch/riscv/mm/fault.c
@@ -293,8 +293,8 @@ void handle_page_fault(struct pt_regs *r
 	if (unlikely(access_error(cause, vma))) {
 		vma_end_read(vma);
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
-		tsk->thread.bad_cause = SEGV_ACCERR;
-		bad_area_nosemaphore(regs, code, addr);
+		tsk->thread.bad_cause = cause;
+		bad_area_nosemaphore(regs, SEGV_ACCERR, addr);
 		return;
 	}
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-backing-dev-use-group-allocation-free-of-per-cpu-counters-api.patch
mm-remove-__set_page_dirty_nobuffers.patch
arm64-mm-cleanup-__do_page_fault.patch
arm64-mm-accelerate-pagefault-when-vm_fault_badaccess.patch
arm-mm-accelerate-pagefault-when-vm_fault_badaccess.patch
powerpc-mm-accelerate-pagefault-when-badaccess.patch
riscv-mm-accelerate-pagefault-when-badaccess.patch
s390-mm-accelerate-pagefault-when-badaccess.patch
x86-mm-accelerate-pagefault-when-badaccess.patch
arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
mm-move-mm-counter-updating-out-of-set_pte_range.patch
mm-filemap-batch-mm-counter-updating-in-filemap_map_pages.patch
mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch
mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch


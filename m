Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095E5181B96
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 20:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712780263; cv=none; b=l1dCnHEOKxw/l4Zz9Z5OAmESh6c4wUwJJXTULdrZ3a0NCErLscXTMelwe/SmjzT+LYiYQWDaAxv8vNPMbgpQHH40RQCazK+lbaFWJNuz6VCd7X6MFVtoKoAr4rPFnVAMvds4e/pxJoobKqFEehTghrajtOMgLG67/T97Ftx3nUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712780263; c=relaxed/simple;
	bh=RO95qMNyZSXat+sgR3AHLt53E77uJ27nH+8weaY+gwQ=;
	h=Date:To:From:Subject:Message-Id; b=kJ0aocpcOCZppAuZDGWG4s0B6iqKt9toMSCrBrcmaU5NK398zWWvArOquJmCYRrhlvmx/CE301hmC7MqQ71FeRK/tzEMvOL32vMx/2FH8ZWpHTxDC3blnGJhtzfbql4tDKfKKW/lNca9iLgsgF4l0Gh/UlC0K0YN02oJcYChbR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tLl3dkU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tLl3dkU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EF7C43390;
	Wed, 10 Apr 2024 20:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712780262;
	bh=RO95qMNyZSXat+sgR3AHLt53E77uJ27nH+8weaY+gwQ=;
	h=Date:To:From:Subject:From;
	b=tLl3dkU1HZPKPKiAYSenNOEcmcBWsq6LLhw9bPEslIwvc5dg7KjkxEvrnNt0CH/JC
	 hWvYWxodoYC0FLEMy6Dxm8lOp8YKcvYQJJWXSLePHO8b2YUk8AwtHW2sG5bAaolV4B
	 yzOOI4f7xektQzPdQraLaeLBG6Oy4+SbCgHDWviY=
Date: Wed, 10 Apr 2024 13:17:41 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,linux@armlinux.org.uk,catalin.marinas@arm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch removed from -mm tree
Message-Id: <20240410201742.67EF7C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mm: drop VM_FAULT_BADMAP/VM_FAULT_BADACCESS
has been removed from the -mm tree.  Its filename was
     arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: arm64: mm: drop VM_FAULT_BADMAP/VM_FAULT_BADACCESS
Date: Sun, 7 Apr 2024 16:12:10 +0800

Patch series "mm: remove arch's private VM_FAULT_BADMAP/BADACCESS:.

Directly set SEGV_MAPRR or SEGV_ACCERR for arm/arm64 to remove the last
two arch's private vm_fault reasons.


This patch (of 2):

If bad map or access, directly set si_code to SEGV_MAPRR or SEGV_ACCERR,
also set fault to 0 and goto error handling, which make us to drop the
arch's special vm fault reason.

Link: https://lkml.kernel.org/r/20240407081211.2292362-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/fault.c |   41 +++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

--- a/arch/arm64/mm/fault.c~arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess
+++ a/arch/arm64/mm/fault.c
@@ -500,9 +500,6 @@ static bool is_write_abort(unsigned long
 	return (esr & ESR_ELx_WNR) && !(esr & ESR_ELx_CM);
 }
 
-#define VM_FAULT_BADMAP		((__force vm_fault_t)0x010000)
-#define VM_FAULT_BADACCESS	((__force vm_fault_t)0x020000)
-
 static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 				   struct pt_regs *regs)
 {
@@ -513,6 +510,7 @@ static int __kprobes do_page_fault(unsig
 	unsigned int mm_flags = FAULT_FLAG_DEFAULT;
 	unsigned long addr = untagged_addr(far);
 	struct vm_area_struct *vma;
+	int si_code;
 
 	if (kprobe_page_fault(regs, esr))
 		return 0;
@@ -572,9 +570,10 @@ static int __kprobes do_page_fault(unsig
 
 	if (!(vma->vm_flags & vm_flags)) {
 		vma_end_read(vma);
-		fault = VM_FAULT_BADACCESS;
+		fault = 0;
+		si_code = SEGV_ACCERR;
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
-		goto done;
+		goto bad_area;
 	}
 	fault = handle_mm_fault(vma, addr, mm_flags | FAULT_FLAG_VMA_LOCK, regs);
 	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
@@ -599,15 +598,18 @@ lock_mmap:
 retry:
 	vma = lock_mm_and_find_vma(mm, addr, regs);
 	if (unlikely(!vma)) {
-		fault = VM_FAULT_BADMAP;
-		goto done;
+		fault = 0;
+		si_code = SEGV_MAPERR;
+		goto bad_area;
 	}
 
-	if (!(vma->vm_flags & vm_flags))
-		fault = VM_FAULT_BADACCESS;
-	else
-		fault = handle_mm_fault(vma, addr, mm_flags, regs);
+	if (!(vma->vm_flags & vm_flags)) {
+		fault = 0;
+		si_code = SEGV_ACCERR;
+		goto bad_area;
+	}
 
+	fault = handle_mm_fault(vma, addr, mm_flags, regs);
 	/* Quick path to respond to signals */
 	if (fault_signal_pending(fault, regs)) {
 		if (!user_mode(regs))
@@ -626,13 +628,11 @@ retry:
 	mmap_read_unlock(mm);
 
 done:
-	/*
-	 * Handle the "normal" (no error) case first.
-	 */
-	if (likely(!(fault & (VM_FAULT_ERROR | VM_FAULT_BADMAP |
-			      VM_FAULT_BADACCESS))))
+	/* Handle the "normal" (no error) case first. */
+	if (likely(!(fault & VM_FAULT_ERROR)))
 		return 0;
 
+bad_area:
 	/*
 	 * If we are in kernel mode at this point, we have no context to
 	 * handle this fault with.
@@ -667,13 +667,8 @@ done:
 
 		arm64_force_sig_mceerr(BUS_MCEERR_AR, far, lsb, inf->name);
 	} else {
-		/*
-		 * Something tried to access memory that isn't in our memory
-		 * map.
-		 */
-		arm64_force_sig_fault(SIGSEGV,
-				      fault == VM_FAULT_BADACCESS ? SEGV_ACCERR : SEGV_MAPERR,
-				      far, inf->name);
+		/* Something tried to access memory that out of memory map */
+		arm64_force_sig_fault(SIGSEGV, si_code, far, inf->name);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-backing-dev-use-group-allocation-free-of-per-cpu-counters-api.patch
mm-remove-__set_page_dirty_nobuffers.patch
arm64-mm-cleanup-__do_page_fault.patch
arm64-mm-accelerate-pagefault-when-vm_fault_badaccess.patch
arm-mm-accelerate-pagefault-when-vm_fault_badaccess.patch
powerpc-mm-accelerate-pagefault-when-badaccess.patch
riscv-mm-accelerate-pagefault-when-badaccess.patch
riscv-mm-accelerate-pagefault-when-badaccess-fix.patch
s390-mm-accelerate-pagefault-when-badaccess.patch
x86-mm-accelerate-pagefault-when-badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch


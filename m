Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6831773D
	for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2024 20:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712866378; cv=none; b=WzJwxq2kNMeukhklhm5KS1PB/+rHV5f4tZzqaneJkW/s6JHNg+HddWgHJQo75esYraCdKc7awzVm/cGzr38wWGHOCydZFRXh8PURTR42dA4OZ87wpaIZh1IJQ21Wp0OtiWK3Kl1Apa5rCB0Gg/PXVDf6EDuVYBqTvzKRS8aNnYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712866378; c=relaxed/simple;
	bh=uiF3qrjua58km/KpS/Prb0H44ruTXjd8VsRTVtS2LAU=;
	h=Date:To:From:Subject:Message-Id; b=GF1TcVaavghLJKWjIM+mS+3iOUTIcbPDy7vrg74nfkcHBJE+c3qBbbMG2FkuMY2rEfNf8BecnYPyO2SjgobHYrcgU1UdM8DXw85AvA14jLFuCwkg1ZvLpE8kR5zEZIN5xta3YVFyJYYNiB/IqhZg+27q2tm9e1iljZYiuFWoaa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jMLC8cs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jMLC8cs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1D2C072AA;
	Thu, 11 Apr 2024 20:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712866378;
	bh=uiF3qrjua58km/KpS/Prb0H44ruTXjd8VsRTVtS2LAU=;
	h=Date:To:From:Subject:From;
	b=jMLC8cs5ohgo/tlzoTCEQQkNe8OjDCXT/ryz39hGfr90hIQzbBN6gIbabcvQ/hv33
	 DZF1QGXQGltVDLdIq5HVn+wDgyOwc+SVrc+ObbR+J0XrQBBSGpffLok27tyUAQhGaF
	 GtIBlWYJcZvCDQXtoZalmznwp3+VKLiPPhQ510bw=
Date: Thu, 11 Apr 2024 13:12:57 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,linux@armlinux.org.uk,cristian.marussi@arm.com,catalin.marinas@arm.com,broonie@kernel.org,aishwarya.tcv@arm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch added to mm-unstable branch
Message-Id: <20240411201257.EE1D2C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mm: drop VM_FAULT_BADMAP/VM_FAULT_BADACCESS
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: arm64: mm: drop VM_FAULT_BADMAP/VM_FAULT_BADACCESS
Date: Thu, 11 Apr 2024 21:09:24 +0800

Patch series "mm: remove arch's private VM_FAULT_BADMAP/BADACCESS", v2.

Directly set SEGV_MAPRR or SEGV_ACCERR for arm/arm64 to remove the last
two arch's private vm_fault reasons.  


This patch (of 2):

If bad map or access, directly set si_code to SEGV_MAPRR or SEGV_ACCERR,
also set fault to 0 and goto error handling, which make us to drop the
arch's special vm fault reason.

Link: https://lkml.kernel.org/r/20240411130925.73281-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240411130925.73281-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Cristian Marussi <cristian.marussi@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/fault.c |   43 ++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

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
@@ -599,15 +598,19 @@ lock_mmap:
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
+		mmap_read_unlock(mm);
+		fault = 0;
+		si_code = SEGV_ACCERR;
+		goto bad_area;
+	}
 
+	fault = handle_mm_fault(vma, addr, mm_flags, regs);
 	/* Quick path to respond to signals */
 	if (fault_signal_pending(fault, regs)) {
 		if (!user_mode(regs))
@@ -626,13 +629,12 @@ retry:
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
 
+	si_code = SEGV_MAPERR;
+bad_area:
 	/*
 	 * If we are in kernel mode at this point, we have no context to
 	 * handle this fault with.
@@ -667,13 +669,8 @@ done:
 
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
arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch


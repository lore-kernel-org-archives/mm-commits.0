Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7389C145348
	for <mm-commits@vger.kernel.org>; Mon,  8 Apr 2024 19:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712604338; cv=none; b=RD0AcDePwWoWwKUSQ1b4mtZBGf7d99BbuiaBhoprIX4PkaTpteHTpUBGVcWL+HMkm0/anjg2GdgBOyLG3QzjJaE6LExT/BGVTMW2p1US6Q8uTxzNgQQApV1Mn7pJEtzGoOgSDOzJcBa4aqb1mlaVLiA7JoT70xW0ST63He7mF/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712604338; c=relaxed/simple;
	bh=74unTrVBceFheuLaDDNFdd6MicHOHmFNKTjAXTquhsY=;
	h=Date:To:From:Subject:Message-Id; b=Cqv/8r63DcqA78fE0KuptWnusRwVU7fFRQX/FwWfxdAObKSOV2dn2Ufw2mKyHKsaQCoDCaY7eP2t9LOFtcObJHje1kcZ4v2LdIcrWBtd9sEH8Ejo8Mfv8DylWqMGNMyESEBhhE2iz2/unzI8FzkAS3hGwX1kKFEzqQl8yfNtgFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ze6+CxX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ze6+CxX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2440C433F1;
	Mon,  8 Apr 2024 19:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712604338;
	bh=74unTrVBceFheuLaDDNFdd6MicHOHmFNKTjAXTquhsY=;
	h=Date:To:From:Subject:From;
	b=ze6+CxX/wVdApAWh/ak/tyY1pUr+UjklXgJ6Qt+S63Gdprumx2mP+1qEmdzfdCEDR
	 jxTqrp0iSsWeRdCXtdBN4WgJVUY1l3Ro7fupBKN33kJHqO64z+5iUSRS9y6NojA655
	 ZnoVB24jCY4nDtqHHtX9qbjZ4s0nGSL0SZFD8KGI=
Date: Mon, 08 Apr 2024 12:25:37 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,linux@armlinux.org.uk,catalin.marinas@arm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch added to mm-unstable branch
Message-Id: <20240408192537.E2440C433F1@smtp.kernel.org>
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
s390-mm-accelerate-pagefault-when-badaccess.patch
x86-mm-accelerate-pagefault-when-badaccess.patch
arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch


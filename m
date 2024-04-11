Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1400D1773D
	for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2024 20:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712866380; cv=none; b=Hly0sj0+PWdp9o0iqjE21Qazag+cYTHukD9sR7p1Q9QIK5Q/K7C6l46zD9dXWyMh9VadYW2IFsYuORG2iL+u8Ak0mYiM7D5JmC1UCQO3APFImT8teRZFzoOLF4GhSnjHHccD8kGHi5brJL2SPfBBKlM/n8GnOSDp+JnD7+1K1fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712866380; c=relaxed/simple;
	bh=n9dGXSdH072AcfI1zqs4G6f2dWKWNVmz87BXzP1Yo5o=;
	h=Date:To:From:Subject:Message-Id; b=hRlWsM6D/XEDtpFeR5pnUp6/knO2bsQhHss/50FW0DNBcIzXmAynlFbvm8pdkr3CMcWmz0fMRQqiLnhs0dEtovPXqO28DPaIyIIc2kCFmn5s+FMs7U+TAPxWLkefcZVGNDyolTYYRELrId5lInB1ikjcxcJa5Y4z/jrshshTIAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZdKDi3b+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZdKDi3b+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73088C072AA;
	Thu, 11 Apr 2024 20:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712866379;
	bh=n9dGXSdH072AcfI1zqs4G6f2dWKWNVmz87BXzP1Yo5o=;
	h=Date:To:From:Subject:From;
	b=ZdKDi3b+gLFwFak8/0XAntfl/Kpt1hi1okm66bghPtYS1GUyLmqqpoDl4GqNS9sQe
	 cvz3EeRgRkv0nUB75w7+kAWi5lGEW6vuIkNhaDkTOC6oZu3vkdrihg7IxDziALk8NQ
	 5RUH2xrx/CG1x8CpW6dQjJnTL9rOTh3oKVaRVpWs=
Date: Thu, 11 Apr 2024 13:12:58 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,linux@armlinux.org.uk,cristian.marussi@arm.com,catalin.marinas@arm.com,broonie@kernel.org,aishwarya.tcv@arm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch added to mm-unstable branch
Message-Id: <20240411201259.73088C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm: mm: drop VM_FAULT_BADMAP/VM_FAULT_BADACCESS
has been added to the -mm mm-unstable branch.  Its filename is
     arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch

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
Subject: arm: mm: drop VM_FAULT_BADMAP/VM_FAULT_BADACCESS
Date: Thu, 11 Apr 2024 21:09:25 +0800

If bad map or access, directly set code to SEGV_MAPRR or SEGV_ACCERR, also
set fault to 0 and goto error handling, which make us to drop the arch's
special vm fault reason.

Link: https://lkml.kernel.org/r/20240411130925.73281-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Cristian Marussi <cristian.marussi@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/arch/arm/mm/fault.c~arm-mm-drop-vm_fault_badmap-vm_fault_badaccess
+++ a/arch/arm/mm/fault.c
@@ -226,9 +226,6 @@ void do_bad_area(unsigned long addr, uns
 }
 
 #ifdef CONFIG_MMU
-#define VM_FAULT_BADMAP		((__force vm_fault_t)0x010000)
-#define VM_FAULT_BADACCESS	((__force vm_fault_t)0x020000)
-
 static inline bool is_permission_fault(unsigned int fsr)
 {
 	int fs = fsr_fs(fsr);
@@ -295,7 +292,8 @@ do_page_fault(unsigned long addr, unsign
 	if (!(vma->vm_flags & vm_flags)) {
 		vma_end_read(vma);
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
-		fault = VM_FAULT_BADACCESS;
+		fault = 0;
+		code = SEGV_ACCERR;
 		goto bad_area;
 	}
 	fault = handle_mm_fault(vma, addr, flags | FAULT_FLAG_VMA_LOCK, regs);
@@ -321,7 +319,8 @@ lock_mmap:
 retry:
 	vma = lock_mm_and_find_vma(mm, addr, regs);
 	if (unlikely(!vma)) {
-		fault = VM_FAULT_BADMAP;
+		fault = 0;
+		code = SEGV_MAPERR;
 		goto bad_area;
 	}
 
@@ -329,10 +328,14 @@ retry:
 	 * ok, we have a good vm_area for this memory access, check the
 	 * permissions on the VMA allow for the fault which occurred.
 	 */
-	if (!(vma->vm_flags & vm_flags))
-		fault = VM_FAULT_BADACCESS;
-	else
-		fault = handle_mm_fault(vma, addr & PAGE_MASK, flags, regs);
+	if (!(vma->vm_flags & vm_flags)) {
+		mmap_read_unlock(mm);
+		fault = 0;
+		code = SEGV_ACCERR;
+		goto bad_area;
+	}
+
+	fault = handle_mm_fault(vma, addr & PAGE_MASK, flags, regs);
 
 	/* If we need to retry but a fatal signal is pending, handle the
 	 * signal first. We do not need to release the mmap_lock because
@@ -358,12 +361,11 @@ retry:
 	mmap_read_unlock(mm);
 done:
 
-	/*
-	 * Handle the "normal" case first - VM_FAULT_MAJOR
-	 */
-	if (likely(!(fault & (VM_FAULT_ERROR | VM_FAULT_BADMAP | VM_FAULT_BADACCESS))))
+	/* Handle the "normal" case first */
+	if (likely(!(fault & VM_FAULT_ERROR)))
 		return 0;
 
+        code = SEGV_MAPERR;
 bad_area:
 	/*
 	 * If we are in kernel mode at this point, we
@@ -395,8 +397,6 @@ bad_area:
 		 * isn't in our memory map..
 		 */
 		sig = SIGSEGV;
-		code = fault == VM_FAULT_BADACCESS ?
-			SEGV_ACCERR : SEGV_MAPERR;
 	}
 
 	__do_user_fault(addr, fsr, sig, code, regs);
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


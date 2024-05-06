Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03DE13AF2
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957018; cv=none; b=GdwBLaNfCXQ7XXret9juP9TuqGyESrAvLudW3w6ydCYCzYnwWWqWY4QNeILKEvT/cDeyxpGPviaoD31zlAbD/475DK+MIjP7mdGBOgNTYfwvqiIBm/7216Qv/C+sdQ4dWp4n56VfWnL+Rgn/mQpWdJuUtXuP2MgPHEEGUunjzAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957018; c=relaxed/simple;
	bh=SDyYNyvNYqUBniB1QQ+8FQnfsstb109l3Yb5eXTYFCA=;
	h=Date:To:From:Subject:Message-Id; b=m1eVdXgyNMmbDKMt+37b3QLEbaWDq4uZ4ryL0xXxby7MYaG0D0kuPRgMBC4mDXPXuarrZ+lNyEyBWz4hgXzktp3ueRZJc1Z79oa6jX7GD8EL0yq6k++VNDpY/BJx8z8xzrBEitYjnRyT1yt917Q5VdNkHOLq2v6pUmTqo3qa+Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KVomYbjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KVomYbjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB0CC113CC;
	Mon,  6 May 2024 00:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957018;
	bh=SDyYNyvNYqUBniB1QQ+8FQnfsstb109l3Yb5eXTYFCA=;
	h=Date:To:From:Subject:From;
	b=KVomYbjyFH9V6EpYI/P4aIGI5i+tlKRJYAaK2hJ5sNt/ccFZ6B2upNeGbphpNGDkm
	 mt5G/WvObzfxBqjPjs2yru5Kun42o5Snd53TxiKrYc/KHti0OMfCaBe88+pQyWjb5+
	 Na5MI2tAolIBtm5G7BX9YebqPOiaXzzUCvbDn2m8=
Date: Sun, 05 May 2024 17:56:57 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,linux@armlinux.org.uk,cristian.marussi@arm.com,catalin.marinas@arm.com,broonie@kernel.org,aishwarya.tcv@arm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch removed from -mm tree
Message-Id: <20240506005658.3FB0CC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mm: drop VM_FAULT_BADMAP/VM_FAULT_BADACCESS
has been removed from the -mm tree.  Its filename was
     arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>
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



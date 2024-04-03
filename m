Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4E03D962
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 20:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712177318; cv=none; b=nzdQtlt8s8m5z42tfbmkZVxwEXacBVLlXpEcfKAwNAyeHO8nlxfz7CFNcOkHEnynJEMSW7WsAP8JGmnL/v36ZrQM73ugbT7whrF9BUstghPTP2T+7iq3rKcg9DDaey3XxriO3J4OOK7m7PFe7Zhi2Zq3XgRt+bMRMMuRl6KHb1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712177318; c=relaxed/simple;
	bh=2HFDXZ0ueXHKYweX6SesGDZTNpC5NXV8kDDIgjH56Xg=;
	h=Date:To:From:Subject:Message-Id; b=g8i25s9TuaWLxAPGUXcBoJ0JxEl3160tnuesrAc/GKjQVlD564BK/JxK3y57cALLQob6VbTHTQVJ751X1LBdh/XPxrXpUtjdvD6bM5Xyunmv0qNag49PCs4MgOUY5ovVaHykLrK6ON04Ovd8XwmVbTN05XSg1KhLQcZySOfHPcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z5Ei36XW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z5Ei36XW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305FEC433F1;
	Wed,  3 Apr 2024 20:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712177318;
	bh=2HFDXZ0ueXHKYweX6SesGDZTNpC5NXV8kDDIgjH56Xg=;
	h=Date:To:From:Subject:From;
	b=z5Ei36XW7o7xiWoyOe7KY1a/TT4RydGzEOYg8c4T3MGxOM+n58BXqCWaZF1P9NRYJ
	 F+/kNmVK4jOzLK/xUtj3OZ/svWGjyP7/VB2QSnrNGD9b/pjxeo7Gi9NUUKp6hoGUQc
	 CUPYOi1u/05eI8guqPbyAFpw6FoLBOBbYUAwziCE=
Date: Wed, 03 Apr 2024 13:48:37 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,surenb@google.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,luto@kernel.org,linux@armlinux.org.uk,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,aou@eecs.berkeley.edu,agordeev@linux.ibm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-accelerate-pagefault-when-badaccess.patch added to mm-unstable branch
Message-Id: <20240403204838.305FEC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86: mm: accelerate pagefault when badaccess
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-accelerate-pagefault-when-badaccess.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-accelerate-pagefault-when-badaccess.patch

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
Subject: x86: mm: accelerate pagefault when badaccess
Date: Wed, 3 Apr 2024 16:38:05 +0800

The access_error() of vma is already checked under per-VMA lock, if it is
a bad access, directly handle error, no need to retry with mmap_lock
again.  In order to release the correct lock, pass the mm_struct into
bad_area_access_error().  If mm is NULL, release vma lock, or release
mmap_lock.  Since the page faut is handled under per-VMA lock, count it as
a vma lock event with VMA_LOCK_SUCCESS.

Link: https://lkml.kernel.org/r/20240403083805.1818160-8-wangkefeng.wang@huawei.com
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
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

 arch/x86/mm/fault.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/arch/x86/mm/fault.c~x86-mm-accelerate-pagefault-when-badaccess
+++ a/arch/x86/mm/fault.c
@@ -866,14 +866,17 @@ bad_area_nosemaphore(struct pt_regs *reg
 
 static void
 __bad_area(struct pt_regs *regs, unsigned long error_code,
-	   unsigned long address, u32 pkey, int si_code)
+	   unsigned long address, struct mm_struct *mm,
+	   struct vm_area_struct *vma, u32 pkey, int si_code)
 {
-	struct mm_struct *mm = current->mm;
 	/*
 	 * Something tried to access memory that isn't in our memory map..
 	 * Fix it, but check if it's kernel or user first..
 	 */
-	mmap_read_unlock(mm);
+	if (mm)
+		mmap_read_unlock(mm);
+	else
+		vma_end_read(vma);
 
 	__bad_area_nosemaphore(regs, error_code, address, pkey, si_code);
 }
@@ -897,7 +900,8 @@ static inline bool bad_area_access_from_
 
 static noinline void
 bad_area_access_error(struct pt_regs *regs, unsigned long error_code,
-		      unsigned long address, struct vm_area_struct *vma)
+		      unsigned long address, struct mm_struct *mm,
+		      struct vm_area_struct *vma)
 {
 	/*
 	 * This OSPKE check is not strictly necessary at runtime.
@@ -927,9 +931,9 @@ bad_area_access_error(struct pt_regs *re
 		 */
 		u32 pkey = vma_pkey(vma);
 
-		__bad_area(regs, error_code, address, pkey, SEGV_PKUERR);
+		__bad_area(regs, error_code, address, mm, vma, pkey, SEGV_PKUERR);
 	} else {
-		__bad_area(regs, error_code, address, 0, SEGV_ACCERR);
+		__bad_area(regs, error_code, address, mm, vma, 0, SEGV_ACCERR);
 	}
 }
 
@@ -1357,8 +1361,9 @@ void do_user_addr_fault(struct pt_regs *
 		goto lock_mmap;
 
 	if (unlikely(access_error(error_code, vma))) {
-		vma_end_read(vma);
-		goto lock_mmap;
+		bad_area_access_error(regs, error_code, address, NULL, vma);
+		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
+		return;
 	}
 	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
 	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
@@ -1394,7 +1399,7 @@ retry:
 	 * we can handle it..
 	 */
 	if (unlikely(access_error(error_code, vma))) {
-		bad_area_access_error(regs, error_code, address, vma);
+		bad_area_access_error(regs, error_code, address, mm, vma);
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


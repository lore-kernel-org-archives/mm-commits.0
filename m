Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C7214C5B3
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 20:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712177314; cv=none; b=l+kvb2Wwif92SInJNS9DPj6n8D/r0D2k4sujxe3dg1cLNfMXEBIwgwLn0fw7rbooerpOqzqyW5ulMMau2y+ArF0quw7Hr7TcrV2evab1RPKFKXQjAC4qhJ0MAxqgdG3x7k/fxEUy4+HaHAaFTuef15Gcy6iIkgqgdwbr3X3JaK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712177314; c=relaxed/simple;
	bh=0FvtobxygP0TMg3tjaS1/1wnS7vt9vsCoDord0rHlq4=;
	h=Date:To:From:Subject:Message-Id; b=DLqQVPOEaewyQzkt/GkqrH22MbLOk512rYn8uslKyjZJhRgjxENdomSgKRAc5VXzA1IAhkoFmbJuG+XFjhNZdb0+e7bu+S9QhYvmuZaqKtye7HHuORYmY8UJM0W6zgBWGwA3N9HYb45qWgiJPTj3FBHvJLlzj8npnv8V2l238iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d+9A6Q6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d+9A6Q6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3B3C433C7;
	Wed,  3 Apr 2024 20:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712177313;
	bh=0FvtobxygP0TMg3tjaS1/1wnS7vt9vsCoDord0rHlq4=;
	h=Date:To:From:Subject:From;
	b=d+9A6Q6gDHCtzJTTKqzYtTMuTFZyFYpY+NHsQK57S9jWg89bUduYd+nZhmEY9fSPj
	 eZxCbeBUmSpUo4Xww6QWwPIZf30C2ZbzCwFv7supZXVCzb1JvmzJvvcSLFNAX5bexd
	 W+Mrroe3RjCBZwbjGNjB+Y7tyT7kxQM9fHWENTEA=
Date: Wed, 03 Apr 2024 13:48:33 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,surenb@google.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,luto@kernel.org,linux@armlinux.org.uk,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,aou@eecs.berkeley.edu,agordeev@linux.ibm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-accelerate-pagefault-when-badaccess.patch added to mm-unstable branch
Message-Id: <20240403204833.8F3B3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc: mm: accelerate pagefault when badaccess
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-mm-accelerate-pagefault-when-badaccess.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-accelerate-pagefault-when-badaccess.patch

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
Subject: powerpc: mm: accelerate pagefault when badaccess
Date: Wed, 3 Apr 2024 16:38:02 +0800

The access_[pkey]_error() of vma already checked under per-VMA lock, if it
is a bad access, directly handle error, no need to retry with mmap_lock
again.  In order to release the correct lock, pass the mm_struct into
bad_access_pkey()/bad_access(), if mm is NULL, release vma lock, or
release mmap_lock.  Since the page faut is handled under per-VMA lock,
count it as a vma lock event with VMA_LOCK_SUCCESS.

Link: https://lkml.kernel.org/r/20240403083805.1818160-5-wangkefeng.wang@huawei.com
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
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/fault.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

--- a/arch/powerpc/mm/fault.c~powerpc-mm-accelerate-pagefault-when-badaccess
+++ a/arch/powerpc/mm/fault.c
@@ -71,23 +71,26 @@ static noinline int bad_area_nosemaphore
 	return __bad_area_nosemaphore(regs, address, SEGV_MAPERR);
 }
 
-static int __bad_area(struct pt_regs *regs, unsigned long address, int si_code)
+static int __bad_area(struct pt_regs *regs, unsigned long address, int si_code,
+		      struct mm_struct *mm, struct vm_area_struct *vma)
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
 
 	return __bad_area_nosemaphore(regs, address, si_code);
 }
 
 static noinline int bad_access_pkey(struct pt_regs *regs, unsigned long address,
+				    struct mm_struct *mm,
 				    struct vm_area_struct *vma)
 {
-	struct mm_struct *mm = current->mm;
 	int pkey;
 
 	/*
@@ -109,7 +112,10 @@ static noinline int bad_access_pkey(stru
 	 */
 	pkey = vma_pkey(vma);
 
-	mmap_read_unlock(mm);
+	if (mm)
+		mmap_read_unlock(mm);
+	else
+		vma_end_read(vma);
 
 	/*
 	 * If we are in kernel mode, bail out with a SEGV, this will
@@ -124,9 +130,10 @@ static noinline int bad_access_pkey(stru
 	return 0;
 }
 
-static noinline int bad_access(struct pt_regs *regs, unsigned long address)
+static noinline int bad_access(struct pt_regs *regs, unsigned long address,
+			       struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	return __bad_area(regs, address, SEGV_ACCERR);
+	return __bad_area(regs, address, SEGV_ACCERR, mm, vma);
 }
 
 static int do_sigbus(struct pt_regs *regs, unsigned long address,
@@ -479,13 +486,13 @@ static int ___do_page_fault(struct pt_re
 
 	if (unlikely(access_pkey_error(is_write, is_exec,
 				       (error_code & DSISR_KEYFAULT), vma))) {
-		vma_end_read(vma);
-		goto lock_mmap;
+		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
+		return bad_access_pkey(regs, address, NULL, vma);
 	}
 
 	if (unlikely(access_error(is_write, is_exec, vma))) {
-		vma_end_read(vma);
-		goto lock_mmap;
+		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
+		return bad_access(regs, address, NULL, vma);
 	}
 
 	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
@@ -521,10 +528,10 @@ retry:
 
 	if (unlikely(access_pkey_error(is_write, is_exec,
 				       (error_code & DSISR_KEYFAULT), vma)))
-		return bad_access_pkey(regs, address, vma);
+		return bad_access_pkey(regs, address, mm, vma);
 
 	if (unlikely(access_error(is_write, is_exec, vma)))
-		return bad_access(regs, address);
+		return bad_access(regs, address, mm, vma);
 
 	/*
 	 * If for any reason at all we couldn't handle the fault,
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


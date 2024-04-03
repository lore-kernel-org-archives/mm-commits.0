Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7293614C5B3
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 20:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712177312; cv=none; b=H7M3xNgs7qZpfmifysP01qX/xEaKeQ4gwFvy6q3/B1+7htX48M0UboIqucHCE9qT2tfVgSt4UGaqvPqG3n1An4pjbUrzUEpFpt30pMWgqG4c4Wb3MzHPlnTzQjjbxv3zuK/oduNofWskHPhtLXTnDud2k9ImHBTS6vVAV0hlI4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712177312; c=relaxed/simple;
	bh=uS0hO4U/NGFJc2NFf4hHk1BzeCIn9/WBUfOO74r/Emg=;
	h=Date:To:From:Subject:Message-Id; b=oFjJ5lTZtnLGf0gyRMwirbv6xgFJjR0+LCLGYcpMH9dx4Z9Kx7z5EGRA8Hdtsy2jDGEsmI2hGsNqCXqLYItZYWD50+9kOKxa4zd0sypRmUX3mzalykTPl8V8FBrQn9N28emKzcTMRIH1z5uO1dyqCVevJQ3TyYkEyyl4elh3ci4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RWYBlbl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RWYBlbl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0729AC433C7;
	Wed,  3 Apr 2024 20:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712177312;
	bh=uS0hO4U/NGFJc2NFf4hHk1BzeCIn9/WBUfOO74r/Emg=;
	h=Date:To:From:Subject:From;
	b=RWYBlbl90oGF01AT1GUpxZom3hAtfRPYGvPUKn6SApsDuhhaL7d7s2/n+1vFW+YXc
	 cMZxzsbLt0wmiUjQ711PxmX+pe90FNtW1TvimTLBKiiwHRBMFMf8lpr2MdELapWGRe
	 NXS7eCZKxSeA9kqFLFhXItgK2y6xCIUUt5t46TaQ=
Date: Wed, 03 Apr 2024 13:48:31 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,surenb@google.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,luto@kernel.org,linux@armlinux.org.uk,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,aou@eecs.berkeley.edu,agordeev@linux.ibm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-mm-accelerate-pagefault-when-vm_fault_badaccess.patch added to mm-unstable branch
Message-Id: <20240403204832.0729AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm: mm: accelerate pagefault when VM_FAULT_BADACCESS
has been added to the -mm mm-unstable branch.  Its filename is
     arm-mm-accelerate-pagefault-when-vm_fault_badaccess.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-mm-accelerate-pagefault-when-vm_fault_badaccess.patch

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

mm-backing-dev-use-group-allocation-free-of-per-cpu-counters-api.patch
mm-remove-__set_page_dirty_nobuffers.patch
arm64-mm-cleanup-__do_page_fault.patch
arm64-mm-accelerate-pagefault-when-vm_fault_badaccess.patch
arm-mm-accelerate-pagefault-when-vm_fault_badaccess.patch
powerpc-mm-accelerate-pagefault-when-badaccess.patch
riscv-mm-accelerate-pagefault-when-badaccess.patch
s390-mm-accelerate-pagefault-when-badaccess.patch
x86-mm-accelerate-pagefault-when-badaccess.patch


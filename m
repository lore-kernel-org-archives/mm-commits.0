Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DC4153BF3
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 20:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712177309; cv=none; b=A9+e9wHm9NGcuCtXJbgbTS1Y6R6iV+JIjRy8hgzB+hk9s7iLsZzD6Qt2iPUJSiH3gPp5JLmLH3nlKB9aLVBBsI7JYhOoR9Vhfm2psM9nrH2w7sg4/BrVP8o3Ruyza5TPCOmiVPP6c1vYziljyY/xDANFNiFZ7Exdjg+kAbN7mTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712177309; c=relaxed/simple;
	bh=HWBzqPNE7gjs7ay/3HkhivFeHZa0Me2HETvEiYNTXxE=;
	h=Date:To:From:Subject:Message-Id; b=bCYv2GYHdKd0ozSKKYZnLPYIb69lkwgYzCufJafTUS5SKoOQ7UnrcK0oX+M46Apf33HAXSdTSPJumYy6NdILSRdbCRVRRDSuxlm4VeZqYGAwRIrrW/wfhc1xW9sceMNVPwnN7VZGcaZoYuinQSquxJgxJyrMhFyXec5SCC7BoOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rFhgbqhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rFhgbqhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DEEC433C7;
	Wed,  3 Apr 2024 20:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712177308;
	bh=HWBzqPNE7gjs7ay/3HkhivFeHZa0Me2HETvEiYNTXxE=;
	h=Date:To:From:Subject:From;
	b=rFhgbqhW6atfHlbcPxvimSAxwOXIGq9elttZ5hao2mGPGuVL43w/3JIoOKlZGjM5l
	 /3fs00bOrZk9NNqHe5lXgvHK7QoFjbuSTISQ2+vo/baD28/ygxWlcDUWyLUhBgPsfz
	 t2NR4cAejxaTxfnF28mmOXaMZBfyqU2Pn2ldEcEU=
Date: Wed, 03 Apr 2024 13:48:28 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,surenb@google.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,luto@kernel.org,linux@armlinux.org.uk,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,aou@eecs.berkeley.edu,agordeev@linux.ibm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-cleanup-__do_page_fault.patch added to mm-unstable branch
Message-Id: <20240403204828.C0DEEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mm: cleanup __do_page_fault()
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-cleanup-__do_page_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-cleanup-__do_page_fault.patch

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
Subject: arm64: mm: cleanup __do_page_fault()
Date: Wed, 3 Apr 2024 16:37:59 +0800

Patch series "arch/mm/fault: accelerate pagefault when badaccess", v2.

After VMA lock-based page fault handling enabled, if bad access met
under per-vma lock, it will fallback to mmap_lock-based handling,
so it leads to unnessary mmap lock and vma find again. A test from
lmbench shows 34% improve after this changes on arm64,

  lat_sig -P 1 prot lat_sig 0.29194 -> 0.19198


This patch (of 7):

The __do_page_fault() only calls handle_mm_fault() after vm_flags checked,
and it is only called by do_page_fault(), let's squash it into
do_page_fault() to cleanup code.

Link: https://lkml.kernel.org/r/20240403083805.1818160-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240403083805.1818160-2-wangkefeng.wang@huawei.com
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

 arch/arm64/mm/fault.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

--- a/arch/arm64/mm/fault.c~arm64-mm-cleanup-__do_page_fault
+++ a/arch/arm64/mm/fault.c
@@ -486,25 +486,6 @@ static void do_bad_area(unsigned long fa
 	}
 }
 
-#define VM_FAULT_BADMAP		((__force vm_fault_t)0x010000)
-#define VM_FAULT_BADACCESS	((__force vm_fault_t)0x020000)
-
-static vm_fault_t __do_page_fault(struct mm_struct *mm,
-				  struct vm_area_struct *vma, unsigned long addr,
-				  unsigned int mm_flags, unsigned long vm_flags,
-				  struct pt_regs *regs)
-{
-	/*
-	 * Ok, we have a good vm_area for this memory access, so we can handle
-	 * it.
-	 * Check that the permissions on the VMA allow for the fault which
-	 * occurred.
-	 */
-	if (!(vma->vm_flags & vm_flags))
-		return VM_FAULT_BADACCESS;
-	return handle_mm_fault(vma, addr, mm_flags, regs);
-}
-
 static bool is_el0_instruction_abort(unsigned long esr)
 {
 	return ESR_ELx_EC(esr) == ESR_ELx_EC_IABT_LOW;
@@ -519,6 +500,9 @@ static bool is_write_abort(unsigned long
 	return (esr & ESR_ELx_WNR) && !(esr & ESR_ELx_CM);
 }
 
+#define VM_FAULT_BADMAP		((__force vm_fault_t)0x010000)
+#define VM_FAULT_BADACCESS	((__force vm_fault_t)0x020000)
+
 static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 				   struct pt_regs *regs)
 {
@@ -617,7 +601,10 @@ retry:
 		goto done;
 	}
 
-	fault = __do_page_fault(mm, vma, addr, mm_flags, vm_flags, regs);
+	if (!(vma->vm_flags & vm_flags))
+		fault = VM_FAULT_BADACCESS;
+	else
+		fault = handle_mm_fault(vma, addr, mm_flags, regs);
 
 	/* Quick path to respond to signals */
 	if (fault_signal_pending(fault, regs)) {
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


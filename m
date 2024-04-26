Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63647F7C1
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104146; cv=none; b=BMM3sLqhkt/0+lzkIK2hEddTkn4M/sVmYhujkJs+1AAGIdB1kPHm7gQP/9GRwU+faRB/v90j5xyXi8ykQMszOeSicBloNX2bBzt5jBkE9CXepqRnU7rPTXwQaIWKF/zZrCIg7aqbIWOiS04GI8SphFtmG73ePVZ6O3zVr7rsnDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104146; c=relaxed/simple;
	bh=7I1ei5DvYSa0iJubSX3zqTjumkOg86lq9jQSivQBTGY=;
	h=Date:To:From:Subject:Message-Id; b=MXcg2D1lTe3EhcpfioswluAFCnOe9FpckhJaTK2BAIpu4e5Cex0kgVWGlGhpO2kUJ5gbzsMViCvfp9do75/bI3XJx2/PriswS2byJoJS2xlssA3sZbGJCs1zJFzSulT9sK8LCtgUor8Unqjow9YheKt3LeUwA/OIep+wV+UWPgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KHrzP+Ha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KHrzP+Ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB2AC113CD;
	Fri, 26 Apr 2024 04:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104146;
	bh=7I1ei5DvYSa0iJubSX3zqTjumkOg86lq9jQSivQBTGY=;
	h=Date:To:From:Subject:From;
	b=KHrzP+HaNTcaKnHG1SA85ytEiuf+pn9e04FaDdTbplJr4iUPrI+J+KlU+TwRk/Uu8
	 b1qd4tWGRio82pgQSL0kV+/PYwiDC9Z1Z08Ud/VafoCcNfc8mbxKvOz+NpJQiSUGTx
	 zZfJ5Wc0bvN7kmZAMY6Ct3ovWybitNwSlekgMwDY=
Date: Thu, 25 Apr 2024 21:02:26 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,surenb@google.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,luto@kernel.org,linux@armlinux.org.uk,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,aou@eecs.berkeley.edu,agordeev@linux.ibm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-cleanup-__do_page_fault.patch removed from -mm tree
Message-Id: <20240426040226.7CB2AC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mm: cleanup __do_page_fault()
has been removed from the -mm tree.  Its filename was
     arm64-mm-cleanup-__do_page_fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
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

arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
mm-move-mm-counter-updating-out-of-set_pte_range.patch
mm-filemap-batch-mm-counter-updating-in-filemap_map_pages.patch
mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch
mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch


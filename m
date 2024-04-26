Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF028062B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104154; cv=none; b=l9EjwnEEyWxjCidksDn16e02m+BzilxxnFBl4gUWOqOrgmK2TuYDLzWgzDqcHYihzg+VmnnsQFHAygvGm+jb9ci5mBcbbFjhzBtoOJEMtGE7l29ztwbPaSWKxUWx7ApiPcKa/FS3ee18BSATCYqitQO8QTRSHXD2lDjSPsF1t8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104154; c=relaxed/simple;
	bh=EpY8CKZu3tXNvGMJ852M1i8M1L1aA4EaElIWgmRqwq8=;
	h=Date:To:From:Subject:Message-Id; b=gDB0cdMnIP1tiMfRLVs0A9sUOZInbyoGb3PT4FtGdxWCYtXNL/ngQBoCi0qyGqBjP6+1C1wD1QndtIybKUGpE8tXHbhrP1JsTundx0UKlV0CV1nMhDkAdjgV0nUNylvNQ9kqlBXK5+OjOfL9boP4ScoejThSE+FeUJgsKno9ayk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DSTMG0li; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DSTMG0li"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C55C32781;
	Fri, 26 Apr 2024 04:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104154;
	bh=EpY8CKZu3tXNvGMJ852M1i8M1L1aA4EaElIWgmRqwq8=;
	h=Date:To:From:Subject:From;
	b=DSTMG0liXBPbIIsB733jIsMl9ZRda8kvAQmy6gFOJh4d7lyuXOrmh/v+epnfBBfft
	 1Tb91zt0vp1Md+YqzyGSn3Jgd9ntfLg6MkhljYAt4wJf6W4NDzo0Mqpltja9rbYKxh
	 ogIjhg+acpVVV3GVemMW9dbpoa2y23cRf2FVx3ds=
Date: Thu, 25 Apr 2024 21:02:34 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,surenb@google.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,luto@kernel.org,linux@armlinux.org.uk,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,aou@eecs.berkeley.edu,agordeev@linux.ibm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-accelerate-pagefault-when-badaccess.patch removed from -mm tree
Message-Id: <20240426040234.89C55C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: mm: accelerate pagefault when badaccess
has been removed from the -mm tree.  Its filename was
     x86-mm-accelerate-pagefault-when-badaccess.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
mm-move-mm-counter-updating-out-of-set_pte_range.patch
mm-filemap-batch-mm-counter-updating-in-filemap_map_pages.patch
mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch
mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch


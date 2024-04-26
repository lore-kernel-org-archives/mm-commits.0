Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EF380C0B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104150; cv=none; b=NmXDzP3Sr5UqcGuXOiZbGNksz0xWyH/WctD+lWkJkoucJnyR4AFGeSQ26gC6+f3Hp0SZnCv+FM/UKCSmrvQmxOz+8HfgBqbCOFJYhNocJXyckfl+vtEHWyuMvNnv9sSplAfWtJul3wpIM9PUJ9MXGwTZX3GBmoRT/wyQz/td7UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104150; c=relaxed/simple;
	bh=SxlMKhIu8oSDkQfV16+0YzdGxV9qauI0adXmgRBRDDE=;
	h=Date:To:From:Subject:Message-Id; b=FA6fRzL7mOPMeJlbut1daq9v6Ie9pyk9vI1iitQU4jK07sdLQARvZF1MHHXqZ8uz9JPATb9S702C4Ey9oGgfNlnw4FljeLRzrSpwyZBa6hnfVq22NAPCulzm6JUbzNE6BU3ATj32AHLU1uyZJOoW0tvt62tyMageN0Sb19ga4TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WjWVDc51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WjWVDc51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083D9C2BD11;
	Fri, 26 Apr 2024 04:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104150;
	bh=SxlMKhIu8oSDkQfV16+0YzdGxV9qauI0adXmgRBRDDE=;
	h=Date:To:From:Subject:From;
	b=WjWVDc51eM8L1AHLB+WgIMJDXINjnUxuyFqXuRAuJ6puz+BC6DmYVyJ9Bq7oVx6ou
	 tNfAEtgYErpvbPCOXZo2fZ3KEgIfgAonP0MHRvyo34ONngLu2iRvvzxhQZT1S2roOS
	 4VbazhVN6awP6PAS2SZ7oBxNNLPMUwbwC6DUt1iw=
Date: Thu, 25 Apr 2024 21:02:29 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,surenb@google.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,luto@kernel.org,linux@armlinux.org.uk,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,aou@eecs.berkeley.edu,agordeev@linux.ibm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-mm-accelerate-pagefault-when-badaccess.patch removed from -mm tree
Message-Id: <20240426040230.083D9C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc: mm: accelerate pagefault when badaccess
has been removed from the -mm tree.  Its filename was
     powerpc-mm-accelerate-pagefault-when-badaccess.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
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

arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
mm-move-mm-counter-updating-out-of-set_pte_range.patch
mm-filemap-batch-mm-counter-updating-in-filemap_map_pages.patch
mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch
mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch


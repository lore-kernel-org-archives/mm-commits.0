Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97994181B96
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 20:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712780263; cv=none; b=UY+a3kygnlOifXas+oTRYtHcj+aHgsNaqBAwSzu6++aQdJlVqBX+hLE52m2Gm8Hb+NJrIVX75J8CllV6lq9kYRxutoGQBQlxSQHdz8Jr9GwkD+au3RGaNjHisyPUTO/VVAUqd5V38M1as7oQmRxQYsI4T+gtAo6N4cImJYr82Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712780263; c=relaxed/simple;
	bh=N0V17G55fMcPhzzyPw7TWscPsxK76pCMnX9SoS07MCc=;
	h=Date:To:From:Subject:Message-Id; b=XFWWW+JxUrj5pD5Cam1+DVVyVUybeD/CXDHXaEUwRWYZIm3DwT4M++2kECNTrpdUhPACjETTUSHmSKfsNrU8FXpOOEYxHpIvwoDNQBw5E3utopO8L3T8Hdh5+mKwcFmW/ySpowiHqpEBo0Kd3rIzz0KavkjcLnGIOY/PbDoTa7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G5KT1AqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G5KT1AqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6393AC433C7;
	Wed, 10 Apr 2024 20:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712780263;
	bh=N0V17G55fMcPhzzyPw7TWscPsxK76pCMnX9SoS07MCc=;
	h=Date:To:From:Subject:From;
	b=G5KT1AqFctGqfSeakZZF41FSqVTlNzRAfJLFwRcdMFxosB4xAFWxdapxtkzdr/zIw
	 hRQx9jOQ6OU6AnlJb1xxUin634+33HSNSYwVnRE3LK0xFw33AuoKYQFMW9PV7fcwiA
	 DxI66IPl5pndVRI6rt1FlG8F/FQEC0Oj6FjA6EsU=
Date: Wed, 10 Apr 2024 13:17:42 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,linux@armlinux.org.uk,catalin.marinas@arm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch removed from -mm tree
Message-Id: <20240410201743.6393AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm: mm: drop VM_FAULT_BADMAP/VM_FAULT_BADACCESS
has been removed from the -mm tree.  Its filename was
     arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: arm: mm: drop VM_FAULT_BADMAP/VM_FAULT_BADACCESS
Date: Sun, 7 Apr 2024 16:12:11 +0800

If bad map or access, directly set si_code to SEGV_MAPRR or SEGV_ACCERR,
also set fault to 0 and goto error handling, which make us to drop the
arch's special vm fault reason.

Link: https://lkml.kernel.org/r/20240407081211.2292362-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

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
 
@@ -329,10 +328,13 @@ retry:
 	 * ok, we have a good vm_area for this memory access, check the
 	 * permissions on the VMA allow for the fault which occurred.
 	 */
-	if (!(vma->vm_flags & vm_flags))
-		fault = VM_FAULT_BADACCESS;
-	else
-		fault = handle_mm_fault(vma, addr & PAGE_MASK, flags, regs);
+	if (!(vma->vm_flags & vm_flags)) {
+		fault = 0;
+		code = SEGV_ACCERR;
+		goto bad_area;
+	}
+
+	fault = handle_mm_fault(vma, addr & PAGE_MASK, flags, regs);
 
 	/* If we need to retry but a fatal signal is pending, handle the
 	 * signal first. We do not need to release the mmap_lock because
@@ -358,10 +360,8 @@ retry:
 	mmap_read_unlock(mm);
 done:
 
-	/*
-	 * Handle the "normal" case first - VM_FAULT_MAJOR
-	 */
-	if (likely(!(fault & (VM_FAULT_ERROR | VM_FAULT_BADMAP | VM_FAULT_BADACCESS))))
+	/* Handle the "normal" case first */
+	if (likely(!(fault & VM_FAULT_ERROR)))
 		return 0;
 
 bad_area:
@@ -395,8 +395,6 @@ bad_area:
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


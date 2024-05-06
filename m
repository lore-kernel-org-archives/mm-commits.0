Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B4313AF2
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957019; cv=none; b=YxlelPL1yZ/kvz9N27dLaCeyLa4DAZ5knFZGXl7qnEpD/WhMI6XVFg902uGiDrlM5iJfMLOpkJw6B8m+FQbgXEj4eyNiq7WrsWTf2Pws6Uw784aMwBBlAWWbtX1qb/677kcVtX/oM2xfivoHd498KZcAmq3MulBHriu98Z0nq6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957019; c=relaxed/simple;
	bh=6/BtAnqfHmnSVbHZma8qqKeiJ3FS+4e9TcQvXc/CuuA=;
	h=Date:To:From:Subject:Message-Id; b=pnWlKQF1EHjVdTFYlA9+fC37q9ePFRYOo8DBBaF0AlBJk2uxllObsZDqk3tOo3WKivxwpxLvbzstiaW0fnGFjkQXQw4NNUewCK5jp8dnhdYXZwGsk+Adju2VNQERuOiEJ0/fqp2DpnizaAc4bKlHrQ6YAiRkQ6zELDiy1B/6ne0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=liloWknt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="liloWknt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAC5C113CC;
	Mon,  6 May 2024 00:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957019;
	bh=6/BtAnqfHmnSVbHZma8qqKeiJ3FS+4e9TcQvXc/CuuA=;
	h=Date:To:From:Subject:From;
	b=liloWkntgX+yBYiQaK226JogmNlOtt4FI6UPQdk79udFQlc1Q6UCoo6tmyYYjMUpd
	 nxaMs7jvc9/a+WX+hai+MoUVN21SL65wHyUPfQ24IdYRgEXb8P+Vu9y68lDheQbGre
	 mCerBDCySqdEia5CQI5wzTBO4OE4B5srqUcvBkL0=
Date: Sun, 05 May 2024 17:56:59 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,linux@armlinux.org.uk,cristian.marussi@arm.com,catalin.marinas@arm.com,broonie@kernel.org,aishwarya.tcv@arm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch removed from -mm tree
Message-Id: <20240506005659.7AAC5C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm: mm: drop VM_FAULT_BADMAP/VM_FAULT_BADACCESS
has been removed from the -mm tree.  Its filename was
     arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: arm: mm: drop VM_FAULT_BADMAP/VM_FAULT_BADACCESS
Date: Thu, 11 Apr 2024 21:09:25 +0800

If bad map or access, directly set code to SEGV_MAPRR or SEGV_ACCERR, also
set fault to 0 and goto error handling, which make us to drop the arch's
special vm fault reason.

[akpm@linux-foundation.org: coding-style cleanups]
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
 
+	code = SEGV_MAPERR;
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD9E14C5B3
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 20:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712177317; cv=none; b=LYNvkt6ejLUjoV1eC6d9AdWqzcZv7BeJkAxb6Z7DxthA9bkToKtUybRdekVERuZATwqAkAVVh0Es+KTSXWSMKwDaEuWLlNYyF524kx40RfdG3k1t4rwwUq/SIfkZIq5QZho4VEvtPFjkMyXkODBqTaRN96l3zq53yQO/krtuen4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712177317; c=relaxed/simple;
	bh=iIfI9qEO0BLuxKN+jC7TJctffHB4v0QoxUoMDBCskjA=;
	h=Date:To:From:Subject:Message-Id; b=Wj7WQOE8h+XJJ1EdJK9yAQWieFE0lokixXS7mLhfW0nOBBK/CGYpuCwEH+tVLfpML3MEJMPJlB/TvgfkiMZ53Y82nWzQxeoeTsuiONIrvvlQ9z0Y9Wo8gxr6p1r6avBG7V5WpKN7zUa/ZxyQmKLxVNpRgaEYXzdNIsBymaEV60s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NsYO84hp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NsYO84hp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8363C433C7;
	Wed,  3 Apr 2024 20:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712177316;
	bh=iIfI9qEO0BLuxKN+jC7TJctffHB4v0QoxUoMDBCskjA=;
	h=Date:To:From:Subject:From;
	b=NsYO84hplgQ2KC42MCcck69395cE6RX7Q1ierX7yn32TJaOzN6NOiguunAys1C6S6
	 PQZA3nLO6liScupc5pRVo4mqbeX5I52TxMTyp7HlZ0xQeotdRE4WWHx0CFqi7lt84b
	 TQajR2y8bLTKU6nZqsuOEG/xb3E+pZ6OEwiHSXFA=
Date: Wed, 03 Apr 2024 13:48:36 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,surenb@google.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,luto@kernel.org,linux@armlinux.org.uk,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,aou@eecs.berkeley.edu,agordeev@linux.ibm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-mm-accelerate-pagefault-when-badaccess.patch added to mm-unstable branch
Message-Id: <20240403204836.A8363C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390: mm: accelerate pagefault when badaccess
has been added to the -mm mm-unstable branch.  Its filename is
     s390-mm-accelerate-pagefault-when-badaccess.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-mm-accelerate-pagefault-when-badaccess.patch

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
Subject: s390: mm: accelerate pagefault when badaccess
Date: Wed, 3 Apr 2024 16:38:04 +0800

The vm_flags of vma already checked under per-VMA lock, if it is a bad
access, directly handle error, no need to retry with mmap_lock again. 
Since the page faut is handled under per-VMA lock, count it as a vma lock
event with VMA_LOCK_SUCCESS.

Link: https://lkml.kernel.org/r/20240403083805.1818160-7-wangkefeng.wang@huawei.com
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

 arch/s390/mm/fault.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/mm/fault.c~s390-mm-accelerate-pagefault-when-badaccess
+++ a/arch/s390/mm/fault.c
@@ -325,7 +325,8 @@ static void do_exception(struct pt_regs
 		goto lock_mmap;
 	if (!(vma->vm_flags & access)) {
 		vma_end_read(vma);
-		goto lock_mmap;
+		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
+		return handle_fault_error_nolock(regs, SEGV_ACCERR);
 	}
 	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
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


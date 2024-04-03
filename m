Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD8914C5B3
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 20:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712177315; cv=none; b=N4/Ld3SH9MJc5ht//LYjB+WsWNHR2oojcyPjJpaWlV9l/7HAxLtpSbzShU7i6FSRYDfH2yJbSCSlzdprOwHKz4lbEnMYjgnnxuIaNPInutFaXfCp6VwVaHjMY7dEk17YSchLjsDUWFK0km7yziw37XyM4PTuzBYODSAFVNzZhrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712177315; c=relaxed/simple;
	bh=/lDCA7Nrlk32IDQOEWel2+ll06MPYRHHzn2yI8+7QZ4=;
	h=Date:To:From:Subject:Message-Id; b=Pb6suqF62eegMNf8MQMotBw0qdi3P/zBPxnQTTcH8dnoZaAG2xfcEhmtaV7IMjIhTjB0sDy8Kq5w6gGuSR0qGmqNAc+WiHcchm2hRaqYM1pSBr2eQ1iD4OtW1777h6TMnjtbakrPNySu9Xft8JEnNSNbVKyxSrVKJ6dm73YIUTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yMwlJxuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yMwlJxuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23052C433F1;
	Wed,  3 Apr 2024 20:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712177315;
	bh=/lDCA7Nrlk32IDQOEWel2+ll06MPYRHHzn2yI8+7QZ4=;
	h=Date:To:From:Subject:From;
	b=yMwlJxuGup2KWBSJZInukqlCg4RG1mw9qtGYnUcF/bh9ULrcS4Yk2rHFoZz0VHWw3
	 EYGwitGYHUNyXYs/V5+HbV59bt7JwcFqdsIjcv/DcAeTI/erdfBCMQdOVmn4GwyF26
	 j/jrAmHhZbgPI702rVCw90eoZiSLER/xTzdpcVy0=
Date: Wed, 03 Apr 2024 13:48:34 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,surenb@google.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,luto@kernel.org,linux@armlinux.org.uk,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,aou@eecs.berkeley.edu,agordeev@linux.ibm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-mm-accelerate-pagefault-when-badaccess.patch added to mm-unstable branch
Message-Id: <20240403204835.23052C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: mm: accelerate pagefault when badaccess
has been added to the -mm mm-unstable branch.  Its filename is
     riscv-mm-accelerate-pagefault-when-badaccess.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-mm-accelerate-pagefault-when-badaccess.patch

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
Subject: riscv: mm: accelerate pagefault when badaccess
Date: Wed, 3 Apr 2024 16:38:03 +0800

The access_error() of vma already checked under per-VMA lock, if it is a
bad access, directly handle error, no need to retry with mmap_lock again. 
Since the page faut is handled under per-VMA lock, count it as a vma lock
event with VMA_LOCK_SUCCESS.

Link: https://lkml.kernel.org/r/20240403083805.1818160-6-wangkefeng.wang@huawei.com
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

 arch/riscv/mm/fault.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/riscv/mm/fault.c~riscv-mm-accelerate-pagefault-when-badaccess
+++ a/arch/riscv/mm/fault.c
@@ -292,7 +292,10 @@ void handle_page_fault(struct pt_regs *r
 
 	if (unlikely(access_error(cause, vma))) {
 		vma_end_read(vma);
-		goto lock_mmap;
+		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
+		tsk->thread.bad_cause = SEGV_ACCERR;
+		bad_area_nosemaphore(regs, code, addr);
+		return;
 	}
 
 	fault = handle_mm_fault(vma, addr, flags | FAULT_FLAG_VMA_LOCK, regs);
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA56780BF7
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104147; cv=none; b=b9DufJ91bNhPibbHqZjlwgZ+ARs9eKvKahNMTUA51ZnhcnFu5JbpdfY88tmTmDbkDn5B7aPN2Mb5dIxR8sEN5PMxnaxKjwsYuhjiZDPNqung2EBIvwQKCKqXynq2ZrVoLT6X7+X6k8FsFr1bEbbqL/OomMq2oAoljHs1lFqNeU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104147; c=relaxed/simple;
	bh=kLTzrlYjljz/gn94mlgYN0tggWycAnBnSjG42PldONQ=;
	h=Date:To:From:Subject:Message-Id; b=Qmy182M0SbGntv14tut7gbXmVed0nFTVjL7WbyfFfo9a1lOtfCTEy15LDJPixupe6vh1i6/ZZ16w62DZKE/ai5cyoVnwZksn8KslgwkdrQoMNstsccVWyyka9NZRGw3MDeZPVQ1c5epCvDo0qPVAmFvFFfzSHONodhCTBdujFF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rkhydvBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rkhydvBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54B7C113CD;
	Fri, 26 Apr 2024 04:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104147;
	bh=kLTzrlYjljz/gn94mlgYN0tggWycAnBnSjG42PldONQ=;
	h=Date:To:From:Subject:From;
	b=rkhydvBBz+tw6gZDQdKQqiLXbuWtRAu3K0VNZY6QSDV2uN20gwxuOiytZ52z3c2dk
	 //qnrr3RwJiUlrqXRUMMvIUOZLk9bxlBHlTkzdE5Q40oswjdcCh/7hlRucpy3m/M9B
	 9hnQzpTSHHPRqlEPCDEw2o3+HM3KKOFJNuZIhrjk=
Date: Thu, 25 Apr 2024 21:02:27 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,surenb@google.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,luto@kernel.org,linux@armlinux.org.uk,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,aou@eecs.berkeley.edu,agordeev@linux.ibm.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-accelerate-pagefault-when-vm_fault_badaccess.patch removed from -mm tree
Message-Id: <20240426040227.A54B7C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mm: accelerate pagefault when VM_FAULT_BADACCESS
has been removed from the -mm tree.  Its filename was
     arm64-mm-accelerate-pagefault-when-vm_fault_badaccess.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: arm64: mm: accelerate pagefault when VM_FAULT_BADACCESS
Date: Wed, 3 Apr 2024 16:38:00 +0800

The vm_flags of vma already checked under per-VMA lock, if it is a bad
access, directly set fault to VM_FAULT_BADACCESS and handle error, no need
to retry with mmap_lock again, the latency time reduces 34% in 'lat_sig -P
1 prot lat_sig' from lmbench testcase.

Since the page fault is handled under per-VMA lock, count it as a vma lock
event with VMA_LOCK_SUCCESS.

Link: https://lkml.kernel.org/r/20240403083805.1818160-3-wangkefeng.wang@huawei.com
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

 arch/arm64/mm/fault.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/mm/fault.c~arm64-mm-accelerate-pagefault-when-vm_fault_badaccess
+++ a/arch/arm64/mm/fault.c
@@ -572,7 +572,9 @@ static int __kprobes do_page_fault(unsig
 
 	if (!(vma->vm_flags & vm_flags)) {
 		vma_end_read(vma);
-		goto lock_mmap;
+		fault = VM_FAULT_BADACCESS;
+		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
+		goto done;
 	}
 	fault = handle_mm_fault(vma, addr, mm_flags | FAULT_FLAG_VMA_LOCK, regs);
 	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
mm-move-mm-counter-updating-out-of-set_pte_range.patch
mm-filemap-batch-mm-counter-updating-in-filemap_map_pages.patch
mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch
mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch


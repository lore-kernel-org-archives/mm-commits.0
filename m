Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2831EEA2A
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 23:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741043396; cv=none; b=NJrqdMTKrHmw4l9CGMBEFXdB2DfEn3mHEVZZ7FRMcJBXec4sU94boZGssFJSH25m0h2qtINJ8A/bZCAM0ZzMwZJCywZLhUaMQkl6LMnJqUCzYBU+OqYrn1wikkoovjAkGexPTxCoSqnz+RS6+3oNqmMEpdx0wKP+u65FkAKeJnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741043396; c=relaxed/simple;
	bh=vQz8U5rEOMePJtCGzZwu3zJypmyH9zxz7IE0xQpSY24=;
	h=Date:To:From:Subject:Message-Id; b=C+xUmw3Xvc2tJr539CmTxDWBwR0axwD4zmttr0sOYcLmSFGtrbWxW6emsnG3Tbuy+cSOu9XoQQ0EH31gsMgJyrrhzSDyw7CNb4U3ZG/At0kot//tIXSwGQ/ejnQhBwFFmPo/rwQwZpvnHwjGENJp+nc+eSlw6eTQ9Pwr4rWboko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bPEuFBej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bPEuFBej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF16C4CEE8;
	Mon,  3 Mar 2025 23:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741043395;
	bh=vQz8U5rEOMePJtCGzZwu3zJypmyH9zxz7IE0xQpSY24=;
	h=Date:To:From:Subject:From;
	b=bPEuFBej3wuTV12zNDhv4lHVOqYwX9LgbOfwzRtsgEvnmixO2bFMHrHY6lHT9bDFT
	 iUwsk0eeCylGvdKNIeIkuLFpRKOwwXQMuC1+OK2XAImqBiar00Ipz8UxmvxQOw2xPr
	 WTckfxbCcdExJ2J4pmx12vc4uwFRD+Zn16u39Ze4=
Date: Mon, 03 Mar 2025 15:09:54 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,mingo@redhat.com,jgross@suse.com,hpa@zytor.com,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,andreas@gaisler.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-reduce-scope-of-lazy-mmu-region.patch added to mm-unstable branch
Message-Id: <20250303230955.6AF16C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: reduce scope of lazy mmu region
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-reduce-scope-of-lazy-mmu-region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-reduce-scope-of-lazy-mmu-region.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: fs/proc/task_mmu: reduce scope of lazy mmu region
Date: Mon, 3 Mar 2025 14:15:36 +0000

Update the way arch_[enter|leave]_lazy_mmu_mode() is called in
pagemap_scan_pmd_entry() to follow the normal pattern of holding the ptl
for user space mappings.  As a result the scope is reduced to only the pte
table, but that's where most of the performance win is.

While I believe there wasn't technically a bug here, the original scope
made it easier to accidentally nest or, worse, accidentally call something
like kmap() which would expect an immediate mode pte modification but it
would end up deferred.

Link: https://lkml.kernel.org/r/20250303141542.3371656-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-reduce-scope-of-lazy-mmu-region
+++ a/fs/proc/task_mmu.c
@@ -2479,22 +2479,19 @@ static int pagemap_scan_pmd_entry(pmd_t
 	spinlock_t *ptl;
 	int ret;
 
-	arch_enter_lazy_mmu_mode();
-
 	ret = pagemap_scan_thp_entry(pmd, start, end, walk);
-	if (ret != -ENOENT) {
-		arch_leave_lazy_mmu_mode();
+	if (ret != -ENOENT)
 		return ret;
-	}
 
 	ret = 0;
 	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, start, &ptl);
 	if (!pte) {
-		arch_leave_lazy_mmu_mode();
 		walk->action = ACTION_AGAIN;
 		return 0;
 	}
 
+	arch_enter_lazy_mmu_mode();
+
 	if ((p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out) {
 		/* Fast path for performing exclusive WP */
 		for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
@@ -2563,8 +2560,8 @@ flush_and_return:
 	if (flush_end)
 		flush_tlb_range(vma, start, addr);
 
-	pte_unmap_unlock(start_pte, ptl);
 	arch_leave_lazy_mmu_mode();
+	pte_unmap_unlock(start_pte, ptl);
 
 	cond_resched();
 	return ret;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-dont-skip-arch_sync_kernel_mappings-in-error-paths.patch
mm-ioremap-pass-pgprot_t-to-ioremap_prot-instead-of-unsigned-long.patch
mm-fix-lazy-mmu-docs-and-usage.patch
fs-proc-task_mmu-reduce-scope-of-lazy-mmu-region.patch
sparc-mm-disable-preemption-in-lazy-mmu-mode.patch
sparc-mm-avoid-calling-arch_enter-leave_lazy_mmu-in-set_ptes.patch
revert-x86-xen-allow-nesting-of-same-lazy-mode.patch


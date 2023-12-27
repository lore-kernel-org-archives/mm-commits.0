Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7DA481AD
	for <mm-commits@vger.kernel.org>; Wed, 27 Dec 2023 21:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ntuDHZWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65CEC433C7;
	Wed, 27 Dec 2023 21:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703712632;
	bh=J/wR8YbE1Y15u7BR8UEewEVIeGbu4NH9JM4SGlShFqs=;
	h=Date:To:From:Subject:From;
	b=ntuDHZWLrdPYuwCn5nO4S9bz8wwJtpRUPMVBVBLZ2WBsQ/TBRHv3i9a4KIBCacdsD
	 188DNfqZxxDtqOWd608lvwVZXooSkM71ejAOPsB+BJ/+q0vUtd3wIyRdap+hcvXF5j
	 SLABUIqUD+r5yrI6inNmpdff/RTjm8gX7NATPl4o=
Date: Wed, 27 Dec 2023 13:30:32 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,peterz@infradead.org,palmer@dabbelt.com,mpe@ellerman.id.au,luto@kernel.org,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,agordeev@linux.ibm.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-mm-fault-fix-major-fault-accounting-when-retrying-under-per-vma-lock.patch added to mm-hotfixes-unstable branch
Message-Id: <20231227213032.D65CEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch/mm/fault: fix major fault accounting when retrying under per-VMA lock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     arch-mm-fault-fix-major-fault-accounting-when-retrying-under-per-vma-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-mm-fault-fix-major-fault-accounting-when-retrying-under-per-vma-lock.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: arch/mm/fault: fix major fault accounting when retrying under per-VMA lock
Date: Tue, 26 Dec 2023 13:46:10 -0800

A test [1] in Android test suite started failing after [2] was merged.  It
turns out that after handling a major fault under per-VMA lock, the
process major fault counter does not register that fault as major.  Before
[2] read faults would be done under mmap_lock, in which case
FAULT_FLAG_TRIED flag is set before retrying.  That in turn causes
mm_account_fault() to account the fault as major once retry completes. 
With per-VMA locks we often retry because a fault can't be handled without
locking the whole mm using mmap_lock.  Therefore such retries do not set
FAULT_FLAG_TRIED flag.  This logic does not work after [2] because we can
now handle read major faults under per-VMA lock and upon retry the fact
there was a major fault gets lost.  Fix this by setting FAULT_FLAG_TRIED
after retrying under per-VMA lock if VM_FAULT_MAJOR was returned.  Ideally
we would use an additional VM_FAULT bit to indicate the reason for the
retry (could not handle under per-VMA lock vs other reason) but this
simpler solution seems to work, so keeping it simple.

[1] https://cs.android.com/android/platform/superproject/+/master:test/vts-testcase/kernel/api/drop_caches_prop/drop_caches_test.cpp
[2] https://lore.kernel.org/all/20231006195318.4087158-6-willy@infradead.org/

Link: https://lkml.kernel.org/r/20231226214610.109282-1-surenb@google.com
Fixes: 12214eba1992 ("mm: handle read faults under the VMA lock")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/fault.c   |    2 ++
 arch/powerpc/mm/fault.c |    2 ++
 arch/riscv/mm/fault.c   |    2 ++
 arch/s390/mm/fault.c    |    3 +++
 arch/x86/mm/fault.c     |    2 ++
 5 files changed, 11 insertions(+)

--- a/arch/arm64/mm/fault.c~arch-mm-fault-fix-major-fault-accounting-when-retrying-under-per-vma-lock
+++ a/arch/arm64/mm/fault.c
@@ -607,6 +607,8 @@ static int __kprobes do_page_fault(unsig
 		goto done;
 	}
 	count_vm_vma_lock_event(VMA_LOCK_RETRY);
+	if (fault & VM_FAULT_MAJOR)
+		mm_flags |= FAULT_FLAG_TRIED;
 
 	/* Quick path to respond to signals */
 	if (fault_signal_pending(fault, regs)) {
--- a/arch/powerpc/mm/fault.c~arch-mm-fault-fix-major-fault-accounting-when-retrying-under-per-vma-lock
+++ a/arch/powerpc/mm/fault.c
@@ -497,6 +497,8 @@ static int ___do_page_fault(struct pt_re
 		goto done;
 	}
 	count_vm_vma_lock_event(VMA_LOCK_RETRY);
+	if (fault & VM_FAULT_MAJOR)
+		flags |= FAULT_FLAG_TRIED;
 
 	if (fault_signal_pending(fault, regs))
 		return user_mode(regs) ? 0 : SIGBUS;
--- a/arch/riscv/mm/fault.c~arch-mm-fault-fix-major-fault-accounting-when-retrying-under-per-vma-lock
+++ a/arch/riscv/mm/fault.c
@@ -304,6 +304,8 @@ void handle_page_fault(struct pt_regs *r
 		goto done;
 	}
 	count_vm_vma_lock_event(VMA_LOCK_RETRY);
+	if (fault & VM_FAULT_MAJOR)
+		flags |= FAULT_FLAG_TRIED;
 
 	if (fault_signal_pending(fault, regs)) {
 		if (!user_mode(regs))
--- a/arch/s390/mm/fault.c~arch-mm-fault-fix-major-fault-accounting-when-retrying-under-per-vma-lock
+++ a/arch/s390/mm/fault.c
@@ -337,6 +337,9 @@ static void do_exception(struct pt_regs
 		return;
 	}
 	count_vm_vma_lock_event(VMA_LOCK_RETRY);
+	if (fault & VM_FAULT_MAJOR)
+		flags |= FAULT_FLAG_TRIED;
+
 	/* Quick path to respond to signals */
 	if (fault_signal_pending(fault, regs)) {
 		if (!user_mode(regs))
--- a/arch/x86/mm/fault.c~arch-mm-fault-fix-major-fault-accounting-when-retrying-under-per-vma-lock
+++ a/arch/x86/mm/fault.c
@@ -1370,6 +1370,8 @@ void do_user_addr_fault(struct pt_regs *
 		goto done;
 	}
 	count_vm_vma_lock_event(VMA_LOCK_RETRY);
+	if (fault & VM_FAULT_MAJOR)
+		flags |= FAULT_FLAG_TRIED;
 
 	/* Quick path to respond to signals */
 	if (fault_signal_pending(fault, regs)) {
_

Patches currently in -mm which might be from surenb@google.com are

arch-mm-fault-fix-major-fault-accounting-when-retrying-under-per-vma-lock.patch
selftests-mm-call-uffd_test_ctx_clear-at-the-end-of-the-test.patch
selftests-mm-add-uffd_test_case_ops-to-allow-test-case-specific-operations.patch
selftests-mm-add-uffdio_move-ioctl-test.patch


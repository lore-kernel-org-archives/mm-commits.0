Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD4F1D6DB5;
	Tue, 18 Mar 2025 05:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274652; cv=none; b=T8ZiypgetV5oyfwJ3uAcWlG4lCMppC1wL9orPhsKzFA7/pOCIXih2Dv6dwqjWGpFgSCUyg4gHRhYpOiAj3LAiURPTD+G3NhtFpkhqqTl6Ij3mjxgFqJN04IJNSYmIvy1zN/4mCm8+4y+GYSFehD/H99Yq6JCfEgJNEeVacJKDec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274652; c=relaxed/simple;
	bh=NtZKRfvAGW896vCB3OsED5qpNDP4MdTBkOr8aBD92RE=;
	h=Date:To:From:Subject:Message-Id; b=UEEVfEKAKO4+7hvtffwbrySUM6T/WFZV89DyIUgI8b6qnyTQJNtNlVIymsHss2MYEcbxWBkzB+ZPmi3NIdFQELLiO/jOVX2V7vKpVp9Nv1OiYkGxZ/EflrdckoIsZZg8E+hYm46rer2aaBcwOzV6NJzh15Tu/dn91VGcW+bZfek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1DNIkQp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1DNIkQp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC395C4CEDD;
	Tue, 18 Mar 2025 05:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274651;
	bh=NtZKRfvAGW896vCB3OsED5qpNDP4MdTBkOr8aBD92RE=;
	h=Date:To:From:Subject:From;
	b=1DNIkQp3BGdssi0BHwAEbOO7f1a8hJ549b5GrXzjKFIMmBlXCjgpr/bpMZckGLa9w
	 B+b3FyJZtzj7AUbz9geg/Ih6Jr+vLOnLnPBmBFSo99LBEvpFbpXpdqQgnWlf8btK4/
	 lg0xlBQ4O1tdCZroNWpH9jEShMMqosqxVvEDEaeQ=
Date: Mon, 17 Mar 2025 22:10:51 -0700
To: mm-commits@vger.kernel.org,yazen.ghannam@amd.com,tony.luck@intel.com,tianruidong@linux.alibaba.com,tglx@linutronix.de,stable@vger.kernel.org,peterz@infradead.org,nao.horiguchi@gmail.com,mingo@redhat.com,linmiaohe@huawei.com,jpoimboe@kernel.org,Jonathan.Cameron@huawei.com,jarkko@kernel.org,jane.chu@oracle.com,hpa@zytor.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,baolin.wang@linux.alibaba.com,xueshuai@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mce-use-is_copy_from_user-to-determine-copy-from-user-context.patch removed from -mm tree
Message-Id: <20250318051051.AC395C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mce: use is_copy_from_user() to determine copy-from-user context
has been removed from the -mm tree.  Its filename was
     x86-mce-use-is_copy_from_user-to-determine-copy-from-user-context.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shuai Xue <xueshuai@linux.alibaba.com>
Subject: x86/mce: use is_copy_from_user() to determine copy-from-user context
Date: Wed, 12 Mar 2025 19:28:50 +0800

Patch series "mm/hwpoison: Fix regressions in memory failure handling",
v4.

## 1. What am I trying to do:

This patchset resolves two critical regressions related to memory failure
handling that have appeared in the upstream kernel since version 5.17, as
compared to 5.10 LTS.

    - copyin case: poison found in user page while kernel copying from user space
    - instr case: poison found while instruction fetching in user space

## 2. What is the expected outcome and why

- For copyin case:

Kernel can recover from poison found where kernel is doing get_user() or
copy_from_user() if those places get an error return and the kernel return
-EFAULT to the process instead of crashing.  More specifily, MCE handler
checks the fixup handler type to decide whether an in kernel #MC can be
recovered.  When EX_TYPE_UACCESS is found, the PC jumps to recovery code
specified in _ASM_EXTABLE_FAULT() and return a -EFAULT to user space.

- For instr case:

If a poison found while instruction fetching in user space, full recovery
is possible.  User process takes #PF, Linux allocates a new page and fills
by reading from storage.


## 3. What actually happens and why

- For copyin case: kernel panic since v5.17

Commit 4c132d1d844a ("x86/futex: Remove .fixup usage") introduced a new
extable fixup type, EX_TYPE_EFAULT_REG, and later patches updated the
extable fixup type for copy-from-user operations, changing it from
EX_TYPE_UACCESS to EX_TYPE_EFAULT_REG.  It breaks previous EX_TYPE_UACCESS
handling when posion found in get_user() or copy_from_user().

- For instr case: user process is killed by a SIGBUS signal due to #CMCI
  and #MCE race

When an uncorrected memory error is consumed there is a race between the
CMCI from the memory controller reporting an uncorrected error with a UCNA
signature, and the core reporting and SRAR signature machine check when
the data is about to be consumed.

### Background: why *UN*corrected errors tied to *C*MCI in Intel platform [1]

Prior to Icelake memory controllers reported patrol scrub events that
detected a previously unseen uncorrected error in memory by signaling a
broadcast machine check with an SRAO (Software Recoverable Action
Optional) signature in the machine check bank.  This was overkill because
it's not an urgent problem that no core is on the verge of consuming that
bad data.  It's also found that multi SRAO UCE may cause nested MCE
interrupts and finally become an IERR.

Hence, Intel downgrades the machine check bank signature of patrol scrub
from SRAO to UCNA (Uncorrected, No Action required), and signal changed to
#CMCI.  Just to add to the confusion, Linux does take an action (in
uc_decode_notifier()) to try to offline the page despite the UC*NA*
signature name.

### Background: why #CMCI and #MCE race when poison is consuming in
    Intel platform [1]

Having decided that CMCI/UCNA is the best action for patrol scrub errors,
the memory controller uses it for reads too.  But the memory controller is
executing asynchronously from the core, and can't tell the difference
between a "real" read and a speculative read.  So it will do CMCI/UCNA if
an error is found in any read.

Thus:

1) Core is clever and thinks address A is needed soon, issues a
   speculative read.

2) Core finds it is going to use address A soon after sending the read
   request

3) The CMCI from the memory controller is in a race with MCE from the
   core that will soon try to retire the load from address A.

Quite often (because speculation has got better) the CMCI from the memory
controller is delivered before the core is committed to the instruction
reading address A, so the interrupt is taken, and Linux offlines the page
(marking it as poison).


## Why user process is killed for instr case

Commit 046545a661af ("mm/hwpoison: fix error page recovered but reported
"not recovered"") tries to fix noise message "Memory error not recovered"
and skips duplicate SIGBUSs due to the race.  But it also introduced a bug
that kill_accessing_process() return -EHWPOISON for instr case, as result,
kill_me_maybe() send a SIGBUS to user process.

# 4. The fix, in my opinion, should be:

- For copyin case:

The key point is whether the error context is in a read from user memory. 
We do not care about the ex-type if we know its a MOV reading from
userspace.

is_copy_from_user() return true when both of the following two checks are
true:

    - the current instruction is copy
    - source address is user memory

If copy_user is true, we set

m->kflags |= MCE_IN_KERNEL_COPYIN | MCE_IN_KERNEL_RECOV;

Then do_machine_check() will try fixup_exception() first.

- For instr case: let kill_accessing_process() return 0 to prevent a SIGBUS.

- For patch 3:

The return value of memory_failure() is quite important while discussed
instr case regression with Tony and Miaohe for patch 2, so add comment
about the return value.


This patch (of 3):

Commit 4c132d1d844a ("x86/futex: Remove .fixup usage") introduced a new
extable fixup type, EX_TYPE_EFAULT_REG, and commit 4c132d1d844a
("x86/futex: Remove .fixup usage") updated the extable fixup type for
copy-from-user operations, changing it from EX_TYPE_UACCESS to
EX_TYPE_EFAULT_REG.  The error context for copy-from-user operations no
longer functions as an in-kernel recovery context.  Consequently, the
error context for copy-from-user operations no longer functions as an
in-kernel recovery context, resulting in kernel panics with the message:
"Machine check: Data load in unrecoverable area of kernel."

To address this, it is crucial to identify if an error context involves a
read operation from user memory.  The function is_copy_from_user() can be
utilized to determine:

    - the current operation is copy
    - when reading user memory

When these conditions are met, is_copy_from_user() will return true,
confirming that it is indeed a direct copy from user memory.  This check
is essential for correctly handling the context of errors in these
operations without relying on the extable fixup types that previously
allowed for in-kernel recovery.

So, use is_copy_from_user() to determine if a context is copy user directly.

Link: https://lkml.kernel.org/r/20250312112852.82415-1-xueshuai@linux.alibaba.com
Link: https://lkml.kernel.org/r/20250312112852.82415-2-xueshuai@linux.alibaba.com
Fixes: 4c132d1d844a ("x86/futex: Remove .fixup usage")
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Ruidong Tian <tianruidong@linux.alibaba.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mce/severity.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/mce/severity.c~x86-mce-use-is_copy_from_user-to-determine-copy-from-user-context
+++ a/arch/x86/kernel/cpu/mce/severity.c
@@ -300,13 +300,12 @@ static noinstr int error_context(struct
 	copy_user  = is_copy_from_user(regs);
 	instrumentation_end();
 
-	switch (fixup_type) {
-	case EX_TYPE_UACCESS:
-		if (!copy_user)
-			return IN_KERNEL;
-		m->kflags |= MCE_IN_KERNEL_COPYIN;
-		fallthrough;
+	if (copy_user) {
+		m->kflags |= MCE_IN_KERNEL_COPYIN | MCE_IN_KERNEL_RECOV;
+		return IN_KERNEL_RECOV;
+	}
 
+	switch (fixup_type) {
 	case EX_TYPE_FAULT_MCE_SAFE:
 	case EX_TYPE_DEFAULT_MCE_SAFE:
 		m->kflags |= MCE_IN_KERNEL_RECOV;
_

Patches currently in -mm which might be from xueshuai@linux.alibaba.com are



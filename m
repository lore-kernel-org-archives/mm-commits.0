Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270C52512E6
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 23:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765928783; cv=none; b=M6z742qoADZYUFaEgsw/iInt6QkS4Bcw4VLrm+jsiEW6jeQZCwNOE9IZXe8hP099pJPDalatbh2ccnPmolW5+Ky/hsqQcuwyZ9Mgp+2hNIdwjMY3g4b92aByIOxLVAbF/ZSVb4sKvBuu5Alg4W0CsnGh9vXtEMZt8Kcs19u/AFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765928783; c=relaxed/simple;
	bh=vfiUjgh8h5upKVr6imIe1flxf/nBOabNIOE7zp1baDc=;
	h=Date:To:From:Subject:Message-Id; b=u2udR3y7VonkU1pEM8YZEGhyZyMZ26kXw7Ctg5rHDOOULtMyYlKMghMJBYONck0KtDPWEMjYj7JVbX24t236f05nuFiqqOUc46A8DHlCL+yjD5ockD+Zu+HxbHvK+klWP/xGmyvt5mx01vlATH5aZf2SGdIg8BcdPto5UzjmXeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ifvtijU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ifvtijU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997CBC4CEF1;
	Tue, 16 Dec 2025 23:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765928782;
	bh=vfiUjgh8h5upKVr6imIe1flxf/nBOabNIOE7zp1baDc=;
	h=Date:To:From:Subject:From;
	b=ifvtijU3j9oon2yXsLvkz6GQ2R1gidoe/5bVhqIWU4AD/FjKlO/SFsBPB97PJaAG1
	 mW9zH2KD4I45AnkXkbspJD7uo9N8jHaIDAyxoJSDmZybyKSXSIvFX7VHciWlN6gxyA
	 XAj4BrJUR89mxHX8b8ypihb40/6tfaEyKywGGwfs=
Date: Tue, 16 Dec 2025 15:46:22 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,rostedt@goodmis.org,rmk+kernel@armlinux.org.uk,mark.rutland@arm.com,macro@orcam.me.uk,ldv@strace.io,jcmvbkbc@gmail.com,deller@gmx.de,chris@zankel.net,charlie@rivosinc.com,catalin.marinas@arm.com,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-avoid-memcpy-for-syscall_get_arguments.patch added to mm-nonmm-unstable branch
Message-Id: <20251216234622.997CBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: avoid memcpy() for syscall_get_arguments()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm64-avoid-memcpy-for-syscall_get_arguments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-avoid-memcpy-for-syscall_get_arguments.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jinjie Ruan <ruanjinjie@huawei.com>
Subject: arm64: avoid memcpy() for syscall_get_arguments()
Date: Mon, 1 Dec 2025 20:06:33 +0800

Do not use memcpy() to extract syscall arguments from struct pt_regs but
rather just perform direct assignments.

Update syscall_set_arguments() too to keep syscall_get_arguments() and
syscall_set_arguments() in sync.

With Generic Entry patch[1] and turn on audit, the performance benchmarks
from perf bench basic syscall on kunpeng920 gives roughly a 1% performance
uplift.

| Metric     | W/O this patch | With this patch | Change    |
| ---------- | -------------- | --------------- | --------- |
| Total time | 2.241 [sec]    | 2.211 [sec]     |  ↓1.36%   |
| usecs/op   | 0.224157       | 0.221146        |  ↓1.36%   |
| ops/sec    | 4,461,157      | 4,501,409       |  ↑0.9%    |

Disassembly shows that using direct assignment causes
syscall_set_arguments() to be inlined and cuts the instruction count by
five or six compared to memcpy().  Because __audit_syscall_entry() only
uses four syscall arguments, the compiler has also elided the copy of
regs->regs[4] and regs->regs[5].

Before:
<syscall_get_arguments.constprop.0>:
       aa0103e2        mov     x2, x1
       91002003        add     x3, x0, #0x8
       f9408804        ldr     x4, [x0, #272]
       f8008444        str     x4, [x2], #8
       a9409404        ldp     x4, x5, [x0, #8]
       a9009424        stp     x4, x5, [x1, #8]
       a9418400        ldp     x0, x1, [x0, #24]
       a9010440        stp     x0, x1, [x2, #16]
       f9401060        ldr     x0, [x3, #32]
       f9001040        str     x0, [x2, #32]
       d65f03c0        ret
       d503201f        nop

After:
       a9408e82        ldp     x2, x3, [x20, #8]
       2a1603e0        mov     w0, w22
       f9400e84        ldr     x4, [x20, #24]
       f9408a81        ldr     x1, [x20, #272]
       9401c4ba        bl      ffff800080215ca8 <__audit_syscall_entry>

This also aligns the implementation with x86 and RISC-V.

Link: https://lkml.kernel.org/r/20251201120633.1193122-3-ruanjinjie@huawei.com
Link: https://lore.kernel.org/all/20251126071446.3234218-1-ruanjinjie@huawei.com/ [1]
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Christian Zankel <chris@zankel.net>
Cc: "Dmitry V. Levin" <ldv@strace.io>
Cc: Helge Deller <deller@gmx.de>
Cc: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/syscall.h |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/syscall.h~arm64-avoid-memcpy-for-syscall_get_arguments
+++ a/arch/arm64/include/asm/syscall.h
@@ -82,16 +82,24 @@ static inline void syscall_get_arguments
 					 unsigned long *args)
 {
 	args[0] = regs->orig_x0;
-	args++;
-
-	memcpy(args, &regs->regs[1], 5 * sizeof(args[0]));
+	args[1] = regs->regs[1];
+	args[2] = regs->regs[2];
+	args[3] = regs->regs[3];
+	args[4] = regs->regs[4];
+	args[5] = regs->regs[5];
 }
 
 static inline void syscall_set_arguments(struct task_struct *task,
 					 struct pt_regs *regs,
 					 const unsigned long *args)
 {
-	memcpy(&regs->regs[0], args, 6 * sizeof(args[0]));
+	regs->regs[0] = args[0];
+	regs->regs[1] = args[1];
+	regs->regs[2] = args[2];
+	regs->regs[3] = args[3];
+	regs->regs[4] = args[4];
+	regs->regs[5] = args[5];
+
 	/*
 	 * Also copy the first argument into orig_x0
 	 * so that syscall_get_arguments() would return it
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are

syscallh-remove-unused-syscall_max_args.patch
arm64-avoid-memcpy-for-syscall_get_arguments.patch


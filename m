Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B018C230BD5
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 01:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767751015; cv=none; b=c2FgdkOpf8PlMXC1vz0itmzlgL6XVgjBySYe6grR5uitPSTqo4hn8jo22A8NynXTlvYyjfubhqmKsNnivQl8xQpDfyTfPmX835Kr5texXoRxr7mMY9r7Y0r917TkNdMf10bTQq80iWZsmO71Cy2tvbUaiWL2vElIhqLpz7MIa50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767751015; c=relaxed/simple;
	bh=z7P8ckizAjRYqihTQec+OuJWA9uav6iftxw49oKVX9Q=;
	h=Date:To:From:Subject:Message-Id; b=GqYvzeHxyQTBHziqQ1UWDKRoByHLpJrHkOFii2tZyuX/Cl6+7sBnRiXJDaYmCp1Y8hHrWPuj4Pj/43nHaIwGfS9dKySlEWiwLt3jwG7F9cJ5RlTSZHnpyStlhgU9Qzt4PDXEM1cPOETf8QOO/qqYnQ0XbYIJguikhOzu6osT6iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M1RtGAzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M1RtGAzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F71C116C6;
	Wed,  7 Jan 2026 01:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767751015;
	bh=z7P8ckizAjRYqihTQec+OuJWA9uav6iftxw49oKVX9Q=;
	h=Date:To:From:Subject:From;
	b=M1RtGAzS63LnNPEiINBXx0WwfPecfH2sw3w03MDwi1/jF3NVDohGGW134Ko6bH4/P
	 pIO4IEzkYWJbQ/WgT6oQJ2zhlh8rWY9/YtNHw2gSYO6u9mRzBGM2IPXNYCAqRsYNwN
	 VaGpHQU0iztRTRewv3stirSuz/58tDTaG53iIMyI=
Date: Tue, 06 Jan 2026 17:56:54 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,rostedt@goodmis.org,rmk+kernel@armlinux.org.uk,mark.rutland@arm.com,macro@orcam.me.uk,ldv@strace.io,jcmvbkbc@gmail.com,deller@gmx.de,chris@zankel.net,charlie@rivosinc.com,catalin.marinas@arm.com,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] arm64-avoid-memcpy-for-syscall_get_arguments.patch removed from -mm tree
Message-Id: <20260107015655.13F71C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: avoid memcpy() for syscall_get_arguments()
has been removed from the -mm tree.  Its filename was
     arm64-avoid-memcpy-for-syscall_get_arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



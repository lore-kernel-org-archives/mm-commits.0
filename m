Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDCF27C153
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 03:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744343460; cv=none; b=Zv5s63uNKLxcXRUZ3ER9CtwQgi/lZb1AxmhzUeEVzW85KCwtnCIrwJSYDb/87w2YPxVBMwUZUDZxj5yFB+O6yPfUtgBSl+En9HBsTlnWldRCInMAFfzuho4R84RtbyHDn1hNbfgqbDE8TGl2j5r6B9L8NtbE69Mzyoz+hmUiFMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744343460; c=relaxed/simple;
	bh=X39xPAA03sg3tU7sbKuQlxWdZt+7ftXNYxoVKC46WHY=;
	h=Date:To:From:Subject:Message-Id; b=q7myenPAG6L0SwJCAhdvNuppHvNLys5NTUvImbUvJnpeFjDcnqnM0U5S52q3PNWmH05gdszIHQ5yVE+q3CfkCcqx8lRTwBhiX11XcTmglRLajZky+wJK6dun7fW/9rWOUjBgnYLja6htgQ8Zps6wyTiuGD+BpSjH2vTC+vwsYDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QMpFBc4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QMpFBc4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3309C4CEE2;
	Fri, 11 Apr 2025 03:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744343459;
	bh=X39xPAA03sg3tU7sbKuQlxWdZt+7ftXNYxoVKC46WHY=;
	h=Date:To:From:Subject:From;
	b=QMpFBc4kLWu18edOQttR4SZmL48rLrrBEp2jIa2INpDVtZWRgDv8Vmjdx9eElxzkL
	 0HVwbomq2D6hc6KUa/lsTgG23ekLFP0Vi9iwhGZddCUytnJ2sizTibA/bKSBxCAwfL
	 aAOmzAV5RcrsdSmsT6+Xdvjr5ukCUu81o2xeVXAo=
Date: Thu, 10 Apr 2025 20:50:59 -0700
To: mm-commits@vger.kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,ldv@strace.io,charlie@rivosinc.com,aou@eecs.berkeley.edu,alex@ghiti.fr,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-avoid-fortify-warning-in-syscall_get_arguments.patch added to mm-nonmm-unstable branch
Message-Id: <20250411035059.C3309C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: avoid fortify warning in syscall_get_arguments()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     riscv-avoid-fortify-warning-in-syscall_get_arguments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-avoid-fortify-warning-in-syscall_get_arguments.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Nathan Chancellor <nathan@kernel.org>
Subject: riscv: avoid fortify warning in syscall_get_arguments()
Date: Wed, 09 Apr 2025 14:24:46 -0700

When building with CONFIG_FORTIFY_SOURCE=y and W=1, there is a warning
because of the memcpy() in syscall_get_arguments():

  In file included from include/linux/string.h:392,
                   from include/linux/bitmap.h:13,
                   from include/linux/cpumask.h:12,
                   from arch/riscv/include/asm/processor.h:55,
                   from include/linux/sched.h:13,
                   from kernel/ptrace.c:13:
  In function 'fortify_memcpy_chk',
      inlined from 'syscall_get_arguments.isra' at arch/riscv/include/asm/syscall.h:66:2:
  include/linux/fortify-string.h:580:25: error: call to '__read_overflow2_field' declared with attribute warning: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Werror=attribute-warning]
    580 |                         __read_overflow2_field(q_size_field, size);
        |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  cc1: all warnings being treated as errors

The fortified memcpy() routine enforces that the source is not overread
and the destination is not overwritten if the size of either field and the
size of the copy are known at compile time.  The memcpy() in
syscall_get_arguments() intentionally overreads from a1 to a5 in 'struct
pt_regs' but this is bigger than the size of a1.

Normally, this could be solved by wrapping a1 through a5 with
struct_group() but there was already a struct_group() applied to these
members in commit bba547810c66 ("riscv: tracing: Fix
__write_overflow_field in ftrace_partial_regs()").

Just avoid memcpy() altogether and write the copying of args from regs
manually, which clears up the warning at the expense of three extra lines
of code.

Link: https://lkml.kernel.org/r/20250409-riscv-avoid-fortify-warning-syscall_get_arguments-v1-1-7853436d4755@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Dmitry V. Levin <ldv@strace.io>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/syscall.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/syscall.h~riscv-avoid-fortify-warning-in-syscall_get_arguments
+++ a/arch/riscv/include/asm/syscall.h
@@ -69,8 +69,11 @@ static inline void syscall_get_arguments
 					 unsigned long *args)
 {
 	args[0] = regs->orig_a0;
-	args++;
-	memcpy(args, &regs->a1, 5 * sizeof(args[0]));
+	args[1] = regs->a1;
+	args[2] = regs->a2;
+	args[3] = regs->a3;
+	args[4] = regs->a4;
+	args[5] = regs->a5;
 }
 
 static inline void syscall_set_arguments(struct task_struct *task,
_

Patches currently in -mm which might be from nathan@kernel.org are

riscv-avoid-fortify-warning-in-syscall_get_arguments.patch


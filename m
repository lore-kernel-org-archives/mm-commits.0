Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F363A1E6F
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 23:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765928780; cv=none; b=YwwgdqS0TjIjkvj5U8ssrLJEJVOS1UHhQIgC7e/07D4t0HL8wjKXyRYyNcRu4ONUM3+ACqscyMMjqnuhrejPGsd0saBxLQNMrYGJ5YEAX3bXe88xhQk6Br9h8XdzGOf7wPrHvXEdaPgFj0+BiRmUeEksBscSU5+bEkGaybrclyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765928780; c=relaxed/simple;
	bh=CX324ARvaxBcGNgIYCywwYbwRky0oXodY5DZV99gVsw=;
	h=Date:To:From:Subject:Message-Id; b=Ag2173hmsCJlaz7xVLGaJBE4klVO3woFAYBKjn6y32U8rEumZQmQ3UNUuWKz3IKh/Ch0zuqCLfeGDK00n1ZVGxFJrbor/cq0NnmuB+VyZonovWtmaeDXkvLpo1QPLipgtEMmWy9xh99AENx6BxkqUJoypJg3Ef2S7mMbfjnDerU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u2SvaH5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u2SvaH5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995A3C4CEF1;
	Tue, 16 Dec 2025 23:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765928779;
	bh=CX324ARvaxBcGNgIYCywwYbwRky0oXodY5DZV99gVsw=;
	h=Date:To:From:Subject:From;
	b=u2SvaH5IP/cqcq9Fv3/zZqA6bZZbUEEKD8v1gOwZT8BLK6cN4C2l6g50DK6MzKyxU
	 pzFu4+6f4nbhI34grQ1LyRr8QCnGwLjck4F4ejTTm/K9pzwfBLbv5JAFhNxq0dk4HR
	 1ZnncJjHdY+TEw9L6udbhfL0TPcIM2LeUuamRbTU=
Date: Tue, 16 Dec 2025 15:46:18 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,rostedt@goodmis.org,rmk+kernel@armlinux.org.uk,mark.rutland@arm.com,macro@orcam.me.uk,ldv@strace.io,jcmvbkbc@gmail.com,deller@gmx.de,chris@zankel.net,charlie@rivosinc.com,catalin.marinas@arm.com,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + syscallh-remove-unused-syscall_max_args.patch added to mm-nonmm-unstable branch
Message-Id: <20251216234619.995A3C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: syscall.h: remove unused SYSCALL_MAX_ARGS
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     syscallh-remove-unused-syscall_max_args.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/syscallh-remove-unused-syscall_max_args.patch

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
Subject: syscall.h: remove unused SYSCALL_MAX_ARGS
Date: Mon, 1 Dec 2025 20:06:32 +0800

Patch series "syscall: Cleanup and improve syscall_get_arguments()", v2.

Remove unused SYSCALL_MAX_ARGS and avoid memcpy() for
syscall_get_arguments() for arm64.


This patch (of 2):

SYSCALL_MAX_ARGS appears to have been unused since commit 32d92586629a
("syscalls: Remove start and number from syscall_set_arguments() args"),
so remove it.

Link: https://lkml.kernel.org/r/20251201120633.1193122-1-ruanjinjie@huawei.com
Link: https://lkml.kernel.org/r/20251201120633.1193122-2-ruanjinjie@huawei.com
Fixes: 32d92586629a ("syscalls: Remove start and number from syscall_set_arguments() args")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Christian Zankel <chris@zankel.net>
Cc: "Dmitry V. Levin" <ldv@strace.io>
Cc: Helge Deller <deller@gmx.de>
Cc: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/syscall.h    |    2 --
 arch/arm64/include/asm/syscall.h  |    2 --
 arch/xtensa/include/asm/syscall.h |    1 -
 3 files changed, 5 deletions(-)

--- a/arch/arm64/include/asm/syscall.h~syscallh-remove-unused-syscall_max_args
+++ a/arch/arm64/include/asm/syscall.h
@@ -77,8 +77,6 @@ static inline void syscall_set_nr(struct
 	}
 }
 
-#define SYSCALL_MAX_ARGS 6
-
 static inline void syscall_get_arguments(struct task_struct *task,
 					 struct pt_regs *regs,
 					 unsigned long *args)
--- a/arch/arm/include/asm/syscall.h~syscallh-remove-unused-syscall_max_args
+++ a/arch/arm/include/asm/syscall.h
@@ -92,8 +92,6 @@ static inline void syscall_set_nr(struct
 		(nr & __NR_SYSCALL_MASK);
 }
 
-#define SYSCALL_MAX_ARGS 7
-
 static inline void syscall_get_arguments(struct task_struct *task,
 					 struct pt_regs *regs,
 					 unsigned long *args)
--- a/arch/xtensa/include/asm/syscall.h~syscallh-remove-unused-syscall_max_args
+++ a/arch/xtensa/include/asm/syscall.h
@@ -61,7 +61,6 @@ static inline void syscall_set_return_va
 	regs->areg[2] = (long) error ? error : val;
 }
 
-#define SYSCALL_MAX_ARGS 6
 #define XTENSA_SYSCALL_ARGUMENT_REGS {6, 3, 4, 5, 8, 9}
 
 static inline void syscall_get_arguments(struct task_struct *task,
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are

syscallh-remove-unused-syscall_max_args.patch
arm64-avoid-memcpy-for-syscall_get_arguments.patch


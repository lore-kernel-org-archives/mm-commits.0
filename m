Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E685710FD
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 01:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767751014; cv=none; b=TxF98BZl8icNBdupw59fFt4GukhUtRyrHuh13RqGYLWoawS7qMKSJXOSP/kd9VZY1IWTHWt5pbD0GWz/cn+RKNoNoh6zCvblP5IaChlR9GdCZujpUDP+5oi2PN69U1SnkcIYHRx0/DT9qLu3Vv6xBcbLkf5dhcnzbdqujAkJHo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767751014; c=relaxed/simple;
	bh=DSASqiIEKOXCPV8evG2/3urSO0bGSDxRfVSA52yy8NE=;
	h=Date:To:From:Subject:Message-Id; b=aOcPHBIdB7lyfDM711i0I6BFoqc2dF7LVVu6toVhDkjUEHjAvckbHsN2FCp2IyqrxwFo+6k84nQ//ynQobexshMUusKCTP+vUtaWeEhE3AE4rUuoIdpMiJ1zXQhDBd1W5iYFKOmmVU87wu/+C/lEharn7miU57tjznN6YpPpaFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zR6L3YUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zR6L3YUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90581C116C6;
	Wed,  7 Jan 2026 01:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767751013;
	bh=DSASqiIEKOXCPV8evG2/3urSO0bGSDxRfVSA52yy8NE=;
	h=Date:To:From:Subject:From;
	b=zR6L3YUsu73BKuPakQ1eYu+jD0+1OCr9sI/7QXFlUY0y2jgumTgNyoeN3157Txcz/
	 1TEaPl8LdqfOWjpf3suRhLQaxhAVjQODR5TvUV5SCfJIuZWCy+lIh2Ry9qSmKNnaQd
	 qt38CeViu+XAvdm21upldbjz28pB8tP8Xfb0JOWY=
Date: Tue, 06 Jan 2026 17:56:53 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,rostedt@goodmis.org,rmk+kernel@armlinux.org.uk,mark.rutland@arm.com,macro@orcam.me.uk,ldv@strace.io,jcmvbkbc@gmail.com,deller@gmx.de,chris@zankel.net,charlie@rivosinc.com,catalin.marinas@arm.com,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] syscallh-remove-unused-syscall_max_args.patch removed from -mm tree
Message-Id: <20260107015653.90581C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: syscall.h: remove unused SYSCALL_MAX_ARGS
has been removed from the -mm tree.  Its filename was
     syscallh-remove-unused-syscall_max_args.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

arm64-avoid-memcpy-for-syscall_get_arguments.patch


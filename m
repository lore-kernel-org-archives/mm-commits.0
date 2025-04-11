Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B0027CCDB
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 04:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744344156; cv=none; b=nWtPad+IKc38TFJRmj0vaLU4qn//hlRKeClmVuWANdAPXTWsWXBDzAWBGDIyx+d+Rd/1t4H68iKWG6JH8V3jnKweaeh90GumEMSNE1mWgfgpsHVEL6cQL7/ZYKiUuQtypW7supQFQyRy//oF37Olks8MWfVSCDanIMEJhpb1uFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744344156; c=relaxed/simple;
	bh=W7fVA0fVKRyYdWB1eHwKoK74Vjzpp8dLirThhqRvBNc=;
	h=Date:To:From:Subject:Message-Id; b=Mjufs9uL8t8YmGMs7sarwrfNzRxnAZ8mQuZnlQaMjO1o5oDj4hGAawTY714ZQsPXKicjNGJq8q7wU/ik8+iSdG9e+Ydh7UCQ5q8Fq1K2caZZRexZ29NfCSSvkODvLahkmZF5B9HMaHvkGUz1zCvCeiUatzciGLlza+Mn99YbRTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AZj95EmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AZj95EmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3C6C4CEE2;
	Fri, 11 Apr 2025 04:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744344154;
	bh=W7fVA0fVKRyYdWB1eHwKoK74Vjzpp8dLirThhqRvBNc=;
	h=Date:To:From:Subject:From;
	b=AZj95EmJQ+ynUCXUR7Y5t1CEsYv8wO8jF+Nag2eeQadgT0f4URNFQ6vdHG/Lry4D8
	 tVUofVvSC2eIIFbXTO+RHSOshIloJdcM4aVpqsmbrle6DtcayJ2wvyQaE1tuKvNhLO
	 OL/KZnxPkCl7//3uGaj411d/3ZhMKycn1tX0Ehzs=
Date: Thu, 10 Apr 2025 21:02:33 -0700
To: mm-commits@vger.kernel.org,macro@orcam.me.uk,ldv@strace.io,deller@gmx.de,charlie@rivosinc.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + syscallh-add-syscall_set_arguments-fix-fix.patch added to mm-new branch
Message-Id: <20250411040234.7A3C6C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: syscallh-add-syscall_set_arguments-fix-fix
has been added to the -mm mm-new branch.  Its filename is
     syscallh-add-syscall_set_arguments-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/syscallh-add-syscall_set_arguments-fix-fix.patch

This patch will later appear in the mm-new branch at
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
Subject: syscallh-add-syscall_set_arguments-fix-fix
Date: Tue, 8 Apr 2025 17:38:03 -0700

fix syscall_get_arguments() also

Link: https://lkml.kernel.org/r/20250409003803.GA2876360@ax162
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Helge Deller <deller@gmx.de> # parisc
Cc: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: "Dmitry V. Levin" <ldv@strace.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/syscall.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/syscall.h~syscallh-add-syscall_set_arguments-fix-fix
+++ a/arch/riscv/include/asm/syscall.h
@@ -62,8 +62,11 @@ static inline void syscall_get_arguments
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

syscallh-add-syscall_set_arguments-fix.patch
syscallh-add-syscall_set_arguments-fix-fix.patch
riscv-avoid-fortify-warning-in-syscall_get_arguments.patch


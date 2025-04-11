Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AFA279338
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 03:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744343776; cv=none; b=pcpYgLUiZz4nP751bgP/2BumDlVG7nJhwlzf2LQQ86TO63oap94m0pbva3y6fr1EhK8Ic3yiMRckAfisCiHLzSTZsE9Kpw/37t4kBndYNMGboA1ElF1U3UlSkpzTyy1vvf8ZqM10MYGPgDG7ZgS8sDyy3dqhpkMaUh0Gn09g1M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744343776; c=relaxed/simple;
	bh=8RJ0miK2esqHPyJlY4vNzAOKJCPCERP9ke5/HDYJhNY=;
	h=Date:To:From:Subject:Message-Id; b=Aqnt7NpIs8u6X2R3FQTBrPUxNY9h72WorG4HefSnFoj7tfAUHKVTMfip618IYKm0zCdoajdwjt/qz5D8v0lTC5+FI3uGF3fiUGUQyM7fAlw5KCHbzJsK7SlqUJCb/ZR/vnYTQlPUFerGQo08ynwz5NaYbZHn72w6ggCpJCwlUaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LuPOuyQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LuPOuyQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A702C4CEE2;
	Fri, 11 Apr 2025 03:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744343776;
	bh=8RJ0miK2esqHPyJlY4vNzAOKJCPCERP9ke5/HDYJhNY=;
	h=Date:To:From:Subject:From;
	b=LuPOuyQer5Do8QpNVnhpMKKXub82GchETyDjmBFDQWyjcWznTURA0tWrabL9JtVog
	 Ji9FOS7zIDAwXbcKIVqfPJMnSeEg5FvU2QwumaRSIWeaaO8gCRnfqpfiwN5azJWYCl
	 exQnIn3WuygysJyD26z8Zea4jRowmMhmnQ4BumEI=
Date: Thu, 10 Apr 2025 20:56:15 -0700
To: mm-commits@vger.kernel.org,macro@orcam.me.uk,deller@gmx.de,charlie@rivosinc.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + syscallh-add-syscall_set_arguments-fix.patch added to mm-new branch
Message-Id: <20250411035616.3A702C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: syscallh-add-syscall_set_arguments-fix
has been added to the -mm mm-new branch.  Its filename is
     syscallh-add-syscall_set_arguments-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/syscallh-add-syscall_set_arguments-fix.patch

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
Subject: syscallh-add-syscall_set_arguments-fix
Date: Tue, 8 Apr 2025 14:31:31 -0700

fix compile time fortify checks

Link: https://lkml.kernel.org/r/20250408213131.GA2872426@ax162
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Helge Deller <deller@gmx.de> # parisc
Cc: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/syscall.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/syscall.h~syscallh-add-syscall_set_arguments-fix
+++ a/arch/riscv/include/asm/syscall.h
@@ -71,8 +71,11 @@ static inline void syscall_set_arguments
 					 const unsigned long *args)
 {
 	regs->orig_a0 = args[0];
-	args++;
-	memcpy(&regs->a1, args, 5 * sizeof(regs->a1));
+	regs->a1 = args[1];
+	regs->a2 = args[2];
+	regs->a3 = args[3];
+	regs->a4 = args[4];
+	regs->a5 = args[5];
 }
 
 static inline int syscall_get_arch(struct task_struct *task)
_

Patches currently in -mm which might be from nathan@kernel.org are

syscallh-add-syscall_set_arguments-fix.patch
riscv-avoid-fortify-warning-in-syscall_get_arguments.patch


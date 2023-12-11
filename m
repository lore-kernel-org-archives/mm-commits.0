Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D032BAD4A
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2axzGK9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD73C433CA;
	Mon, 11 Dec 2023 01:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257800;
	bh=Vv8t5w9lWu/3sgTVuhe1U50tvjtvMWKm8SHyt0cYsIE=;
	h=Date:To:From:Subject:From;
	b=2axzGK9X9yUCGIxXJpxgR0vd1JxckaaUX7+4gphONb1Asy+LzI5CHGfmQeECm0+7s
	 9Pgu5JQA+4OyRTDL82ymAziiwVF5AAZtBkERYRYghI7qJo3fHx1JNdturpXxMSGPUV
	 eBKHCLQfmnkde3+TiqnO5j5pjSfETl5OtrCYPVpw=
Date: Sun, 10 Dec 2023 17:23:20 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-signal-switch-to-syscall_define0-for-sys_rt_sigreturn.patch removed from -mm tree
Message-Id: <20231211012320.9CD73C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: signal: switch to SYSCALL_DEFINE0 for sys_rt_sigreturn()
has been removed from the -mm tree.  Its filename was
     hexagon-signal-switch-to-syscall_define0-for-sys_rt_sigreturn.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: signal: switch to SYSCALL_DEFINE0 for sys_rt_sigreturn()
Date: Thu, 30 Nov 2023 15:58:24 -0700

Clang warns:

  arch/hexagon/kernel/signal.c:223:16: warning: no previous prototype for function 'sys_rt_sigreturn' [-Wmissing-prototypes]
    223 | asmlinkage int sys_rt_sigreturn(void)
        |                ^
  arch/hexagon/kernel/signal.c:223:12: note: declare 'static' if the function is not intended to be used outside of this translation unit
    223 | asmlinkage int sys_rt_sigreturn(void)
        |            ^
        |            static
  1 warning generated.

Switch to the SYSCALL_DEFINE0() macro, which automatically declares a
prototype.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-11-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/hexagon/kernel/signal.c~hexagon-signal-switch-to-syscall_define0-for-sys_rt_sigreturn
+++ a/arch/hexagon/kernel/signal.c
@@ -220,7 +220,7 @@ no_restart:
  * Architecture-specific wrappers for signal-related system calls
  */
 
-asmlinkage int sys_rt_sigreturn(void)
+SYSCALL_DEFINE0(rt_sigreturn)
 {
 	struct pt_regs *regs = current_pt_regs();
 	struct rt_sigframe __user *frame;
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch


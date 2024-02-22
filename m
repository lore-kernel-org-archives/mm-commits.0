Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B97FBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645217; cv=none; b=gnVzITpocIjG9vUCkEyB8443E0BBUiZ7s3NLOTwKDpKMPC4JgqcbB+tb1Ovrbn7wqB24lFn637Uune6pp6Fn1UyCKN8TBlv0DcOIudIiljBVq0V8mmTa1b/VO4Gc7h4iAMiig80oFs/7E2RBCmdTNGX64EM0NtdAoz5WSn2pOnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645217; c=relaxed/simple;
	bh=dgxYrWYlTHdSvq3MyK3/ciKcnlyWAglvDhLHPPnFtXc=;
	h=Date:To:From:Subject:Message-Id; b=S8YtYKrOnNkqxv3AZov0Zowb2dDhbTXzR6eqB8f/zcD/UzEf3qoFWnOOloiJ6KNY5mbHZRq0f/IUUWbcaJ24gbSrXdRafgmZx6Ldqr9y0wF3s1STOewEdmHCJVJ/Pk5h1koc3frgp9yLzCvjAoCBJARNka79L796Z9uPEaoU2gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dnecBidt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dnecBidt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B38C433F1;
	Thu, 22 Feb 2024 23:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645216;
	bh=dgxYrWYlTHdSvq3MyK3/ciKcnlyWAglvDhLHPPnFtXc=;
	h=Date:To:From:Subject:From;
	b=dnecBidta2IGJFu3u6tQLPsIUCUYkJxrYF3w+z2KilrDLwannFM8f5S7XZKM8PVAX
	 2k34IVbZ/lvYkPk+k3BJdlIgmcZbK5+Z3p6H3zQdo9W4Bs2X95M7XDXBqS1xsl8pqv
	 m0z+Kf5hBg/hvysKnmDD0/YFXvqSUPC0/J3LRcFw=
Date: Thu, 22 Feb 2024 15:40:15 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,jpoimboe@kernel.org,iii@linux.ibm.com,arnd@arndb.de,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] init-remove-obsolete-arch_call_rest_init-wrapper.patch removed from -mm tree
Message-Id: <20240222234016.79B38C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init: remove obsolete arch_call_rest_init() wrapper
has been removed from the -mm tree.  Its filename was
     init-remove-obsolete-arch_call_rest_init-wrapper.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: init: remove obsolete arch_call_rest_init() wrapper
Date: Wed, 24 Jan 2024 15:27:35 +0100

Since commit 3570ee046c46b5dc ("s390/smp: keep the original lowcore for
CPU 0"), there is no longer any architecture that needs to override
arch_call_rest_init().

Remove the weak wrapper around rest_init(), call rest_init() directly, and
make rest_init() static.

Link: https://lkml.kernel.org/r/aa10868bfb176eef4abb8bb4a710b85330792694.1706106183.git.geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/start_kernel.h |    2 --
 init/main.c                  |    9 ++-------
 tools/objtool/noreturns.h    |    1 -
 3 files changed, 2 insertions(+), 10 deletions(-)

--- a/include/linux/start_kernel.h~init-remove-obsolete-arch_call_rest_init-wrapper
+++ a/include/linux/start_kernel.h
@@ -9,7 +9,5 @@
    up something else. */
 
 extern asmlinkage void __init __noreturn start_kernel(void);
-extern void __init __noreturn arch_call_rest_init(void);
-extern void __ref __noreturn rest_init(void);
 
 #endif /* _LINUX_START_KERNEL_H */
--- a/init/main.c~init-remove-obsolete-arch_call_rest_init-wrapper
+++ a/init/main.c
@@ -681,7 +681,7 @@ static void __init setup_command_line(ch
 
 static __initdata DECLARE_COMPLETION(kthreadd_done);
 
-noinline void __ref __noreturn rest_init(void)
+static noinline void __ref __noreturn rest_init(void)
 {
 	struct task_struct *tsk;
 	int pid;
@@ -822,11 +822,6 @@ static int __init early_randomize_kstack
 early_param("randomize_kstack_offset", early_randomize_kstack_offset);
 #endif
 
-void __init __weak __noreturn arch_call_rest_init(void)
-{
-	rest_init();
-}
-
 static void __init print_unknown_bootoptions(void)
 {
 	char *unknown_options;
@@ -1069,7 +1064,7 @@ void start_kernel(void)
 	kcsan_init();
 
 	/* Do the rest non-__init'ed, we're now alive */
-	arch_call_rest_init();
+	rest_init();
 
 	/*
 	 * Avoid stack canaries in callers of boot_init_stack_canary for gcc-10
--- a/tools/objtool/noreturns.h~init-remove-obsolete-arch_call_rest_init-wrapper
+++ a/tools/objtool/noreturns.h
@@ -12,7 +12,6 @@ NORETURN(__reiserfs_panic)
 NORETURN(__stack_chk_fail)
 NORETURN(__tdx_hypercall_failed)
 NORETURN(__ubsan_handle_builtin_unreachable)
-NORETURN(arch_call_rest_init)
 NORETURN(arch_cpu_idle_dead)
 NORETURN(bch2_trans_in_restart_error)
 NORETURN(bch2_trans_restart_error)
_

Patches currently in -mm which might be from geert+renesas@glider.be are



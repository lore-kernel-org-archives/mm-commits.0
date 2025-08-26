Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FBF1FC8
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 01:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756171092; cv=none; b=TyhQiYkL43mEzZlNUe6kQcePfld9/CYSG+clwoXuFuOkyxcD+k5f0XN4ynh8/P5OkJcxjAEI/u7JZmHi/R48ZuiH+eZ3tmVFgS4U5/3V5UchMi/6yQzinuAxfs/AxAmVz0A3tFOjqLbK4At46A5n7R1hImJnZ25teSsFMA3Kp7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756171092; c=relaxed/simple;
	bh=H3SqotSiSzXJaVmz8V/FBfNO3v2eINSmfeZKMVRZS64=;
	h=Date:To:From:Subject:Message-Id; b=DVSavlA7uvOG5lxWe9KFSpJSsM7w9eWEBkbu+ZUIE/AYXDBOFG/BbTZSj4Nxg/2P+LvInHW6HDYwERcIRR589aoi4AeIYrWQJvG4zvXq10HQ8e/2g59Mol/oaujs4IWzWZ7Uost5cpMhOFcDKMobWKirRZSvbqvfVh8bdt/MRJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EeN3eSJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EeN3eSJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEF7C4CEED;
	Tue, 26 Aug 2025 01:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756171091;
	bh=H3SqotSiSzXJaVmz8V/FBfNO3v2eINSmfeZKMVRZS64=;
	h=Date:To:From:Subject:From;
	b=EeN3eSJk1sbkMDR/fHmkI16A184J1DV7Ll9dowgXviIzaK0SbQxn/P7776PdKKvfo
	 Q/6x2ZqI2BXf3YxFnnXwcRgB/r6QQklXnQCEsnaoMH42KZy2ZdC4J2f2L0n55uNiyy
	 oa7uYQX7NxEPClXmWI9mPGLl5hT92hM5iWiPP5ZU=
Date: Mon, 25 Aug 2025 18:18:11 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhiramat@kernel.org,liam.howlett@oracle.com,bp@alien8.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-mainc-fix-boot-time-tracing-crash.patch added to mm-hotfixes-unstable branch
Message-Id: <20250826011811.7FEF7C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init/main.c: fix boot time tracing crash
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     init-mainc-fix-boot-time-tracing-crash.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-mainc-fix-boot-time-tracing-crash.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: init/main.c: fix boot time tracing crash
Date: Sun, 24 Aug 2025 16:07:59 +0300

Steven Rostedt reported a crash with "ftrace=function" kernel command
line:

[    0.159269] BUG: kernel NULL pointer dereference, address: 000000000000001c
[    0.160254] #PF: supervisor read access in kernel mode
[    0.160975] #PF: error_code(0x0000) - not-present page
[    0.161697] PGD 0 P4D 0
[    0.162055] Oops: Oops: 0000 [#1] SMP PTI
[    0.162619] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.17.0-rc2-test-00006-g48d06e78b7cb-dirty #9 PREEMPT(undef)
[    0.164141] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    0.165439] RIP: 0010:kmem_cache_alloc_noprof (mm/slub.c:4237)
[ 0.166186] Code: 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 fc 53 48 83 e4 f0 48 83 ec 20 8b 05 c9 b6 7e 01 <44> 8b 77 1c 65 4c 8b 2d b5 ea 20 02 4c 89 6c 24 18 41 89 f5 21 f0
[    0.168811] RSP: 0000:ffffffffb2e03b30 EFLAGS: 00010086
[    0.169545] RAX: 0000000001fff33f RBX: 0000000000000000 RCX: 0000000000000000
[    0.170544] RDX: 0000000000002800 RSI: 0000000000002800 RDI: 0000000000000000
[    0.171554] RBP: ffffffffb2e03b80 R08: 0000000000000004 R09: ffffffffb2e03c90
[    0.172549] R10: ffffffffb2e03c90 R11: 0000000000000000 R12: 0000000000000000
[    0.173544] R13: ffffffffb2e03c90 R14: ffffffffb2e03c90 R15: 0000000000000001
[    0.174542] FS:  0000000000000000(0000) GS:ffff9d2808114000(0000) knlGS:0000000000000000
[    0.175684] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.176486] CR2: 000000000000001c CR3: 000000007264c001 CR4: 00000000000200b0
[    0.177483] Call Trace:
[    0.177828]  <TASK>
[    0.178123] mas_alloc_nodes (lib/maple_tree.c:176 (discriminator 2) lib/maple_tree.c:1255 (discriminator 2))
[    0.178692] mas_store_gfp (lib/maple_tree.c:5468)
[    0.179223] execmem_cache_add_locked (mm/execmem.c:207)
[    0.179870] execmem_alloc (mm/execmem.c:213 mm/execmem.c:313 mm/execmem.c:335 mm/execmem.c:475)
[    0.180397] ? ftrace_caller (arch/x86/kernel/ftrace_64.S:169)
[    0.180922] ? __pfx_ftrace_caller (arch/x86/kernel/ftrace_64.S:158)
[    0.181517] execmem_alloc_rw (mm/execmem.c:487)
[    0.182052] arch_ftrace_update_trampoline (arch/x86/kernel/ftrace.c:266 arch/x86/kernel/ftrace.c:344 arch/x86/kernel/ftrace.c:474)
[    0.182778] ? ftrace_caller_op_ptr (arch/x86/kernel/ftrace_64.S:182)
[    0.183388] ftrace_update_trampoline (kernel/trace/ftrace.c:7947)
[    0.184024] __register_ftrace_function (kernel/trace/ftrace.c:368)
[    0.184682] ftrace_startup (kernel/trace/ftrace.c:3048)
[    0.185205] ? __pfx_function_trace_call (kernel/trace/trace_functions.c:210)
[    0.185877] register_ftrace_function_nolock (kernel/trace/ftrace.c:8717)
[    0.186595] register_ftrace_function (kernel/trace/ftrace.c:8745)
[    0.187254] ? __pfx_function_trace_call (kernel/trace/trace_functions.c:210)
[    0.187924] function_trace_init (kernel/trace/trace_functions.c:170)
[    0.188499] tracing_set_tracer (kernel/trace/trace.c:5916 kernel/trace/trace.c:6349)
[    0.189088] register_tracer (kernel/trace/trace.c:2391)
[    0.189642] early_trace_init (kernel/trace/trace.c:11075 kernel/trace/trace.c:11149)
[    0.190204] start_kernel (init/main.c:970)
[    0.190732] x86_64_start_reservations (arch/x86/kernel/head64.c:307)
[    0.191381] x86_64_start_kernel (??:?)
[    0.191955] common_startup_64 (arch/x86/kernel/head_64.S:419)
[    0.192534]  </TASK>
[    0.192839] Modules linked in:
[    0.193267] CR2: 000000000000001c
[    0.193730] ---[ end trace 0000000000000000 ]---

The crash happens because on x86 ftrace allocations from execmem require
maple tree to be initialized.

Move maple tree initialization that depends only on slab availability
earlier in boot so that it will happen right after mm_core_init().

Link: https://lkml.kernel.org/r/20250824130759.1732736-1-rppt@kernel.org
Fixes: 5d79c2be5081 ("x86/ftrace: enable EXECMEM_ROX_CACHE for ftrace allocations")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reported-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Tested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Closes: https://lore.kernel.org/all/20250820184743.0302a8b5@gandalf.local.home/
Cc: Borislav Betkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-mainc-fix-boot-time-tracing-crash
+++ a/init/main.c
@@ -956,6 +956,7 @@ void start_kernel(void)
 	sort_main_extable();
 	trap_init();
 	mm_core_init();
+	maple_tree_init();
 	poking_init();
 	ftrace_init();
 
@@ -973,7 +974,6 @@ void start_kernel(void)
 		 "Interrupts were enabled *very* early, fixing it\n"))
 		local_irq_disable();
 	radix_tree_init();
-	maple_tree_init();
 
 	/*
 	 * Set up housekeeping before setting up workqueues to allow the unbound
_

Patches currently in -mm which might be from rppt@kernel.org are

init-mainc-fix-boot-time-tracing-crash.patch
kho-allow-scratch-areas-with-zero-size.patch
lib-test_kho-fixes-for-error-handling.patch
selftest-kho-update-generation-of-initrd.patch


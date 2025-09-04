Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1951BA34
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 00:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756944694; cv=none; b=ak+ehiEnPBJN8fHzY16Mettn9vFDz8VFgZRQDsHpyUh3GwkyUgT5mxoqUOvbzSDjAFtBmf13DWfudUv8utH0sBrSZ0NPPir+4RptrhB1r4HpzOprLgo7JonLG5bd1F2QvPyxfuj4B6Hn0py/NmhMCHL89gnZaPXX4E8ROynq73g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756944694; c=relaxed/simple;
	bh=ljaEbMheFLeTnpmqw8gu3piMvMgg+W9jaCC460ODELg=;
	h=Date:To:From:Subject:Message-Id; b=B8vDxK184DhVhSr35JBoVKNP1JgDjMPNJSA1YokERLdBl2cl2WFlvHNJ0cmq6YZn1UjQBjE9rhLDESx8mpfwprZcey+ZdUZtjamKFjLVVaecEysrOWodORl7MAUFGEJqfShriPpV0k47u11zeJWYdXv4I2Itax4SgLbabLWENyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RMjZ4Z/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RMjZ4Z/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A699C4CEFD;
	Thu,  4 Sep 2025 00:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756944694;
	bh=ljaEbMheFLeTnpmqw8gu3piMvMgg+W9jaCC460ODELg=;
	h=Date:To:From:Subject:From;
	b=RMjZ4Z/h5i7NRohiF6e/b7LBMjUo0fDkjypBKEBcf7dgupNd1/Ma/lZDH6MCr+YRi
	 PmnUDaZ+QyB7B/n/obabhkn3VjdgkFgfst7INhHomxHB5tWpLemSv09zzTMDjtbW0a
	 ct3YRGPJ8ZoEESxi9w7bPFBcDbJyvS4Ff+JyMhwM=
Date: Wed, 03 Sep 2025 17:11:33 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhiramat@kernel.org,Liam.Howlett@oracle.com,bp@alien8.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] init-mainc-fix-boot-time-tracing-crash.patch removed from -mm tree
Message-Id: <20250904001134.2A699C4CEFD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init/main.c: fix boot time tracing crash
has been removed from the -mm tree.  Its filename was
     init-mainc-fix-boot-time-tracing-crash.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
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

kho-allow-scratch-areas-with-zero-size.patch
lib-test_kho-fixes-for-error-handling.patch
selftest-kho-update-generation-of-initrd.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A47381752
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104461; cv=none; b=UtOyLJdZ2AfOVXaQiS3YW8QM5Y8IROv+0DPiL383l+owtnjymdvc1wuPO1SPEV1crxaoLHx2M8lKfMbRt+17sGMoNjaE/enm+lMIwLPVW0QcTw0mjnWEVGhJ/pIocE8LtHmsAgadauDEJNaTNGlYYS/lQSrIqx2zx73ETd067ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104461; c=relaxed/simple;
	bh=iqHUkiZokXqZDRej1vRmgPX0CBv+/fYd9mAC2fYI0kw=;
	h=Date:To:From:Subject:Message-Id; b=q/DvOZncqAyB9DvhcZVbB8fzepsMYRRv/s5ARGOME7uBXlHL5fYfnly2Yl3nQn2i6qDV3UDpMRIs7e3pXkxBtcs361LWaEO+DnNCzkZbe5U9AUoB71rvv3tdfKHo1akYSzJFp0jHInj/VQCDjJj8v8vwDeAJ1B6CM/Kn8YV5o74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wtone2MB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wtone2MB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4693CC113CD;
	Fri, 26 Apr 2024 04:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104461;
	bh=iqHUkiZokXqZDRej1vRmgPX0CBv+/fYd9mAC2fYI0kw=;
	h=Date:To:From:Subject:From;
	b=Wtone2MBwSiADQYGi1+WPmFcAEnIC1roQc3cuZfJ+FNBOfj2PRdhVn54fj0VdGQd2
	 r22VC5SoZKtUKDyXvanL9Czfo1YjTzuL4gODoFHRHQuEShtjhxG0E05a5+UlEbUQ+N
	 ijYwpmaaXzCP0BiHsFiXp6z3tfvzvpho9/5OKOIE=
Date: Thu, 25 Apr 2024 21:07:40 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,will@kernel.org,vschneid@redhat.com,vbabka@suse.cz,tglx@linutronix.de,rppt@kernel.org,rafael@kernel.org,paul.walmsley@sifive.com,palmer@rivosinc.com,ndesaulniers@google.com,mpe@ellerman.id.au,mingo@kernel.org,mikelley@microsoft.com,mhiramat@kernel.org,mark.rutland@arm.com,kuba@kernel.org,jpoimboe@kernel.org,jiaxun.yang@flygoat.com,gregkh@linuxfoundation.org,chenhuacai@kernel.org,catalin.marinas@arm.com,arnd@arndb.de,aou@eecs.berkeley.edu,shijie@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] numa-early-use-of-cpu_to_node-returns-0-instead-of-the-correct-node-id.patch removed from -mm tree
Message-Id: <20240426040741.4693CC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: NUMA: early use of cpu_to_node() returns 0 instead of the correct node id
has been removed from the -mm tree.  Its filename was
     numa-early-use-of-cpu_to_node-returns-0-instead-of-the-correct-node-id.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Shijie <shijie@os.amperecomputing.com>
Subject: NUMA: early use of cpu_to_node() returns 0 instead of the correct node id
Date: Fri, 26 Jan 2024 14:44:51 +0800

During the kernel booting, the generic cpu_to_node() is called too early
in arm64, powerpc and riscv when CONFIG_NUMA is enabled.

There are at least four places in the common code where
the generic cpu_to_node() is called before it is initialized:
	   1.) early_trace_init()         in kernel/trace/trace.c
	   2.) sched_init()               in kernel/sched/core.c
	   3.) init_sched_fair_class()    in kernel/sched/fair.c
	   4.) workqueue_init_early()     in kernel/workqueue.c

This will harm performance since there is an increase in off node
accesses.

In order to fix the bug, the patch introduces early_numa_node_init() which
is called after smp_prepare_boot_cpu() in start_kernel. 
early_numa_node_init will initialize the "numa_node" as soon as the
early_cpu_to_node() is ready, before the cpu_to_node() is called at the
first time.

Link: https://lkml.kernel.org/r/20240126064451.5465-1-shijie@os.amperecomputing.com
Signed-off-by: Huang Shijie <shijie@os.amperecomputing.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>	[RISC-V]
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michael Kelley (LINUX) <mikelley@microsoft.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/init/main.c~numa-early-use-of-cpu_to_node-returns-0-instead-of-the-correct-node-id
+++ a/init/main.c
@@ -882,6 +882,19 @@ static void __init print_unknown_bootopt
 	memblock_free(unknown_options, len);
 }
 
+static void __init early_numa_node_init(void)
+{
+#ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
+#ifndef cpu_to_node
+	int cpu;
+
+	/* The early_cpu_to_node() should be ready here. */
+	for_each_possible_cpu(cpu)
+		set_cpu_numa_node(cpu, early_cpu_to_node(cpu));
+#endif
+#endif
+}
+
 asmlinkage __visible __init __no_sanitize_address __noreturn __no_stack_protector
 void start_kernel(void)
 {
@@ -912,6 +925,7 @@ void start_kernel(void)
 	setup_nr_cpu_ids();
 	setup_per_cpu_areas();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
+	early_numa_node_init();
 	boot_cpu_hotplug_init();
 
 	pr_notice("Kernel command line: %s\n", saved_command_line);
_

Patches currently in -mm which might be from shijie@os.amperecomputing.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96ED614C5BC
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 18:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711563434; cv=none; b=S8ypHNQ5mv5wK0p+pwlxNA9jOiZw61ac9iC+dS6ko/Ox6qIzR1cCfdNEhFkzdc+8T4eOQO9/sexuhcAa/kcVoOCGNDgXe1RaiMosPQZlzQlC4Z0W+EO/ZA55kBQkVBGvRHNmurEaIOkujsMvA+1pvDAhUdRiD/fDgeVXoflj8I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711563434; c=relaxed/simple;
	bh=R35kR0W5drGWd1+545dEaxEpIFU1t2orAq4J4sy5JpM=;
	h=Date:To:From:Subject:Message-Id; b=mbh2wzb27timOrPK/WTxHyAENni4U9z7jz58llAbMbfjp7k1RCqjRtilGRS5YSPT4+ZWZ37O+UiIFq5jJdev6C4wEOu82Tx+t1veqBB9TLU3wOSs3Q4cbGSR3wT3jsbVIwzKwMAaJn6vz5YTNWI2NaxNWeOuy/ZyJ3pbZqgWqTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OVUO93Wl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OVUO93Wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F297FC433C7;
	Wed, 27 Mar 2024 18:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711563434;
	bh=R35kR0W5drGWd1+545dEaxEpIFU1t2orAq4J4sy5JpM=;
	h=Date:To:From:Subject:From;
	b=OVUO93Wl7ZSisjW/wGx4AC/LoG/eLkWPs6UfpYVptujEqAJvsXrwlviqVUqBAUKt+
	 RfR64JUY1JNCsBde5vBrD9kKwywGF0VszpKxZyMXtF49st2/MO4Y9zVA3ICkK+9B0u
	 ZLnarconvPuGEbC/3roVZZDiM1xMWPFxzDw54mdc=
Date: Wed, 27 Mar 2024 11:17:13 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,will@kernel.org,vschneid@redhat.com,vbabka@suse.cz,tglx@linutronix.de,rppt@kernel.org,rafael@kernel.org,paul.walmsley@sifive.com,palmer@rivosinc.com,ndesaulniers@google.com,mpe@ellerman.id.au,mingo@kernel.org,mikelley@microsoft.com,mhiramat@kernel.org,mark.rutland@arm.com,kuba@kernel.org,jpoimboe@kernel.org,jiaxun.yang@flygoat.com,gregkh@linuxfoundation.org,chenhuacai@kernel.org,catalin.marinas@arm.com,arnd@arndb.de,aou@eecs.berkeley.edu,shijie@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + numa-early-use-of-cpu_to_node-returns-0-instead-of-the-correct-node-id.patch added to mm-nonmm-unstable branch
Message-Id: <20240327181713.F297FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: NUMA: early use of cpu_to_node() returns 0 instead of the correct node id
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     numa-early-use-of-cpu_to_node-returns-0-instead-of-the-correct-node-id.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/numa-early-use-of-cpu_to_node-returns-0-instead-of-the-correct-node-id.patch

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
@@ -877,6 +877,19 @@ static void __init print_unknown_bootopt
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
@@ -907,6 +920,7 @@ void start_kernel(void)
 	setup_nr_cpu_ids();
 	setup_per_cpu_areas();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
+	early_numa_node_init();
 	boot_cpu_hotplug_init();
 
 	pr_notice("Kernel command line: %s\n", saved_command_line);
_

Patches currently in -mm which might be from shijie@os.amperecomputing.com are

numa-early-use-of-cpu_to_node-returns-0-instead-of-the-correct-node-id.patch


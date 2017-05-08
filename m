From: akpm@linux-foundation.org
Subject: [patch 034/114] fork: free vmapped stacks in cache when
 cpus are offline
Date: Mon, 08 May 2017 15:56:11 -0700
Message-ID: <20170508225611.sqoAUVZ3l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46074 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751850AbdEHW4N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:56:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, hoeun.ryu@gmail.com, keescook@chromium.org, luto@kernel.org, mguzik@redhat.com, mhocko@suse.com, mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org

From: Hoeun Ryu <hoeun.ryu@gmail.com>
Subject: fork: free vmapped stacks in cache when cpus are offline

Using virtually mapped stack, kernel stacks are allocated via vmalloc.  In
the current implementation, two stacks per cpu can be cached when tasks
are freed and the cached stacks are used again in task duplications.  but
the cached stacks may remain unfreed even when cpu are offline.  By adding
a cpu hotplug callback to free the cached stacks when a cpu goes offline,
the pages of the cached stacks are not wasted.

Link: http://lkml.kernel.org/r/1487076043-17802-1-git-send-email-hoeun.ryu@gmail.com
Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Mateusz Guzik <mguzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN kernel/fork.c~fork-free-vmapped-stacks-in-cache-when-cpus-are-offline kernel/fork.c
--- a/kernel/fork.c~fork-free-vmapped-stacks-in-cache-when-cpus-are-offline
+++ a/kernel/fork.c
@@ -179,6 +179,24 @@ void __weak arch_release_thread_stack(un
  */
 #define NR_CACHED_STACKS 2
 static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
+
+static int free_vm_stack_cache(unsigned int cpu)
+{
+	struct vm_struct **cached_vm_stacks = per_cpu_ptr(cached_stacks, cpu);
+	int i;
+
+	for (i = 0; i < NR_CACHED_STACKS; i++) {
+		struct vm_struct *vm_stack = cached_vm_stacks[i];
+
+		if (!vm_stack)
+			continue;
+
+		vfree(vm_stack->addr);
+		cached_vm_stacks[i] = NULL;
+	}
+
+	return 0;
+}
 #endif
 
 static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
@@ -467,6 +485,11 @@ void __init fork_init(void)
 	for (i = 0; i < UCOUNT_COUNTS; i++) {
 		init_user_ns.ucount_max[i] = max_threads/2;
 	}
+
+#ifdef CONFIG_VMAP_STACK
+	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "fork:vm_stack_cache",
+			  NULL, free_vm_stack_cache);
+#endif
 }
 
 int __weak arch_dup_task_struct(struct task_struct *dst,
_

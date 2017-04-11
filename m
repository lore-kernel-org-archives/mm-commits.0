From: akpm@linux-foundation.org
Subject: + fork-free-vmapped-stacks-in-cache-when-cpus-are-offline.patch
 added to -mm tree
Date: Tue, 11 Apr 2017 13:53:25 -0700
Message-ID: <58ed4245.FwyZcRV98gEpe7kZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36200 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753609AbdDKUx0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2017 16:53:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hoeun.ryu@gmail.com, ebiederm@xmission.com, keescook@chromium.org, luto@kernel.org, mguzik@redhat.com, mhocko@suse.com, mingo@kernel.org, oleg@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fork: free vmapped stacks in cache when cpus are offline
has been added to the -mm tree.  Its filename is
     fork-free-vmapped-stacks-in-cache-when-cpus-are-offline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fork-free-vmapped-stacks-in-cache-when-cpus-are-offline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fork-free-vmapped-stacks-in-cache-when-cpus-are-offline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -178,6 +178,24 @@ void __weak arch_release_thread_stack(un
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
@@ -466,6 +484,11 @@ void __init fork_init(void)
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

Patches currently in -mm which might be from hoeun.ryu@gmail.com are

fork-free-vmapped-stacks-in-cache-when-cpus-are-offline.patch


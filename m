From: akpm@linux-foundation.org
Subject: - percpu-fix-debug_preempt-per_cpu-checking.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:53 -0800
Message-ID: <200802232023.m1NKNrWr013584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763164AbYBWU3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, benh@kernel.crashing.org, davem@davemloft.net, mingo@elte.hu, paulus@samba.org, schwidefsky@de.ibm.com, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     percpu: fix DEBUG_PREEMPT per_cpu checking
has been removed from the -mm tree.  Its filename was
     percpu-fix-debug_preempt-per_cpu-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: percpu: fix DEBUG_PREEMPT per_cpu checking
From: Hugh Dickins <hugh@veritas.com>

Recent percpu changes have broken CONFIG_DEBUG_PREEMPT's per_cpu checking
on several architectures.  On s390, sparc64 and x86 it's been weakened to
not checking at all; whereas on powerpc64 it's become too strict, issuing
warnings from __raw_get_cpu_var in io_schedule and init_timer for example.

Fix this by weakening powerpc's __my_cpu_offset to use the non-checking
local_paca instead of get_paca (which itself contains such a check); and
strengthening the generic my_cpu_offset to go the old slow way via
smp_processor_id when CONFIG_DEBUG_PREEMPT (debug_smp_processor_id is where
all the knowledge of what's correct when lives).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/percpu.h |    2 ++
 include/asm-powerpc/percpu.h |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/percpu.h~percpu-fix-debug_preempt-per_cpu-checking include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h~percpu-fix-debug_preempt-per_cpu-checking
+++ a/include/asm-generic/percpu.h
@@ -32,6 +32,8 @@ extern unsigned long __per_cpu_offset[NR
  */
 #ifndef __my_cpu_offset
 #define __my_cpu_offset per_cpu_offset(raw_smp_processor_id())
+#endif
+#ifdef CONFIG_DEBUG_PREEMPT
 #define my_cpu_offset per_cpu_offset(smp_processor_id())
 #else
 #define my_cpu_offset __my_cpu_offset
diff -puN include/asm-powerpc/percpu.h~percpu-fix-debug_preempt-per_cpu-checking include/asm-powerpc/percpu.h
--- a/include/asm-powerpc/percpu.h~percpu-fix-debug_preempt-per_cpu-checking
+++ a/include/asm-powerpc/percpu.h
@@ -13,7 +13,7 @@
 #include <asm/paca.h>
 
 #define __per_cpu_offset(cpu) (paca[cpu].data_offset)
-#define __my_cpu_offset get_paca()->data_offset
+#define __my_cpu_offset local_paca->data_offset
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
 #endif /* CONFIG_SMP */
_

Patches currently in -mm which might be from hugh@veritas.com are

git-sched.patch
git-unionfs.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
prio_tree-debugging-patch.patch

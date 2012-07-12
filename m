From: akpm@linux-foundation.org
Subject: + fork-fix-error-handling-in-dup_task.patch added to -mm tree
Date: Thu, 12 Jul 2012 15:10:27 -0700
Message-ID: <20120712221028.4F58A100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:42158 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab2GLWKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 18:10:30 -0400
Received: by vcqp1 with SMTP id p1so34809vcq.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 15:10:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, a.p.zijlstra@chello.nl, cmetcalf@tilera.com, dhowells@redhat.com, hpa@zytor.com, lethal@linux-sh.org, mingo@elte.hu, mingo@redhat.com, sqazi@google.com, tglx@linutronix.de, yasutake.koichi@jp.panasonic.com


The patch titled
     Subject: fork: fix error handling in dup_task()
has been added to the -mm tree.  Its filename is
     fork-fix-error-handling-in-dup_task.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: fork: fix error handling in dup_task()

The function dup_task() may fail at the following function calls in the
following order.

0) alloc_task_struct_node()
1) alloc_thread_info_node()
2) arch_dup_task_struct()

Error by 0) is not a matter, it can just return.  But error by 1) requires
releasing task_struct allocated by 0) before it returns.  Likewise, error
by 2) requires releasing task_struct and thread_info allocated by 0) and
1).

The existing error handling calls free_task_struct() and
free_thread_info() which do not only release task_struct and thread_info,
but also call architecture specific arch_release_task_struct() and
arch_release_thread_info().

The problem is that task_struct and thread_info are not fully initialized
yet at this point, but arch_release_task_struct() and
arch_release_thread_info() are called with them.

For example, x86 defines its own arch_release_task_struct() that releases
a task_xstate.  If alloc_thread_info_node() fails in dup_task(),
arch_release_task_struct() is called with task_struct which is just
allocated and filled with garbage in this error handling.

This actually happened with tools/testing/fault-injection/failcmd.sh

	# env FAILCMD_TYPE=fail_page_alloc \
		./tools/testing/fault-injection/failcmd.sh --times=100 \
		--min-order=0 --ignore-gfp-wait=0 \
		-- make -C tools/testing/selftests/ run_tests

In order to fix this issue, make free_{task_struct,thread_info}() not to
call arch_release_{task_struct,thread_info}() and call
arch_release_{task_struct,thread_info}() implicitly where needed.

Default arch_release_task_struct() and arch_release_thread_info() are
defined as empty by default.  So this change only affects the
architectures which implement their own arch_release_task_struct() or
arch_release_thread_info() as listed below.

arch_release_task_struct(): x86, sh
arch_release_thread_info(): mn10300, tile

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Salman Qazi <sqazi@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN kernel/fork.c~fork-fix-error-handling-in-dup_task kernel/fork.c
--- a/kernel/fork.c~fork-fix-error-handling-in-dup_task
+++ a/kernel/fork.c
@@ -114,6 +114,8 @@ int nr_processes(void)
 	return total;
 }
 
+void __weak arch_release_task_struct(struct task_struct *tsk) { }
+
 #ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
 static struct kmem_cache *task_struct_cachep;
 
@@ -122,18 +124,16 @@ static inline struct task_struct *alloc_
 	return kmem_cache_alloc_node(task_struct_cachep, GFP_KERNEL, node);
 }
 
-void __weak arch_release_task_struct(struct task_struct *tsk) { }
-
 static inline void free_task_struct(struct task_struct *tsk)
 {
-	arch_release_task_struct(tsk);
 	kmem_cache_free(task_struct_cachep, tsk);
 }
 #endif
 
-#ifndef CONFIG_ARCH_THREAD_INFO_ALLOCATOR
 void __weak arch_release_thread_info(struct thread_info *ti) { }
 
+#ifndef CONFIG_ARCH_THREAD_INFO_ALLOCATOR
+
 /*
  * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
  * kmemcache based allocator.
@@ -150,7 +150,6 @@ static struct thread_info *alloc_thread_
 
 static inline void free_thread_info(struct thread_info *ti)
 {
-	arch_release_thread_info(ti);
 	free_pages((unsigned long)ti, THREAD_SIZE_ORDER);
 }
 # else
@@ -164,7 +163,6 @@ static struct thread_info *alloc_thread_
 
 static void free_thread_info(struct thread_info *ti)
 {
-	arch_release_thread_info(ti);
 	kmem_cache_free(thread_info_cache, ti);
 }
 
@@ -205,10 +203,12 @@ static void account_kernel_stack(struct 
 void free_task(struct task_struct *tsk)
 {
 	account_kernel_stack(tsk->stack, -1);
+	arch_release_thread_info(tsk->stack);
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
 	put_seccomp_filter(tsk);
+	arch_release_task_struct(tsk);
 	free_task_struct(tsk);
 }
 EXPORT_SYMBOL(free_task);
@@ -298,14 +298,12 @@ static struct task_struct *dup_task_stru
 		return NULL;
 
 	ti = alloc_thread_info_node(tsk, node);
-	if (!ti) {
-		free_task_struct(tsk);
-		return NULL;
-	}
+	if (!ti)
+		goto free_tsk;
 
 	err = arch_dup_task_struct(tsk, orig);
 	if (err)
-		goto out;
+		goto free_ti;
 
 	tsk->stack = ti;
 
@@ -333,8 +331,9 @@ static struct task_struct *dup_task_stru
 
 	return tsk;
 
-out:
+free_ti:
 	free_thread_info(ti);
+free_tsk:
 	free_task_struct(tsk);
 	return NULL;
 }
_
Subject: Subject: fork: fix error handling in dup_task()

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
string-introduce-memweight.patch
string-introduce-memweight-fix.patch
string-introduce-memweight-fix-build-error-caused-by-memweight-introduction.patch
qnx4fs-use-memweight.patch
dm-use-memweight.patch
affs-use-memweight.patch
video-uvc-use-memweight.patch
ocfs2-use-memweight.patch
ext2-use-memweight.patch
ext3-use-memweight.patch
ext4-use-memweight.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
fork-fix-error-handling-in-dup_task.patch
fork-fix-error-handling-in-dup_task-fix.patch
fault-injection-notifier-error-injection.patch
fault-injection-notifier-error-injection-doc.patch
cpu-rewrite-cpu-notifier-error-inject-module.patch
pm-pm-notifier-error-injection-module.patch
memory-memory-notifier-error-injection-module.patch
memory-memory-notifier-error-injection-module-fix.patch
powerpc-pseries-reconfig-notifier-error-injection-module.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc.patch
fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc-doc.patch


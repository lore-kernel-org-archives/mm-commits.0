From: akpm@linux-foundation.org
Subject: + task_struct-move-fpu_counter-and-oomkilladj.patch added to -mm tree
Date: Wed, 03 Oct 2007 13:25:50 -0700
Message-ID: <200710032025.l93KPoFj007038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48590 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753559AbXJCU0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 16:26:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, arjan@infradead.org


The patch titled
     task_struct: move ->fpu_counter and ->oomkilladj
has been added to the -mm tree.  Its filename is
     task_struct-move-fpu_counter-and-oomkilladj.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: task_struct: move ->fpu_counter and ->oomkilladj
From: Alexey Dobriyan <adobriyan@sw.ru>

There is nice 2 byte hole after struct task_struct::ioprio field
into which we can put two 1-byte fields: ->fpu_counter and ->oomkilladj.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/sched.h~task_struct-move-fpu_counter-and-oomkilladj include/linux/sched.h
--- a/include/linux/sched.h~task_struct-move-fpu_counter-and-oomkilladj
+++ a/include/linux/sched.h
@@ -888,6 +888,16 @@ struct task_struct {
 #endif
 
 	unsigned short ioprio;
+	/*
+	 * fpu_counter contains the number of consecutive context switches
+	 * that the FPU is used. If this is over a threshold, the lazy fpu
+	 * saving becomes unlazy to save the trap. This is an unsigned char
+	 * so that after 256 times the counter wraps and the behavior turns
+	 * lazy again; this to deal with bursty apps that only use FPU for
+	 * a short time
+	 */
+	unsigned char fpu_counter;
+	s8 oomkilladj; /* OOM kill score adjustment (bit shift). */
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
 #endif
@@ -972,16 +982,6 @@ struct task_struct {
 	struct key *thread_keyring;	/* keyring private to this thread */
 	unsigned char jit_keyring;	/* default keyring to attach requested keys to */
 #endif
-	/*
-	 * fpu_counter contains the number of consecutive context switches
-	 * that the FPU is used. If this is over a threshold, the lazy fpu
-	 * saving becomes unlazy to save the trap. This is an unsigned char
-	 * so that after 256 times the counter wraps and the behavior turns
-	 * lazy again; this to deal with bursty apps that only use FPU for
-	 * a short time
-	 */
-	unsigned char fpu_counter;
-	s8 oomkilladj; /* OOM kill score adjustment (bit shift). */
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
 				       it with task_lock())
_

Patches currently in -mm which might be from adobriyan@sw.ru are

consolidate-ptrace_detach.patch
git-kbuild.patch
git-sched.patch
slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab-fix.patch
use-list_head-in-binfmt-handling-update.patch
make-unregister_binfmt-return-void.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
tweak-proc-ipmi-removal.patch
shrink-task_struct-if-config_futex=n.patch
userc-deinline.patch
userc-ifdef-mq_bytes.patch
userc-ifdef-mq_bytes-fix.patch
move-kasprintfo-to-obj-y.patch
task_struct-move-fpu_counter-and-oomkilladj.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
single_open-seq_release-leak-diagnostics.patch

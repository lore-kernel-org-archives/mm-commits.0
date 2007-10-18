From: akpm@linux-foundation.org
Subject: - task_struct-move-fpu_counter-and-oomkilladj.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:48 -0700
Message-ID: <200710180701.l9I71moM031206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50127 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759442AbXJRHWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:22:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, arjan@infradead.org, mm-commits@vger.kernel.org


The patch titled
     task_struct: move ->fpu_counter and ->oomkilladj
has been removed from the -mm tree.  Its filename was
     task_struct-move-fpu_counter-and-oomkilladj.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: task_struct: move ->fpu_counter and ->oomkilladj
From: Alexey Dobriyan <adobriyan@sw.ru>

There is nice 2 byte hole after struct task_struct::ioprio field
into which we can put two 1-byte fields: ->fpu_counter and ->oomkilladj.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Acked-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN include/linux/sched.h~task_struct-move-fpu_counter-and-oomkilladj include/linux/sched.h
--- a/include/linux/sched.h~task_struct-move-fpu_counter-and-oomkilladj
+++ a/include/linux/sched.h
@@ -918,6 +918,16 @@ struct task_struct {
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
@@ -1003,16 +1013,6 @@ struct task_struct {
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

origin.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
add-kernel-notifierc-fix-2-fix-3.patch
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
uninline-forkc-exitc.patch
uninline-forkc-exitc-checkpatch-fixes.patch
single_open-seq_release-leak-diagnostics.patch

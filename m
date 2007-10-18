From: akpm@linux-foundation.org
Subject: - kernel-rtmutex-debugc-cleanups.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:54:39 -0700
Message-ID: <200710180654.l9I6sddS030539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46010 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932375AbXJRHnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     kernel/rtmutex-debug.c: cleanups
has been removed from the -mm tree.  Its filename was
     kernel-rtmutex-debugc-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel/rtmutex-debug.c: cleanups
From: Adrian Bunk <bunk@stusta.de>

This patch contains the following cleanups:
- make the needlessly global variable rt_trace_on static
- remove the unused global function deadlock_trace_off()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rtmutex-debug.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN kernel/rtmutex-debug.c~kernel-rtmutex-debugc-cleanups kernel/rtmutex-debug.c
--- a/kernel/rtmutex-debug.c~kernel-rtmutex-debugc-cleanups
+++ a/kernel/rtmutex-debug.c
@@ -82,12 +82,7 @@ do {						\
  * into the tracing code when doing error printk or
  * executing a BUG():
  */
-int rt_trace_on = 1;
-
-void deadlock_trace_off(void)
-{
-	rt_trace_on = 0;
-}
+static int rt_trace_on = 1;
 
 static void printk_task(struct task_struct *p)
 {
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-kvm.patch
remove-fs-jffs2-ioctlc.patch
parisc-extern-inline-static-inline.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
unexport-pm_power_off_prepare.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch

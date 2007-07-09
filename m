From: akpm@linux-foundation.org
Subject: - mm-variable-length-argument-support-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:51:23 -0700
Message-ID: <200707092351.l69NpNN9021509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757139AbXGIXvh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:51:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, aaw@google.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     mm-variable-length-argument-support-fix
has been removed from the -mm tree.  Its filename was
     mm-variable-length-argument-support-fix.patch

This patch was dropped because it was folded into mm-variable-length-argument-support.patch

------------------------------------------------------
Subject: mm-variable-length-argument-support-fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ollie Wild <aaw@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+)

diff -puN fs/exec.c~mm-variable-length-argument-support-fix fs/exec.c
--- a/fs/exec.c~mm-variable-length-argument-support-fix
+++ a/fs/exec.c
@@ -199,6 +199,23 @@ static struct page *get_arg_page(struct 
 	if (ret <= 0)
 		return NULL;
 
+	if (write) {
+		struct rlimit *rlim = current->signal->rlim;
+		unsigned long size = bprm->vma->vm_end - bprm->vma->vm_start;
+
+		/*
+		 * Limit to 1/4-th the stack size for the argv+env strings.
+		 * This ensures that:
+		 *  - the remaining binfmt code will not run out of stack space,
+		 *  - the program will have a reasonable amount of stack left
+		 *    to work from.
+		 */
+		if (size > rlim[RLIMIT_STACK].rlim_cur / 4) {
+			put_page(page);
+			return NULL;
+		}
+	}
+
 	return page;
 }
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
arch-personality-independent-stack-top.patch
audit-rework-execve-audit.patch
mm-variable-length-argument-support.patch
mm-variable-length-argument-support-fix.patch
mm-variable-length-argument-support-fix-2.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
lockstat-human-readability-tweaks.patch
lockstat-human-readability-tweaks-fix.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-various-fixes-checkpatch.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-measure-lock-bouncing-checkpatch.patch
lockstat-better-class-name-representation.patch
lockdep-debugging-give-stacktrace-for-init_error.patch
stacktrace-fix-header-file-for-config_stacktrace.patch

From: akpm@linux-foundation.org
Subject: - arch_rebalance_pgtables-call.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:31:44 -0800
Message-ID: <200802052231.m15MVPsQ012163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58157 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761239AbYBEWml (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwidefsky@de.ibm.com, benh@kernel.crashing.org, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     arch_rebalance_pgtables call
has been removed from the -mm tree.  Its filename was
     arch_rebalance_pgtables-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch_rebalance_pgtables call
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

In order to change the layout of the page tables after an mmap has crossed the
adress space limit of the current page table layout a architecture hook in
get_unmapped_area is needed.  The arguments are the address of the new mapping
and the length of it.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/mmap.c~arch_rebalance_pgtables-call mm/mmap.c
--- a/mm/mmap.c~arch_rebalance_pgtables-call
+++ a/mm/mmap.c
@@ -36,6 +36,10 @@
 #define arch_mmap_check(addr, len, flags)	(0)
 #endif
 
+#ifndef arch_rebalance_pgtables
+#define arch_rebalance_pgtables(addr, len)		(addr)
+#endif
+
 static void unmap_region(struct mm_struct *mm,
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end);
@@ -1424,7 +1428,7 @@ get_unmapped_area(struct file *file, uns
 	if (addr & ~PAGE_MASK)
 		return -EINVAL;
 
-	return addr;
+	return arch_rebalance_pgtables(addr, len);
 }
 
 EXPORT_SYMBOL(get_unmapped_area);
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

origin.patch
git-sched.patch
taskstats-scaled-time-cleanup.patch
calibrate_delay-must-be-__cpuinit.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-s390.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
page-owner-tracking-leak-detector-broken-on-s390.patch

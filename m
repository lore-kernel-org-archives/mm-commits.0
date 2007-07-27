From: akpm@linux-foundation.org
Subject: + audit-fix-two-bugs-in-the-new-execve-audit-code.patch added to -mm tree
Date: Fri, 27 Jul 2007 16:05:50 -0700
Message-ID: <200707272305.l6RN5oZ3014444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44223 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760667AbXG0XGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 19:06:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, sgrubb@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     audit: fix two bugs in the new execve audit code
has been added to the -mm tree.  Its filename is
     audit-fix-two-bugs-in-the-new-execve-audit-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: audit: fix two bugs in the new execve audit code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

On Fri, 2007-07-27 at 16:13 -0400, Steve Grubb wrote:
> Hi,
>
> I was testing our rawhide kernel and I'm scrolling these errors:
>
> WARNING: at kernel/auditsc.c:859 audit_log_execve_info() (Not tainted)
>
> Call Trace:
>  [<ffffffff8106b06f>] audit_log_exit+0x5d7/0x964
>  [<ffffffff81050805>] trace_hardirqs_on+0x12e/0x151
>  [<ffffffff8106b60b>] audit_syscall_exit+0x9b/0x300
>  [<ffffffff8100ee62>] syscall_trace_leave+0x2c/0x87
>  [<ffffffff8100beb1>] int_very_careful+0x3a/0x43
>

copy_from_user() returns the number of bytes not copied, hence 0 is the
expected output.

axi->mm might not be valid anymore when not equal to current->mm, do not
dereference before checking that - thanks to Al for spotting that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steve Grubb <sgrubb@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/auditsc.c~audit-fix-two-bugs-in-the-new-execve-audit-code kernel/auditsc.c
--- a/kernel/auditsc.c~audit-fix-two-bugs-in-the-new-execve-audit-code
+++ a/kernel/auditsc.c
@@ -824,12 +824,14 @@ static void audit_log_execve_info(struct
 {
 	int i;
 	long len, ret;
-	const char __user *p = (const char __user *)axi->mm->arg_start;
+	const char __user *p;
 	char *buf;
 
 	if (axi->mm != current->mm)
 		return; /* execve failed, no additional info */
 
+	p = (const char __user *)axi->mm->arg_start;
+
 	for (i = 0; i < axi->argc; i++, p += len) {
 		len = strnlen_user(p, MAX_ARG_STRLEN);
 		/*
@@ -855,7 +857,7 @@ static void audit_log_execve_info(struct
 		 * copied them here, and the mm hasn't been exposed to user-
 		 * space yet.
 		 */
-		if (!ret) {
+		if (ret) {
 			WARN_ON(1);
 			send_sig(SIGKILL, current, 0);
 		}
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

slub-add-lock-debugging-check.patch
audit-fix-two-bugs-in-the-new-execve-audit-code.patch
slub-fix-bug-in-slub-debug-support.patch
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
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch

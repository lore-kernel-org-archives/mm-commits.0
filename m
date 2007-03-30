From: akpm@linux-foundation.org
Subject: + uml-speed-up-exec.patch added to -mm tree
Date: Fri, 30 Mar 2007 14:21:37 -0700
Message-ID: <200703302121.l2ULLbmA005961@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53226 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbXC3VVl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Mar 2007 17:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: speed up exec
has been added to the -mm tree.  Its filename is
     uml-speed-up-exec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: speed up exec
From: Jeff Dike <jdike@addtoit.com>

flush_thread doesn't need to do a full page table walk in order to clear the
address space.  It knows what the end result needs to be, so it can call unmap
directly.

This results in a 10-20% speedup in an exec from bash.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/skas/exec.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletion(-)

diff -puN arch/um/kernel/skas/exec.c~uml-speed-up-exec arch/um/kernel/skas/exec.c
--- a/arch/um/kernel/skas/exec.c~uml-speed-up-exec
+++ a/arch/um/kernel/skas/exec.c
@@ -17,7 +17,17 @@
 
 void flush_thread_skas(void)
 {
-	force_flush_all();
+	void *data = NULL;
+	unsigned long end = proc_mm ? task_size : CONFIG_STUB_START;
+	int ret;
+
+	ret = unmap(&current->mm->context.skas.id, 0, end, 1, &data);
+	if(ret){
+		printk("flush_thread_skas - clearing address space failed, "
+		       "err = %d\n", ret);
+		force_sig(SIGKILL, current);
+	}
+
 	switch_mm_skas(&current->mm->context.skas.id);
 }
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-unreasonably-long-udelay.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch

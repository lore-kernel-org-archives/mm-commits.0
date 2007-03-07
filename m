From: akpm@linux-foundation.org
Subject: - uml-comment-the-initialization-of-a-global.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:48 -0800
Message-ID: <200703070421.l274LmFw018933@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47064 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161291AbXCGEVv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: comment the initialization of a global
has been removed from the -mm tree.  Its filename was
     uml-comment-the-initialization-of-a-global.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: comment the initialization of a global
From: Jeff Dike <jdike@addtoit.com>

Comment the fact that sig_info is initialized early in boot, and thus doesn't
need any locking.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/trap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/um/os-Linux/trap.c~uml-comment-the-initialization-of-a-global arch/um/os-Linux/trap.c
--- a/arch/um/os-Linux/trap.c~uml-comment-the-initialization-of-a-global
+++ a/arch/um/os-Linux/trap.c
@@ -16,6 +16,7 @@ void usr2_handler(int sig, union uml_pt_
 	CHOOSE_MODE(syscall_handler_tt(sig, regs), (void) 0);
 }
 
+/* Initialized from linux_main() */
 void (*sig_info[NSIG])(int, union uml_pt_regs *);
 
 void os_fill_handlinfo(struct kern_handlers h)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-fix-double-free.patch
uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
uml-fix-a-memory-leak-in-the-multicast-driver.patch
uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
uml-mark-both-consoles-as-con_anytime.patch
uml-fix-confusion-irq-early-reenabling.patch
uml-activate_fd-return-enomem-only-when-appropriate.patch
uml-fix-errno-usage.patch
div64_64-common-code.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
uml-fix-prototypes.patch

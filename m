From: akpm@linux-foundation.org
Subject: + uml-comment-the-initialization-of-a-global.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:54:23 -0800
Message-ID: <200703060454.l264sNLq012320@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50945 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbXCFEy0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:54:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: comment the initialization of a global
has been added to the -mm tree.  Its filename is
     uml-comment-the-initialization-of-a-global.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
linux-audith-needs-linux-typesh.patch
uml-fix-formatting-violations-in-signal-delivery-code.patch
uml-add-a-debugging-message.patch
uml-comment-the-initialization-of-a-global.patch
div64_64-common-code.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch
uml-hostfs-fix-double-free.patch
uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
uml-fix-a-memory-leak-in-the-multicast-driver.patch
uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
uml-mark-both-consoles-as-con_anytime.patch
uml-fix-confusion-irq-early-reenabling.patch
uml-activate_fd-return-enomem-only-when-appropriate.patch
uml-fix-errno-usage.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch

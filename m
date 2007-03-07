From: akpm@linux-foundation.org
Subject: + uml-mark-tt-mode-code-for-future-removal.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:23:43 -0800
Message-ID: <200703070123.l271Nhw6015405@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41986 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161126AbXCGBXs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:23:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: mark tt-mode code for future removal
has been added to the -mm tree.  Its filename is
     uml-mark-tt-mode-code-for-future-removal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: mark tt-mode code for future removal
From: Jeff Dike <jdike@addtoit.com>

Mark some tt-mode-only code as such.

Also cleaned up some formatting.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/ptrace_user.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff -puN arch/um/sys-i386/ptrace_user.c~uml-mark-tt-mode-code-for-future-removal arch/um/sys-i386/ptrace_user.c
--- a/arch/um/sys-i386/ptrace_user.c~uml-mark-tt-mode-code-for-future-removal
+++ a/arch/um/sys-i386/ptrace_user.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
@@ -45,7 +45,8 @@ int ptrace_setfpregs(long pid, unsigned 
 	return 0;
 }
 
-/* All the below stuff is of interest for TT mode only */
+#ifdef UML_CONFIG_MODE_TT
+
 static void write_debugregs(int pid, unsigned long *regs)
 {
 	struct user *dummy;
@@ -128,13 +129,4 @@ void update_debugregs(int seq)
 }
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
+#endif
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
linux-audith-needs-linux-typesh.patch
uml-fix-formatting-violations-in-signal-delivery-code.patch
uml-add-a-debugging-message.patch
uml-comment-the-initialization-of-a-global.patch
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
uml-fix-prototypes.patch

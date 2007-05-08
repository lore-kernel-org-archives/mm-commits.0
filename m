From: akpm@linux-foundation.org
Subject: - uml-mark-tt-mode-code-for-future-removal.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:00 -0700
Message-ID: <200705080006.l48060o4009138@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967376AbXEHAGc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: mark tt-mode code for future removal
has been removed from the -mm tree.  Its filename was
     uml-mark-tt-mode-code-for-future-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 4 insertions(+), 12 deletions(-)

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
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch

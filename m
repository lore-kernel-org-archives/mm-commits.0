From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-um.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:17 -0800
Message-ID: <200702122248.l1CMmHd6013999@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45503 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030380AbXBLWsU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, blaisorblade@yahoo.it, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: um
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-um.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: um
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/user_util.h |    2 +-
 arch/um/kernel/um_arch.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/include/user_util.h~dynamic-kernel-command-line-um arch/um/include/user_util.h
--- a/arch/um/include/user_util.h~dynamic-kernel-command-line-um
+++ a/arch/um/include/user_util.h
@@ -38,7 +38,7 @@ extern unsigned long long highmem;
 
 extern char host_info[];
 
-extern char saved_command_line[];
+extern char __initdata boot_command_line[];
 
 extern unsigned long _stext, _etext, _sdata, _edata, __bss_start, _end;
 extern unsigned long _unprotected_end;
diff -puN arch/um/kernel/um_arch.c~dynamic-kernel-command-line-um arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~dynamic-kernel-command-line-um
+++ a/arch/um/kernel/um_arch.c
@@ -481,7 +481,7 @@ void __init setup_arch(char **cmdline_p)
 	atomic_notifier_chain_register(&panic_notifier_list,
 			&panic_exit_notifier);
 	paging_init();
-        strlcpy(saved_command_line, command_line, COMMAND_LINE_SIZE);
+	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
  	*cmdline_p = command_line;
 	setup_hostinfo();
 }
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch

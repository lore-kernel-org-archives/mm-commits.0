From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-m68k.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:47:55 -0800
Message-ID: <200702122247.l1CMltiP013951@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45440 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030360AbXBLWsA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: m68k
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-m68k.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: m68k
From: Alon Bar-Lev <alon.barlev@gmail.com>

Rename saved_command_line into boot_command_line.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/m68k/kernel/setup.c~dynamic-kernel-command-line-m68k arch/m68k/kernel/setup.c
--- a/arch/m68k/kernel/setup.c~dynamic-kernel-command-line-m68k
+++ a/arch/m68k/kernel/setup.c
@@ -256,7 +256,7 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.brk = (unsigned long) &_end;
 
 	*cmdline_p = m68k_command_line;
-	memcpy(saved_command_line, *cmdline_p, CL_SIZE);
+	memcpy(boot_command_line, *cmdline_p, CL_SIZE);
 
 	/* Parse the command line for arch-specific options.
 	 * For the m68k, this is currently only "debug=xxx" to enable printing
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch

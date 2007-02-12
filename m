From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-alpha.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:47:35 -0800
Message-ID: <200702122247.l1CMlZBo013915@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45406 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030346AbXBLWru (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:47:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: alpha
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-alpha.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: alpha
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/alpha/kernel/setup.c~dynamic-kernel-command-line-alpha arch/alpha/kernel/setup.c
--- a/arch/alpha/kernel/setup.c~dynamic-kernel-command-line-alpha
+++ a/arch/alpha/kernel/setup.c
@@ -122,7 +122,7 @@ static void get_sysnames(unsigned long, 
 			 char **, char **);
 static void determine_cpu_caches (unsigned int);
 
-static char command_line[COMMAND_LINE_SIZE];
+static char __initdata command_line[COMMAND_LINE_SIZE];
 
 /*
  * The format of "screen_info" is strange, and due to early
@@ -547,7 +547,7 @@ setup_arch(char **cmdline_p)
 	} else {
 		strlcpy(command_line, COMMAND_LINE, sizeof command_line);
 	}
-	strcpy(saved_command_line, command_line);
+	strcpy(boot_command_line, command_line);
 	*cmdline_p = command_line;
 
 	/* 
@@ -589,7 +589,7 @@ setup_arch(char **cmdline_p)
 	}
 
 	/* Replace the command line, now that we've killed it with strsep.  */
-	strcpy(command_line, saved_command_line);
+	strcpy(command_line, boot_command_line);
 
 	/* If we want SRM console printk echoing early, do it now. */
 	if (alpha_using_srm && srmcons_output) {
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch

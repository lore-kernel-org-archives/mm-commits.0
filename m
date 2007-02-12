From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-v850.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:19 -0800
Message-ID: <200702122248.l1CMmJja014002@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45509 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030381AbXBLWsW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, uclinux-v850@lsi.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: v850
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-v850.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: v850
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Miles Bader <uclinux-v850@lsi.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/v850/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/v850/kernel/setup.c~dynamic-kernel-command-line-v850 arch/v850/kernel/setup.c
--- a/arch/v850/kernel/setup.c~dynamic-kernel-command-line-v850
+++ a/arch/v850/kernel/setup.c
@@ -42,7 +42,7 @@ extern char _root_fs_image_start __attri
 extern char _root_fs_image_end __attribute__ ((__weak__));
 
 
-char command_line[COMMAND_LINE_SIZE];
+char __initdata command_line[COMMAND_LINE_SIZE];
 
 /* Memory not used by the kernel.  */
 static unsigned long total_ram_pages;
@@ -64,8 +64,8 @@ void __init setup_arch (char **cmdline)
 {
 	/* Keep a copy of command line */
 	*cmdline = command_line;
-	memcpy (saved_command_line, command_line, COMMAND_LINE_SIZE);
-	saved_command_line[COMMAND_LINE_SIZE - 1] = '\0';
+	memcpy (boot_command_line, command_line, COMMAND_LINE_SIZE);
+	boot_command_line[COMMAND_LINE_SIZE - 1] = '\0';
 
 	console_verbose ();
 
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch

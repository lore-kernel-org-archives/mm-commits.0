From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-s390.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:07 -0800
Message-ID: <200702122248.l1CMm7Zn013976@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46201 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030455AbXBLW6t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:58:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: s390
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-s390.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: s390
From: Alon Bar-Lev <alon.barlev@gmail.com>

Rename saved_command_line into boot_command_line.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/s390/kernel/setup.c~dynamic-kernel-command-line-s390 arch/s390/kernel/setup.c
--- a/arch/s390/kernel/setup.c~dynamic-kernel-command-line-s390
+++ a/arch/s390/kernel/setup.c
@@ -740,7 +740,7 @@ setup_arch(char **cmdline_p)
 #endif /* CONFIG_64BIT */
 
 	/* Save unparsed command line copy for /proc/cmdline */
-	strlcpy(saved_command_line, COMMAND_LINE, COMMAND_LINE_SIZE);
+	strlcpy(boot_command_line, COMMAND_LINE, COMMAND_LINE_SIZE);
 
 	*cmdline_p = COMMAND_LINE;
 	*(*cmdline_p + COMMAND_LINE_SIZE - 1) = '\0';
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch

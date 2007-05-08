From: akpm@linux-foundation.org
Subject: - uml-print-coredump-limits.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:02 -0700
Message-ID: <200705080006.l48062P8009145@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967380AbXEHAGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: print coredump limits
has been removed from the -mm tree.  Its filename was
     uml-print-coredump-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: print coredump limits
From: Jeff Dike <jdike@addtoit.com>

Print out core dump limits at boot time.  This is to allow core dumps
to be collected if something goes very wrong and to tell if a core
dump isn't going to happen because of a resource limit.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/start_up.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN arch/um/os-Linux/start_up.c~uml-print-coredump-limits arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-print-coredump-limits
+++ a/arch/um/os-Linux/start_up.c
@@ -17,6 +17,7 @@
 #include <sys/time.h>
 #include <sys/wait.h>
 #include <sys/mman.h>
+#include <sys/resource.h>
 #include <asm/unistd.h>
 #include <asm/page.h>
 #include <sys/types.h>
@@ -329,8 +330,32 @@ static void __init check_ptrace(void)
 
 extern void check_tmpexec(void);
 
+static void check_coredump_limit(void)
+{
+	struct rlimit lim;
+	int err = getrlimit(RLIMIT_CORE, &lim);
+
+	if(err){
+		perror("Getting core dump limit");
+		return;
+	}
+
+	printf("Core dump limits :\n\tsoft - ");
+	if(lim.rlim_cur == RLIM_INFINITY)
+		printf("NONE\n");
+	else printf("%lu\n", lim.rlim_cur);
+
+	printf("\thard - ");
+	if(lim.rlim_max == RLIM_INFINITY)
+		printf("NONE\n");
+	else printf("%lu\n", lim.rlim_max);
+}
+
 void os_early_checks(void)
 {
+	/* Print out the core dump limits early */
+	check_coredump_limit();
+
 	check_ptrace();
 
 	/* Need to check this early because mmapping happens before the
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch

From: akpm@linux-foundation.org
Subject: + uml-print-coredump-limits.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:23:45 -0800
Message-ID: <200703070123.l271Nj9B015410@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161130AbXCGBXs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:23:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: print coredump limits
has been added to the -mm tree.  Its filename is
     uml-print-coredump-limits.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 25 insertions(+)

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

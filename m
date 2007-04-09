From: akpm@linux-foundation.org
Subject: + uml-remove-unused-x86_64-code.patch added to -mm tree
Date: Mon, 09 Apr 2007 13:44:30 -0700
Message-ID: <200704092044.l39KiURL022977@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59604 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965085AbXDIUoh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 16:44:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: remove unused x86_64 code
has been added to the -mm tree.  Its filename is
     uml-remove-unused-x86_64-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: remove unused x86_64 code
From: Jeff Dike <jdike@addtoit.com>

It turns out that essentially none of the x86_64 bugs.c is needed.  So, we can
delete most of it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-x86_64/bugs.c |   69 ------------------------------------
 1 files changed, 69 deletions(-)

diff -puN arch/um/sys-x86_64/bugs.c~uml-remove-unused-x86_64-code arch/um/sys-x86_64/bugs.c
--- a/arch/um/sys-x86_64/bugs.c~uml-remove-unused-x86_64-code
+++ a/arch/um/sys-x86_64/bugs.c
@@ -4,12 +4,7 @@
  * Licensed under the GPL
  */
 
-#include "linux/sched.h"
-#include "linux/errno.h"
-#include "asm/system.h"
-#include "asm/pda.h"
 #include "sysdep/ptrace.h"
-#include "os.h"
 
 void arch_init_thread(void)
 {
@@ -23,67 +18,3 @@ int arch_handle_signal(int sig, union um
 {
 	return 0;
 }
-
-#define MAXTOKEN 64
-
-/* Set during early boot */
-int host_has_cmov = 1;
-int host_has_xmm = 0;
-
-static char token(int fd, char *buf, int len, char stop)
-{
-	int n;
-	char *ptr, *end, c;
-
-	ptr = buf;
-	end = &buf[len];
-	do {
-		n = os_read_file(fd, ptr, sizeof(*ptr));
-		c = *ptr++;
-		if(n != sizeof(*ptr)){
-			if(n == 0)
-				return 0;
-			printk("Reading /proc/cpuinfo failed, err = %d\n", -n);
-			if(n < 0)
-				return n;
-			else return -EIO;
-		}
-	} while((c != '\n') && (c != stop) && (ptr < end));
-
-	if(ptr == end){
-		printk("Failed to find '%c' in /proc/cpuinfo\n", stop);
-		return -1;
-	}
-	*(ptr - 1) = '\0';
-	return c;
-}
-
-static int find_cpuinfo_line(int fd, char *key, char *scratch, int len)
-{
-	int n;
-	char c;
-
-	scratch[len - 1] = '\0';
-	while(1){
-		c = token(fd, scratch, len - 1, ':');
-		if(c <= 0)
-			return 0;
-		else if(c != ':'){
-			printk("Failed to find ':' in /proc/cpuinfo\n");
-			return 0;
-		}
-
-		if(!strncmp(scratch, key, strlen(key)))
-			return 1;
-
-		do {
-			n = os_read_file(fd, &c, sizeof(c));
-			if(n != sizeof(c)){
-				printk("Failed to find newline in "
-				       "/proc/cpuinfo, err = %d\n", -n);
-				return 0;
-			}
-		} while(c != '\n');
-	}
-	return 0;
-}
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-tidy-processc-fix.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
uml-tidy-fault-code.patch
uml-kernel-segfaults-should-dump-proper-registers.patch
uml-comment-early-boot-locking.patch
uml-irq-locking-commentary.patch
uml-delete-host_frame_size.patch
uml-drivers-get-release-methods.patch
uml-dump-registers-on-ptrace-or-wait-failure.patch
uml-speed-up-page-table-walking.patch
uml-remove-unused-x86_64-code.patch
uml-start-fixing-os_read_file-and-os_write_file.patch
uml-tidy-libc-code.patch
uml-convert-libc-layer-to-call-read-and-write.patch
sys_futex64-allows-64bit-futexes-workaround-for-uml.patch
utrace-uml-make-uml-compile-with-utrace-enabled.patch

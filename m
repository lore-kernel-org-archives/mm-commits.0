From: akpm@linux-foundation.org
Subject: - uml-remove-unused-x86_64-code.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:03 -0700
Message-ID: <200705080007.l48073IR009248@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966416AbXEHALp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:11:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove unused x86_64 code
has been removed from the -mm tree.  Its filename was
     uml-remove-unused-x86_64-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 69 deletions(-)

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

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch

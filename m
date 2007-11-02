From: akpm@linux-foundation.org
Subject: + i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch added to -mm tree
Date: Fri, 02 Nov 2007 14:17:55 -0700
Message-ID: <200711022117.lA2LHtwQ011399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49496 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410AbXKBVSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 17:18:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bradjsmith@btinternet.com, frank@tuxrocks.com, jeff@garzik.org


The patch titled
     I8K: allow i8k driver to be built on x86_64 systems
has been added to the -mm tree.  Its filename is
     i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: I8K: allow i8k driver to be built on x86_64 systems
From: Bradley Smith <bradjsmith@btinternet.com>

Adds #if clause and additional inline assembly so that the driver
builds on x86_64 systems.

Signed-off-by: Bradley Smith <bradjsmith@btinternet.com>
Cc: Frank Sorenson <frank@tuxrocks.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/i8k.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff -puN drivers/char/i8k.c~i8k-allow-i8k-driver-to-be-built-on-x86_64-systems drivers/char/i8k.c
--- a/drivers/char/i8k.c~i8k-allow-i8k-driver-to-be-built-on-x86_64-systems
+++ a/drivers/char/i8k.c
@@ -113,6 +113,33 @@ static int i8k_smm(struct smm_regs *regs
 	int rc;
 	int eax = regs->eax;
 
+#if defined(CONFIG_X86_64)
+	asm("pushq %%rax\n\t"
+		"movl 0(%%rax),%%edx\n\t"
+		"pushq %%rdx\n\t"
+		"movl 4(%%rax),%%ebx\n\t"
+		"movl 8(%%rax),%%ecx\n\t"
+		"movl 12(%%rax),%%edx\n\t"
+		"movl 16(%%rax),%%esi\n\t"
+		"movl 20(%%rax),%%edi\n\t"
+		"popq %%rax\n\t"
+		"out %%al,$0xb2\n\t"
+		"out %%al,$0x84\n\t"
+		"xchgq %%rax,(%%rsp)\n\t"
+		"movl %%ebx,4(%%rax)\n\t"
+		"movl %%ecx,8(%%rax)\n\t"
+		"movl %%edx,12(%%rax)\n\t"
+		"movl %%esi,16(%%rax)\n\t"
+		"movl %%edi,20(%%rax)\n\t"
+		"popq %%rdx\n\t"
+		"movl %%edx,0(%%rax)\n\t"
+		"lahf\n\t"
+		"shrl $8,%%eax\n\t"
+		"andl $1,%%eax\n"
+		:"=a"(rc)
+		:    "a"(regs)
+		:    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
+#else
 	asm("pushl %%eax\n\t"
 	    "movl 0(%%eax),%%edx\n\t"
 	    "push %%edx\n\t"
@@ -137,7 +164,7 @@ static int i8k_smm(struct smm_regs *regs
 	    "andl $1,%%eax\n":"=a"(rc)
 	    :    "a"(regs)
 	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
-
+#endif
 	if (rc != 0 || (regs->eax & 0xffff) == 0xffff || regs->eax == eax)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from bradjsmith@btinternet.com are

i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
i8k-inspiron-e1705-fix.patch

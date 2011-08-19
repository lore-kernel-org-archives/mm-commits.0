From: akpm@linux-foundation.org
Subject: + kdump-add-size-to-elfcorehdr-kernel-parameter.patch added to -mm tree
Date: Fri, 19 Aug 2011 15:06:08 -0700
Message-ID: <201108192206.p7JM68E1027690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295Ab1HSWGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Aug 2011 18:06:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holzheu@linux.vnet.ibm.com, schwidefsky@de.ibm.com, vgoyal@redhat.com


The patch titled
     kdump: add size to elfcorehdr kernel parameter
has been added to the -mm tree.  Its filename is
     kdump-add-size-to-elfcorehdr-kernel-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kdump: add size to elfcorehdr kernel parameter
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Currently only the address of the pre-allocated ELF header is passed with
the elfcorehdr= kernel parameter.  In order to reserve memory for the
header in the 2nd kernel also the size is required.  Current kdump
architecture backends use different methods to do that, e.g.  x86 uses the
memmap= kernel parameter.  On s390 there is no easy way to transfer this
information.  Therefore the elfcorehdr kernel parameter is extended to
also pass the size.  This now can also be used as standard mechanism by
all future kdump architecture backends.

The syntax of the kernel parameter is extended as follows:

elfcorehdr=[size[KMG]@]offset[KMG]

This change is backward compatible because elfcorehdr=size is still allowed.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 +++---
 include/linux/crash_dump.h          |    1 +
 kernel/crash_dump.c                 |   11 +++++++++++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff -puN Documentation/kernel-parameters.txt~kdump-add-size-to-elfcorehdr-kernel-parameter Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~kdump-add-size-to-elfcorehdr-kernel-parameter
+++ a/Documentation/kernel-parameters.txt
@@ -741,10 +741,10 @@ bytes respectively. Such letter suffixes
 			See Documentation/block/as-iosched.txt and
 			Documentation/block/deadline-iosched.txt for details.
 
-	elfcorehdr=	[IA-64,PPC,SH,X86]
+	elfcorehdr=[size[KMG]@]offset[KMG] [IA64,PPC,SH,X86,S390]
 			Specifies physical address of start of kernel core
-			image elf header. Generally kexec loader will
-			pass this option to capture kernel.
+			image elf header and optionally the size. Generally
+			kexec loader will pass this option to capture kernel.
 			See Documentation/kdump/kdump.txt for details.
 
 	enable_mtrr_cleanup [X86]
diff -puN include/linux/crash_dump.h~kdump-add-size-to-elfcorehdr-kernel-parameter include/linux/crash_dump.h
--- a/include/linux/crash_dump.h~kdump-add-size-to-elfcorehdr-kernel-parameter
+++ a/include/linux/crash_dump.h
@@ -10,6 +10,7 @@
 #define ELFCORE_ADDR_ERR	(-2ULL)
 
 extern unsigned long long elfcorehdr_addr;
+extern unsigned long long elfcorehdr_size;
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
diff -puN kernel/crash_dump.c~kdump-add-size-to-elfcorehdr-kernel-parameter kernel/crash_dump.c
--- a/kernel/crash_dump.c~kdump-add-size-to-elfcorehdr-kernel-parameter
+++ a/kernel/crash_dump.c
@@ -20,8 +20,15 @@ unsigned long saved_max_pfn;
 unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
 
 /*
+ * stores the size of elf header of crash image
+ */
+unsigned long long elfcorehdr_size;
+
+/*
  * elfcorehdr= specifies the location of elf core header stored by the crashed
  * kernel. This option will be passed by kexec loader to the capture kernel.
+ *
+ * Syntax: elfcorehdr=[size[KMG]@]offset[KMG]
  */
 static int __init setup_elfcorehdr(char *arg)
 {
@@ -29,6 +36,10 @@ static int __init setup_elfcorehdr(char 
 	if (!arg)
 		return -EINVAL;
 	elfcorehdr_addr = memparse(arg, &end);
+	if (*end == '@') {
+		elfcorehdr_size = elfcorehdr_addr;
+		elfcorehdr_addr = memparse(end + 1, &end);
+	}
 	return end > arg ? 0 : -EINVAL;
 }
 early_param("elfcorehdr", setup_elfcorehdr);
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

kdump-add-kexec_crash_control_memory_limit.patch
kdump-add-size-to-elfcorehdr-kernel-parameter.patch


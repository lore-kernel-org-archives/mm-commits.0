From: akpm@linux-foundation.org
Subject: + uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch added to -mm tree
Date: Mon, 06 Aug 2007 12:50:17 -0700
Message-ID: <200708061950.l76JoH2G011786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56366 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757501AbXHFTu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 15:50:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: fix an IPV6 libc vs kernel symbol clash
has been added to the -mm tree.  Its filename is
     uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix an IPV6 libc vs kernel symbol clash
From: Jeff Dike <jdike@addtoit.com>

On some systems, with IPV6 configured, there is a clash between the kernel's
in6addr_any and the one in libc.

This is handled in the usual (gross) way of defining the kernel symbol out of
the way on the gcc command line.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/um/Makefile~uml-fix-an-ipv6-libc-vs-kernel-symbol-clash arch/um/Makefile
--- a/arch/um/Makefile~uml-fix-an-ipv6-libc-vs-kernel-symbol-clash
+++ a/arch/um/Makefile
@@ -60,7 +60,8 @@ SYS_DIR		:= $(ARCH_DIR)/include/sysdep-$
 
 CFLAGS += $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\"	\
 	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
-	-Din6addr_loopback=kernel_in6addr_loopback
+	-Din6addr_loopback=kernel_in6addr_loopback \
+	-Din6addr_any=kernel_in6addr_any
 
 AFLAGS += $(ARCH_INCLUDE)
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch

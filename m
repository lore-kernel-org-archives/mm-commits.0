From: akpm@linux-foundation.org
Subject: - uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:37:00 -0700
Message-ID: <200710162037.l9GKb0eb015243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39027 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935105AbXJPVHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix an IPV6 libc vs kernel symbol clash
has been removed from the -mm tree.  Its filename was
     uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch

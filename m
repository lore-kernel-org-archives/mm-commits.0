From: akpm@linux-foundation.org
Subject: [merged] um-fix-strrchr-problems.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:36:02 -0700
Message-ID: <201109151936.p8FJa2Co011171@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:10318 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934606Ab1IOTgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:36:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ftp.linux.org.uk, jdike@addtoit.com, richard@nod.at, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     um: fix strrchr() problems
has been removed from the -mm tree.  Its filename was
     um-fix-strrchr-problems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: fix strrchr() problems
From: Al Viro <viro@ftp.linux.org.uk>

richard@nod.at:
Fixes:
/usr/lib/gcc/x86_64-linux-gnu/4.4.5/../../../../lib/libc.a(strrchr.o): In function `rindex':
(.text+0x0): multiple definition of `strrchr'

If both STATIC_LINK and UML_NET_VDE are set to "y" libc's strrchr may
clash with the kernel implementation.

This workaround comes originally from Jeff Dike:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=494995#35

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/Makefile~um-fix-strrchr-problems arch/um/Makefile
--- a/arch/um/Makefile~um-fix-strrchr-problems
+++ a/arch/um/Makefile
@@ -41,7 +41,7 @@ KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_D
 KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\" \
 	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
 	-Din6addr_loopback=kernel_in6addr_loopback \
-	-Din6addr_any=kernel_in6addr_any
+	-Din6addr_any=kernel_in6addr_any -Dstrrchr=kernel_strrchr
 
 KBUILD_AFLAGS += $(ARCH_INCLUDE)
 
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

origin.patch
slab-leaks3-default-y.patch


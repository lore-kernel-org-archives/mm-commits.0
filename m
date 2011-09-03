From: akpm@linux-foundation.org
Subject: + um-fix-strrchr-problems.patch added to -mm tree
Date: Fri, 02 Sep 2011 17:16:26 -0700
Message-ID: <201109030016.p830GQqS018813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633Ab1ICAQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2011 20:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, jdike@addtoit.com, richard@nod.at, viro@zeniv.linux.org.uk


The patch titled
     um: fix strrchr() problems
has been added to the -mm tree.  Its filename is
     um-fix-strrchr-problems.patch

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

um-fix-oopsable-race-in-line_close.patch
um-winch_interrupt-can-happen-inside-of-free_winch.patch
um-fix-free_winch-mess.patch
um-ptrace_etfpxregs-had-been-wired-on-the-wrong-subarch.patch
um-clean-arch_ptrace-up-a-bit.patch
um-fix-strrchr-problems.patch
slab-leaks3-default-y.patch


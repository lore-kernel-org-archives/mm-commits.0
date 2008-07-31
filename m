From: akpm@linux-foundation.org
Subject: + uml-fix-missing-posix_typesh.patch added to -mm tree
Date: Thu, 31 Jul 2008 10:17:30 -0700
Message-ID: <200807311717.m6VHHUR8002261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755838AbYGaRRz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 13:17:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@addtoit.com, sam@ravnborg.org, wangcong@zeuux.org


The patch titled
     UML: fix missing posix_types.h
has been added to the -mm tree.  Its filename is
     uml-fix-missing-posix_typesh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: UML: fix missing posix_types.h
From: WANG Cong <xiyou.wangcong@gmail.com>

When building UML with 'O=foo' specified, I got:

CC      kernel/bounds.s
  In file included from
/home/wangcong/Projects/linux-2.6/include/linux/types.h:11,
                 from
/home/wangcong/Projects/linux-2.6/include/linux/page-flags.h:8,
                 from
/home/wangcong/Projects/linux-2.6/kernel/bounds.c:9:
/home/wangcong/Projects/linux-2.6/include/linux/posix_types.h:47:29:
error: asm/posix_types.h: No such file or directory
In file included from
/home/wangcong/Projects/linux-2.6/include/linux/page-flags.h:8,
                 from
/home/wangcong/Projects/linux-2.6/kernel/bounds.c:9:
/home/wangcong/Projects/linux-2.6/include/linux/types.h:12:23: error:
asm/types.h: No such file or directory
In file included from
/home/wangcong/Projects/linux-2.6/include/linux/page-flags.h:8,

Below patch fixed it, note, it is only tested for x86 and um.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Makefile~uml-fix-missing-posix_typesh Makefile
--- a/Makefile~uml-fix-missing-posix_typesh
+++ a/Makefile
@@ -931,7 +931,8 @@ ifneq ($(KBUILD_SRC),)
 		/bin/false; \
 	fi;
 	$(Q)if [ ! -d include2 ]; then mkdir -p include2; fi;
-	$(Q)if [ -e $(srctree)/include/asm-$(SRCARCH)/system.h ]; then  \
+	$(Q)if [ -e $(srctree)/include/asm-$(SRCARCH)/system.h -o \
+		 -e $(objtree)/include/asm-$(SRCARCH)/system.h ] ; then \
 	    ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
 	    fi
 endif
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
uml-fix-missing-posix_typesh.patch


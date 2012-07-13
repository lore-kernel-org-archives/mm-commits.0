From: akpm@linux-foundation.org
Subject: + mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:17:21 -0700
Message-ID: <20120713211722.44C035C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:50051 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab2GMVRZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:17:25 -0400
Received: by bkcjc3 with SMTP id jc3so205223bkc.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:17:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, dhowells@redhat.com, tony@bakeyournoodle.com, yasutake.koichi@jp.panasonic.com


The patch titled
     Subject: mn10300: only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it
has been added to the -mm tree.  Its filename is
     mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mn10300: only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it

It seems the current (gcc 4.6.3) no longer provides this so make it
conditional.

As reported by Tony before, the mn10300 architecture cross-compiles with
gcc-4.6.3 if -mmem-funcs is not added to KBUILD_CFLAGS.

Reported-by: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mn10300/Makefile~mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it arch/mn10300/Makefile
--- a/arch/mn10300/Makefile~mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it
+++ a/arch/mn10300/Makefile
@@ -26,7 +26,7 @@ CHECKFLAGS	+=
 PROCESSOR	:= unset
 UNIT		:= unset
 
-KBUILD_CFLAGS	+= -mam33 -mmem-funcs -DCPU=AM33
+KBUILD_CFLAGS	+= -mam33 -DCPU=AM33 $(call cc-option,-mmem-funcs,)
 KBUILD_AFLAGS	+= -mam33 -DCPU=AM33
 
 ifeq ($(CONFIG_MN10300_CURRENT_IN_E2),y)
_
Subject: Subject: mn10300: only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it.patch
frv-kill-used-but-uninitialized-variable.patch


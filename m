From: akpm@linux-foundation.org
Subject: [merged] mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:11:52 -0700
Message-ID: <20121005201153.46C8D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:52982 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab2JEULz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:11:55 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so98776lah.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:11:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dhowells@redhat.com, stable@vger.kernel.org, tony@bakeyournoodle.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it
has been removed from the -mm tree.  Its filename was
     mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <stable@vger.kernel.org>
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

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
cris-fix-i-o-macros.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch


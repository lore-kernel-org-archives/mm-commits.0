From: akpm@linux-foundation.org
Subject: + xtensa-use-test-e-instead-of-bashism-test-a.patch added to -mm tree
Date: Mon, 11 Jun 2012 15:16:14 -0700
Message-ID: <20120611221615.17CB3A026F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:60561 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854Ab2FKWQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2012 18:16:17 -0400
Received: by lagr15 with SMTP id r15so251378lag.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 15:16:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, chris@zankel.net


The patch titled
     Subject: xtensa: use "test -e" instead of bashism "test -a"
has been added to the -mm tree.  Its filename is
     xtensa-use-test-e-instead-of-bashism-test-a.patch

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
Subject: xtensa: use "test -e" instead of bashism "test -a"

On Ubuntu, /bin/sh is a symlink to dash, which does not support "test -a".
This causes messages like

    test: 1: -a: unexpected operator
    test: 1: -a: unexpected operator

and link failures like

    (.init.text+0x132): undefined reference to `platform_init'

due to the appropriate platform code not being compiled.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/xtensa/Makefile~xtensa-use-test-e-instead-of-bashism-test-a arch/xtensa/Makefile
--- a/arch/xtensa/Makefile~xtensa-use-test-e-instead-of-bashism-test-a
+++ a/arch/xtensa/Makefile
@@ -68,8 +68,8 @@ endif
 
 # Only build variant and/or platform if it includes a Makefile
 
-buildvar := $(shell test -a $(srctree)/arch/xtensa/variants/$(VARIANT)/Makefile && echo arch/xtensa/variants/$(VARIANT)/)
-buildplf := $(shell test -a $(srctree)/arch/xtensa/platforms/$(PLATFORM)/Makefile && echo arch/xtensa/platforms/$(PLATFORM)/)
+buildvar := $(shell test -e $(srctree)/arch/xtensa/variants/$(VARIANT)/Makefile && echo arch/xtensa/variants/$(VARIANT)/)
+buildplf := $(shell test -e $(srctree)/arch/xtensa/platforms/$(PLATFORM)/Makefile && echo arch/xtensa/platforms/$(PLATFORM)/)
 
 # Find libgcc.a
 
_
Subject: Subject: xtensa: use "test -e" instead of bashism "test -a"

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
xtensa-replace-xtensa-specific-_fdatatext-by-_sdatatext.patch
xtensa-use-test-e-instead-of-bashism-test-a.patch
xtensa-use-the-declarations-provided-by-asm-sectionsh.patch


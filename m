From: akpm@linux-foundation.org
Subject: + x86-fix-cc1-options-to-disable-fpie-when-compiling-with-config_cc_stackprotector=y.patch added to -mm tree
Date: Mon, 13 Sep 2010 15:48:46 -0700
Message-ID: <201009132248.o8DMmkGI025713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141Ab0IMWtN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 18:49:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: basile@opensource.dyc.edu, anarchy@gentoo.org, hpa@zytor.com, mail@cleeus.de, mingo@elte.hu, mmarek@suse.cz, tglx@linutronix.de, zorry@gentoo.org


The patch titled
     x86: fix cc1 options to disable -fPIE when compiling with CONFIG_CC_STACKPROTECTOR=y
has been added to the -mm tree.  Its filename is
     x86-fix-cc1-options-to-disable-fpie-when-compiling-with-config_cc_stackprotector=y.patch

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
Subject: x86: fix cc1 options to disable -fPIE when compiling with CONFIG_CC_STACKPROTECTOR=y
From: Anthony G. Basile <basile@opensource.dyc.edu>

The arch/x86/Makefile uses scripts/gcc-x86_$(BITS)-has-stack-protector.sh
to check if cc1 supports -fstack-protector.  When -fPIE is passed to cc1,
these scripts fail causing stack protection to be disabled even when it
is available.

This fix is similar to commit c47efe5548abbf ("kbuild: fix cc1 options
check to ensure we do not use -fPIC when compiling").

Reported-by: Kai Dietrich <mail@cleeus.de>
Signed-off-by: Magnus Granberg <zorry@gentoo.org>
Signed-off-by: Anthony G. Basile <basile@opensource.dyc.edu>
Cc: Jory A. Pratt <anarchy@gentoo.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/Makefile~x86-fix-cc1-options-to-disable-fpie-when-compiling-with-config_cc_stackprotector=y arch/x86/Makefile
--- a/arch/x86/Makefile~x86-fix-cc1-options-to-disable-fpie-when-compiling-with-config_cc_stackprotector=y
+++ a/arch/x86/Makefile
@@ -74,7 +74,7 @@ endif
 
 ifdef CONFIG_CC_STACKPROTECTOR
 	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
-        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(biarch)),y)
+        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
                 stackp-y := -fstack-protector
                 KBUILD_CFLAGS += $(stackp-y)
         else
_

Patches currently in -mm which might be from basile@opensource.dyc.edu are

x86-fix-cc1-options-to-disable-fpie-when-compiling-with-config_cc_stackprotector=y.patch


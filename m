From: akpm@linux-foundation.org
Subject: +
 makefile-move-stack-protector-compiler-breakage-test-earlier.patch added to -mm tree
Date: Tue, 21 Nov 2017 15:36:24 -0800
Message-ID: <5a14b878.TVZ6ljEl65LdLlVP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40692 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbdKUXg0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 18:36:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, arnd@arndb.de, josh@joshtriplett.org, labbott@redhat.com, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Makefile: move stack-protector compiler breakage test earlier
has been added to the -mm tree.  Its filename is
     makefile-move-stack-protector-compiler-breakage-test-earlier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/makefile-move-stack-protector-compiler-breakage-test-earlier.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/makefile-move-stack-protector-compiler-breakage-test-earlier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: Makefile: move stack-protector compiler breakage test earlier

In order to make stack-protector failures warn instead of unconditionally
breaking the build, this moves the compiler output sanity-check earlier,
and sets a flag for later testing.  Future patches can choose to warn or
fail, depending on the flag value.

Link: http://lkml.kernel.org/r/1510076320-69931-2-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Laura Abbott <labbott@redhat.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN Makefile~makefile-move-stack-protector-compiler-breakage-test-earlier Makefile
--- a/Makefile~makefile-move-stack-protector-compiler-breakage-test-earlier
+++ a/Makefile
@@ -681,6 +681,12 @@ endif
 ifdef CONFIG_CC_STACKPROTECTOR
   stackp-path := $(srctree)/scripts/gcc-$(SRCARCH)_$(BITS)-has-stack-protector.sh
   stackp-check := $(wildcard $(stackp-path))
+  # If the wildcard test matches a test script, run it to check functionality.
+  ifdef stackp-check
+    ifneq ($(shell $(CONFIG_SHELL) $(stackp-check) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
+      stackp-broken := y
+    endif
+  endif
 endif
 KBUILD_CFLAGS += $(stackp-flag)
 
@@ -1089,11 +1095,9 @@ ifdef stackp-name
   endif
 endif
 # Make sure compiler does not have buggy stack-protector support.
-ifdef stackp-check
-  ifneq ($(shell $(CONFIG_SHELL) $(stackp-check) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
+ifdef stackp-broken
 	@echo Cannot use CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
                   $(stackp-flag) available but compiler is broken >&2 && exit 1
-  endif
 endif
 	@:
 
_

Patches currently in -mm which might be from keescook@chromium.org are

makefile-move-stack-protector-compiler-breakage-test-earlier.patch
makefile-move-stack-protector-availability-out-of-kconfig.patch
makefile-introduce-config_cc_stackprotector_auto.patch


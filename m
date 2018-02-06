From: akpm@linux-foundation.org
Subject: [patch 028/114] Makefile: move stack-protector compiler
 breakage test earlier
Date: Tue, 06 Feb 2018 15:37:38 -0800
Message-ID: <20180206233738.zaFg16zXw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754019AbeBFXhj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:37:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, josh@joshtriplett.org, keescook@chromium.org, labbott@redhat.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

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
@@ -696,6 +696,12 @@ endif
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
 
@@ -1098,11 +1104,9 @@ ifdef stackp-name
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

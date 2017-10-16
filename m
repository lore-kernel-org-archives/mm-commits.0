From: akpm@linux-foundation.org
Subject: +
 makefile-fix-empty-flag-results-for-stackprotector-_auto-mode.patch added
 to -mm tree
Date: Mon, 16 Oct 2017 15:21:45 -0700
Message-ID: <59e530f9.RRPdkH7t/N8L4VUZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40674 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752007AbdJPWVq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 18:21:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, robert.jarzmik@free.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: Makefile: fix empty flag results for stackprotector _AUTO mode
has been added to the -mm tree.  Its filename is
     makefile-fix-empty-flag-results-for-stackprotector-_auto-mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/makefile-fix-empty-flag-results-for-stackprotector-_auto-mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/makefile-fix-empty-flag-results-for-stackprotector-_auto-mode.patch

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
Subject: Makefile: fix empty flag results for stackprotector _AUTO mode

If the compiler didn't support any stackprotector mode, the second empty
test would still trip.  This moves it to an "else" test for the non-AUTO
modes.

Link: http://lkml.kernel.org/r/20171016040333.GA82643@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Robert Jarzmik <robert.jarzmik@free.fr>
Tested-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN Makefile~makefile-fix-empty-flag-results-for-stackprotector-_auto-mode Makefile
--- a/Makefile~makefile-fix-empty-flag-results-for-stackprotector-_auto-mode
+++ a/Makefile
@@ -1097,16 +1097,17 @@ PHONY += prepare-compiler-check
 prepare-compiler-check: FORCE
 # Make sure compiler supports requested stack protector flag.
 ifdef stackp-name
-  # Warn about CONFIG_CC_STACKPROTECTOR_AUTO having found no option.
   ifeq ($(stackp-flag),)
+	# Warn about CONFIG_CC_STACKPROTECTOR_AUTO having found no option.
 	@echo CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
 		  Compiler does not support any known stack-protector >&2
-  endif
-  # Fail if specifically requested stack protector is missing.
+  else
   ifeq ($(call cc-option, $(stackp-flag)),)
+	# Fail if specifically requested stack protector is missing.
 	@echo Cannot use CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
 		  $(stackp-flag) not supported by compiler >&2 && exit 1
   endif
+  endif
 endif
 # Make sure compiler does not have buggy stack-protector support.
 ifdef stackp-check
_

Patches currently in -mm which might be from keescook@chromium.org are

sh-boot-add-static-stack-protector-to-pre-kernel.patch
makefile-move-stackprotector-availability-out-of-kconfig.patch
makefile-introduce-config_cc_stackprotector_auto.patch
makefile-introduce-config_cc_stackprotector_auto-fix.patch
makefile-introduce-config_cc_stackprotector_auto-fix-2.patch
makefile-fix-empty-flag-results-for-stackprotector-_auto-mode.patch


From: akpm@linux-foundation.org
Subject: [to-be-updated]
 makefile-introduce-config_cc_stackprotector_auto-fix-3.patch removed from
 -mm tree
Date: Tue, 17 Oct 2017 12:57:12 -0700
Message-ID: <59e66098.R7B0L8Rt8uZSCugK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36754 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760136AbdJQT5N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 15:57:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, robert.jarzmik@free.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: Makefile: fix empty flag results for stackprotector _AUTO mode
has been removed from the -mm tree.  Its filename was
     makefile-introduce-config_cc_stackprotector_auto-fix-3.patch

This patch was dropped because an updated version will be merged

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

diff -puN Makefile~makefile-introduce-config_cc_stackprotector_auto-fix-3 Makefile
--- a/Makefile~makefile-introduce-config_cc_stackprotector_auto-fix-3
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

writeback-convert-timers-to-use-timer_setup.patch


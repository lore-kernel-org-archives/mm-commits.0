From: akpm@linux-foundation.org
Subject: [to-be-updated]
 makefile-introduce-config_cc_stackprotector_auto-fix.patch removed from -mm tree
Date: Tue, 17 Oct 2017 12:57:06 -0700
Message-ID: <59e66092.qiWS7u1CusiCV+Gr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36740 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760136AbdJQT5H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 15:57:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mark.rutland@arm.com, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Makefile: fix CONFIG_CC_STACKPROTECTOR_AUTO to not enable SSP
has been removed from the -mm tree.  Its filename was
     makefile-introduce-config_cc_stackprotector_auto-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: Makefile: fix CONFIG_CC_STACKPROTECTOR_AUTO to not enable SSP

There was a think-o in the logic for CONFIG_CC_STACKPROTECTOR_AUTO, which
would leave CONFIG_CC_STACKPROTECTOR defined when a compiler didn't
support stack-protector.  This usually won't cause a problem with a build,
but it's not correct, and shouldn't happen.

Link: http://lkml.kernel.org/r/20171003183228.GA142273@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN Makefile~makefile-introduce-config_cc_stackprotector_auto-fix Makefile
--- a/Makefile~makefile-introduce-config_cc_stackprotector_auto-fix
+++ a/Makefile
@@ -693,14 +693,18 @@ else
 endif
 endif
 endif
+# If stack-protection was requested (and available, in the case of _AUTO),
+# then prepare the build for it being enabled.
 ifdef stackp-name
-  # If the stack protector has been selected, inform the rest of the build.
+ifneq ($(stackp-flag),)
+  # If the stack protector is active, enable code that depends on it.
   KBUILD_CFLAGS += -DCONFIG_CC_STACKPROTECTOR
   KBUILD_AFLAGS += -DCONFIG_CC_STACKPROTECTOR
   # Find arch-specific stack protector compiler sanity-checking script.
   stackp-path := $(srctree)/scripts/gcc-$(SRCARCH)_$(BITS)-has-stack-protector.sh
   stackp-check := $(wildcard $(stackp-path))
 endif
+endif
 KBUILD_CFLAGS += $(stackp-flag)
 
 ifeq ($(cc-name),clang)
_

Patches currently in -mm which might be from keescook@chromium.org are

writeback-convert-timers-to-use-timer_setup.patch
makefile-introduce-config_cc_stackprotector_auto-fix-2.patch
makefile-introduce-config_cc_stackprotector_auto-fix-3.patch


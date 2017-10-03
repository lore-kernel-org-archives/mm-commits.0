From: akpm@linux-foundation.org
Subject: + makefile-introduce-config_cc_stackprotector_auto-fix.patch
 added to -mm tree
Date: Tue, 03 Oct 2017 14:31:02 -0700
Message-ID: <59d40196./XyfOGcFXnBtH1n5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52434 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751117AbdJCVbD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 17:31:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mark.rutland@arm.com, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Makefile: fix CONFIG_CC_STACKPROTECTOR_AUTO to not enable SSP
has been added to the -mm tree.  Its filename is
     makefile-introduce-config_cc_stackprotector_auto-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/makefile-introduce-config_cc_stackprotector_auto-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/makefile-introduce-config_cc_stackprotector_auto-fix.patch

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

sh-boot-add-static-stack-protector-to-pre-kernel.patch
makefile-move-stackprotector-availability-out-of-kconfig.patch
makefile-introduce-config_cc_stackprotector_auto.patch
makefile-introduce-config_cc_stackprotector_auto-fix.patch


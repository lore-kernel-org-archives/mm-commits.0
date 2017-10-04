From: akpm@linux-foundation.org
Subject: + makefile-introduce-config_cc_stackprotector_auto-fix-2.patch
 added to -mm tree
Date: Wed, 04 Oct 2017 14:59:04 -0700
Message-ID: <59d559a8.7nmbV80nIDilHzZD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44070 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750797AbdJDV7F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 17:59:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: makefile-introduce-config_cc_stackprotector_auto-fix-2
has been added to the -mm tree.  Its filename is
     makefile-introduce-config_cc_stackprotector_auto-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/makefile-introduce-config_cc_stackprotector_auto-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/makefile-introduce-config_cc_stackprotector_auto-fix-2.patch

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
Subject: makefile-introduce-config_cc_stackprotector_auto-fix-2

special-case gcc-4.4.4

Link: http://lkml.kernel.org/r/CAGXu5jLg69y3ic7MbzUqb=SM+miqy2KYxBkrYdx9mq_N+aUicA@mail.gmail.com

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN Makefile~makefile-introduce-config_cc_stackprotector_auto-fix-2 Makefile
--- a/Makefile~makefile-introduce-config_cc_stackprotector_auto-fix-2
+++ a/Makefile
@@ -1107,8 +1107,16 @@ endif
 # Make sure compiler does not have buggy stack-protector support.
 ifdef stackp-check
   ifneq ($(shell $(CONFIG_SHELL) $(stackp-check) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
+    # The stack-protector is known-broken on gcc 4.4. In AUTO mode, this
+    # can just be a warning. Any breakage in other compilers should still
+    # abort the build, as that would be unexpected.
+    ifeq ($(call cc-ifversion, -eq, 0404,$(stackp-name)),AUTO)
+       @echo CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
+                  $(stackp-flag) available but compiler is broken >&2
+    else
 	@echo Cannot use CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
                   $(stackp-flag) available but compiler is broken >&2 && exit 1
+    endif
   endif
 endif
 	@:
_

Patches currently in -mm which might be from keescook@chromium.org are

sh-boot-add-static-stack-protector-to-pre-kernel.patch
makefile-move-stackprotector-availability-out-of-kconfig.patch
makefile-introduce-config_cc_stackprotector_auto.patch
makefile-introduce-config_cc_stackprotector_auto-fix.patch
makefile-introduce-config_cc_stackprotector_auto-fix-2.patch


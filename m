From: akpm@linux-foundation.org
Subject: [to-be-updated]
 makefile-introduce-config_cc_stackprotector_auto-fix-2.patch removed from
 -mm tree
Date: Tue, 17 Oct 2017 12:57:09 -0700
Message-ID: <59e66095.72xF2iTTLIOIiuo3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36748 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760136AbdJQT5K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 15:57:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: makefile-introduce-config_cc_stackprotector_auto-fix-2
has been removed from the -mm tree.  Its filename was
     makefile-introduce-config_cc_stackprotector_auto-fix-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: makefile-introduce-config_cc_stackprotector_auto-fix-2

special-case gcc-4.4.4

Link: http://lkml.kernel.org/r/CAGXu5jLg69y3ic7MbzUqb=SM+miqy2KYxBkrYdx9mq_N+aUicA@mail.gmail.com

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

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
+	@echo CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
+		$(stackp-flag) available but compiler is broken >&2
+    else
 	@echo Cannot use CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
-                  $(stackp-flag) available but compiler is broken >&2 && exit 1
+		$(stackp-flag) available but compiler is broken >&2 && exit 1
+    endif
   endif
 endif
 	@:
_

Patches currently in -mm which might be from keescook@chromium.org are

writeback-convert-timers-to-use-timer_setup.patch
makefile-introduce-config_cc_stackprotector_auto-fix-3.patch


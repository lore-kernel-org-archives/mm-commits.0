From: akpm@linux-foundation.org
Subject: [merged]
 makefile-fix-extra-parenthesis-typo-when-cc_stackprotector_regular-is-enabled.patch removed from -mm tree
Date: Thu, 27 Feb 2014 12:23:56 -0800
Message-ID: <530f9edc.cGv+eSiX/jTSbjZM%akpm__21770.9127617583$1393532648$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaB0UX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 15:23:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, keescook@chromium.org, fathi.boudra@linaro.org

Subject: [merged] makefile-fix-extra-parenthesis-typo-when-cc_stackprotector_regular-is-enabled.patch removed from -mm tree
To: fathi.boudra@linaro.org,keescook@chromium.org,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 12:23:56 -0800


The patch titled
     Subject: Makefile: fix extra parenthesis typo when CC_STACKPROTECTOR_REGULAR is enabled
has been removed from the -mm tree.  Its filename was
     makefile-fix-extra-parenthesis-typo-when-cc_stackprotector_regular-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fathi Boudra <fathi.boudra@linaro.org>
Subject: Makefile: fix extra parenthesis typo when CC_STACKPROTECTOR_REGULAR is enabled

An extra parenthesis typo introduced in 19952a9203 ("stackprotector: Unify
the HAVE_CC_STACKPROTECTOR logic between architectures") is causing the
following error when CONFIG_CC_STACKPROTECTOR_REGULAR is enabled:

Makefile:608: Cannot use CONFIG_CC_STACKPROTECTOR: -fstack-protector not supported by compiler
Makefile:608: *** missing separator.  Stop.

Signed-off-by: Fathi Boudra <fathi.boudra@linaro.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~makefile-fix-extra-parenthesis-typo-when-cc_stackprotector_regular-is-enabled Makefile
--- a/Makefile~makefile-fix-extra-parenthesis-typo-when-cc_stackprotector_regular-is-enabled
+++ a/Makefile
@@ -606,7 +606,7 @@ ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
   stackp-flag := -fstack-protector
   ifeq ($(call cc-option, $(stackp-flag)),)
     $(warning Cannot use CONFIG_CC_STACKPROTECTOR: \
-	      -fstack-protector not supported by compiler))
+             -fstack-protector not supported by compiler)
   endif
 else ifdef CONFIG_CC_STACKPROTECTOR_STRONG
   stackp-flag := -fstack-protector-strong
_

Patches currently in -mm which might be from fathi.boudra@linaro.org are

origin.patch


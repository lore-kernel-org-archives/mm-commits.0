From: akpm@linux-foundation.org
Subject: + lib-add-module-support-to-array-based-sort-tests.patch added to -mm tree
Date: Tue, 28 Feb 2017 15:57:12 -0800
Message-ID: <58b60e58.P032+sSL9bHUPFQV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41786 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbdCAELY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 23:11:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, andriy.shevchenko@linux.intel.com, arnd@arndb.de, paul.gortmaker@windriver.com, shuah@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: add module support to array-based sort tests
has been added to the -mm tree.  Its filename is
     lib-add-module-support-to-array-based-sort-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-module-support-to-array-based-sort-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-module-support-to-array-based-sort-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: lib: add module support to array-based sort tests

Allow to compile the array-based sort test code either to a loadable
module, or builtin into the kernel.

Link: http://lkml.kernel.org/r/1488287219-15832-3-git-send-email-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN lib/Kconfig.debug~lib-add-module-support-to-array-based-sort-tests lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-add-module-support-to-array-based-sort-tests
+++ a/lib/Kconfig.debug
@@ -1727,10 +1727,11 @@ config TEST_LIST_SORT
 	  If unsure, say N.
 
 config TEST_SORT
-	bool "Array-based sort test"
-	depends on DEBUG_KERNEL
+	tristate "Array-based sort test"
+	depends on DEBUG_KERNEL || m
 	help
-	  This option enables the self-test function of 'sort()' at boot.
+	  This option enables the self-test function of 'sort()' at boot,
+	  or at module load time.
 
 	  If unsure, say N.
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

revert-lib-test_sortc-make-it-explicitly-non-modular.patch
lib-add-module-support-to-array-based-sort-tests.patch
lib-add-module-support-to-linked-list-sorting-tests.patch


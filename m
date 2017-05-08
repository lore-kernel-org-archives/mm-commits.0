From: akpm@linux-foundation.org
Subject: [patch 018/114] lib: add module support to array-based
 sort tests
Date: Mon, 08 May 2017 15:55:23 -0700
Message-ID: <20170508225523.VNrjhnRlI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45870 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751243AbdEHWza (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:55:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, arnd@arndb.de, geert@linux-m68k.org, mm-commits@vger.kernel.org, paul.gortmaker@windriver.com, shuah@kernel.org, torvalds@linux-foundation.org

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
@@ -1728,10 +1728,11 @@ config TEST_LIST_SORT
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

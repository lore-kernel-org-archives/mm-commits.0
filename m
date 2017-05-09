From: akpm@linux-foundation.org
Subject: [merged]
 lib-add-module-support-to-array-based-sort-tests.patch removed from -mm
 tree
Date: Tue, 09 May 2017 11:00:55 -0700
Message-ID: <20170509180055.DqA3WXp1l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34286 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752993AbdEISA4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:00:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, arnd@arndb.de, geert@linux-m68k.org, mm-commits@vger.kernel.org, paul.gortmaker@windriver.com, shuah@kernel.org


The patch titled
     Subject: lib: add module support to array-based sort tests
has been removed from the -mm tree.  Its filename was
     lib-add-module-support-to-array-based-sort-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from geert@linux-m68k.org are



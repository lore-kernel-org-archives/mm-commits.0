From: akpm@linux-foundation.org
Subject: + revert-lib-test_sortc-make-it-explicitly-non-modular.patch
 added to -mm tree
Date: Tue, 28 Feb 2017 15:57:10 -0800
Message-ID: <58b60e56.pbMD83e8HTGfg5ZQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38490 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751756AbdB1X6S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 18:58:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, andriy.shevchenko@linux.intel.com, arnd@arndb.de, paul.gortmaker@windriver.com, shuah@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "lib/test_sort.c: make it explicitly non-modular"
has been added to the -mm tree.  Its filename is
     revert-lib-test_sortc-make-it-explicitly-non-modular.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-lib-test_sortc-make-it-explicitly-non-modular.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-lib-test_sortc-make-it-explicitly-non-modular.patch

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
Subject: Revert "lib/test_sort.c: make it explicitly non-modular"

Patch series "lib: add module support to sort tests".

This patch series allows to compile the array-based and linked list sort
test code either to loadable modules, or builtin into the kernel.

It's very valuable to have modular tests, so you can run them just by
insmodding the test modules, instead of needing a separate kernel that
runs them at boot.


This patch (of 3):

This reverts commit 8893f519330bb073a49c5b4676fce4be6f1be15d.

It's very valuable to have modular tests, so you can run them just by
insmodding the test modules, instead of needing a separate kernel that
runs them at boot.

Link: http://lkml.kernel.org/r/1488287219-15832-2-git-send-email-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_sort.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN lib/test_sort.c~revert-lib-test_sortc-make-it-explicitly-non-modular lib/test_sort.c
--- a/lib/test_sort.c~revert-lib-test_sortc-make-it-explicitly-non-modular
+++ a/lib/test_sort.c
@@ -1,11 +1,8 @@
 #include <linux/sort.h>
 #include <linux/slab.h>
-#include <linux/init.h>
+#include <linux/module.h>
 
-/*
- * A simple boot-time regression test
- * License: GPL
- */
+/* a simple boot-time regression test */
 
 #define TEST_LEN 1000
 
@@ -41,4 +38,6 @@ exit:
 	kfree(a);
 	return err;
 }
-subsys_initcall(test_sort_init);
+
+module_init(test_sort_init);
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from geert@linux-m68k.org are

revert-lib-test_sortc-make-it-explicitly-non-modular.patch
lib-add-module-support-to-array-based-sort-tests.patch
lib-add-module-support-to-linked-list-sorting-tests.patch


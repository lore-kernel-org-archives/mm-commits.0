From: akpm@linux-foundation.org
Subject: [patch 017/114] Revert "lib/test_sort.c: make it
 explicitly non-modular"
Date: Mon, 08 May 2017 15:55:20 -0700
Message-ID: <20170508225520.bJHqswK99%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdEHWzW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, arnd@arndb.de, geert@linux-m68k.org, mm-commits@vger.kernel.org, paul.gortmaker@windriver.com, shuah@kernel.org, torvalds@linux-foundation.org

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

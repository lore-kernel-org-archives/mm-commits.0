From: akpm@linux-foundation.org
Subject: [patch 113/124] lib/test_sort.c: make it explicitly non-modular
Date: Fri, 24 Feb 2017 15:01:09 -0800
Message-ID: <58b0bb35.nV4ei1U/EMIGndyZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39180 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751864AbdBXXBL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:01:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, paul.gortmaker@windriver.com, arnd@arndb.de, fkostenzer@live.at

From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: lib/test_sort.c: make it explicitly non-modular

The Kconfig currently controlling compilation of this code is:

     lib/Kconfig.debug:config TEST_SORT
     lib/Kconfig.debug:      bool "Array-based sort test"

...meaning that it currently is not being built as a module by anyone.

Lets remove the couple traces of modular infrastructure use, so that
when reading the code there is no doubt it is builtin-only.

Since module_init translates to device_initcall in the non-modular
case, the init ordering becomes slightly earlier when we change it
to use subsys_initcall as done here.  However, since it is a self
contained test, this shouldn't be an issue and subsys_initcall
seems like a better fit for this particular case.

We also delete the MODULE_LICENSE tag since that information is now
contained at the top of the file in the comments.

Link: http://lkml.kernel.org/r/20170124225608.7319-1-paul.gortmaker@windriver.com
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Kostenzer Felix <fkostenzer@live.at>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_sort.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN lib/test_sort.c~lib-test_sort-make-it-explicitly-non-modular lib/test_sort.c
--- a/lib/test_sort.c~lib-test_sort-make-it-explicitly-non-modular
+++ a/lib/test_sort.c
@@ -1,8 +1,11 @@
 #include <linux/sort.h>
 #include <linux/slab.h>
-#include <linux/module.h>
+#include <linux/init.h>
 
-/* a simple boot-time regression test */
+/*
+ * A simple boot-time regression test
+ * License: GPL
+ */
 
 #define TEST_LEN 1000
 
@@ -38,6 +41,4 @@ exit:
 	kfree(a);
 	return err;
 }

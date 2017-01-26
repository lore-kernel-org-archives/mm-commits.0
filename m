From: akpm@linux-foundation.org
Subject: + lib-test_sort-make-it-explicitly-non-modular.patch added to -mm tree
Date: Wed, 25 Jan 2017 16:59:43 -0800
Message-ID: <588949ff.VWjBa4O8ZzSBPDZt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57536 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751829AbdAZA7o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2017 19:59:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.gortmaker@windriver.com, arnd@arndb.de, fkostenzer@live.at, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_sort.c: make it explicitly non-modular
has been added to the -mm tree.  Its filename is
     lib-test_sort-make-it-explicitly-non-modular.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_sort-make-it-explicitly-non-modular.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_sort-make-it-explicitly-non-modular.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

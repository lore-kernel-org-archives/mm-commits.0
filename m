From: akpm@linux-foundation.org
Subject: + lib-add-module-unload-support-to-sort-tests.patch added to -mm
 tree
Date: Fri, 22 Dec 2017 14:17:19 -0800
Message-ID: <5a3d846f.PDzAWSnNpD0+fyb2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46466 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755458AbdLVWRU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Dec 2017 17:17:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pravin.shedge4linux@gmail.com, andriy.shevchenko@linux.intel.com, fkostenzer@live.at, geert@linux-m68k.org, paul.gortmaker@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_sort.c: add module unload support
has been added to the -mm tree.  Its filename is
     lib-add-module-unload-support-to-sort-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-module-unload-support-to-sort-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-module-unload-support-to-sort-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pravin Shedge <pravin.shedge4linux@gmail.com>
Subject: lib/test_sort.c: add module unload support

test_sort.c performs array-based and linked list sort test.  Code allows
to compile either as a loadable modules or builtin into the kernel.

Current code is not allow to unload the test_sort.ko module after
successful completion.

This patch adds support to unload the "test_sort.ko" module by adding
module_exit support.

Previous patch was implemented auto unload support by returning -EAGAIN
from module_init() function on successful case, but this approach is not
ideal.

The auto-unload might seem like a nice optimization, but it encourages
inconsistent behaviour.  And behaviour that is different from all other
normal modules.

Link: http://lkml.kernel.org/r/1513967133-6843-1-git-send-email-pravin.shedge4linux@gmail.com
Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>
Cc: Kostenzer Felix <fkostenzer@live.at>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_sort.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN lib/test_sort.c~lib-add-module-unload-support-to-sort-tests lib/test_sort.c
--- a/lib/test_sort.c~lib-add-module-unload-support-to-sort-tests
+++ a/lib/test_sort.c
@@ -39,5 +39,11 @@ exit:
 	return err;
 }
 
+static void __exit test_sort_exit(void)
+{
+}
+
 module_init(test_sort_init);
+module_exit(test_sort_exit);
+
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from pravin.shedge4linux@gmail.com are

lib-add-module-unload-support-to-sort-tests.patch
mm-remove-duplicate-includes.patch


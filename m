From: akpm@linux-foundation.org
Subject: + lib-add-config_test_sort-to-enable-self-test-of-sort-fix.patch
 added to -mm tree
Date: Fri, 13 Jan 2017 15:43:14 -0800
Message-ID: <58796612.PC731PTOM9qOr6P2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50418 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbdAMXnP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2017 18:43:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, fkostenzer@live.at, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: move sort self-test into a separate file
has been added to the -mm tree.  Its filename is
     lib-add-config_test_sort-to-enable-self-test-of-sort-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-config_test_sort-to-enable-self-test-of-sort-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-config_test_sort-to-enable-self-test-of-sort-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: lib: move sort self-test into a separate file

The lib/sort.c file gets included in the EFI stub for use outside of the
kernel address space, which now fails due to the addition of a
module_init() function:

00000000 R_ARM_ABS32       test_sort_init
drivers/firmware/efi/libstub/lib-sort.stub.o: absolute symbol references not allowed in the EFI stub
drivers/firmware/efi/libstub/Makefile:69: recipe for target 'drivers/firmware/efi/libstub/lib-sort.stub.o' failed

Other library tests live in a separate file, so doing the same here
is an easy way to avoid the problem.

Fixes: akpm-current ("lib: add CONFIG_TEST_SORT to enable self-test of sort()")
Link: http://lkml.kernel.org/r/20170112110657.3123790-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kostenzer Felix <fkostenzer@live.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile    |    1 +
 lib/sort.c      |   44 --------------------------------------------
 lib/test_sort.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 44 deletions(-)

diff -puN lib/Makefile~lib-add-config_test_sort-to-enable-self-test-of-sort-fix lib/Makefile
--- a/lib/Makefile~lib-add-config_test_sort-to-enable-self-test-of-sort-fix
+++ a/lib/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_TEST_KASAN) += test_kasan.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 obj-$(CONFIG_TEST_LKM) += test_module.o
 obj-$(CONFIG_TEST_RHASHTABLE) += test_rhashtable.o
+obj-$(CONFIG_TEST_SORT) += test_sort.o
 obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
 obj-$(CONFIG_TEST_STATIC_KEYS) += test_static_keys.o
 obj-$(CONFIG_TEST_STATIC_KEYS) += test_static_key_base.o
diff -puN lib/sort.c~lib-add-config_test_sort-to-enable-self-test-of-sort-fix lib/sort.c
--- a/lib/sort.c~lib-add-config_test_sort-to-enable-self-test-of-sort-fix
+++ a/lib/sort.c
@@ -103,47 +103,3 @@ void sort(void *base, size_t num, size_t
 }
 
 EXPORT_SYMBOL(sort);
-
-#ifdef CONFIG_TEST_SORT
-#include <linux/slab.h>
-#include <linux/module.h>
-/* a simple boot-time regression test */
-
-#define TEST_LEN 1000
-
-static int __init cmpint(const void *a, const void *b)
-{
-	return *(int *)a - *(int *)b;
-}
-
-static int __init test_sort_init(void)
-{
-	int *a, i, r = 1, err = -ENOMEM;
-
-	a = kmalloc_array(TEST_LEN, sizeof(*a), GFP_KERNEL);
-	if (!a)
-		return err;
-
-	for (i = 0; i < TEST_LEN; i++) {
-		r = (r * 725861) % 6599;
-		a[i] = r;
-	}
-
-	sort(a, TEST_LEN, sizeof(*a), cmpint, NULL);
-
-	err = -EINVAL;
-	for (i = 0; i < TEST_LEN-1; i++)
-		if (a[i] > a[i+1]) {
-			pr_err("test has failed\n");
-			goto exit;
-		}
-	err = 0;
-	pr_info("test passed\n");
-exit:
-	kfree(a);
-	return err;
-}
-
-module_init(test_sort_init);
-MODULE_LICENSE("GPL");
-#endif
diff -puN /dev/null lib/test_sort.c
--- /dev/null
+++ a/lib/test_sort.c
@@ -0,0 +1,43 @@
+#include <linux/sort.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+
+/* a simple boot-time regression test */
+
+#define TEST_LEN 1000
+
+static int __init cmpint(const void *a, const void *b)
+{
+	return *(int *)a - *(int *)b;
+}
+
+static int __init test_sort_init(void)
+{
+	int *a, i, r = 1, err = -ENOMEM;
+
+	a = kmalloc_array(TEST_LEN, sizeof(*a), GFP_KERNEL);
+	if (!a)
+		return err;
+
+	for (i = 0; i < TEST_LEN; i++) {
+		r = (r * 725861) % 6599;
+		a[i] = r;
+	}
+
+	sort(a, TEST_LEN, sizeof(*a), cmpint, NULL);
+
+	err = -EINVAL;
+	for (i = 0; i < TEST_LEN-1; i++)
+		if (a[i] > a[i+1]) {
+			pr_err("test has failed\n");
+			goto exit;
+		}
+	err = 0;
+	pr_info("test passed\n");
+exit:
+	kfree(a);
+	return err;
+}
+
+module_init(test_sort_init);
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from arnd@arndb.de are

memstick-core-avoid-wnonnull-warning.patch
lib-add-config_test_sort-to-enable-self-test-of-sort-fix.patch


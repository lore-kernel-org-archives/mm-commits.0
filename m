From: akpm@linux-foundation.org
Subject: [merged]
 lib-add-config_test_sort-to-enable-self-test-of-sort.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:29:07 -0800
Message-ID: <58b48c13.hrYFx0zsNblsNydo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34528 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751529AbdB0Ujt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:39:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fkostenzer@live.at, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: add CONFIG_TEST_SORT to enable self-test of sort()
has been removed from the -mm tree.  Its filename was
     lib-add-config_test_sort-to-enable-self-test-of-sort.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kostenzer Felix <fkostenzer@live.at>
Subject: lib: add CONFIG_TEST_SORT to enable self-test of sort()

Along with the addition made to Kconfig.debug, the prior existing but
permanently disabled test function has been slightly refactored.

Patch has been tested using QEMU 2.1.2 with a .config obtained through
'make defconfig' (x86_64) and manually enabling the option.

[arnd@arndb.de: move sort self-test into a separate file]
  Link: http://lkml.kernel.org/r/20170112110657.3123790-1-arnd@arndb.de
Link: http://lkml.kernel.org/r/HE1PR09MB0394B0418D504DCD27167D4FD49B0@HE1PR09MB0394.eurprd09.prod.outlook.com
Signed-off-by: Kostenzer Felix <fkostenzer@live.at>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    8 ++++++++
 lib/Makefile      |    1 +
 lib/sort.c        |   41 ++---------------------------------------
 lib/test_sort.c   |   43 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 54 insertions(+), 39 deletions(-)

diff -puN lib/Kconfig.debug~lib-add-config_test_sort-to-enable-self-test-of-sort lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-add-config_test_sort-to-enable-self-test-of-sort
+++ a/lib/Kconfig.debug
@@ -1739,6 +1739,14 @@ config TEST_LIST_SORT
 
 	  If unsure, say N.
 
+config TEST_SORT
+	bool "Array-based sort test"
+	depends on DEBUG_KERNEL
+	help
+	  This option enables the self-test function of 'sort()' at boot.
+
+	  If unsure, say N.
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
diff -puN lib/Makefile~lib-add-config_test_sort-to-enable-self-test-of-sort lib/Makefile
--- a/lib/Makefile~lib-add-config_test_sort-to-enable-self-test-of-sort
+++ a/lib/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_TEST_KASAN) += test_kasan.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 obj-$(CONFIG_TEST_LKM) += test_module.o
 obj-$(CONFIG_TEST_RHASHTABLE) += test_rhashtable.o
+obj-$(CONFIG_TEST_SORT) += test_sort.o
 obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
 obj-$(CONFIG_TEST_STATIC_KEYS) += test_static_keys.o
 obj-$(CONFIG_TEST_STATIC_KEYS) += test_static_key_base.o
diff -puN lib/sort.c~lib-add-config_test_sort-to-enable-self-test-of-sort lib/sort.c
--- a/lib/sort.c~lib-add-config_test_sort-to-enable-self-test-of-sort
+++ a/lib/sort.c
@@ -4,6 +4,8 @@
  * Jan 23 2005  Matt Mackall <mpm@selenic.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/export.h>
 #include <linux/sort.h>
@@ -101,42 +103,3 @@ void sort(void *base, size_t num, size_t
 }
 
 EXPORT_SYMBOL(sort);
-
-#if 0
-#include <linux/slab.h>
-/* a simple boot-time regression test */
-
-int cmpint(const void *a, const void *b)
-{
-	return *(int *)a - *(int *)b;
-}
-
-static int sort_test(void)
-{
-	int *a, i, r = 1;
-
-	a = kmalloc(1000 * sizeof(int), GFP_KERNEL);
-	BUG_ON(!a);
-
-	printk("testing sort()\n");
-
-	for (i = 0; i < 1000; i++) {
-		r = (r * 725861) % 6599;
-		a[i] = r;
-	}
-
-	sort(a, 1000, sizeof(int), cmpint, NULL);
-
-	for (i = 0; i < 999; i++)
-		if (a[i] > a[i+1]) {
-			printk("sort() failed!\n");
-			break;
-		}
-
-	kfree(a);
-
-	return 0;
-}
-
-module_init(sort_test);
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

Patches currently in -mm which might be from fkostenzer@live.at are



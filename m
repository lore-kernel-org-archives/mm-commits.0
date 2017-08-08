From: akpm@linux-foundation.org
Subject: + lib-add-test-module-for-config_debug_virtual.patch added to -mm tree
Date: Tue, 08 Aug 2017 15:21:53 -0700
Message-ID: <598a3981.AyHoXFNNrLPvDZqF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55000 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbdHHWVy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Aug 2017 18:21:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: f.fainelli@gmail.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: add test module for CONFIG_DEBUG_VIRTUAL
has been added to the -mm tree.  Its filename is
     lib-add-test-module-for-config_debug_virtual.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-test-module-for-config_debug_virtual.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-test-module-for-config_debug_virtual.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: lib: add test module for CONFIG_DEBUG_VIRTUAL

Add a test module that allows testing that CONFIG_DEBUG_VIRTUAL works
correctly, at least that it can catch invalid calls to virt_to_phys()
against the non-linear kernel virtual address map.

Link: http://lkml.kernel.org/r/20170808164035.26725-1-f.fainelli@gmail.com
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug        |   11 ++++++++
 lib/Makefile             |    1 
 lib/test_debug_virtual.c |   49 +++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)

diff -puN lib/Kconfig.debug~lib-add-test-module-for-config_debug_virtual lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-add-test-module-for-config_debug_virtual
+++ a/lib/Kconfig.debug
@@ -1902,6 +1902,17 @@ config TEST_KMOD
 
 	  If unsure, say N.
 
+config TEST_DEBUG_VIRTUAL
+	tristate "Test CONFIG_DEBUG_VIRTUAL feature"
+	depends on DEBUG_VIRTUAL
+	help
+	  Test the kernel's ability to detect incorrect calls to
+	  virt_to_phys() done against the non-linear part of the
+	  kernel's virtual address map.
+
+	  If unsure, say N.
+
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
diff -puN lib/Makefile~lib-add-test-module-for-config_debug_virtual lib/Makefile
--- a/lib/Makefile~lib-add-test-module-for-config_debug_virtual
+++ a/lib/Makefile
@@ -62,6 +62,7 @@ obj-$(CONFIG_TEST_BITMAP) += test_bitmap
 obj-$(CONFIG_TEST_UUID) += test_uuid.o
 obj-$(CONFIG_TEST_PARMAN) += test_parman.o
 obj-$(CONFIG_TEST_KMOD) += test_kmod.o
+obj-$(CONFIG_TEST_DEBUG_VIRTUAL) += test_debug_virtual.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff -puN /dev/null lib/test_debug_virtual.c
--- /dev/null
+++ a/lib/test_debug_virtual.c
@@ -0,0 +1,49 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/export.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include <linux/sizes.h>
+
+#include <asm/page.h>
+#ifdef CONFIG_MIPS
+#include <asm/bootinfo.h>
+#endif
+
+struct foo {
+	unsigned int bar;
+};
+
+struct foo *foo;
+
+static int __init test_debug_virtual_init(void)
+{
+	phys_addr_t pa;
+	void *va;
+
+	va = (void *)VMALLOC_START;
+	pa = virt_to_phys(va);
+
+	pr_info("PA: %pa for VA: 0x%lx\n", &pa, (unsigned long)va);
+
+	foo = kzalloc(sizeof(*foo), GFP_KERNEL);
+	if (!foo)
+		return -ENOMEM;
+
+	pa = virt_to_phys(foo);
+	va = foo;
+	pr_info("PA: %pa for VA: 0x%lx\n", &pa, (unsigned long)va);
+
+	return 0;
+}
+module_init(test_debug_virtual_init);
+
+static void __exit test_debug_virtual_exit(void)
+{
+	kfree(foo);
+}
+module_exit(test_debug_virtual_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Test module for CONFIG_DEBUG_VIRTUAL");
_

Patches currently in -mm which might be from f.fainelli@gmail.com are

lib-add-test-module-for-config_debug_virtual.patch


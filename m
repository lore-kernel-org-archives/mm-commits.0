From: akpm@osdl.org
Subject: - fault-injection-capability-for-alloc_pages.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:17 -0800
Message-ID: <200612082011.kB8KBHUs002891@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59023 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946513AbWLHULV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:11:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault-injection capability for alloc_pages()
has been removed from the -mm tree.  Its filename was
     fault-injection-capability-for-alloc_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fault-injection capability for alloc_pages()
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch provides fault-injection capability for alloc_pages()

Boot option:

fail_page_alloc=<interval>,<probability>,<space>,<times>

	<interval> -- specifies the interval of failures.

	<probability> -- specifies how often it should fail in percent.

	<space> -- specifies the size of free space where memory can be
		   allocated safely in pages.

	<times> -- specifies how many times failures may happen at most.

Debugfs:

/debug/fail_page_alloc/interval
/debug/fail_page_alloc/probability
/debug/fail_page_alloc/specifies
/debug/fail_page_alloc/times
/debug/fail_page_alloc/ignore-gfp-highmem
/debug/fail_page_alloc/ignore-gfp-wait

Example:

	fail_page_alloc=10,100,0,-1

The page allocation (alloc_pages(), ...) fails once per 10 times.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/Kconfig.debug |    7 +++
 mm/page_alloc.c   |   87 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+)

diff -puN lib/Kconfig.debug~fault-injection-capability-for-alloc_pages lib/Kconfig.debug
--- a/lib/Kconfig.debug~fault-injection-capability-for-alloc_pages
+++ a/lib/Kconfig.debug
@@ -424,6 +424,13 @@ config FAILSLAB
 	help
 	  This option provides fault-injection capabilitiy for kmalloc.
 
+config FAIL_PAGE_ALLOC
+	bool "Fault-injection capabilitiy for alloc_pages()"
+	depends on DEBUG_KERNEL
+	select FAULT_INJECTION
+	help
+	  This option provides fault-injection capabilitiy for alloc_pages().
+
 config FAULT_INJECTION_DEBUG_FS
 	bool "Debugfs entries for fault-injection capabilities"
 	depends on FAULT_INJECTION && SYSFS
diff -puN mm/page_alloc.c~fault-injection-capability-for-alloc_pages mm/page_alloc.c
--- a/mm/page_alloc.c~fault-injection-capability-for-alloc_pages
+++ a/mm/page_alloc.c
@@ -40,6 +40,7 @@
 #include <linux/sort.h>
 #include <linux/pfn.h>
 #include <linux/backing-dev.h>
+#include <linux/fault-inject.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -892,6 +893,89 @@ failed:
 #define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
 #define ALLOC_CPUSET		0x40 /* check for correct cpuset */
 
+#ifdef CONFIG_FAIL_PAGE_ALLOC
+
+static struct fail_page_alloc_attr {
+	struct fault_attr attr;
+
+	u32 ignore_gfp_highmem;
+	u32 ignore_gfp_wait;
+
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+
+	struct dentry *ignore_gfp_highmem_file;
+	struct dentry *ignore_gfp_wait_file;
+
+#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
+
+} fail_page_alloc = {
+	.attr = FAULT_ATTR_INITIALIZER,
+};
+
+static int __init setup_fail_page_alloc(char *str)
+{
+	return setup_fault_attr(&fail_page_alloc.attr, str);
+}
+__setup("fail_page_alloc=", setup_fail_page_alloc);
+
+static int should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
+{
+	if (gfp_mask & __GFP_NOFAIL)
+		return 0;
+	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
+		return 0;
+	if (fail_page_alloc.ignore_gfp_wait && (gfp_mask & __GFP_WAIT))
+		return 0;
+
+	return should_fail(&fail_page_alloc.attr, 1 << order);
+}
+
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+
+static int __init fail_page_alloc_debugfs(void)
+{
+	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
+	struct dentry *dir;
+	int err;
+
+	err = init_fault_attr_dentries(&fail_page_alloc.attr,
+				       "fail_page_alloc");
+	if (err)
+		return err;
+	dir = fail_page_alloc.attr.dentries.dir;
+
+	fail_page_alloc.ignore_gfp_wait_file =
+		debugfs_create_bool("ignore-gfp-wait", mode, dir,
+				      &fail_page_alloc.ignore_gfp_wait);
+
+	fail_page_alloc.ignore_gfp_highmem_file =
+		debugfs_create_bool("ignore-gfp-highmem", mode, dir,
+				      &fail_page_alloc.ignore_gfp_highmem);
+
+	if (!fail_page_alloc.ignore_gfp_wait_file ||
+			!fail_page_alloc.ignore_gfp_highmem_file) {
+		err = -ENOMEM;
+		debugfs_remove(fail_page_alloc.ignore_gfp_wait_file);
+		debugfs_remove(fail_page_alloc.ignore_gfp_highmem_file);
+		cleanup_fault_attr_dentries(&fail_page_alloc.attr);
+	}
+
+	return err;
+}
+
+late_initcall(fail_page_alloc_debugfs);
+
+#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
+
+#else /* CONFIG_FAIL_PAGE_ALLOC */
+
+static inline int should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
+{
+	return 0;
+}
+
+#endif /* CONFIG_FAIL_PAGE_ALLOC */
+
 /*
  * Return 1 if free pages are above 'mark'. This takes into account the order
  * of the allocation.
@@ -1136,6 +1220,9 @@ __alloc_pages(gfp_t gfp_mask, unsigned i
 
 	might_sleep_if(wait);
 
+	if (should_fail_alloc_page(gfp_mask, order))
+		return NULL;
+
 restart:
 	z = zonelist->zones;  /* the list of zones suitable for gfp_mask */
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-capability-for-alloc_pages.patch
fault-injection-capability-for-disk-io.patch
fault-injection-process-filtering-for-fault-injection-capabilities.patch
fault-injection-stacktrace-filtering.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
fault-injection-correct-disambiguate-and.patch
fault-injection-use-bool-true-false-throughout.patch
fault-injection-clamp-debugfs-stacktrace-depth-to.patch
fault-injection-optimize-and-simplify.patch
fault-injection-defaults-likely-to-please-a-new.patch
acpi-fix-single-linked-list-manipulation.patch
acpi-processor-prevent-loading-module-on-failures.patch
git-alsa.patch
audit-fix-kstrdup-error-check.patch
drm-fix-return-value-check.patch
ata-fix-platform_device_register_simple-error-check.patch
git-mtd.patch
net-use-bitrev8.patch
gss_spkm3-fix-error-handling-in-module-init.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch


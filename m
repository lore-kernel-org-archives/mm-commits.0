From: akpm@osdl.org
Subject: - fault-injection-capabilities-infrastructure.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:11 -0800
Message-ID: <200612082011.kB8KBBeQ002885@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59120 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946513AbWLHULo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:11:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, dwm@meer.net, okuji@enbug.org, mm-commits@vger.kernel.org


The patch titled
     fault-injection capabilities infrastructure
has been removed from the -mm tree.  Its filename was
     fault-injection-capabilities-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fault-injection capabilities infrastructure
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch provides base functions implement to fault-injection
capabilities.

- The function should_fail() is taken from failmalloc-1.0
  (http://www.nongnu.org/failmalloc/)

[akpm@osdl.org: cleanups, comments, add __init]
Cc: <okuji@enbug.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Don Mullis <dwm@meer.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/fault-inject.h |   69 ++++++++++++
 lib/Kconfig.debug            |   12 ++
 lib/Makefile                 |    1 
 lib/fault-inject.c           |  183 +++++++++++++++++++++++++++++++++
 4 files changed, 265 insertions(+)

diff -puN /dev/null include/linux/fault-inject.h
--- /dev/null
+++ a/include/linux/fault-inject.h
@@ -0,0 +1,69 @@
+#ifndef _LINUX_FAULT_INJECT_H
+#define _LINUX_FAULT_INJECT_H
+
+#ifdef CONFIG_FAULT_INJECTION
+
+#include <linux/types.h>
+#include <linux/debugfs.h>
+#include <asm/atomic.h>
+
+/*
+ * For explanation of the elements of this struct, see
+ * Documentation/fault-injection/fault-injection.txt
+ */
+struct fault_attr {
+	unsigned long probability;
+	unsigned long interval;
+	atomic_t times;
+	atomic_t space;
+	unsigned long verbose;
+
+	unsigned long count;
+
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+
+	struct {
+		struct dentry *dir;
+
+		struct dentry *probability_file;
+		struct dentry *interval_file;
+		struct dentry *times_file;
+		struct dentry *space_file;
+		struct dentry *verbose_file;
+	} dentries;
+
+#endif
+};
+
+#define FAULT_ATTR_INITIALIZER {				\
+		.interval = 1,					\
+		.times = ATOMIC_INIT(1),			\
+	}
+
+#define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
+int setup_fault_attr(struct fault_attr *attr, char *str);
+void should_fail_srandom(unsigned long entropy);
+int should_fail(struct fault_attr *attr, ssize_t size);
+
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+
+int init_fault_attr_dentries(struct fault_attr *attr, const char *name);
+void cleanup_fault_attr_dentries(struct fault_attr *attr);
+
+#else /* CONFIG_FAULT_INJECTION_DEBUG_FS */
+
+static inline int init_fault_attr_dentries(struct fault_attr *attr,
+					  const char *name)
+{
+	return -ENODEV;
+}
+
+static inline void cleanup_fault_attr_dentries(struct fault_attr *attr)
+{
+}
+
+#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
+
+#endif /* CONFIG_FAULT_INJECTION */
+
+#endif /* _LINUX_FAULT_INJECT_H */
diff -puN lib/Kconfig.debug~fault-injection-capabilities-infrastructure lib/Kconfig.debug
--- a/lib/Kconfig.debug~fault-injection-capabilities-infrastructure
+++ a/lib/Kconfig.debug
@@ -413,3 +413,15 @@ config LKDTM
 
 	Documentation on how to use the module can be found in
 	drivers/misc/lkdtm.c
+
+config FAULT_INJECTION
+	bool
+
+config FAULT_INJECTION_DEBUG_FS
+	bool "Debugfs entries for fault-injection capabilities"
+	depends on FAULT_INJECTION && SYSFS
+	select DEBUG_FS
+	help
+	  This option enable configuration of fault-injection capabilities via
+	  debugfs.
+
diff -puN lib/Makefile~fault-injection-capabilities-infrastructure lib/Makefile
--- a/lib/Makefile~fault-injection-capabilities-infrastructure
+++ a/lib/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_SMP) += percpu_counter.o
 obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
+obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
diff -puN /dev/null lib/fault-inject.c
--- /dev/null
+++ a/lib/fault-inject.c
@@ -0,0 +1,183 @@
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/random.h>
+#include <linux/stat.h>
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/fault-inject.h>
+
+/*
+ * setup_fault_attr() is a helper function for various __setup handlers, so it
+ * returns 0 on error, because that is what __setup handlers do.
+ */
+int __init setup_fault_attr(struct fault_attr *attr, char *str)
+{
+	unsigned long probability;
+	unsigned long interval;
+	int times;
+	int space;
+
+	/* "<interval>,<probability>,<space>,<times>" */
+	if (sscanf(str, "%lu,%lu,%d,%d",
+			&interval, &probability, &space, &times) < 4) {
+		printk(KERN_WARNING
+			"FAULT_INJECTION: failed to parse arguments\n");
+		return 0;
+	}
+
+	attr->probability = probability;
+	attr->interval = interval;
+	atomic_set(&attr->times, times);
+	atomic_set(&attr->space, space);
+
+	return 1;
+}
+
+static void fail_dump(struct fault_attr *attr)
+{
+	if (attr->verbose > 0)
+		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure\n");
+	if (attr->verbose > 1)
+		dump_stack();
+}
+
+#define atomic_dec_not_zero(v)		atomic_add_unless((v), -1, 0)
+
+/*
+ * This code is stolen from failmalloc-1.0
+ * http://www.nongnu.org/failmalloc/
+ */
+
+int should_fail(struct fault_attr *attr, ssize_t size)
+{
+	if (atomic_read(&attr->times) == 0)
+		return 0;
+
+	if (atomic_read(&attr->space) > size) {
+		atomic_sub(size, &attr->space);
+		return 0;
+	}
+
+	if (attr->interval > 1) {
+		attr->count++;
+		if (attr->count % attr->interval)
+			return 0;
+	}
+
+	if (attr->probability > random32() % 100)
+		goto fail;
+
+	return 0;
+
+fail:
+	fail_dump(attr);
+
+	if (atomic_read(&attr->times) != -1)
+		atomic_dec_not_zero(&attr->times);
+
+	return 1;
+}
+
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+
+static void debugfs_ul_set(void *data, u64 val)
+{
+	*(unsigned long *)data = val;
+}
+
+static u64 debugfs_ul_get(void *data)
+{
+	return *(unsigned long *)data;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_ul, debugfs_ul_get, debugfs_ul_set, "%llu\n");
+
+static struct dentry *debugfs_create_ul(const char *name, mode_t mode,
+				struct dentry *parent, unsigned long *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_ul);
+}
+
+static void debugfs_atomic_t_set(void *data, u64 val)
+{
+	atomic_set((atomic_t *)data, val);
+}
+
+static u64 debugfs_atomic_t_get(void *data)
+{
+	return atomic_read((atomic_t *)data);
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_atomic_t, debugfs_atomic_t_get,
+			debugfs_atomic_t_set, "%lld\n");
+
+static struct dentry *debugfs_create_atomic_t(const char *name, mode_t mode,
+				struct dentry *parent, atomic_t *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_atomic_t);
+}
+
+void cleanup_fault_attr_dentries(struct fault_attr *attr)
+{
+	debugfs_remove(attr->dentries.probability_file);
+	attr->dentries.probability_file = NULL;
+
+	debugfs_remove(attr->dentries.interval_file);
+	attr->dentries.interval_file = NULL;
+
+	debugfs_remove(attr->dentries.times_file);
+	attr->dentries.times_file = NULL;
+
+	debugfs_remove(attr->dentries.space_file);
+	attr->dentries.space_file = NULL;
+
+	debugfs_remove(attr->dentries.verbose_file);
+	attr->dentries.verbose_file = NULL;
+
+	if (attr->dentries.dir)
+		WARN_ON(!simple_empty(attr->dentries.dir));
+
+	debugfs_remove(attr->dentries.dir);
+	attr->dentries.dir = NULL;
+}
+
+int init_fault_attr_dentries(struct fault_attr *attr, const char *name)
+{
+	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
+	struct dentry *dir;
+
+	memset(&attr->dentries, 0, sizeof(attr->dentries));
+
+	dir = debugfs_create_dir(name, NULL);
+	if (!dir)
+		goto fail;
+	attr->dentries.dir = dir;
+
+	attr->dentries.probability_file =
+		debugfs_create_ul("probability", mode, dir, &attr->probability);
+
+	attr->dentries.interval_file =
+		debugfs_create_ul("interval", mode, dir, &attr->interval);
+
+	attr->dentries.times_file =
+		debugfs_create_atomic_t("times", mode, dir, &attr->times);
+
+	attr->dentries.space_file =
+		debugfs_create_atomic_t("space", mode, dir, &attr->space);
+
+	attr->dentries.verbose_file =
+		debugfs_create_ul("verbose", mode, dir, &attr->verbose);
+
+	if (!attr->dentries.probability_file || !attr->dentries.interval_file
+	    || !attr->dentries.times_file || !attr->dentries.space_file
+	    || !attr->dentries.verbose_file)
+		goto fail;
+
+	return 0;
+fail:
+	cleanup_fault_attr_dentries(attr);
+	return -ENOMEM;
+}
+
+#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-capability-for-kmalloc.patch
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


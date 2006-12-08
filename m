From: akpm@osdl.org
Subject: - fault-injection-capability-for-kmalloc.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:14 -0800
Message-ID: <200612082011.kB8KBEt6002888@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59033 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946575AbWLHULX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:11:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     fault-injection capability for kmalloc
has been removed from the -mm tree.  Its filename was
     fault-injection-capability-for-kmalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fault-injection capability for kmalloc
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch provides fault-injection capability for kmalloc.

Boot option:

failslab=<interval>,<probability>,<space>,<times>

	<interval> -- specifies the interval of failures.

	<probability> -- specifies how often it should fail in percent.

	<space> -- specifies the size of free space where memory can be
		   allocated safely in bytes.

	<times> -- specifies how many times failures may happen at most.

Debugfs:

/debug/failslab/interval
/debug/failslab/probability
/debug/failslab/specifies
/debug/failslab/times
/debug/failslab/ignore-gfp-highmem
/debug/failslab/ignore-gfp-wait

Example:

	failslab=10,100,0,-1

slab allocation (kmalloc(), kmem_cache_alloc(),..) fails once per 10 times.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/fault-injection/fault-injection.txt |    2 
 lib/Kconfig.debug                                 |    7 +
 mm/slab.c                                         |   77 ++++++++++++
 3 files changed, 84 insertions(+), 2 deletions(-)

diff -puN Documentation/fault-injection/fault-injection.txt~fault-injection-capability-for-kmalloc Documentation/fault-injection/fault-injection.txt
--- a/Documentation/fault-injection/fault-injection.txt~fault-injection-capability-for-kmalloc
+++ a/Documentation/fault-injection/fault-injection.txt
@@ -86,7 +86,6 @@ configuration of fault-injection capabil
 	specifies the maximum stacktrace depth walked during search
 	for a caller within [address-start,address-end).
 
-- /debug/failslab/ignore-gfp-highmem:
 - /debug/fail_page_alloc/ignore-gfp-highmem:
 
 	Format: { 0 | 1 }
@@ -167,7 +166,6 @@ echo 10 > /debug/$FAILNAME/probability
 echo 100 > /debug/$FAILNAME/interval
 echo -1 > /debug/$FAILNAME/times
 echo 2 > /debug/$FAILNAME/verbose
-echo 1 > /debug/$FAILNAME/ignore-gfp-highmem
 echo 1 > /debug/$FAILNAME/ignore-gfp-wait
 
 blacklist()
diff -puN lib/Kconfig.debug~fault-injection-capability-for-kmalloc lib/Kconfig.debug
--- a/lib/Kconfig.debug~fault-injection-capability-for-kmalloc
+++ a/lib/Kconfig.debug
@@ -417,6 +417,13 @@ config LKDTM
 config FAULT_INJECTION
 	bool
 
+config FAILSLAB
+	bool "Fault-injection capabilitiy for kmalloc"
+	depends on DEBUG_KERNEL
+	select FAULT_INJECTION
+	help
+	  This option provides fault-injection capabilitiy for kmalloc.
+
 config FAULT_INJECTION_DEBUG_FS
 	bool "Debugfs entries for fault-injection capabilities"
 	depends on FAULT_INJECTION && SYSFS
diff -puN mm/slab.c~fault-injection-capability-for-kmalloc mm/slab.c
--- a/mm/slab.c~fault-injection-capability-for-kmalloc
+++ a/mm/slab.c
@@ -107,6 +107,7 @@
 #include	<linux/nodemask.h>
 #include	<linux/mempolicy.h>
 #include	<linux/mutex.h>
+#include	<linux/fault-inject.h>
 #include	<linux/rtmutex.h>
 
 #include	<asm/cacheflush.h>
@@ -3088,12 +3089,88 @@ static void *cache_alloc_debugcheck_afte
 #define cache_alloc_debugcheck_after(a,b,objp,d) (objp)
 #endif
 
+#ifdef CONFIG_FAILSLAB
+
+static struct failslab_attr {
+
+	struct fault_attr attr;
+
+	u32 ignore_gfp_wait;
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+	struct dentry *ignore_gfp_wait_file;
+#endif
+
+} failslab = {
+	.attr = FAULT_ATTR_INITIALIZER,
+};
+
+static int __init setup_failslab(char *str)
+{
+	return setup_fault_attr(&failslab.attr, str);
+}
+__setup("failslab=", setup_failslab);
+
+static int should_failslab(struct kmem_cache *cachep, gfp_t flags)
+{
+	if (cachep == &cache_cache)
+		return 0;
+	if (flags & __GFP_NOFAIL)
+		return 0;
+	if (failslab.ignore_gfp_wait && (flags & __GFP_WAIT))
+		return 0;
+
+	return should_fail(&failslab.attr, obj_size(cachep));
+}
+
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+
+static int __init failslab_debugfs(void)
+{
+	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
+	struct dentry *dir;
+	int err;
+
+       	err = init_fault_attr_dentries(&failslab.attr, "failslab");
+	if (err)
+		return err;
+	dir = failslab.attr.dentries.dir;
+
+	failslab.ignore_gfp_wait_file =
+		debugfs_create_bool("ignore-gfp-wait", mode, dir,
+				      &failslab.ignore_gfp_wait);
+
+	if (!failslab.ignore_gfp_wait_file) {
+		err = -ENOMEM;
+		debugfs_remove(failslab.ignore_gfp_wait_file);
+		cleanup_fault_attr_dentries(&failslab.attr);
+	}
+
+	return err;
+}
+
+late_initcall(failslab_debugfs);
+
+#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
+
+#else /* CONFIG_FAILSLAB */
+
+static inline int should_failslab(struct kmem_cache *cachep, gfp_t flags)
+{
+	return 0;
+}
+
+#endif /* CONFIG_FAILSLAB */
+
 static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 {
 	void *objp;
 	struct array_cache *ac;
 
 	check_irq_off();
+
+	if (should_failslab(cachep, flags))
+		return NULL;
+
 	ac = cpu_cache_get(cachep);
 	if (likely(ac->avail)) {
 		STATS_INC_ALLOCHIT(cachep);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
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


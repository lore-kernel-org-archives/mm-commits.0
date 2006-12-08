From: akpm@osdl.org
Subject: - fault-injection-capability-for-kmalloc-failslab-remove-__gfp_highmem-filtering.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:59:40 -0800
Message-ID: <200612080859.kB88xeSu014236@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38170 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425264AbWLHI7n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:59:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     failslab: remove __GFP_HIGHMEM filtering
has been removed from the -mm tree.  Its filename was
     fault-injection-capability-for-kmalloc-failslab-remove-__gfp_highmem-filtering.patch

This patch was dropped because it was folded into fault-injection-capability-for-kmalloc.patch

------------------------------------------------------
Subject: failslab: remove __GFP_HIGHMEM filtering
From: Akinobu Mita <akinobu.mita@gmail.com>

Filtering __GFP_HIGHMEM flag for slab allocations is useless.  Because no
one sets __GFP_HIGHMEM for slab allocator, unlike for page allocator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/fault-injection/fault-injection.txt |    2 -
 mm/slab.c                                         |   17 +-----------
 2 files changed, 2 insertions(+), 17 deletions(-)

diff -puN Documentation/fault-injection/fault-injection.txt~fault-injection-capability-for-kmalloc-failslab-remove-__gfp_highmem-filtering Documentation/fault-injection/fault-injection.txt
--- a/Documentation/fault-injection/fault-injection.txt~fault-injection-capability-for-kmalloc-failslab-remove-__gfp_highmem-filtering
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
diff -puN mm/slab.c~fault-injection-capability-for-kmalloc-failslab-remove-__gfp_highmem-filtering mm/slab.c
--- a/mm/slab.c~fault-injection-capability-for-kmalloc-failslab-remove-__gfp_highmem-filtering
+++ a/mm/slab.c
@@ -3098,15 +3098,10 @@ static struct failslab_attr {
 
 	struct fault_attr attr;
 
-	u32 ignore_gfp_highmem;
 	u32 ignore_gfp_wait;
-
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-
-	struct dentry *ignore_gfp_highmem_file;
 	struct dentry *ignore_gfp_wait_file;
-
-#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
+#endif
 
 } failslab = {
 	.attr = FAULT_ATTR_INITIALIZER,
@@ -3124,8 +3119,6 @@ static int should_failslab(struct kmem_c
 		return 0;
 	if (flags & __GFP_NOFAIL)
 		return 0;
-	if (failslab.ignore_gfp_highmem && (flags & __GFP_HIGHMEM))
-		return 0;
 	if (failslab.ignore_gfp_wait && (flags & __GFP_WAIT))
 		return 0;
 
@@ -3149,15 +3142,9 @@ static int __init failslab_debugfs(void)
 		debugfs_create_bool("ignore-gfp-wait", mode, dir,
 				      &failslab.ignore_gfp_wait);
 
-	failslab.ignore_gfp_highmem_file =
-		debugfs_create_bool("ignore-gfp-highmem", mode, dir,
-				      &failslab.ignore_gfp_highmem);
-
-	if (!failslab.ignore_gfp_wait_file ||
-			!failslab.ignore_gfp_highmem_file) {
+	if (!failslab.ignore_gfp_wait_file) {
 		err = -ENOMEM;
 		debugfs_remove(failslab.ignore_gfp_wait_file);
-		debugfs_remove(failslab.ignore_gfp_highmem_file);
 		cleanup_fault_attr_dentries(&failslab.attr);
 	}
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
bit-revese-library.patch
crc32-replace-bitreverse-by-bitrev32.patch
video-use-bitrev8.patch
isdn-hisax-use-bitrev8.patch
atm-ambassador-use-bitrev8.patch
isdn-gigaset-use-bitrev8.patch
isdn-fix-missing-unregister_capi_driver.patch
fault-injection-documentation-and-scripts.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-capability-for-kmalloc.patch
fault-injection-capability-for-kmalloc-failslab-remove-__gfp_highmem-filtering.patch
fault-injection-capability-for-alloc_pages.patch
fault-injection-capability-for-disk-io.patch
fault-injection-process-filtering-for-fault-injection-capabilities.patch
fault-injection-stacktrace-filtering.patch
fault-injection-stacktrace-filtering-reject-failure-if-any-caller-lies-within-specified-range.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
fault-injection-Kconfig-cleanup-config_fault_injection-help-text.patch
fault-injection-correct-disambiguate-and.patch
fault-injection-use-bool-true-false-throughout.patch
fault-injection-clamp-debugfs-stacktrace-depth-to.patch
fault-injection-optimize-and-simplify.patch
fault-injection-defaults-likely-to-please-a-new.patch


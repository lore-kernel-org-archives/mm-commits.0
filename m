From: akpm@linux-foundation.org
Subject: [merged] fail_page_alloc-simplify-debugfs-initialization.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:29:47 -0700
Message-ID: <201107271928.p6RJSYhh003314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755041Ab1G0T2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fail_page_alloc: simplify debugfs initialization
has been removed from the -mm tree.  Its filename was
     fail_page_alloc-simplify-debugfs-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fail_page_alloc: simplify debugfs initialization
From: Akinobu Mita <akinobu.mita@gmail.com>

Now cleanup_fault_attr_dentries() recursively removes a directory, So we
can simplify the error handling in the initialization code and no need to
hold dentry structs for each debugfs file.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   47 +++++++++++++++-------------------------------
 1 file changed, 16 insertions(+), 31 deletions(-)

diff -puN mm/page_alloc.c~fail_page_alloc-simplify-debugfs-initialization mm/page_alloc.c
--- a/mm/page_alloc.c~fail_page_alloc-simplify-debugfs-initialization
+++ a/mm/page_alloc.c
@@ -1370,21 +1370,12 @@ failed:
 
 #ifdef CONFIG_FAIL_PAGE_ALLOC
 
-static struct fail_page_alloc_attr {
+static struct {
 	struct fault_attr attr;
 
 	u32 ignore_gfp_highmem;
 	u32 ignore_gfp_wait;
 	u32 min_order;
-
-#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-
-	struct dentry *ignore_gfp_highmem_file;
-	struct dentry *ignore_gfp_wait_file;
-	struct dentry *min_order_file;
-
-#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
-
 } fail_page_alloc = {
 	.attr = FAULT_ATTR_INITIALIZER,
 	.ignore_gfp_wait = 1,
@@ -1424,30 +1415,24 @@ static int __init fail_page_alloc_debugf
 				       "fail_page_alloc");
 	if (err)
 		return err;
+
 	dir = fail_page_alloc.attr.dir;
 
-	fail_page_alloc.ignore_gfp_wait_file =
-		debugfs_create_bool("ignore-gfp-wait", mode, dir,
-				      &fail_page_alloc.ignore_gfp_wait);
-
-	fail_page_alloc.ignore_gfp_highmem_file =
-		debugfs_create_bool("ignore-gfp-highmem", mode, dir,
-				      &fail_page_alloc.ignore_gfp_highmem);
-	fail_page_alloc.min_order_file =
-		debugfs_create_u32("min-order", mode, dir,
-				   &fail_page_alloc.min_order);
-
-	if (!fail_page_alloc.ignore_gfp_wait_file ||
-            !fail_page_alloc.ignore_gfp_highmem_file ||
-            !fail_page_alloc.min_order_file) {
-		err = -ENOMEM;
-		debugfs_remove(fail_page_alloc.ignore_gfp_wait_file);
-		debugfs_remove(fail_page_alloc.ignore_gfp_highmem_file);
-		debugfs_remove(fail_page_alloc.min_order_file);
-		cleanup_fault_attr_dentries(&fail_page_alloc.attr);
-	}
+	if (!debugfs_create_bool("ignore-gfp-wait", mode, dir,
+				&fail_page_alloc.ignore_gfp_wait))
+		goto fail;
+	if (!debugfs_create_bool("ignore-gfp-highmem", mode, dir,
+				&fail_page_alloc.ignore_gfp_highmem))
+		goto fail;
+	if (!debugfs_create_u32("min-order", mode, dir,
+				&fail_page_alloc.min_order))
+		goto fail;
+
+	return 0;
+fail:
+	cleanup_fault_attr_dentries(&fail_page_alloc.attr);
 
-	return err;
+	return -ENOMEM;
 }
 
 late_initcall(fail_page_alloc_debugfs);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch


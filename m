From: akpm@linux-foundation.org
Subject: [merged] failslab-simplify-debugfs-initialization.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:29:44 -0700
Message-ID: <201107271928.p6RJSVjX003311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755059Ab1G0T2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, cl@linux-foundation.org, mpm@selenic.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     failslab: simplify debugfs initialization
has been removed from the -mm tree.  Its filename was
     failslab-simplify-debugfs-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: failslab: simplify debugfs initialization
From: Akinobu Mita <akinobu.mita@gmail.com>

Now cleanup_fault_attr_dentries() recursively removes a directory, So we
can simplify the error handling in the initialization code and no need to
hold dentry structs for each debugfs file.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/failslab.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff -puN mm/failslab.c~failslab-simplify-debugfs-initialization mm/failslab.c
--- a/mm/failslab.c~failslab-simplify-debugfs-initialization
+++ a/mm/failslab.c
@@ -5,10 +5,6 @@ static struct {
 	struct fault_attr attr;
 	u32 ignore_gfp_wait;
 	int cache_filter;
-#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-	struct dentry *ignore_gfp_wait_file;
-	struct dentry *cache_filter_file;
-#endif
 } failslab = {
 	.attr = FAULT_ATTR_INITIALIZER,
 	.ignore_gfp_wait = 1,
@@ -39,31 +35,24 @@ __setup("failslab=", setup_failslab);
 static int __init failslab_debugfs_init(void)
 {
 	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
-	struct dentry *dir;
 	int err;
 
 	err = init_fault_attr_dentries(&failslab.attr, "failslab");
 	if (err)
 		return err;
-	dir = failslab.attr.dir;
 
-	failslab.ignore_gfp_wait_file =
-		debugfs_create_bool("ignore-gfp-wait", mode, dir,
-				      &failslab.ignore_gfp_wait);
-
-	failslab.cache_filter_file =
-		debugfs_create_bool("cache-filter", mode, dir,
-				      &failslab.cache_filter);
-
-	if (!failslab.ignore_gfp_wait_file ||
-	    !failslab.cache_filter_file) {
-		err = -ENOMEM;
-		debugfs_remove(failslab.cache_filter_file);
-		debugfs_remove(failslab.ignore_gfp_wait_file);
-		cleanup_fault_attr_dentries(&failslab.attr);
-	}
+	if (!debugfs_create_bool("ignore-gfp-wait", mode, failslab.attr.dir,
+				&failslab.ignore_gfp_wait))
+		goto fail;
+	if (!debugfs_create_bool("cache-filter", mode, failslab.attr.dir,
+				&failslab.cache_filter))
+		goto fail;
+
+	return 0;
+fail:
+	cleanup_fault_attr_dentries(&failslab.attr);
 
-	return err;
+	return -ENOMEM;
 }
 
 late_initcall(failslab_debugfs_init);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch


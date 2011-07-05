From: akpm@linux-foundation.org
Subject: + fail_page_alloc-simplify-debugfs-initialization.patch added to -mm tree
Date: Tue, 05 Jul 2011 14:24:47 -0700
Message-ID: <201107052124.p65LOlLb024977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab1GEVYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 17:24:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     fail_page_alloc: simplify debugfs initialization
has been added to the -mm tree.  Its filename is
     fail_page_alloc-simplify-debugfs-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
reiserfs-use-proper-little-endian-bitops.patch
reiserfs-use-hweight_long.patch
fault-injection-do-not-include-unneeded-header.patch
fault-injection-remove-nonexistent-function-extern.patch
fault-injection-cleanup-simple-attribute-of-stacktrace_depth.patch
fault-injection-use-debugfs_remove_recursive.patch
failslab-simplify-debugfs-initialization.patch
fail_page_alloc-simplify-debugfs-initialization.patch
fail_make_request-cleanup-should_fail_request.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch


From: akpm@linux-foundation.org
Subject: + failslab-simplify-debugfs-initialization.patch added to -mm tree
Date: Tue, 05 Jul 2011 14:24:44 -0700
Message-ID: <201107052124.p65LOi2W024971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab1GEVYt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 17:24:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, cl@linux-foundation.org, mpm@selenic.com, penberg@kernel.org


The patch titled
     failslab: simplify debugfs initialization
has been added to the -mm tree.  Its filename is
     failslab-simplify-debugfs-initialization.patch

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


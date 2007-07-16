From: akpm@linux-foundation.org
Subject: - fault-injection-add-min-order-parameter-to-fail_page_alloc.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:15 -0700
Message-ID: <200707162055.l6GKtFWE001897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37138 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758332AbXGPVOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:14:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault-injection: add min-order parameter to fail_page_alloc
has been removed from the -mm tree.  Its filename was
     fault-injection-add-min-order-parameter-to-fail_page_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fault-injection: add min-order parameter to fail_page_alloc
From: Akinobu Mita <akinobu.mita@gmail.com>

Limiting smaller allocation failures by fault injection helps to find real
possible bugs.  Because higher order allocations are likely to fail and
zero-order allocations are not likely to fail.

This patch adds min-order parameter to fail_page_alloc.  It specifies the
minimum page allocation order to be injected failures.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fault-injection/fault-injection.txt |    5 +++++
 mm/page_alloc.c                                   |   12 +++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff -puN Documentation/fault-injection/fault-injection.txt~fault-injection-add-min-order-parameter-to-fail_page_alloc Documentation/fault-injection/fault-injection.txt
--- a/Documentation/fault-injection/fault-injection.txt~fault-injection-add-min-order-parameter-to-fail_page_alloc
+++ a/Documentation/fault-injection/fault-injection.txt
@@ -103,6 +103,11 @@ configuration of fault-injection capabil
 	default is 'N', setting it to 'Y' will inject failures
 	only into non-sleep allocations (GFP_ATOMIC allocations).
 
+- /debug/fail_page_alloc/min-order:
+
+	specifies the minimum page allocation order to be injected
+	failures.
+
 o Boot option
 
 In order to inject faults while debugfs is not available (early boot time),
diff -puN mm/page_alloc.c~fault-injection-add-min-order-parameter-to-fail_page_alloc mm/page_alloc.c
--- a/mm/page_alloc.c~fault-injection-add-min-order-parameter-to-fail_page_alloc
+++ a/mm/page_alloc.c
@@ -900,11 +900,13 @@ static struct fail_page_alloc_attr {
 
 	u32 ignore_gfp_highmem;
 	u32 ignore_gfp_wait;
+	u32 min_order;
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 
 	struct dentry *ignore_gfp_highmem_file;
 	struct dentry *ignore_gfp_wait_file;
+	struct dentry *min_order_file;
 
 #endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
 
@@ -912,6 +914,7 @@ static struct fail_page_alloc_attr {
 	.attr = FAULT_ATTR_INITIALIZER,
 	.ignore_gfp_wait = 1,
 	.ignore_gfp_highmem = 1,
+	.min_order = 1,
 };
 
 static int __init setup_fail_page_alloc(char *str)
@@ -922,6 +925,8 @@ __setup("fail_page_alloc=", setup_fail_p
 
 static int should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
+	if (order < fail_page_alloc.min_order)
+		return 0;
 	if (gfp_mask & __GFP_NOFAIL)
 		return 0;
 	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
@@ -953,12 +958,17 @@ static int __init fail_page_alloc_debugf
 	fail_page_alloc.ignore_gfp_highmem_file =
 		debugfs_create_bool("ignore-gfp-highmem", mode, dir,
 				      &fail_page_alloc.ignore_gfp_highmem);
+	fail_page_alloc.min_order_file =
+		debugfs_create_u32("min-order", mode, dir,
+				   &fail_page_alloc.min_order);
 
 	if (!fail_page_alloc.ignore_gfp_wait_file ||
-			!fail_page_alloc.ignore_gfp_highmem_file) {
+            !fail_page_alloc.ignore_gfp_highmem_file ||
+            !fail_page_alloc.min_order_file) {
 		err = -ENOMEM;
 		debugfs_remove(fail_page_alloc.ignore_gfp_wait_file);
 		debugfs_remove(fail_page_alloc.ignore_gfp_highmem_file);
+		debugfs_remove(fail_page_alloc.min_order_file);
 		cleanup_fault_attr_dentries(&fail_page_alloc.attr);
 	}
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-dvb.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
unregister_chrdev-ignore-the-return-value.patch
unregister_chrdev-return-void.patch
unregister_blkdev-do-warn_on-on-failure.patch
unregister_blkdev-delete-redundant-messages-in-callers.patch
unregister_blkdev-delete-redundant-message.patch
unregister_blkdev-return-void.patch

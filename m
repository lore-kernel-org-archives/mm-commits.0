From: akpm@linux-foundation.org
Subject: + fault-injection-add-min-order-parameter-to-fail_page_alloc.patch added to -mm tree
Date: Wed, 30 May 2007 15:32:05 -0700
Message-ID: <200705302232.l4UMW5oN006781@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbXE3Wrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 18:47:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     fault-injection: add min-order parameter to fail_page_alloc
has been added to the -mm tree.  Its filename is
     fault-injection-add-min-order-parameter-to-fail_page_alloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1130,11 +1130,13 @@ static struct fail_page_alloc_attr {
 
 	u32 ignore_gfp_highmem;
 	u32 ignore_gfp_wait;
+	u32 min_order;
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 
 	struct dentry *ignore_gfp_highmem_file;
 	struct dentry *ignore_gfp_wait_file;
+	struct dentry *min_order_file;
 
 #endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
 
@@ -1142,6 +1144,7 @@ static struct fail_page_alloc_attr {
 	.attr = FAULT_ATTR_INITIALIZER,
 	.ignore_gfp_wait = 1,
 	.ignore_gfp_highmem = 1,
+	.min_order = 1,
 };
 
 static int __init setup_fail_page_alloc(char *str)
@@ -1152,6 +1155,8 @@ __setup("fail_page_alloc=", setup_fail_p
 
 static int should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
+	if (order < fail_page_alloc.min_order)
+		return 0;
 	if (gfp_mask & __GFP_NOFAIL)
 		return 0;
 	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
@@ -1183,12 +1188,17 @@ static int __init fail_page_alloc_debugf
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

git-dvb.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-add-min-order-parameter-to-fail_page_alloc.patch
fault-injection-fix-example-scripts-in-documentation.patch

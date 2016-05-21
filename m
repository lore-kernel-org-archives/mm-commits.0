From: akpm@linux-foundation.org
Subject: [patch 125/162] radix-tree: add test for radix_tree_locate_item()
Date: Fri, 20 May 2016 17:02:49 -0700
Message-ID: <573fa5a9.xEznMYk5E75e6my5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbcEUACv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, hughd@google.com

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix-tree: add test for radix_tree_locate_item()

Add a unit test that provides coverage for the bug fixed in the commit
entitled "radix-tree: rewrite radix_tree_locate_item fix" from Hugh
Dickins.  I've verified that this test fails before his patch due to
miscalculated 'index' values in __locate() in lib/radix-tree.c, and passes
with his fix.

Link: http://lkml.kernel.org/r/1462307263-20623-1-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux/init.h |    1 +
 tools/testing/radix-tree/main.c       |   15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff -puN /dev/null tools/testing/radix-tree/linux/init.h
--- /dev/null
+++ a/tools/testing/radix-tree/linux/init.h
@@ -0,0 +1 @@
+/* An empty file stub that allows radix-tree.c to compile. */
diff -puN tools/testing/radix-tree/main.c~radix-tree-add-test-for-radix_tree_locate_item tools/testing/radix-tree/main.c
--- a/tools/testing/radix-tree/main.c~radix-tree-add-test-for-radix_tree_locate_item
+++ a/tools/testing/radix-tree/main.c
@@ -232,7 +232,7 @@ void copy_tag_check(void)
 	item_kill_tree(&tree);
 }
 
-void __locate_check(struct radix_tree_root *tree, unsigned long index,
+static void __locate_check(struct radix_tree_root *tree, unsigned long index,
 			unsigned order)
 {
 	struct item *item;
@@ -248,12 +248,25 @@ void __locate_check(struct radix_tree_ro
 	}
 }
 
+static void __order_0_locate_check(void)
+{
+	RADIX_TREE(tree, GFP_KERNEL);
+	int i;
+
+	for (i = 0; i < 50; i++)
+		__locate_check(&tree, rand() % INT_MAX, 0);
+
+	item_kill_tree(&tree);
+}
+
 static void locate_check(void)
 {
 	RADIX_TREE(tree, GFP_KERNEL);
 	unsigned order;
 	unsigned long offset, index;
 
+	__order_0_locate_check();
+
 	for (order = 0; order < 20; order++) {
 		for (offset = 0; offset < (1 << (order + 3));
 		     offset += (1UL << order)) {
_

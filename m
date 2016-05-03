From: akpm@linux-foundation.org
Subject: + radix-tree-add-test-for-radix_tree_locate_item.patch added to
 -mm tree
Date: Tue, 03 May 2016 15:31:42 -0700
Message-ID: <572926ce.awb0V839t725nQTg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519AbcECWbn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2016 18:31:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: add test for radix_tree_locate_item()
has been added to the -mm tree.  Its filename is
     radix-tree-add-test-for-radix_tree_locate_item.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-add-test-for-radix_tree_locate_item.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-add-test-for-radix_tree_locate_item.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

radix-tree-test-suite-allow-testing-other-fan-out-values.patch
radix-tree-test-suite-keep-regression-test-runs-short.patch
radix-tree-test-suite-rebuild-when-headers-change.patch
radix-tree-remove-unused-looping-macros.patch
radix-tree-add-support-for-multi-order-iterating.patch
radix-tree-test-suite-multi-order-iteration-test.patch
radix-tree-rewrite-radix_tree_tag_set.patch
radix-tree-rewrite-radix_tree_tag_clear.patch
radix-tree-rewrite-radix_tree_tag_get.patch
radix-tree-test-suite-add-multi-order-tag-test.patch
radix-tree-add-test-for-radix_tree_locate_item.patch
radix-tree-fix-radix_tree_dump-for-multi-order-entries.patch


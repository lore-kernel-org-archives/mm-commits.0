From: akpm@linux-foundation.org
Subject: [patch 088/114] radix tree test suite: handle exceptional entries
Date: Wed, 14 Dec 2016 15:08:20 -0800
Message-ID: <5851d0e4.is1vMFT/NQ7npuNL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35304 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934101AbcLNXIV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:08:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com

From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: radix tree test suite: handle exceptional entries

item_kill_tree() assumes that everything in the tree is a pointer to a
struct item, which is annoying when testing the behaviour of exceptional
entries.  Fix it to delete exceptional entries on the assumption they
don't need to be freed.

Link: http://lkml.kernel.org/r/1480369871-5271-45-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/test.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN tools/testing/radix-tree/test.c~radix-tree-test-suite-handle-exceptional-entries tools/testing/radix-tree/test.c
--- a/tools/testing/radix-tree/test.c~radix-tree-test-suite-handle-exceptional-entries
+++ a/tools/testing/radix-tree/test.c
@@ -200,9 +200,16 @@ void verify_tag_consistency(struct radix
 
 void item_kill_tree(struct radix_tree_root *root)
 {
+	struct radix_tree_iter iter;
+	void **slot;
 	struct item *items[32];
 	int nfound;
 
+	radix_tree_for_each_slot(slot, root, &iter, 0) {
+		if (radix_tree_exceptional_entry(*slot))
+			radix_tree_delete(root, iter.index);
+	}
+
 	while ((nfound = radix_tree_gang_lookup(root, (void **)items, 0, 32))) {
 		int i;
 
_

From: akpm@linux-foundation.org
Subject: + radix-tree-test-suite-handle-exceptional-entries.patch added to -mm tree
Date: Tue, 06 Dec 2016 12:50:27 -0800
Message-ID: <58472493.tqId80IWDNlpd+Sp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36912 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751905AbcLFUt5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 15:49:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: handle exceptional entries
has been added to the -mm tree.  Its filename is
     radix-tree-test-suite-handle-exceptional-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-test-suite-handle-exceptional-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-test-suite-handle-exceptional-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from mawilcox@microsoft.com are

radix-tree-test-suite-fix-compilation.patch
radix-tree-test-suite-iteration-test-misuses-rcu.patch
radix-tree-test-suite-use-rcu_barrier.patch
radix-tree-test-suite-handle-exceptional-entries.patch
radix-tree-test-suite-record-order-in-each-item.patch
btrfs-fix-race-in-btrfs_free_dummy_fs_info.patch
radix-tree-improve-multiorder-iterators.patch
radix-tree-delete-radix_tree_locate_item.patch
radix-tree-delete-radix_tree_range_tag_if_tagged.patch
radix-tree-fix-replacement-for-multiorder-entries.patch
radix-tree-test-suite-check-multiorder-iteration.patch
tpm-use-idr_find-not-idr_find_slowpath.patch
rxrpc-abstract-away-knowledge-of-idr-internals.patch


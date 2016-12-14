From: akpm@linux-foundation.org
Subject: + radix-tree-test-suite-add-new-tag-check.patch added to -mm tree
Date: Wed, 14 Dec 2016 12:27:06 -0800
Message-ID: <5851ab1a.cImVZqSp3rPk2fLO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50492 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933067AbcLNU0S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 15:26:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: add new tag check
has been added to the -mm tree.  Its filename is
     radix-tree-test-suite-add-new-tag-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-test-suite-add-new-tag-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-test-suite-add-new-tag-check.patch

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
Subject: radix tree test suite: add new tag check

We have a check that setting a tag on a single entry at root succeeds, but
we were missing a check that clearing a tag on that same entry also
succeeds.

Link: http://lkml.kernel.org/r/1481667692-14500-4-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/tag_check.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN tools/testing/radix-tree/tag_check.c~radix-tree-test-suite-add-new-tag-check tools/testing/radix-tree/tag_check.c
--- a/tools/testing/radix-tree/tag_check.c~radix-tree-test-suite-add-new-tag-check
+++ a/tools/testing/radix-tree/tag_check.c
@@ -324,6 +324,9 @@ static void single_check(void)
 	assert(ret == 1);
 	ret = radix_tree_gang_lookup_tag(&tree, (void **)items, 0, BATCH, 1);
 	assert(ret == 1);
+	item_tag_clear(&tree, 0, 0);
+	ret = radix_tree_gang_lookup_tag(&tree, (void **)items, 0, BATCH, 0);
+	assert(ret == 0);
 	item_kill_tree(&tree);
 }
 
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
radix-tree-test-suite-cache-recently-freed-objects.patch
radix-tree-ensure-counts-are-initialised.patch
radix-tree-test-suite-add-new-tag-check.patch
radix-tree-test-suite-delete-unused-rcupdatec.patch


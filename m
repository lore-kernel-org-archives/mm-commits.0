From: akpm@linux-foundation.org
Subject: [merged] radix-tree-test-suite-add-new-tag-check.patch removed
 from -mm tree
Date: Thu, 15 Dec 2016 10:49:30 -0800
Message-ID: <5852e5ba.yaQ47QNFcKvY6bEQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50288 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754074AbcLOStb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:49:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: add new tag check
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-add-new-tag-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


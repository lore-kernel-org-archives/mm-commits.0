From: akpm@linux-foundation.org
Subject: + radix-tree-fix-sibling-entry-insertion.patch added to -mm tree
Date: Fri, 15 Apr 2016 22:58:14 -0700
Message-ID: <5711d476.ZpZ/VWQ5oa0svkJ+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbcDPF6P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 01:58:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: fix sibling entry insertion
has been added to the -mm tree.  Its filename is
     radix-tree-fix-sibling-entry-insertion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-fix-sibling-entry-insertion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-fix-sibling-entry-insertion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: fix sibling entry insertion

The subtraction was the wrong way round, leading to undefined behaviour
(shift by an amount larger than the size of the type).

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-fix-sibling-entry-insertion lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-sibling-entry-insertion
+++ a/lib/radix-tree.c
@@ -526,8 +526,8 @@ int __radix_tree_create(struct radix_tre
 
 #ifdef CONFIG_RADIX_TREE_MULTIORDER
 	/* Insert pointers to the canonical entry */
-	if ((shift - order) > 0) {
-		int i, n = 1 << (shift - order);
+	if (order > shift) {
+		int i, n = 1 << (order - shift);
 		offset = offset & ~(n - 1);
 		slot = ptr_to_indirect(&node->slots[offset]);
 		for (i = 0; i < n; i++) {
_

Patches currently in -mm which might be from willy@linux.intel.com are

radix-tree-introduce-radix_tree_empty.patch
radix-tree-test-suite-fix-build.patch
radix-tree-test-suite-add-tests-for-radix_tree_locate_item.patch
introduce-config_radix_tree_multiorder.patch
radix-tree-add-missing-sibling-entry-functionality.patch
radix-tree-fix-sibling-entry-insertion.patch
radix-tree-fix-deleting-a-multi-order-entry-through-an-alias.patch
radix-tree-remove-restriction-on-multi-order-entries.patch
radix-tree-introduce-radix_tree_load_root.patch
radix-tree-fix-extending-the-tree-for-multi-order-entries-at-offset-0.patch
radix-tree-test-suite-start-adding-multiorder-tests.patch
radix-tree-fix-several-shrinking-bugs-with-multiorder-entries.patch
radix-tree-rewrite-__radix_tree_lookup.patch
radix-tree-fix-multiorder-bug_on-in-radix_tree_insert.patch
radix-tree-fix-radix_tree_create-for-sibling-entries.patch
radix-tree-rewrite-radix_tree_locate_item.patch
radix-tree-fix-radix_tree_range_tag_if_tagged-for-multiorder-entries.patch
radix-tree-add-copyright-statements.patch


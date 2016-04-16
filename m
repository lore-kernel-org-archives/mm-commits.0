From: akpm@linux-foundation.org
Subject: + radix-tree-introduce-radix_tree_empty.patch added to -mm tree
Date: Fri, 15 Apr 2016 22:57:56 -0700
Message-ID: <5711d464.T85IbdyvfRmG5lwS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbcDPF56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 01:57:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: introduce radix_tree_empty
has been added to the -mm tree.  Its filename is
     radix-tree-introduce-radix_tree_empty.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-introduce-radix_tree_empty.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-introduce-radix_tree_empty.patch

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
Subject: radix-tree: introduce radix_tree_empty

Commit f96d18ff84 left the impression that the support for multiorder
radix tree entries was functional.  As soon as Ross tried to use it, it
became apparent that my testing was completely inadequate, and it didn't
even work a little bit for orders that were not a multiple of shift.

This series of patches is the result of about 6 weeks of redesign,
reimplementation, testing, arguing and hair-pulling.  The great news is
that the test-suite is now far better than it was.  That's reflected in
the diffstat for the test-suite alone:

 12 files changed, 436 insertions(+), 28 deletions(-)

The highlight for users of the tree is that the restriction on the order
of inserted entries being >= RADIX_TREE_MAP_SHIFT is now gone; the radix
tree now supports any order between 0 and 64.

For those who are interested in how the tree works, patch 9 is probably
the most interesting one as it introduces the new machinery for handling
sibling entries.

I've tried to be fair in attributing authorship to the person who
contributed the majority of the code in each patch; Ross has been an
invaluable partner in the development of this support and it's fair to say
that each of us has code in every commit.

I should also express my appreciation of the 0day testing.  It prompted me
that I was bloating the tinyconfig in an unacceptable way, and it bisected
to a commit which contained a rather nasty memory-corruption bug.



This patch (of 29):

The irqdomain code was checking for 0 or 1 entries, not 0 entries like the
comment said they were.  Introduce a new helper that will actually check
for an empty tree.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    5 +++++
 kernel/irq/irqdomain.c     |    7 +------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-introduce-radix_tree_empty include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-introduce-radix_tree_empty
+++ a/include/linux/radix-tree.h
@@ -136,6 +136,11 @@ do {									\
 	(root)->rnode = NULL;						\
 } while (0)
 
+static inline bool radix_tree_empty(struct radix_tree_root *root)
+{
+	return root->rnode == NULL;
+}
+
 /**
  * Radix-tree synchronization
  *
diff -puN kernel/irq/irqdomain.c~radix-tree-introduce-radix_tree_empty kernel/irq/irqdomain.c
--- a/kernel/irq/irqdomain.c~radix-tree-introduce-radix_tree_empty
+++ a/kernel/irq/irqdomain.c
@@ -139,12 +139,7 @@ void irq_domain_remove(struct irq_domain
 {
 	mutex_lock(&irq_domain_mutex);
 
-	/*
-	 * radix_tree_delete() takes care of destroying the root
-	 * node when all entries are removed. Shout if there are
-	 * any mappings left.
-	 */
-	WARN_ON(domain->revmap_tree.height);
+	WARN_ON(!radix_tree_empty(&domain->revmap_tree));
 
 	list_del(&domain->link);
 
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


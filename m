From: akpm@linux-foundation.org
Subject: [patch 099/162] radix-tree: introduce radix_tree_empty
Date: Fri, 20 May 2016 17:01:33 -0700
Message-ID: <573fa55d.dEy16uRCKgHzaYiF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbcEUABe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.cz, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: introduce radix_tree_empty

Commit e61452365372 ("radix_tree: add support for multi-order entries")
left the impression that the support for multiorder radix tree entries was
functional.  As soon as Ross tried to use it, it became apparent that my
testing was completely inadequate, and it didn't even work a little bit
for orders that were not a multiple of shift.

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
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
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

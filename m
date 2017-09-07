From: akpm@linux-foundation.org
Subject: [merged]
 dax-remove-dax-code-from-page_cache_tree_insert.patch removed from -mm tree
Date: Thu, 07 Sep 2017 11:36:37 -0700
Message-ID: <20170907183637.oXl3eV2Xl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54998 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755745AbdIGShE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:37:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adilger.kernel@dilger.ca, corbet@lwn.net, dan.j.williams@intel.com, darrick.wong@oracle.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mingo@redhat.com, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, rostedt@goodmis.org, tytso@mit.edu, viro@zeniv.linux.org.uk


The patch titled
     Subject: dax: remove DAX code from page_cache_tree_insert()
has been removed from the -mm tree.  Its filename was
     dax-remove-dax-code-from-page_cache_tree_insert.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: remove DAX code from page_cache_tree_insert()

Now that we no longer insert struct page pointers in DAX radix trees we
can remove the special casing for DAX in page_cache_tree_insert().  This
also allows us to make dax_wake_mapping_entry_waiter() local to fs/dax.c,
removing it from dax.h.

Link: http://lkml.kernel.org/r/20170724170616.25810-5-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c            |    2 +-
 include/linux/dax.h |    2 --
 mm/filemap.c        |   13 ++-----------
 3 files changed, 3 insertions(+), 14 deletions(-)

diff -puN fs/dax.c~dax-remove-dax-code-from-page_cache_tree_insert fs/dax.c
--- a/fs/dax.c~dax-remove-dax-code-from-page_cache_tree_insert
+++ a/fs/dax.c
@@ -127,7 +127,7 @@ static int wake_exceptional_entry_func(w
  * correct waitqueue where tasks might be waiting for that old 'entry' and
  * wake them.
  */
-void dax_wake_mapping_entry_waiter(struct address_space *mapping,
+static void dax_wake_mapping_entry_waiter(struct address_space *mapping,
 		pgoff_t index, void *entry, bool wake_all)
 {
 	struct exceptional_entry_key key;
diff -puN include/linux/dax.h~dax-remove-dax-code-from-page_cache_tree_insert include/linux/dax.h
--- a/include/linux/dax.h~dax-remove-dax-code-from-page_cache_tree_insert
+++ a/include/linux/dax.h
@@ -123,8 +123,6 @@ int dax_iomap_fault(struct vm_fault *vmf
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
-void dax_wake_mapping_entry_waiter(struct address_space *mapping,
-		pgoff_t index, void *entry, bool wake_all);
 
 #ifdef CONFIG_FS_DAX
 int __dax_zero_page_range(struct block_device *bdev,
diff -puN mm/filemap.c~dax-remove-dax-code-from-page_cache_tree_insert mm/filemap.c
--- a/mm/filemap.c~dax-remove-dax-code-from-page_cache_tree_insert
+++ a/mm/filemap.c
@@ -130,17 +130,8 @@ static int page_cache_tree_insert(struct
 			return -EEXIST;
 
 		mapping->nrexceptional--;
-		if (!dax_mapping(mapping)) {
-			if (shadowp)
-				*shadowp = p;
-		} else {
-			/* DAX can replace empty locked entry with a hole */
-			WARN_ON_ONCE(p !=
-				dax_radix_locked_entry(0, RADIX_DAX_EMPTY));
-			/* Wakeup waiters for exceptional entry lock */
-			dax_wake_mapping_entry_waiter(mapping, page->index, p,
-						      true);
-		}
+		if (shadowp)
+			*shadowp = p;
 	}
 	__radix_tree_replace(&mapping->page_tree, node, slot, page,
 			     workingset_update_node, mapping);
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are



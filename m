From: akpm@linux-foundation.org
Subject: + dax-remove-dax-code-from-page_cache_tree_insert.patch added to
 -mm tree
Date: Tue, 25 Jul 2017 15:04:40 -0700
Message-ID: <5977c078.raWm2/5lDZA/wDhf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54554 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdGYWEl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2017 18:04:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, adilger.kernel@dilger.ca, corbet@lwn.net, dan.j.williams@intel.com, darrick.wong@oracle.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mingo@redhat.com, rostedt@goodmis.org, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: remove DAX code from page_cache_tree_insert()
has been added to the -mm tree.  Its filename is
     dax-remove-dax-code-from-page_cache_tree_insert.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-remove-dax-code-from-page_cache_tree_insert.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-remove-dax-code-from-page_cache_tree_insert.patch

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
@@ -122,8 +122,6 @@ int dax_iomap_fault(struct vm_fault *vmf
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

mm-add-vm_insert_mixed_mkwrite.patch
dax-relocate-some-dax-functions.patch
dax-use-common-4k-zero-page-for-dax-mmap-reads.patch
dax-remove-dax-code-from-page_cache_tree_insert.patch
dax-move-all-dax-radix-tree-defs-to-fs-daxc.patch


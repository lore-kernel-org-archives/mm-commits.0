From: akpm@linux-foundation.org
Subject: + radixtree-introduce-radix_tree_scan_hole.patch added to -mm tree
Date: Mon, 23 Jul 2007 20:53:12 -0700
Message-ID: <200707240353.l6O3rCrd026878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756298AbXGXDyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 23:54:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, nickpiggin@yahoo.com.au, rusty@rustcorp.com.au


The patch titled
     radixtree: introduce radix_tree_scan_hole()
has been added to the -mm tree.  Its filename is
     radixtree-introduce-radix_tree_scan_hole.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: radixtree: introduce radix_tree_scan_hole()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Introduce radix_tree_scan_hole(root, index, max_scan) to scan radix tree for
the first hole.  It will be used in interleaved readahead.

The implementation is dumb and obviously correct.  It can help debug(and
document) the possible smart one in future.

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    2 +
 lib/radix-tree.c           |   36 +++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff -puN include/linux/radix-tree.h~radixtree-introduce-radix_tree_scan_hole include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radixtree-introduce-radix_tree_scan_hole
+++ a/include/linux/radix-tree.h
@@ -155,6 +155,8 @@ void *radix_tree_delete(struct radix_tre
 unsigned int
 radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 			unsigned long first_index, unsigned int max_items);
+unsigned long radix_tree_next_hole(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan);
 int radix_tree_preload(gfp_t gfp_mask);
 void radix_tree_init(void);
 void *radix_tree_tag_set(struct radix_tree_root *root,
diff -puN lib/radix-tree.c~radixtree-introduce-radix_tree_scan_hole lib/radix-tree.c
--- a/lib/radix-tree.c~radixtree-introduce-radix_tree_scan_hole
+++ a/lib/radix-tree.c
@@ -599,6 +599,42 @@ int radix_tree_tag_get(struct radix_tree
 EXPORT_SYMBOL(radix_tree_tag_get);
 #endif
 
+/**
+ *	radix_tree_next_hole    -    find the next hole (not-present entry)
+ *	@root:		tree root
+ *	@index:		index key
+ *	@max_scan:	maximum range to search
+ *
+ *	Search the set [index, min(index+max_scan-1, MAX_INDEX)] for the lowest
+ *	indexed hole.
+ *
+ *	Returns: the index of the hole if found, otherwise returns an index
+ *	outside of the set specified (in which case 'return - index >= max_scan'
+ *	will be true).
+ *
+ *	radix_tree_next_hole may be called under rcu_read_lock. However, like
+ *	radix_tree_gang_lookup, this will not atomically search a snapshot of the
+ *	tree at a single point in time. For example, if a hole is created at index
+ *	5, then subsequently a hole is created at index 10, radix_tree_next_hole
+ *	covering both indexes may return 10 if called under rcu_read_lock.
+ */
+unsigned long radix_tree_next_hole(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan)
+{
+	unsigned long i;
+
+	for (i = 0; i < max_scan; i++) {
+		if (!radix_tree_lookup(root, index))
+			break;
+		index++;
+		if (index == 0)
+			break;
+	}
+
+	return index;
+}
+EXPORT_SYMBOL(radix_tree_next_hole);
+
 static unsigned int
 __lookup(struct radix_tree_node *slot, void **results, unsigned long index,
 	unsigned int max_items, unsigned long *next_index)
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
radixtree-introduce-radix_tree_scan_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
convert-ill-defined-log2-to-ilog2.patch

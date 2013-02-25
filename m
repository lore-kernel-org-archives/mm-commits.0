From: akpm@linux-foundation.org
Subject: [merged] ksm-shrink-32-bit-rmap_item-back-to-32-bytes.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:05 -0800
Message-ID: <20130225205605.ABBF05A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:55983 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab3BYU4H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:07 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so363307qaj.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, hannes@cmpxchg.org, izik.eidus@ravellosystems.com, mgorman@suse.de, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: shrink 32-bit rmap_item back to 32 bytes
has been removed from the -mm tree.  Its filename was
     ksm-shrink-32-bit-rmap_item-back-to-32-bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ksm: shrink 32-bit rmap_item back to 32 bytes

Think of struct rmap_item as an extension of struct page (restricted to
MADV_MERGEABLE areas): there may be a lot of them, we need to keep them
small, especially on 32-bit architectures of limited lowmem.

Siting "int nid" after "unsigned int checksum" works nicely on 64-bit,
making no change to its 64-byte struct rmap_item; but bloats the 32-bit
struct rmap_item from (nicely cache-aligned) 32 bytes to 36 bytes, which
rounds up to 40 bytes once allocated from slab.  We'd better avoid that.

Hey, I only just remembered that the anon_vma pointer in struct rmap_item
has no purpose until the rmap_item is hung from a stable tree node (which
has its own nid field); and rmap_item's nid field no purpose than to say
which tree root to tell rb_erase() when unlinking from an unstable tree.

Double them up in a union.  There's just one place where we set anon_vma
early (when we already hold mmap_sem): now we must remove tree_rmap_item
from its unstable tree there, before overwriting nid.  No need to spatter
BUG()s around: we'd be seeing oopses if this were wrong.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN mm/ksm.c~ksm-shrink-32-bit-rmap_item-back-to-32-bytes mm/ksm.c
--- a/mm/ksm.c~ksm-shrink-32-bit-rmap_item-back-to-32-bytes
+++ a/mm/ksm.c
@@ -150,23 +150,25 @@ struct stable_node {
  * struct rmap_item - reverse mapping item for virtual addresses
  * @rmap_list: next rmap_item in mm_slot's singly-linked rmap_list
  * @anon_vma: pointer to anon_vma for this mm,address, when in stable tree
+ * @nid: NUMA node id of unstable tree in which linked (may not match page)
  * @mm: the memory structure this rmap_item is pointing into
  * @address: the virtual address this rmap_item tracks (+ flags in low bits)
  * @oldchecksum: previous checksum of the page at that virtual address
- * @nid: NUMA node id of unstable tree in which linked (may not match page)
  * @node: rb node of this rmap_item in the unstable tree
  * @head: pointer to stable_node heading this list in the stable tree
  * @hlist: link into hlist of rmap_items hanging off that stable_node
  */
 struct rmap_item {
 	struct rmap_item *rmap_list;
-	struct anon_vma *anon_vma;	/* when stable */
+	union {
+		struct anon_vma *anon_vma;	/* when stable */
+#ifdef CONFIG_NUMA
+		int nid;		/* when node of unstable tree */
+#endif
+	};
 	struct mm_struct *mm;
 	unsigned long address;		/* + low bits used for flags below */
 	unsigned int oldchecksum;	/* when unstable */
-#ifdef CONFIG_NUMA
-	int nid;
-#endif
 	union {
 		struct rb_node node;	/* when node of unstable tree */
 		struct {		/* when listed from stable tree */
@@ -1094,6 +1096,9 @@ static int try_to_merge_with_ksm_page(st
 	if (err)
 		goto out;
 
+	/* Unstable nid is in union with stable anon_vma: remove first */
+	remove_rmap_item_from_tree(rmap_item);
+
 	/* Must get reference to anon_vma while still holding mmap_sem */
 	rmap_item->anon_vma = vma->anon_vma;
 	get_anon_vma(vma->anon_vma);
@@ -1468,14 +1473,11 @@ static void cmp_and_merge_page(struct pa
 		kpage = try_to_merge_two_pages(rmap_item, page,
 						tree_rmap_item, tree_page);
 		put_page(tree_page);
-		/*
-		 * As soon as we merge this page, we want to remove the
-		 * rmap_item of the page we have merged with from the unstable
-		 * tree, and insert it instead as new node in the stable tree.
-		 */
 		if (kpage) {
-			remove_rmap_item_from_tree(tree_rmap_item);

From: akpm@linux-foundation.org
Subject: + mm-vmap-fix-overflow-update.patch added to -mm tree
Date: Wed, 18 Feb 2009 15:26:27 -0800
Message-ID: <200902182326.n1INQREN003308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487AbZBRX1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 18:27:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm-vmap-fix-overflow-update
has been added to the -mm tree.  Its filename is
     mm-vmap-fix-overflow-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-vmap-fix-overflow-update
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~mm-vmap-fix-overflow-update mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmap-fix-overflow-update
+++ a/mm/vmalloc.c
@@ -324,6 +324,7 @@ static struct vmap_area *alloc_vmap_area
 	unsigned long addr;
 	int purged = 0;
 
+	BUG_ON(!size);
 	BUG_ON(size & ~PAGE_MASK);
 
 	va = kmalloc_node(sizeof(struct vmap_area),
@@ -335,7 +336,7 @@ retry:
 	addr = ALIGN(vstart, align);
 
 	spin_lock(&vmap_area_lock);
-	if (addr + size < addr)
+	if (addr + size - 1 < addr)
 		goto overflow;
 
 	/* XXX: could have a last_hole cache */
@@ -369,7 +370,7 @@ retry:
 
 		while (addr + size > first->va_start && addr + size <= vend) {
 			addr = ALIGN(first->va_end + PAGE_SIZE, align);
-			if (addr + size < addr)
+			if (addr + size - 1 < addr)
 				goto overflow;
 
 			n = rb_next(&first->rb_node);
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-task-dirty-accounting-fix.patch
linux-next.patch
mm-vmap-fix-overflow.patch
mm-vmap-fix-overflow-update.patch
vmap-remove-needless-lock-and-list-in-vmap.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
mm-dont-call-mark_page_accessed-in-do_swap_page.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
vfs-add-set_page_dirty_notag.patch
vfs-add-set_page_dirty_notag-checkpatch-fixes.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch


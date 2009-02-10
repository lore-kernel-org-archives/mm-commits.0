From: akpm@linux-foundation.org
Subject: + mm-vmap-fix-overflow.patch added to -mm tree
Date: Tue, 10 Feb 2009 14:44:30 -0800
Message-ID: <200902102244.n1AMiUfZ020344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757301AbZBJWpR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 17:45:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, hch@lst.de, stable@kernel.org


The patch titled
     mm: vmap fix overflow
has been added to the -mm tree.  Its filename is
     mm-vmap-fix-overflow.patch

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
Subject: mm: vmap fix overflow
From: Nick Piggin <npiggin@suse.de>

The new vmap allocator can wrap the address and get confused in the case
of large allocations or VMALLOC_END near the end of address space.

Problem reported by Christoph Hellwig on a 32-bit XFS workload.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Reported-by: Christoph Hellwig <hch@lst.de>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/vmalloc.c~mm-vmap-fix-overflow mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmap-fix-overflow
+++ a/mm/vmalloc.c
@@ -335,6 +335,9 @@ retry:
 	addr = ALIGN(vstart, align);
 
 	spin_lock(&vmap_area_lock);
+	if (addr + size < addr)
+		goto overflow;
+
 	/* XXX: could have a last_hole cache */
 	n = vmap_area_root.rb_node;
 	if (n) {
@@ -366,6 +369,8 @@ retry:
 
 		while (addr + size > first->va_start && addr + size <= vend) {
 			addr = ALIGN(first->va_end + PAGE_SIZE, align);
+			if (addr + size < addr)
+				goto overflow;
 
 			n = rb_next(&first->rb_node);
 			if (n)
@@ -376,6 +381,7 @@ retry:
 	}
 found:
 	if (addr + size > vend) {
+overflow:
 		spin_unlock(&vmap_area_lock);
 		if (!purged) {
 			purge_vmap_area_lazy();
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes.patch
writeback-fix-break-condition.patch
writeback-fix-break-condition-checkpatch-fixes.patch
mm-task-dirty-accounting-fix.patch
mm-vmap-fix-overflow.patch
vmap-remove-needless-lock-and-list-in-vmap.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch


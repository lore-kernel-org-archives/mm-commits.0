From: akpm@linux-foundation.org
Subject: [merged] ksm-add-cond_resched-to-the-rmap_walks.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:16:09 -0800
Message-ID: <563d0a89.JwbjSZ/+qM+CA6IK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162949AbbKFUQJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dbueso@suse.de, hughd@google.com, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: add cond_resched() to the rmap_walks
has been removed from the -mm tree.  Its filename was
     ksm-add-cond_resched-to-the-rmap_walks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: ksm: add cond_resched() to the rmap_walks

While at it add it to the file and anon walks too.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c  |    2 ++
 mm/rmap.c |    4 ++++
 2 files changed, 6 insertions(+)

diff -puN mm/ksm.c~ksm-add-cond_resched-to-the-rmap_walks mm/ksm.c
--- a/mm/ksm.c~ksm-add-cond_resched-to-the-rmap_walks
+++ a/mm/ksm.c
@@ -1914,9 +1914,11 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
+		cond_resched();
 		anon_vma_lock_read(anon_vma);
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
 					       0, ULONG_MAX) {
+			cond_resched();
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
 			    rmap_item->address >= vma->vm_end)
diff -puN mm/rmap.c~ksm-add-cond_resched-to-the-rmap_walks mm/rmap.c
--- a/mm/rmap.c~ksm-add-cond_resched-to-the-rmap_walks
+++ a/mm/rmap.c
@@ -1609,6 +1609,8 @@ static int rmap_walk_anon(struct page *p
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
 
+		cond_resched();
+
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
 			continue;
 
@@ -1658,6 +1660,8 @@ static int rmap_walk_file(struct page *p
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
 
+		cond_resched();
+
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
 			continue;
 
_

Patches currently in -mm which might be from aarcange@redhat.com are



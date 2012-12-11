From: akpm@linux-foundation.org
Subject: [folded-merged] mm-check-rb_subtree_gap-correctness-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:45:12 -0800
Message-ID: <20121211234512.6A0DE82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:35267 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab2LKXpO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:45:14 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so6742ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:45:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-check-rb_subtree_gap-correctness-fix
has been removed from the -mm tree.  Its filename was
     mm-check-rb_subtree_gap-correctness-fix.patch

This patch was dropped because it was folded into mm-check-rb_subtree_gap-correctness.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-check-rb_subtree_gap-correctness-fix

repair innovative coding-style inventions

Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michel Lespinasse <walken@google.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff -puN mm/mmap.c~mm-check-rb_subtree_gap-correctness-fix mm/mmap.c
--- a/mm/mmap.c~mm-check-rb_subtree_gap-correctness-fix
+++ a/mm/mmap.c
@@ -343,16 +343,25 @@ static int browse_rb(struct rb_root *roo
 	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
 		struct vm_area_struct *vma;
 		vma = rb_entry(nd, struct vm_area_struct, vm_rb);
-		if (vma->vm_start < prev)
-			printk("vm_start %lx prev %lx\n", vma->vm_start, prev), bug = 1;
-		if (vma->vm_start < pend)
-			printk("vm_start %lx pend %lx\n", vma->vm_start, pend), bug = 1;
-		if (vma->vm_start > vma->vm_end)
-			printk("vm_end %lx < vm_start %lx\n", vma->vm_end, vma->vm_start), bug = 1;
-		if (vma->rb_subtree_gap != vma_compute_subtree_gap(vma))
+		if (vma->vm_start < prev) {
+			printk("vm_start %lx prev %lx\n", vma->vm_start, prev);
+			bug = 1;
+		}
+		if (vma->vm_start < pend) {
+			printk("vm_start %lx pend %lx\n", vma->vm_start, pend);
+			bug = 1;
+		}
+		if (vma->vm_start > vma->vm_end) {
+			printk("vm_end %lx < vm_start %lx\n",
+				vma->vm_end, vma->vm_start);
+			bug = 1;
+		}
+		if (vma->rb_subtree_gap != vma_compute_subtree_gap(vma)) {
 			printk("free gap %lx, correct %lx\n",
 			       vma->rb_subtree_gap,
-			       vma_compute_subtree_gap(vma)), bug = 1;
+			       vma_compute_subtree_gap(vma));
+			bug = 1;
+		}
 		i++;
 		pn = nd;
 		prev = vma->vm_start;
@@ -361,8 +370,10 @@ static int browse_rb(struct rb_root *roo
 	j = 0;
 	for (nd = pn; nd; nd = rb_prev(nd))
 		j++;
-	if (i != j)
-		printk("backwards %d, forwards %d\n", j, i), bug = 1;
+	if (i != j) {
+		printk("backwards %d, forwards %d\n", j, i);
+		bug = 1;
+	}
 	return bug ? -1 : i;
 }
 
@@ -394,14 +405,20 @@ void validate_mm(struct mm_struct *mm)
 		vma = vma->vm_next;
 		i++;
 	}
-	if (i != mm->map_count)
-		printk("map_count %d vm_next %d\n", mm->map_count, i), bug = 1;
-	if (highest_address != mm->highest_vm_end)
+	if (i != mm->map_count) {
+		printk("map_count %d vm_next %d\n", mm->map_count, i);
+		bug = 1;
+	}
+	if (highest_address != mm->highest_vm_end) {
 		printk("mm->highest_vm_end %lx, found %lx\n",
-		       mm->highest_vm_end, highest_address), bug = 1;
+		       mm->highest_vm_end, highest_address);
+		bug = 1;
+	}
 	i = browse_rb(&mm->mm_rb);
-	if (i != mm->map_count)
-		printk("map_count %d rb %d\n", mm->map_count, i), bug = 1;
+	if (i != mm->map_count) {
+		printk("map_count %d rb %d\n", mm->map_count, i);
+		bug = 1;
+	}
 	BUG_ON(bug);
 }
 #else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-introduce-mm_find_pmd.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch
mm-check-rb_subtree_gap-correctness.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch


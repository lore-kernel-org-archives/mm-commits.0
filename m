From: akpm@linux-foundation.org
Subject: [merged] proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:05 -0700
Message-ID: <20120601193405.606E0A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:53839 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759102Ab2FATeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:07 -0400
Received: by lagr15 with SMTP id r15so139280lag.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, adobriyan@gmail.com, andi@firstfloor.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc/smaps: show amount of nonlinear ptes in vma
has been removed from the -mm tree.  Its filename was
     proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: proc/smaps: show amount of nonlinear ptes in vma

Currently, nonlinear mappings can not be distinguished from ordinary
mappings.  This patch adds into /proc/pid/smaps line "Nonlinear: <size>
kB", where size is amount of nonlinear ptes in vma, this line appears only
if VM_NONLINEAR is set.  This information may be useful not only for
checkpoint/restore project.

Requested by Pavel Emelyanov.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN fs/proc/task_mmu.c~proc-smaps-show-amount-of-nonlinear-ptes-in-vma fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-smaps-show-amount-of-nonlinear-ptes-in-vma
+++ a/fs/proc/task_mmu.c
@@ -393,6 +393,7 @@ struct mem_size_stats {
 	unsigned long anonymous;
 	unsigned long anonymous_thp;
 	unsigned long swap;
+	unsigned long nonlinear;
 	u64 pss;
 };
 
@@ -402,6 +403,7 @@ static void smaps_pte_entry(pte_t ptent,
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = mss->vma;
+	pgoff_t pgoff = linear_page_index(vma, addr);
 	struct page *page = NULL;
 	int mapcount;
 
@@ -414,6 +416,9 @@ static void smaps_pte_entry(pte_t ptent,
 			mss->swap += ptent_size;
 		else if (is_migration_entry(swpent))
 			page = migration_entry_to_page(swpent);
+	} else if (pte_file(ptent)) {
+		if (pte_to_pgoff(ptent) != pgoff)
+			mss->nonlinear += ptent_size;
 	}
 
 	if (!page)
@@ -422,6 +427,9 @@ static void smaps_pte_entry(pte_t ptent,
 	if (PageAnon(page))
 		mss->anonymous += ptent_size;
 
+	if (page->index != pgoff)
+		mss->nonlinear += ptent_size;
+
 	mss->resident += ptent_size;
 	/* Accumulate the size in pages that have been accessed. */
 	if (pte_young(ptent) || PageReferenced(page))
@@ -523,6 +531,10 @@ static int show_smap(struct seq_file *m,
 		   (vma->vm_flags & VM_LOCKED) ?
 			(unsigned long)(mss.pss >> (10 + PSS_SHIFT)) : 0);
 
+	if (vma->vm_flags & VM_NONLINEAR)
+		seq_printf(m, "Nonlinear:      %8lu kB\n",
+				mss.nonlinear >> 10);
+
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task->mm))
 			? vma->vm_start : 0;
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch


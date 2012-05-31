From: akpm@linux-foundation.org
Subject: [nacked] proc-smaps-show-amount-of-hwpoison-pages.patch removed from -mm tree
Date: Thu, 31 May 2012 13:12:38 -0700
Message-ID: <20120531201238.8E61CA03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:63787 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933258Ab2EaUMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 16:12:40 -0400
Received: by faaa25 with SMTP id a25so77334faa.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 13:12:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, adobriyan@gmail.com, ak@linux.intel.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc/smaps: show amount of hwpoison pages
has been removed from the -mm tree.  Its filename was
     proc-smaps-show-amount-of-hwpoison-pages.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: proc/smaps: show amount of hwpoison pages

Add the line "HWPoinson: <size> kB" into /proc/pid/smaps if
CONFIG_MEMORY_FAILURE=y and some HWPoison pages were found.  This may be
useful for searching applications which use a broken memory.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Andi Kleen <ak@linux.intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/proc/task_mmu.c~proc-smaps-show-amount-of-hwpoison-pages fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-smaps-show-amount-of-hwpoison-pages
+++ a/fs/proc/task_mmu.c
@@ -394,6 +394,7 @@ struct mem_size_stats {
 	unsigned long anonymous_thp;
 	unsigned long swap;
 	unsigned long nonlinear;
+	unsigned long hwpoison;
 	u64 pss;
 };
 
@@ -416,6 +417,8 @@ static void smaps_pte_entry(pte_t ptent,
 			mss->swap += ptent_size;
 		else if (is_migration_entry(swpent))
 			page = migration_entry_to_page(swpent);
+		else if (is_hwpoison_entry(swpent))
+			mss->hwpoison += ptent_size;
 	} else if (pte_file(ptent)) {
 		if (pte_to_pgoff(ptent) != pgoff)
 			mss->nonlinear += ptent_size;
@@ -430,6 +433,9 @@ static void smaps_pte_entry(pte_t ptent,
 	if (page->index != pgoff)
 		mss->nonlinear += ptent_size;
 
+	if (PageHWPoison(page))
+		mss->hwpoison += ptent_size;
+
 	mss->resident += ptent_size;
 	/* Accumulate the size in pages that have been accessed. */
 	if (pte_young(ptent) || PageReferenced(page))
@@ -535,6 +541,10 @@ static int show_smap(struct seq_file *m,
 		seq_printf(m, "Nonlinear:      %8lu kB\n",
 				mss.nonlinear >> 10);
 
+	if (IS_ENABLED(CONFIG_MEMORY_FAILURE) && mss.hwpoison)
+		seq_printf(m, "HWPoison:       %8lu kB\n",
+				mss.hwpoison >> 10);
+
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task->mm))
 			? vma->vm_start : 0;
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch


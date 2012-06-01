From: akpm@linux-foundation.org
Subject: [merged] proc-smaps-carefully-handle-migration-entries.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:02 -0700
Message-ID: <20120601193402.A55FAA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:42691 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759112Ab2FATeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:03 -0400
Received: by yhgm50 with SMTP id m50so288024yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, adobriyan@gmail.com, andi@firstfloor.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc/smaps: carefully handle migration entries
has been removed from the -mm tree.  Its filename was
     proc-smaps-carefully-handle-migration-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: proc/smaps: carefully handle migration entries

Currently smaps reports migration entries as "swap", as result "swap" can
appears in shared mapping.

This patch converts migration entries into pages and handles them as usual.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-smaps-carefully-handle-migration-entries fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-smaps-carefully-handle-migration-entries
+++ a/fs/proc/task_mmu.c
@@ -402,18 +402,20 @@ static void smaps_pte_entry(pte_t ptent,
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = mss->vma;
-	struct page *page;
+	struct page *page = NULL;
 	int mapcount;
 
-	if (is_swap_pte(ptent)) {
-		mss->swap += ptent_size;
-		return;
-	}
+	if (pte_present(ptent)) {
+		page = vm_normal_page(vma, addr, ptent);
+	} else if (is_swap_pte(ptent)) {
+		swp_entry_t swpent = pte_to_swp_entry(ptent);
 
-	if (!pte_present(ptent))
-		return;
+		if (!non_swap_entry(swpent))
+			mss->swap += ptent_size;
+		else if (is_migration_entry(swpent))
+			page = migration_entry_to_page(swpent);
+	}
 
-	page = vm_normal_page(vma, addr, ptent);
 	if (!page)
 		return;
 
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch


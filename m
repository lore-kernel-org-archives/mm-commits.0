From: akpm@linux-foundation.org
Subject: + numa_emulation-fix-cpumask_of_node.patch added to -mm tree
Date: Fri, 16 Mar 2012 13:57:48 -0700
Message-ID: <20120316205748.73804A0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:38247 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965109Ab2CPU5v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Mar 2012 16:57:51 -0400
Received: by eaaq10 with SMTP id q10so211130eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Mar 2012 13:57:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, andi@firstfloor.org, hpa@zytor.com, jweiner@redhat.com, mingo@elte.hu, rientjes@google.com, tglx@linutronix.de


The patch titled
     Subject: numa_emulation: fix cpumask_of_node()
has been added to the -mm tree.  Its filename is
     numa_emulation-fix-cpumask_of_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: numa_emulation: fix cpumask_of_node()

Without this fix the cpumask_of_node() for a fake=numa=2 is:

cpumask 0 ff
cpumask 1 ff

with the fix it's correct and it's set to:

cpumask 0 55
cpumask 1 aa

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa_emulation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/numa_emulation.c~numa_emulation-fix-cpumask_of_node arch/x86/mm/numa_emulation.c
--- a/arch/x86/mm/numa_emulation.c~numa_emulation-fix-cpumask_of_node
+++ a/arch/x86/mm/numa_emulation.c
@@ -60,7 +60,7 @@ static int __init emu_setup_memblk(struc
 	eb->nid = nid;
 
 	if (emu_nid_to_phys[nid] == NUMA_NO_NODE)
-		emu_nid_to_phys[nid] = pb->nid;
+		emu_nid_to_phys[nid] = nid;
 
 	pb->start += size;
 	if (pb->start >= pb->end) {
_
Subject: Subject: numa_emulation: fix cpumask_of_node()

Patches currently in -mm which might be from aarcange@redhat.com are

linux-next.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-checkpatch-fixes.patch
vmscan-reclaim-at-order-0-when-compaction-is-enabled.patch
vmscan-kswapd-carefully-call-compaction.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
vmscan-only-defer-compaction-for-failed-order-and-higher.patch
mm-compaction-make-compact_control-order-signed.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
thp-optimize-away-unnecessary-page-table-locking-fix.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
thp-transparent_hugepage=-can-also-be-specified-on-cmdline.patch
thp-allow-a-hwpoisoned-head-page-to-be-put-back-to-lru.patch
ksm-cleanup-introduce-find_mergeable_vma.patch
numa_emulation-fix-cpumask_of_node.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch
memcg-clean-up-existing-move-charge-code.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage.patch
memcg-avoid-thp-split-in-task-migration.patch


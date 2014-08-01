From: akpm@linux-foundation.org
Subject: + mm-mark-fault_around_bytes-__read_mostly.patch added to -mm
 tree
Date: Fri, 01 Aug 2014 13:24:07 -0700
Message-ID: <53dbf767.r/KtHYXVKKMlChSt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:57562 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbaHAUYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Aug 2014 16:24:08 -0400
Received: by mail-vc0-f201.google.com with SMTP id le20so604621vcb.2
        for <mm-commits@vger.kernel.org>; Fri, 01 Aug 2014 13:24:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, a.ryabinin@samsung.com, dave.hansen@intel.com, rientjes@google.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mark fault_around_bytes __read_mostly
has been added to the -mm tree.  Its filename is
     mm-mark-fault_around_bytes-__read_mostly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mark-fault_around_bytes-__read_mostly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mark-fault_around_bytes-__read_mostly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: mark fault_around_bytes __read_mostly

fault_around_bytes can only be changed via debugfs. Let's mark it
read-mostly.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~mm-mark-fault_around_bytes-__read_mostly mm/memory.c
--- a/mm/memory.c~mm-mark-fault_around_bytes-__read_mostly
+++ a/mm/memory.c
@@ -2768,7 +2768,8 @@ void do_set_pte(struct vm_area_struct *v
 	update_mmu_cache(vma, address, pte);
 }
 
-static unsigned long fault_around_bytes = rounddown_pow_of_two(65536);
+static unsigned long fault_around_bytes __read_mostly =
+	rounddown_pow_of_two(65536);
 
 #ifdef CONFIG_DEBUG_FS
 static int fault_around_bytes_get(void *data, u64 *val)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map.patch
mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
mm-oom-remove-unnecessary-check-for-null-zonelist.patch
mm-oom-rename-zonelist-locking-functions.patch
mm-close-race-between-do_fault_around-and-fault_around_bytes_set.patch
mm-mark-fault_around_bytes-__read_mostly.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch


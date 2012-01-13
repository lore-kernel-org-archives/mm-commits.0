From: akpm@linux-foundation.org
Subject: [merged] thp-remove-unnecessary-tlb-flush-for-mprotect.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:34:37 -0800
Message-ID: <20120113203438.1B1435C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37836 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab2AMUek (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:34:40 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25396eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:34:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, aarcange@redhat.com, jweiner@redhat.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: remove unnecessary tlb flush for mprotect
has been removed from the -mm tree.  Its filename was
     thp-remove-unnecessary-tlb-flush-for-mprotect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shaohua Li <shaohua.li@intel.com>
Subject: thp: remove unnecessary tlb flush for mprotect

change_protection() will do TLB flush later, don't need duplicate tlb
flush.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/huge_memory.c~thp-remove-unnecessary-tlb-flush-for-mprotect mm/huge_memory.c
--- a/mm/huge_memory.c~thp-remove-unnecessary-tlb-flush-for-mprotect
+++ a/mm/huge_memory.c
@@ -1145,7 +1145,6 @@ int change_huge_pmd(struct vm_area_struc
 			entry = pmd_modify(entry, newprot);
 			set_pmd_at(mm, addr, pmd, entry);
 			spin_unlock(&vma->vm_mm->page_table_lock);
-			flush_tlb_range(vma, addr, addr + HPAGE_PMD_SIZE);
 			ret = 1;
 		}
 	} else
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch


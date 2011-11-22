From: akpm@linux-foundation.org
Subject: + thp-remove-unnecessary-tlb-flush-for-mprotect.patch added to -mm tree
Date: Tue, 22 Nov 2011 15:08:41 -0800
Message-ID: <201111222308.pAMN8gw3018035@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:53893 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab1KVXIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 18:08:45 -0500
Received: by wwe5 with SMTP id 5so28340wwe.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 15:08:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, aarcange@redhat.com, jweiner@redhat.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     Subject: thp: remove unnecessary tlb flush for mprotect
has been added to the -mm tree.  Its filename is
     thp-remove-unnecessary-tlb-flush-for-mprotect.patch

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
Subject: Subject: thp: remove unnecessary tlb flush for mprotect

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
x86-tlb-flush-avoid-superflous-leave_mm.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
thp-improve-order-in-lru-list-for-split-huge-page.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch


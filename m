From: akpm@linux-foundation.org
Subject: +
 mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch added
 to -mm tree
Date: Thu, 22 Jan 2015 12:07:31 -0800
Message-ID: <54c15883.Ly9smTQR8CCtyJsD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbbAVUHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 15:07:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shashim@codeaurora.org, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagewalk: call pte_hole() for VM_PFNMAP during walk_page_range
has been added to the -mm tree.  Its filename is
     mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shiraz Hashim <shashim@codeaurora.org>
Subject: mm: pagewalk: call pte_hole() for VM_PFNMAP during walk_page_range

walk_page_range() silently skips vma having VM_PFNMAP set, which leads to
undesirable behaviour at client end (who called walk_page_range).  For
example for pagemap_read, when no callbacks are called against VM_PFNMAP
vma, pagemap_read may prepare pagemap data for next virtual address range
at wrong index.

Signed-off-by: Shiraz Hashim <shashim@codeaurora.org>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/pagewalk.c~mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range mm/pagewalk.c
--- a/mm/pagewalk.c~mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range
+++ a/mm/pagewalk.c
@@ -199,7 +199,10 @@ int walk_page_range(unsigned long addr, 
 			 */
 			if ((vma->vm_start <= addr) &&
 			    (vma->vm_flags & VM_PFNMAP)) {
-				next = vma->vm_end;
+				if (walk->pte_hole)
+					err = walk->pte_hole(addr, next, walk);
+				if (err)
+					break;
 				pgd = pgd_offset(walk->mm, next);
 				continue;
 			}
_

Patches currently in -mm which might be from shashim@codeaurora.org are

mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch
mm-pagemap-limit-scan-to-virtual-region-being-asked.patch


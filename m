From: akpm@linux-foundation.org
Subject: + thp-fix-comments-of-__pmd_trans_huge_lock.patch added to -mm
 tree
Date: Tue, 21 Jun 2016 16:17:50 -0700
Message-ID: <5769cb1e.+hLCn5AZ87vQIuCK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbcFUXSj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2016 19:18:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix comments of __pmd_trans_huge_lock()
has been added to the -mm tree.  Its filename is
     thp-fix-comments-of-__pmd_trans_huge_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-fix-comments-of-__pmd_trans_huge_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-fix-comments-of-__pmd_trans_huge_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: thp: fix comments of __pmd_trans_huge_lock()

To make the comments consistent with the already changed code.

Link: http://lkml.kernel.org/r/1466200004-6196-1-git-send-email-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~thp-fix-comments-of-__pmd_trans_huge_lock mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-comments-of-__pmd_trans_huge_lock
+++ a/mm/huge_memory.c
@@ -1463,10 +1463,10 @@ int change_huge_pmd(struct vm_area_struc
 }
 
 /*
- * Returns true if a given pmd maps a thp, false otherwise.
+ * Returns page table lock pointer if a given pmd maps a thp, NULL otherwise.
  *
- * Note that if it returns true, this routine returns without unlocking page
- * table lock. So callers must unlock it.
+ * Note that if it returns page table lock pointer, this routine returns without
+ * unlocking page table lock. So callers must unlock it.
  */
 spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma)
 {
_

Patches currently in -mm which might be from ying.huang@intel.com are

thp-fix-comments-of-__pmd_trans_huge_lock.patch


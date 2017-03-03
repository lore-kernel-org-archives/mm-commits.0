From: akpm@linux-foundation.org
Subject: + thp-fix-madv_dontneed-vs-clear-soft-dirty-race.patch added to
 -mm tree
Date: Fri, 03 Mar 2017 14:30:06 -0800
Message-ID: <58b9ee6e.x+xKHW9xdhUvgcM5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37684 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752093AbdCCWbC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 17:31:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix MADV_DONTNEED vs clear soft dirty race
has been added to the -mm tree.  Its filename is
     thp-fix-madv_dontneed-vs-clear-soft-dirty-race.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-fix-madv_dontneed-vs-clear-soft-dirty-race.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-fix-madv_dontneed-vs-clear-soft-dirty-race.patch

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
Subject: thp: fix MADV_DONTNEED vs clear soft dirty race

Yet another instance of the same race.

Fix is identical to change_huge_pmd().

See "thp: fix MADV_DONTNEED vs. numa balancing race" for more details.

Link: http://lkml.kernel.org/r/20170302151034.27829-5-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~thp-fix-madv_dontneed-vs-clear-soft-dirty-race fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~thp-fix-madv_dontneed-vs-clear-soft-dirty-race
+++ a/fs/proc/task_mmu.c
@@ -906,7 +906,14 @@ static inline void clear_soft_dirty(stru
 static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
-	pmd_t pmd = pmdp_huge_get_and_clear(vma->vm_mm, addr, pmdp);
+	pmd_t pmd = *pmdp;
+
+	/* See comment in change_huge_pmd() */
+	pmdp_invalidate(vma, addr, pmdp);
+	if (pmd_dirty(*pmdp))
+		pmd = pmd_mkdirty(pmd);
+	if (pmd_young(*pmdp))
+		pmd = pmd_mkyoung(pmd);
 
 	pmd = pmd_wrprotect(pmd);
 	pmd = pmd_clear_soft_dirty(pmd);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rmap-fix-null-pointer-dereference-on-thp-munlocking.patch
thp-reduce-indentation-level-in-change_huge_pmd.patch
thp-fix-madv_dontneed-vs-numa-balancing-race.patch
thp-fix-madv_dontneed-vs-madv_free-race.patch
thp-fix-madv_dontneed-vs-clear-soft-dirty-race.patch


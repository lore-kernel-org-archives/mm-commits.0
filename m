From: akpm@linux-foundation.org
Subject: [patch 06/11] thp: fix MADV_DONTNEED vs clear soft dirty race
Date: Thu, 13 Apr 2017 14:56:28 -0700
Message-ID: <58eff40c.igr9Xr+W4OtV3cfZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53642 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752336AbdDMV4a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 17:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, aarcange@redhat.com, hillf.zj@alibaba-inc.com, stable@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: fix MADV_DONTNEED vs clear soft dirty race

Yet another instance of the same race.

Fix is identical to change_huge_pmd().

See "thp: fix MADV_DONTNEED vs. numa balancing race" for more details.

Link: http://lkml.kernel.org/r/20170302151034.27829-5-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~thp-fix-madv_dontneed-vs-clear-soft-dirty-race fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~thp-fix-madv_dontneed-vs-clear-soft-dirty-race
+++ a/fs/proc/task_mmu.c
@@ -900,7 +900,14 @@ static inline void clear_soft_dirty(stru
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

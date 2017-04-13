From: akpm@linux-foundation.org
Subject: [patch 03/11] thp: fix MADV_DONTNEED vs. numa balancing race
Date: Thu, 13 Apr 2017 14:56:20 -0700
Message-ID: <58eff404.V9XD9IoJUulzli+F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53612 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751645AbdDMV4V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 17:56:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, aarcange@redhat.com, hillf.zj@alibaba-inc.com, stable@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: fix MADV_DONTNEED vs. numa balancing race

In case prot_numa, we are under down_read(mmap_sem). It's critical
to not clear pmd intermittently to avoid race with MADV_DONTNEED
which is also under down_read(mmap_sem):

	CPU0:				CPU1:
				change_huge_pmd(prot_numa=1)
				 pmdp_huge_get_and_clear_notify()
madvise_dontneed()
 zap_pmd_range()
  pmd_trans_huge(*pmd) == 0 (without ptl)
  // skip the pmd
				 set_pmd_at();
				 // pmd is re-established

The race makes MADV_DONTNEED miss the huge pmd and don't clear it
which may break userspace.

Found by code analysis, never saw triggered.

Link: http://lkml.kernel.org/r/20170302151034.27829-3-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-fix-madv_dontneed-vs-numa-balancing-race mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-madv_dontneed-vs-numa-balancing-race
+++ a/mm/huge_memory.c
@@ -1746,7 +1746,39 @@ int change_huge_pmd(struct vm_area_struc
 	if (prot_numa && pmd_protnone(*pmd))
 		goto unlock;
 
-	entry = pmdp_huge_get_and_clear_notify(mm, addr, pmd);
+	/*
+	 * In case prot_numa, we are under down_read(mmap_sem). It's critical
+	 * to not clear pmd intermittently to avoid race with MADV_DONTNEED
+	 * which is also under down_read(mmap_sem):
+	 *
+	 *	CPU0:				CPU1:
+	 *				change_huge_pmd(prot_numa=1)
+	 *				 pmdp_huge_get_and_clear_notify()
+	 * madvise_dontneed()
+	 *  zap_pmd_range()
+	 *   pmd_trans_huge(*pmd) == 0 (without ptl)
+	 *   // skip the pmd
+	 *				 set_pmd_at();
+	 *				 // pmd is re-established
+	 *
+	 * The race makes MADV_DONTNEED miss the huge pmd and don't clear it
+	 * which may break userspace.
+	 *
+	 * pmdp_invalidate() is required to make sure we don't miss
+	 * dirty/young flags set by hardware.
+	 */
+	entry = *pmd;
+	pmdp_invalidate(vma, addr, pmd);
+
+	/*
+	 * Recover dirty/young flags.  It relies on pmdp_invalidate to not
+	 * corrupt them.
+	 */
+	if (pmd_dirty(*pmd))
+		entry = pmd_mkdirty(entry);
+	if (pmd_young(*pmd))
+		entry = pmd_mkyoung(entry);
+
 	entry = pmd_modify(entry, newprot);
 	if (preserve_write)
 		entry = pmd_mk_savedwrite(entry);
_

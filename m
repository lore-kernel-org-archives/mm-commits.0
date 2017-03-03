From: akpm@linux-foundation.org
Subject: + thp-fix-madv_dontneed-vs-numa-balancing-race.patch added to -mm tree
Date: Fri, 03 Mar 2017 14:30:02 -0800
Message-ID: <58b9ee6a.U3wuNCi7e7/2CHxv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37658 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752004AbdCCWbC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 17:31:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix MADV_DONTNEED vs. numa balancing race
has been added to the -mm tree.  Its filename is
     thp-fix-madv_dontneed-vs-numa-balancing-race.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-fix-madv_dontneed-vs-numa-balancing-race.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-fix-madv_dontneed-vs-numa-balancing-race.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-fix-madv_dontneed-vs-numa-balancing-race mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-madv_dontneed-vs-numa-balancing-race
+++ a/mm/huge_memory.c
@@ -1745,7 +1745,39 @@ int change_huge_pmd(struct vm_area_struc
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

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rmap-fix-null-pointer-dereference-on-thp-munlocking.patch
thp-reduce-indentation-level-in-change_huge_pmd.patch
thp-fix-madv_dontneed-vs-numa-balancing-race.patch
thp-fix-madv_dontneed-vs-madv_free-race.patch
thp-fix-madv_dontneed-vs-clear-soft-dirty-race.patch


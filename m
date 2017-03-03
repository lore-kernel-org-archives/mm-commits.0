From: akpm@linux-foundation.org
Subject: + thp-fix-madv_dontneed-vs-madv_free-race-fix.patch added to -mm
 tree
Date: Fri, 03 Mar 2017 15:09:06 -0800
Message-ID: <58b9f792.fm0efpvlUiet5avU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48326 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbdCCXJV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:09:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-fix-madv_dontneed-vs-madv_free-race-fix
has been added to the -mm tree.  Its filename is
     thp-fix-madv_dontneed-vs-madv_free-race-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-fix-madv_dontneed-vs-madv_free-race-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-fix-madv_dontneed-vs-madv_free-race-fix.patch

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
Subject: thp-fix-madv_dontneed-vs-madv_free-race-fix

Urgh... Power is special again.

Link: http://lkml.kernel.org/r/20170303102636.bhd2zhtpds4mt62a@black.fi.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/huge_memory.c~thp-fix-madv_dontneed-vs-madv_free-race-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-madv_dontneed-vs-madv_free-race-fix
+++ a/mm/huge_memory.c
@@ -1565,6 +1565,7 @@ bool madvise_free_huge_pmd(struct mmu_ga
 	unlock_page(page);
 
 	if (pmd_young(orig_pmd) || pmd_dirty(orig_pmd)) {
+		pmdp_invalidate(vma, addr, pmd);
 		orig_pmd = pmd_mkold(orig_pmd);
 		orig_pmd = pmd_mkclean(orig_pmd);
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rmap-fix-null-pointer-dereference-on-thp-munlocking.patch
thp-fix-another-corner-case-of-munlock-vs-thps.patch
thp-reduce-indentation-level-in-change_huge_pmd.patch
thp-fix-madv_dontneed-vs-numa-balancing-race.patch
thp-fix-madv_dontneed-vs-madv_free-race.patch
thp-fix-madv_dontneed-vs-madv_free-race-fix.patch
thp-fix-madv_dontneed-vs-clear-soft-dirty-race.patch


From: akpm@linux-foundation.org
Subject: +
 madvise_free-thp-fix-madvise_free_huge_pmd-return-value-after-splitting.patch added to -mm tree
Date: Mon, 11 Jul 2016 12:55:41 -0700
Message-ID: <5783f9bd.6KIuqMuG+Qf3/tL7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbcGKTzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 15:55:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, ebru.akagunduz@gmail.com, jmarchan@redhat.com, kirill.shutemov@linux.intel.com, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: madvise_free, thp: fix madvise_free_huge_pmd return value after splitting
has been added to the -mm tree.  Its filename is
     madvise_free-thp-fix-madvise_free_huge_pmd-return-value-after-splitting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/madvise_free-thp-fix-madvise_free_huge_pmd-return-value-after-splitting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/madvise_free-thp-fix-madvise_free_huge_pmd-return-value-after-splitting.patch

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
Subject: madvise_free, thp: fix madvise_free_huge_pmd return value after splitting

madvise_free_huge_pmd should return 0 if the fallback PTE operations are
required.  In madvise_free_huge_pmd, if part pages of THP are discarded,
the THP will be split and fallback PTE operations should be used if
splitting succeeds.  But the original code will make fallback PTE
operations skipped, after splitting succeeds.  Fix that via make
madvise_free_huge_pmd return 0 after splitting successfully, so that the
fallback PTE operations will be done.

Link: http://lkml.kernel.org/r/1467135452-16688-1-git-send-email-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN mm/huge_memory.c~madvise_free-thp-fix-madvise_free_huge_pmd-return-value-after-splitting mm/huge_memory.c
--- a/mm/huge_memory.c~madvise_free-thp-fix-madvise_free_huge_pmd-return-value-after-splitting
+++ a/mm/huge_memory.c
@@ -1624,14 +1624,9 @@ int madvise_free_huge_pmd(struct mmu_gat
 	if (next - addr != HPAGE_PMD_SIZE) {
 		get_page(page);
 		spin_unlock(ptl);
-		if (split_huge_page(page)) {
-			put_page(page);
-			unlock_page(page);
-			goto out_unlocked;
-		}
+		split_huge_page(page);
 		put_page(page);
 		unlock_page(page);
-		ret = 1;
 		goto out_unlocked;
 	}
 
_

Patches currently in -mm which might be from ying.huang@intel.com are

madvise_free-thp-fix-madvise_free_huge_pmd-return-value-after-splitting.patch
thp-fix-comments-of-__pmd_trans_huge_lock.patch
mm-thp-clean-up-return-value-of-madvise_free_huge_pmd.patch


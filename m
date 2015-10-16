From: akpm@linux-foundation.org
Subject: + mm-dont-split-thp-page-when-syscall-is-called-fix-4.patch added to -mm tree
Date: Fri, 16 Oct 2015 15:50:52 -0700
Message-ID: <56217f4c.VqYVn3KiaD92kdNH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbbJPWux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Oct 2015 18:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: dont split thp page when syscall is called fix 4
has been added to the -mm tree.  Its filename is
     mm-dont-split-thp-page-when-syscall-is-called-fix-4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-split-thp-page-when-syscall-is-called-fix-4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-split-thp-page-when-syscall-is-called-fix-4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: dont split thp page when syscall is called fix 4

Compiler gives helpful warnings that madvise_free_pte_range()
has the args to split_huge_pmd() the wrong way round.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/madvise.c~mm-dont-split-thp-page-when-syscall-is-called-fix-4 mm/madvise.c
--- a/mm/madvise.c~mm-dont-split-thp-page-when-syscall-is-called-fix-4
+++ a/mm/madvise.c
@@ -281,7 +281,7 @@ static int madvise_free_pte_range(pmd_t
 	next = pmd_addr_end(addr, end);
 	if (pmd_trans_huge(*pmd)) {
 		if (next - addr != HPAGE_PMD_SIZE)
-			split_huge_pmd(vma, addr, pmd);
+			split_huge_pmd(vma, pmd, addr);
 		else if (!madvise_free_huge_pmd(tlb, vma, pmd, addr))
 			goto next;
 		/* fall through */
_

Patches currently in -mm which might be from hughd@google.com are

memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-4.patch


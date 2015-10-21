From: akpm@linux-foundation.org
Subject: + thp-reintroduce-split_huge_page-fix-2.patch added to -mm tree
Date: Wed, 21 Oct 2015 13:30:38 -0700
Message-ID: <5627f5ee.bI8ese0TmUtlfFBU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbbJUUaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Oct 2015 16:30:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-reintroduce-split_huge_page-fix-2
has been added to the -mm tree.  Its filename is
     thp-reintroduce-split_huge_page-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-reintroduce-split_huge_page-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-reintroduce-split_huge_page-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: thp-reintroduce-split_huge_page-fix-2

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/huge_memory.c~thp-reintroduce-split_huge_page-fix-2 mm/huge_memory.c
--- a/mm/huge_memory.c~thp-reintroduce-split_huge_page-fix-2
+++ a/mm/huge_memory.c
@@ -3038,6 +3038,7 @@ static void unfreeze_page_vma(struct vm_
 			continue;
 
 		entry = pte_mkold(mk_pte(page, vma->vm_page_prot));
+		entry = pte_mkdirty(entry);
 		if (is_write_migration_entry(swp_entry))
 			entry = maybe_mkwrite(entry, vma);
 
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
thp-reintroduce-split_huge_page-fix-2.patch


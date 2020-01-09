From: akpm@linux-foundation.org
Subject: + mm-pagewalk-add-p4d_entry-and-pgd_entry-fix.patch added
 to -mm tree
Date: Thu, 09 Jan 2020 13:20:10 -0800
Message-ID: <20200109212010.iHTCg72Wq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgAIVUL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 16:20:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, jhubbard@nvidia.com, mm-commits@vger.kernel.org, steven.price@arm.com


The patch titled
     Subject: mm: pagewalk: fix unused variable warning
has been added to the -mm tree.  Its filename is
     mm-pagewalk-add-p4d_entry-and-pgd_entry-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pagewalk-add-p4d_entry-and-pgd_entry-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pagewalk-add-p4d_entry-and-pgd_entry-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: pagewalk: fix unused variable warning

One of the pagewalk patches introduced a harmless warning:

mm/hmm.c: In function 'hmm_vma_walk_pud':
mm/hmm.c:478:9: error: unused variable 'pmdp' [-Werror=3Dunused-variable]
  pmd_t *pmdp;
         ^~~~
mm/hmm.c:477:30: error: unused variable 'next' [-Werror=3Dunused-variable=
]
  unsigned long addr =3D start, next;
                              ^~~~

Remove both of the now-unused variables.

Link: http://lkml.kernel.org/r/20200107204607.1533842-1-arnd@arndb.de
Fixes: cb4d03d5fb4c ("mm: pagewalk: add p4d_entry() and pgd_entry()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hmm.c~mm-pagewalk-add-p4d_entry-and-pgd_entry-fix
+++ a/mm/hmm.c
@@ -474,8 +474,7 @@ static int hmm_vma_walk_pud(pud_t *pudp,
 {
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
 	struct hmm_range *range = hmm_vma_walk->range;
-	unsigned long addr = start, next;
-	pmd_t *pmdp;
+	unsigned long addr = start;
 	pud_t pud;
 	int ret = 0;
 	spinlock_t *ptl = pud_trans_huge_lock(pudp, walk->vma);
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-pagewalk-add-p4d_entry-and-pgd_entry-fix.patch

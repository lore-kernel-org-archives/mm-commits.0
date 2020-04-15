From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-build-without-thp.patch added to -mm tree
Date: Wed, 15 Apr 2020 11:41:46 -0700
Message-ID: <20200415184146.hJEYWu8H5%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1416845AbgDOSlr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 14:41:47 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: mm/shmem: fix build without THP
has been added to the -mm tree.  Its filename is
     mm-shmem-fix-build-without-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-fix-build-without-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-fix-build-without-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/shmem: fix build without THP

Some optimizers don't notice that shmem_punch_compound() is always true
(PageTransCompound() being false) without CONFIG_TRANSPARENT_HUGEPAGE=3Dy:
use IS_ENABLED to help them to avoid the BUILD_BUG inside HPAGE_PMD_NR.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2004142339170.10035@eggly.anvils
Fixes: 71725ed10c40 ("mm: huge tmpfs: try to split_huge_page() when punchin=
g hole")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-build-without-thp
+++ a/mm/shmem.c
@@ -952,7 +952,7 @@ static void shmem_undo_range(struct inod
 				VM_BUG_ON_PAGE(PageWriteback(page), page);
 				if (shmem_punch_compound(page, start, end))
 					truncate_inode_page(mapping, page);
-				else {
+				else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 					/* Wipe the page and don't get stuck */
 					clear_highpage(page);
 					flush_dcache_page(page);
_

Patches currently in -mm which might be from hughd@google.com are

mm-shmem-fix-build-without-thp.patch

From: akpm@linux-foundation.org
Subject: +
 mm-migrate-fix-indexing-bug-off-by-one-and-avoid-out-of-bound-access.patch
 added to -mm tree
Date: Mon, 02 Oct 2017 14:39:24 -0700
Message-ID: <59d2b20c.Lnxr8XoLT86whPtq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41080 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751084AbdJBVjZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 17:39:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhairgrove@nvidia.com, jglisse@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix indexing bug (off by one) and avoid out of bound access
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-indexing-bug-off-by-one-and-avoid-out-of-bound-access.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fix-indexing-bug-off-by-one-and-avoid-out-of-bound-access.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fix-indexing-bug-off-by-one-and-avoid-out-of-bound-access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Hairgrove <mhairgrove@nvidia.com>
Subject: mm/migrate: fix indexing bug (off by one) and avoid out of bound access

Index was incremented before last use and thus the second array could
dereference to an invalid address (not mentioning the fact that it did not
properly clear the entry we intended to clear).

Link: http://lkml.kernel.org/r/1506973525-16491-1-git-send-email-jglisse@redhat.com
Fixes: 8315ada7f095bf ("mm/migrate: allow migrate_vma() to alloc new page on empty entry")
Signed-off-by: Mark Hairgrove <mhairgrove@nvidia.com>
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migrate-fix-indexing-bug-off-by-one-and-avoid-out-of-bound-access mm/migrate.c
--- a/mm/migrate.c~mm-migrate-fix-indexing-bug-off-by-one-and-avoid-out-of-bound-access
+++ a/mm/migrate.c
@@ -2146,8 +2146,9 @@ static int migrate_vma_collect_hole(unsi
 	unsigned long addr;
 
 	for (addr = start & PAGE_MASK; addr < end; addr += PAGE_SIZE) {
-		migrate->src[migrate->npages++] = MIGRATE_PFN_MIGRATE;
+		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
 		migrate->dst[migrate->npages] = 0;
+		migrate->npages++;
 		migrate->cpages++;
 	}
 
_

Patches currently in -mm which might be from mhairgrove@nvidia.com are

mm-migrate-fix-indexing-bug-off-by-one-and-avoid-out-of-bound-access.patch


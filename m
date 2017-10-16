From: akpm@linux-foundation.org
Subject: [merged]
 mm-migrate-fix-indexing-bug-off-by-one-and-avoid-out-of-bound-access.patch
 removed from -mm tree
Date: Mon, 16 Oct 2017 12:55:09 -0700
Message-ID: <20171016195509.hB2Ih4rCh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55480 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753995AbdJPTzL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 15:55:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, jglisse@redhat.com, mhairgrove@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix indexing bug (off by one) and avoid out of bound access
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-indexing-bug-off-by-one-and-avoid-out-of-bound-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
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



From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix.patch
 added to -mm tree
Date: Thu, 21 May 2020 12:00:18 -0700
Message-ID: <20200521190018.4NDRD7bXn%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729555AbgEUTAT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 May 2020 15:00:19 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix
has been added to the -mm tree.  Its filename is
     mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix.patch

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
Subject: mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix

Fix 5.7-rc6-mm1 page migration crash in unmap_and_move(): when the
page to be migrated has been freed from under us, that is considered
a MIGRATEPAGE_SUCCESS, but no newpage has been allocated (and I don't
think it would ever need to be counted as a successful THP migration).

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2005210643340.482@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix
+++ a/mm/migrate.c
@@ -1248,7 +1248,7 @@ out:
 	 * we want to retry.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		if (PageTransHuge(newpage))
+		if (newpage && PageTransHuge(newpage))
 			thp_migration_success(true);
 		put_page(page);
 		if (reason == MR_MEMORY_FAILURE) {
_

Patches currently in -mm which might be from hughd@google.com are

mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix.patch

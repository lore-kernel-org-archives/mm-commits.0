From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-vmstat-add-events-for-thp-migration-without-split-fix.patch added to -mm
 tree
Date: Wed, 08 Jul 2020 19:04:04 -0700
Message-ID: <20200709020404.Jj8p7XNn0%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgGICEG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 22:04:06 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, daniel.m.jordan@oracle.com, hughd@google.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, willy@infradead.org, ziy@nvidia.com


The patch titled
     Subject: mm-vmstat-add-events-for-thp-migration-without-split-fix
has been added to the -mm tree.  Its filename is
     mm-vmstat-add-events-for-thp-migration-without-split-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-add-events-for-thp-migration-without-split-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmstat-add-events-for-thp-migration-without-split-fix

s/hpage_nr_pages/thp_nr_pages/ due to "mm: replace hpage_nr_pages with
thp_nr_pages".

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-vmstat-add-events-for-thp-migration-without-split-fix
+++ a/mm/migrate.c
@@ -1446,7 +1446,7 @@ retry:
 			 * during migration.
 			 */
 			is_thp = PageTransHuge(page);
-			thp_nr_pages = hpage_nr_pages(page);
+			thp_nr_pages = thp_nr_pages(page);
 			cond_resched();
 
 			if (PageHuge(page))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

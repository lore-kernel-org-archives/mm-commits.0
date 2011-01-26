From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-dont-depend-on-hugetlb_page.patch removed from -mm tree
Date: Wed, 26 Jan 2011 12:32:42 -0800
Message-ID: <201101262032.p0QKWg5n003212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161Ab1AZUcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 15:32:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, kronos.it@gmail.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: compaction: don't depend on HUGETLB_PAGE
has been removed from the -mm tree.  Its filename was
     mm-compaction-dont-depend-on-hugetlb_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: don't depend on HUGETLB_PAGE
From: Andrea Arcangeli <aarcange@redhat.com>

5d6892407 ("thp: select CONFIG_COMPACTION if TRANSPARENT_HUGEPAGE
enabled") causes this warning during the configuration process:

  warning: (TRANSPARENT_HUGEPAGE) selects COMPACTION which has unmet
  direct dependencies (EXPERIMENTAL && HUGETLB_PAGE && MMU)

COMPACTION doesn't depend on HUGETLB_PAGE, it doesn't depend on THP
either, it is also useful for regular alloc_pages(order > 0) including the
very kernel stack during fork (THREAD_ORDER = 1).  It's always better to
enable COMPACTION.

The warning should be an error because we would end up with MIGRATION not
selected, and COMPACTION wouldn't work without migration (despite it seems
to build with an inline migrate_pages returning -ENOSYS).

I'd also like to remove EXPERIMENTAL: compaction has been in the kernel
for some releases (for full safety the default remains disabled which I
think is enough).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Luca Tettamanti <kronos.it@gmail.com>
Tested-by: Luca Tettamanti <kronos.it@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~mm-compaction-dont-depend-on-hugetlb_page mm/Kconfig
--- a/mm/Kconfig~mm-compaction-dont-depend-on-hugetlb_page
+++ a/mm/Kconfig
@@ -179,7 +179,7 @@ config SPLIT_PTLOCK_CPUS
 config COMPACTION
 	bool "Allow for memory compaction"
 	select MIGRATION
-	depends on EXPERIMENTAL && HUGETLB_PAGE && MMU
+	depends on MMU
 	help
 	  Allows the compaction of memory for the allocation of huge pages.
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch


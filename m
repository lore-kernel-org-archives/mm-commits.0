From: akpm@linux-foundation.org
Subject: + mm-compaction-dont-depend-on-hugetlb_page.patch added to -mm tree
Date: Mon, 24 Jan 2011 13:43:57 -0800
Message-ID: <201101242143.p0OLhvlx012191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301Ab1AXVoM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 16:44:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, kronos.it@gmail.com, mel@csn.ul.ie


The patch titled
     mm: compaction: don't depend on HUGETLB_PAGE
has been added to the -mm tree.  Its filename is
     mm-compaction-dont-depend-on-hugetlb_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

thp-fix-paravirt-x86-32bit-nopae.patch
mm-compaction-dont-depend-on-hugetlb_page.patch


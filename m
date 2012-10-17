From: akpm@linux-foundation.org
Subject: + mm-compaction-correct-the-nr_strict_isolated-check-for-cma.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:17:16 -0700
Message-ID: <20121017231716.C751D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:33988 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab2JQXRS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:17:18 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so1006757ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:17:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, arnd@arndb.de, avi@redhat.com, linux@prisktech.co.nz, minchan@kernel.org, richard@arachsys.com, riel@redhat.com, shli@kernel.org, thierry.reding@avionic-design.de


The patch titled
     Subject: mm: compaction: correct the nr_strict va isolated check for CMA
has been added to the -mm tree.  Its filename is
     mm-compaction-correct-the-nr_strict_isolated-check-for-cma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: correct the nr_strict va isolated check for CMA

Thierry reported that the "iron out" patch for isolate_freepages_block()
had problems due to the strict check being too strict with "mm:
compaction: Iron out isolate_freepages_block() and
isolate_freepages_range() -fix1".  It's possible that more pages than
necessary are isolated but the check still fails and I missed that this
fix was not picked up before RC1.  This same problem has been identified
in 3.7-RC1 by Tony Prisk and should be addressed by the following patch.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Tested-by: Tony Prisk <linux@prisktech.co.nz>
Reported-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Richard Davies <richard@arachsys.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-correct-the-nr_strict_isolated-check-for-cma mm/compaction.c
--- a/mm/compaction.c~mm-compaction-correct-the-nr_strict_isolated-check-for-cma
+++ a/mm/compaction.c
@@ -346,7 +346,7 @@ static unsigned long isolate_freepages_b
 	 * pages requested were isolated. If there were any failures, 0 is
 	 * returned and CMA will fail.
 	 */
-	if (strict && nr_strict_required != total_isolated)
+	if (strict && nr_strict_required > total_isolated)
 		total_isolated = 0;
 
 	if (locked)
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-compaction-correct-the-nr_strict_isolated-check-for-cma.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-only-in-direct-reclaim.patch


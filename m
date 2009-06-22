From: akpm@linux-foundation.org
Subject: + mm-fix-handling-of-pagesets-for-downed-cpus.patch added to -mm tree
Date: Mon, 22 Jun 2009 11:39:52 -0700
Message-ID: <200906221839.n5MIdqBU017463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbZFVSlg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 14:41:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sivanich@sgi.com, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, stable@kernel.org


The patch titled
     mm: fix handling of pagesets for downed cpus
has been added to the -mm tree.  Its filename is
     mm-fix-handling-of-pagesets-for-downed-cpus.patch

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
Subject: mm: fix handling of pagesets for downed cpus
From: Dimitri Sivanich <sivanich@sgi.com>

After downing/upping a cpu, an attempt to set
/proc/sys/vm/percpu_pagelist_fraction results in an oops in
percpu_pagelist_fraction_sysctl_handler().

If a processor is downed then we need to set the pageset pointer back to
the boot pageset.

Updates of the high water marks should not access pagesets of unpopulated
zones (those pointer go to the boot pagesets which would be no longer
functional if their size would be increased beyond zero).

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-handling-of-pagesets-for-downed-cpus mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-handling-of-pagesets-for-downed-cpus
+++ a/mm/page_alloc.c
@@ -3026,7 +3026,7 @@ bad:
 		if (dzone == zone)
 			break;
 		kfree(zone_pcp(dzone, cpu));
-		zone_pcp(dzone, cpu) = NULL;
+		zone_pcp(dzone, cpu) = &boot_pageset[cpu];
 	}
 	return -ENOMEM;
 }
@@ -3041,7 +3041,7 @@ static inline void free_zone_pagesets(in
 		/* Free per_cpu_pageset if it is slab allocated */
 		if (pset != &boot_pageset[cpu])
 			kfree(pset);
-		zone_pcp(zone, cpu) = NULL;
+		zone_pcp(zone, cpu) = &boot_pageset[cpu];
 	}
 }
 
@@ -4659,7 +4659,7 @@ int percpu_pagelist_fraction_sysctl_hand
 	ret = proc_dointvec_minmax(table, write, file, buffer, length, ppos);
 	if (!write || (ret == -EINVAL))
 		return ret;
-	for_each_zone(zone) {
+	for_each_populated_zone(zone) {
 		for_each_online_cpu(cpu) {
 			unsigned long  high;
 			high = zone->present_pages / percpu_pagelist_fraction;
_

Patches currently in -mm which might be from sivanich@sgi.com are

mm-fix-handling-of-pagesets-for-downed-cpus.patch


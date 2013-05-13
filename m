From: akpm@linux-foundation.org
Subject: + mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch added to -mm tree
Date: Mon, 13 May 2013 14:11:53 -0700
Message-ID: <20130513211153.D5C535A40E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:57455 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3EMVL4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 17:11:56 -0400
Received: by mail-yh0-f74.google.com with SMTP id t59so655900yho.5
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 14:11:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com, gilad@benyossef.com, kosaki.motohiro@gmail.com, mgorman@suse.de, penberg@kernel.org


The patch titled
     Subject: mm/page_alloc: when handling percpu_pagelist_fraction, don't unneedly recalulate high
has been added to the -mm tree.  Its filename is
     mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/page_alloc: when handling percpu_pagelist_fraction, don't unneedly recalulate high

Simply moves calculation of the new 'high' value outside the
for_each_possible_cpu() loop, as it does not depend on the cpu.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high
+++ a/mm/page_alloc.c
@@ -5575,7 +5575,6 @@ int lowmem_reserve_ratio_sysctl_handler(
  * cpu.  It is the fraction of total pages in each zone that a hot per cpu pagelist
  * can have before it gets flushed back to buddy allocator.
  */
-
 int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
@@ -5589,12 +5588,11 @@ int percpu_pagelist_fraction_sysctl_hand
 
 	mutex_lock(&pcp_batch_high_lock);
 	for_each_populated_zone(zone) {
-		for_each_possible_cpu(cpu) {
-			unsigned long  high;
-			high = zone->managed_pages / percpu_pagelist_fraction;
+		unsigned long  high;
+		high = zone->managed_pages / percpu_pagelist_fraction;
+		for_each_possible_cpu(cpu)
 			setup_pagelist_highmark(
-				per_cpu_ptr(zone->pageset, cpu), high);
-		}
+					per_cpu_ptr(zone->pageset, cpu), high);
 	}
 	mutex_unlock(&pcp_batch_high_lock);
 	return 0;
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch
mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch
mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch
mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch
mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch
mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch
mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch
mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch
mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch
mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch
mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch


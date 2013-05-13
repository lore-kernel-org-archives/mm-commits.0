From: akpm@linux-foundation.org
Subject: + mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch added to -mm tree
Date: Mon, 13 May 2013 14:11:45 -0700
Message-ID: <20130513211145.D9FDD5A40E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:34807 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3EMVLr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 17:11:47 -0400
Received: by mail-vb0-f74.google.com with SMTP id q16so654204vbe.3
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 14:11:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com, gilad@benyossef.com, kosaki.motohiro@gmail.com, mgorman@suse.de, penberg@kernel.org


The patch titled
     Subject: mm/page_alloc: prevent concurrent updaters of pcp ->batch and ->high
has been added to the -mm tree.  Its filename is
     mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch

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
Subject: mm/page_alloc: prevent concurrent updaters of pcp ->batch and ->high

Because we are going to rely upon a careful transision between old and new
->high and ->batch values using memory barriers and will remove
stop_machine(), we need to prevent multiple updaters from interweaving
their memory writes.

Add a simple mutex to protect both update loops.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high
+++ a/mm/page_alloc.c
@@ -65,6 +65,9 @@
 #include <asm/div64.h>
 #include "internal.h"
 
+/* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
+static DEFINE_MUTEX(pcp_batch_high_lock);
+
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
@@ -5557,6 +5560,8 @@ int percpu_pagelist_fraction_sysctl_hand
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
 	if (!write || (ret < 0))
 		return ret;
+
+	mutex_lock(&pcp_batch_high_lock);
 	for_each_populated_zone(zone) {
 		for_each_possible_cpu(cpu) {
 			unsigned long  high;
@@ -5565,6 +5570,7 @@ int percpu_pagelist_fraction_sysctl_hand
 				per_cpu_ptr(zone->pageset, cpu), high);
 		}
 	}
+	mutex_unlock(&pcp_batch_high_lock);
 	return 0;
 }
 
@@ -6078,7 +6084,9 @@ static int __meminit __zone_pcp_update(v
 
 void __meminit zone_pcp_update(struct zone *zone)
 {
+	mutex_lock(&pcp_batch_high_lock);
 	stop_machine(__zone_pcp_update, zone, NULL);
+	mutex_unlock(&pcp_batch_high_lock);
 }
 #endif
 
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


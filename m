From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reset-numa-stats-for-boot-pagesets-v3.patch added to
 -mm tree
Date: Mon, 11 May 2020 12:08:51 -0700
Message-ID: <20200511190851.mnIeg5-2p%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730974AbgEKTIw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 15:08:52 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, khlebnikov@yandex-team.ru, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org, sandipan@linux.ibm.com, vbabka@suse.cz


The patch titled
     Subject: mm-reset-numa-stats-for-boot-pagesets-v3
has been added to the -mm tree.  Its filename is
     mm-reset-numa-stats-for-boot-pagesets-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-reset-numa-stats-for-boot-pagesets-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-reset-numa-stats-for-boot-pagesets-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sandipan Das <sandipan@linux.ibm.com>
Subject: mm-reset-numa-stats-for-boot-pagesets-v3

Drop the redundant static key-based check to see if numa stats are enabled
as suggested by Vlastimil.

Link: http://lkml.kernel.org/r/20200511170356.162531-1-sandipan@linux.ibm.com
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

--- a/mm/page_alloc.c~mm-reset-numa-stats-for-boot-pagesets-v3
+++ a/mm/page_alloc.c
@@ -6242,26 +6242,22 @@ void __init setup_per_cpu_pageset(void)
 {
 	struct pglist_data *pgdat;
 	struct zone *zone;
+	int __maybe_unused cpu;
 
 	for_each_populated_zone(zone)
 		setup_zone_pageset(zone);
 
 #ifdef CONFIG_NUMA
-	if (static_branch_likely(&vm_numa_stat_key)) {
-		struct per_cpu_pageset *pcp;
-		int cpu;
-
-		/*
-		 * Unpopulated zones continue using the boot pagesets.
-		 * The numa stats for these pagesets need to be reset.
-		 * Otherwise, they will end up skewing the stats of
-		 * the nodes these zones are associated with.
-		 */
-		for_each_possible_cpu(cpu) {
-			pcp = &per_cpu(boot_pageset, cpu);
-			memset(pcp->vm_numa_stat_diff, 0,
-			       sizeof(pcp->vm_numa_stat_diff));
-		}
+	/*
+	 * Unpopulated zones continue using the boot pagesets.
+	 * The numa stats for these pagesets need to be reset.
+	 * Otherwise, they will end up skewing the stats of
+	 * the nodes these zones are associated with.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_pageset *pcp = &per_cpu(boot_pageset, cpu);
+		memset(pcp->vm_numa_stat_diff, 0,
+		       sizeof(pcp->vm_numa_stat_diff));
 	}
 #endif
 
_

Patches currently in -mm which might be from sandipan@linux.ibm.com are

mm-reset-numa-stats-for-boot-pagesets.patch
mm-reset-numa-stats-for-boot-pagesets-v3.patch
selftests-vm-pkeys-use-sane-types-for-pkey-register.patch
selftests-vm-pkeys-add-helpers-for-pkey-bits.patch
selftests-vm-pkeys-use-the-correct-huge-page-size.patch
selftests-vm-pkeys-introduce-powerpc-support-fix.patch
selftests-vm-pkeys-override-access-right-definitions-on-powerpc-fix.patch
selftests-vm-pkeys-use-the-correct-page-size-on-powerpc.patch
selftests-vm-pkeys-fix-multilib-builds-for-x86.patch

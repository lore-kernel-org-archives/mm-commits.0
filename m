From: akpm@linux-foundation.org
Subject: [merged] mm-fix-division-by-0-in-percpu_pagelist_fraction.patch removed from -mm tree
Date: Wed, 16 May 2012 11:46:49 -0700
Message-ID: <20120516184649.74484A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:61458 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760093Ab2EPSqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 14:46:50 -0400
Received: by vcbfl13 with SMTP id fl13so9184vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 11:46:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: levinsasha928@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix division by 0 in percpu_pagelist_fraction()
has been removed from the -mm tree.  Its filename was
     mm-fix-division-by-0-in-percpu_pagelist_fraction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sasha Levin <levinsasha928@gmail.com>
Subject: mm: fix division by 0 in percpu_pagelist_fraction()

percpu_pagelist_fraction_sysctl_handler() has only considered -EINVAL as a
possible error from proc_dointvec_minmax().  If any other error is
returned, it would proceed to divide by zero since
percpu_pagelist_fraction wasn't getting initialized at any point.  For
example, writing 0 bytes into the proc file would trigger the issue.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-division-by-0-in-percpu_pagelist_fraction mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-division-by-0-in-percpu_pagelist_fraction
+++ a/mm/page_alloc.c
@@ -105,7 +105,7 @@ unsigned long totalreserve_pages __read_
  */
 unsigned long dirty_balance_reserve __read_mostly;
 
-int percpu_pagelist_fraction;
+int percpu_pagelist_fraction = 8;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
 #ifdef CONFIG_PM_SLEEP
@@ -5203,7 +5203,7 @@ int percpu_pagelist_fraction_sysctl_hand
 	int ret;
 
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (!write || (ret == -EINVAL))
+	if (!write || (ret < 0))
 		return ret;
 	for_each_populated_zone(zone) {
 		for_each_possible_cpu(cpu) {
_

Patches currently in -mm which might be from levinsasha928@gmail.com are

linux-next.patch
fs-proc-fix-abba-deadlock-in-case-of-execution-attempt-of-map_files-entries.patch
locking-add-kern_cont-when-needed-to-self-test.patch
x86-nmi-add-missing-kern_cont-to-nmi-selftest.patch
isdn-add-missing-kern_cont.patch
isdn-add-missing-kern_cont-fix.patch
ipc-mqueue-improve-performance-of-send-recv-use-correct-gfp-flags-in-msg_insert.patch


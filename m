From: akpm@linux-foundation.org
Subject: + mm-fix-division-by-0-in-percpu_pagelist_fraction.patch added to -mm tree
Date: Mon, 30 Apr 2012 15:42:32 -0700
Message-ID: <20120430224232.B64DDA00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:34704 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756603Ab2D3Wmf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2012 18:42:35 -0400
Received: by laai8 with SMTP id i8so170165laa.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 15:42:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: levinsasha928@gmail.com, minchan@kernel.org


The patch titled
     Subject: mm: fix division by 0 in percpu_pagelist_fraction()
has been added to the -mm tree.  Its filename is
     mm-fix-division-by-0-in-percpu_pagelist_fraction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -106,7 +106,7 @@ unsigned long totalreserve_pages __read_
  */
 unsigned long dirty_balance_reserve __read_mostly;
 
-int percpu_pagelist_fraction;
+int percpu_pagelist_fraction = 8;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
 #ifdef CONFIG_PM_SLEEP
@@ -5271,7 +5271,7 @@ int percpu_pagelist_fraction_sysctl_hand
 	int ret;
 
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (!write || (ret == -EINVAL))
+	if (!write || (ret < 0))
 		return ret;
 	for_each_populated_zone(zone) {
 		for_each_possible_cpu(cpu) {
_
Subject: Subject: mm: fix division by 0 in percpu_pagelist_fraction()

Patches currently in -mm which might be from levinsasha928@gmail.com are

linux-next.patch
mm-fix-division-by-0-in-percpu_pagelist_fraction.patch
brlocks-lglocks-cleanups.patch


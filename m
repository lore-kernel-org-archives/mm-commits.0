From: akpm@linux-foundation.org
Subject: [merged] mm-vmscanc-try_to_freeze-returns-boolean.patch removed from -mm tree
Date: Wed, 12 Dec 2012 12:00:46 -0800
Message-ID: <20121212200047.07ADA820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:46538 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2LLUAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:00:47 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so118273vcd.3
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:00:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff.liu@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: try_to_freeze() returns boolean
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-try_to_freeze-returns-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Liu <jeff.liu@oracle.com>
Subject: mm/vmscan.c: try_to_freeze() returns boolean

kswapd()->try_to_freeze() is defined to return a boolean, so it's better
to use a bool to hold its return value.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscanc-try_to_freeze-returns-boolean mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscanc-try_to_freeze-returns-boolean
+++ a/mm/vmscan.c
@@ -2963,7 +2963,7 @@ static int kswapd(void *p)
 	classzone_idx = new_classzone_idx = pgdat->nr_zones - 1;
 	balanced_classzone_idx = classzone_idx;
 	for ( ; ; ) {
-		int ret;
+		bool ret;
 
 		/*
 		 * If the last balance_pgdat was unsuccessful it's unlikely a
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

origin.patch
tmpfs-support-seek_data-and-seek_hole-reprise.patch
linux-next.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch


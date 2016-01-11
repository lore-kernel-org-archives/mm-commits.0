From: akpm@linux-foundation.org
Subject: + mm-oom-introduce-oom-reaper-v4.patch added to -mm tree
Date: Mon, 11 Jan 2016 14:55:21 -0800
Message-ID: <569432d9.8kBG/ac9dJ23EJQF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553AbcAKWzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 17:55:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-introduce-oom-reaper-v4
has been added to the -mm tree.  Its filename is
     mm-oom-introduce-oom-reaper-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-introduce-oom-reaper-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-introduce-oom-reaper-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm-oom-introduce-oom-reaper-v4

- use subsys_initcall instead of module_init - Paul Gortmaker

Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-introduce-oom-reaper-v4 mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-introduce-oom-reaper-v4
+++ a/mm/oom_kill.c
@@ -32,12 +32,11 @@
 #include <linux/mempolicy.h>
 #include <linux/security.h>
 #include <linux/ptrace.h>
-#include <linux/delay.h>
 #include <linux/freezer.h>
 #include <linux/ftrace.h>
 #include <linux/ratelimit.h>
 #include <linux/kthread.h>
-#include <linux/module.h>
+#include <linux/init.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -542,7 +541,7 @@ static int __init oom_init(void)
 	}
 	return 0;
 }
-module_init(oom_init)
+subsys_initcall(oom_init)
 #else
 static void wake_oom_reaper(struct mm_struct *mm)
 {
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-get-rid-of-__alloc_pages_high_priority.patch
mm-do-not-loop-over-alloc_no_watermarks-without-triggering-reclaim.patch
mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages.patch
mm-allow-gfp_iofs-for-page_cache_read-page-cache-allocation.patch
mm-oom-give-__gfp_nofail-allocations-access-to-memory-reserves.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch
mm-oom-introduce-oom-reaper.patch
mm-oom-introduce-oom-reaper-v4.patch


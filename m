From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-oom-introduce-oom-reaper-v4.patch removed from -mm tree
Date: Wed, 03 Feb 2016 15:12:50 -0800
Message-ID: <56b28972.DRlSgj1UtoD53FTA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbcBCXMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 18:12:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-introduce-oom-reaper-v4
has been removed from the -mm tree.  Its filename was
     mm-oom-introduce-oom-reaper-v4.patch

This patch was dropped because an updated version will be merged

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
@@ -543,7 +542,7 @@ static int __init oom_init(void)
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

mm-vmstat-make-quiet_vmstat-lighter.patch
vmstat-make-vmstat_update-deferrable.patch
mm-vmscan-make-zone_reclaimable_pages-more-precise.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch
oom-reaper-handle-anonymous-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch


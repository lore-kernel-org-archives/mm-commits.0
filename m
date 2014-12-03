From: akpm@linux-foundation.org
Subject: [merged]
 mm-do-not-overwrite-reserved-pages-counter-at-show_mem.patch removed from
 -mm tree
Date: Wed, 03 Dec 2014 13:29:30 -0800
Message-ID: <547f80ba.sjlFgwrw+N0MSSOm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaLCV3b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2014 16:29:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jweiner@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not overwrite reserved pages counter at show_mem()
has been removed from the -mm tree.  Its filename was
     mm-do-not-overwrite-reserved-pages-counter-at-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm: do not overwrite reserved pages counter at show_mem()

Minor fixlet to perform the reserved pages counter aggregation for each
node, at show_mem()

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/show_mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/show_mem.c~mm-do-not-overwrite-reserved-pages-counter-at-show_mem lib/show_mem.c
--- a/lib/show_mem.c~mm-do-not-overwrite-reserved-pages-counter-at-show_mem
+++ a/lib/show_mem.c
@@ -28,7 +28,7 @@ void show_mem(unsigned int filter)
 				continue;
 
 			total += zone->present_pages;
-			reserved = zone->present_pages - zone->managed_pages;
+			reserved += zone->present_pages - zone->managed_pages;
 
 			if (is_highmem_idx(zoneid))
 				highmem += zone->present_pages;
_

Patches currently in -mm which might be from aquini@redhat.com are

origin.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-semc-increase-semmsl-semmni-semopm.patch
ipc-msg-increase-msgmni-remove-scaling.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch


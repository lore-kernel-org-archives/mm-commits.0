From: akpm@linux-foundation.org
Subject: - add-debugging-feature-proc-timer_stat-cleanup.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:18:08 -0800
Message-ID: <200702160818.l1G8I8Zl024330@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59648 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966196AbXBPIV1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:21:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     make kernel/time/timer_stats.c:nr_entries static
has been removed from the -mm tree.  Its filename was
     add-debugging-feature-proc-timer_stat-cleanup.patch

This patch was dropped because it was folded into add-debugging-feature-proc-timer_stat.patch

------------------------------------------------------
Subject: make kernel/time/timer_stats.c:nr_entries static
From: Adrian Bunk <bunk@stusta.de>

nr_entries can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_stats.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/timer_stats.c~add-debugging-feature-proc-timer_stat-cleanup kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c~add-debugging-feature-proc-timer_stat-cleanup
+++ a/kernel/time/timer_stats.c
@@ -112,7 +112,7 @@ static ktime_t time_start, time_stop;
 #define MAX_ENTRIES_BITS	10
 #define MAX_ENTRIES		(1UL << MAX_ENTRIES_BITS)
 
-unsigned long nr_entries;
+static unsigned long nr_entries;
 static struct entry entries[MAX_ENTRIES];
 
 static atomic_t overflow_count;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
correct-config_gigaset_m101-makefile-entry.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_stat-cleanup.patch

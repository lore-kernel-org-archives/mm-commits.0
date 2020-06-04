From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-page=5Fallocc-only-tune-sysctl=5Flowmem=5Freserve=5Frat?=
 =?US-ASCII?Q?io-value-once-when-changing-it.patch?= removed from -mm tree
Date: Thu, 04 Jun 2020 10:18:00 -0700
Message-ID: <20200604171800.1rCSmtv-o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729999AbgFDRSB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:18:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org, rientjes@google.com


The patch titled
     Subject: mm/page_alloc.c: only tune sysctl_lowmem_reserve_ratio value once when changing it
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-only-tune-sysctl_lowmem_reserve_ratio-value-once-when-changing-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/page_alloc.c: only tune sysctl_lowmem_reserve_ratio value once when changing it

Patch series "improvements about lowmem_reserve and /proc/zoneinfo", v2.


This patch (of 3):

When people write to /proc/sys/vm/lowmem_reserve_ratio to change
sysctl_lowmem_reserve_ratio[], setup_per_zone_lowmem_reserve() is called
to recalculate all ->lowmem_reserve[] for each zone of all nodes as below:

static void setup_per_zone_lowmem_reserve(void)
{
...
	for_each_online_pgdat(pgdat) {
		for (j = 0; j < MAX_NR_ZONES; j++) {
			...
			while (idx) {
				...
				if (sysctl_lowmem_reserve_ratio[idx] < 1) {
					sysctl_lowmem_reserve_ratio[idx] = 0;
					lower_zone->lowmem_reserve[j] = 0;
                                } else {
				...
			}
		}
	}
}

Meanwhile, here, sysctl_lowmem_reserve_ratio[idx] will be tuned if its
value is smaller than '1'.  As we know, sysctl_lowmem_reserve_ratio[] is
set for zone without regarding to which node it belongs to.  That means
the tuning will be done on all nodes, even though it has been done in the
first node.

And the tuning will be done too even when init_per_zone_wmark_min() calls
setup_per_zone_lowmem_reserve(), where actually nobody tries to change
sysctl_lowmem_reserve_ratio[].

So now move the tuning into lowmem_reserve_ratio_sysctl_handler(), to make
code logic more reasonable.

Link: http://lkml.kernel.org/r/20200402140113.3696-1-bhe@redhat.com
Link: http://lkml.kernel.org/r/20200402140113.3696-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-only-tune-sysctl_lowmem_reserve_ratio-value-once-when-changing-it
+++ a/mm/page_alloc.c
@@ -7704,8 +7704,7 @@ static void setup_per_zone_lowmem_reserv
 				idx--;
 				lower_zone = pgdat->node_zones + idx;
 
-				if (sysctl_lowmem_reserve_ratio[idx] < 1) {
-					sysctl_lowmem_reserve_ratio[idx] = 0;
+				if (!sysctl_lowmem_reserve_ratio[idx]) {
 					lower_zone->lowmem_reserve[j] = 0;
 				} else {
 					lower_zone->lowmem_reserve[j] =
@@ -7970,7 +7969,15 @@ int sysctl_min_slab_ratio_sysctl_handler
 int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
+	int i;
+
 	proc_dointvec_minmax(table, write, buffer, length, ppos);
+
+	for (i = 0; i < MAX_NR_ZONES; i++) {
+		if (sysctl_lowmem_reserve_ratio[i] < 1)
+			sysctl_lowmem_reserve_ratio[i] = 0;
+	}
+
 	setup_per_zone_lowmem_reserve();
 	return 0;
 }
_

Patches currently in -mm which might be from bhe@redhat.com are

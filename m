From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-page=5Fallocc-only-tune-sysctl=5Flowmem=5Freserve=5Frat?=
 =?US-ASCII?Q?io-value-once-when-changing-it.patch?= added to -mm tree
Date: Wed, 15 Apr 2020 20:52:20 -0700
Message-ID: <20200416035220.lnv99pHhY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403807AbgDPDwX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 23:52:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org, rientjes@google.com


The patch titled
     Subject: mm/page_alloc.c: only tune sysctl_lowmem_reserve_ratio value once when changing it
has been added to the -mm tree.  Its filename is
     mm-page_allocc-only-tune-sysctl_lowmem_reserve_ratio-value-once-when-changing-it.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-only-tune-sysctl_lowmem_reserve_ratio-value-once-when-changing-it.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-only-tune-sysctl_lowmem_reserve_ratio-value-once-when-changing-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -7702,8 +7702,7 @@ static void setup_per_zone_lowmem_reserv
 				idx--;
 				lower_zone = pgdat->node_zones + idx;
 
-				if (sysctl_lowmem_reserve_ratio[idx] < 1) {
-					sysctl_lowmem_reserve_ratio[idx] = 0;
+				if (!sysctl_lowmem_reserve_ratio[idx]) {
 					lower_zone->lowmem_reserve[j] = 0;
 				} else {
 					lower_zone->lowmem_reserve[j] =
@@ -7968,7 +7967,15 @@ int sysctl_min_slab_ratio_sysctl_handler
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

mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn.patch
mm-remove-unused-free_bootmem_with_active_regions.patch
mm-page_allocc-only-tune-sysctl_lowmem_reserve_ratio-value-once-when-changing-it.patch
mm-page_allocc-clear-out-zone-lowmem_reserve-if-the-zone-is-empty.patch
mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone.patch

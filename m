From: akpm@linux-foundation.org
Subject: +
 mm-initialise-per_cpu_nodestats-for-all-online-pgdats-at-boot.patch added
 to -mm tree
Date: Thu, 04 Aug 2016 13:11:22 -0700
Message-ID: <57a3a16a.vnFhL4pBBPHG2Iqi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965116AbcHDULX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 16:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, arbab@linux.vnet.ibm.com, paulus@ozlabs.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: initialise per_cpu_nodestats for all online pgdats at boot
has been added to the -mm tree.  Its filename is
     mm-initialise-per_cpu_nodestats-for-all-online-pgdats-at-boot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-initialise-per_cpu_nodestats-for-all-online-pgdats-at-boot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-initialise-per_cpu_nodestats-for-all-online-pgdats-at-boot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: initialise per_cpu_nodestats for all online pgdats at boot

Paul Mackerras and Reza Arbab reported that machines with memoryless nodes
fail when vmstats are refreshed.  Paul reported an oops as follows

[    1.713998] Unable to handle kernel paging request for data at address 0xff7a10000
[    1.714164] Faulting instruction address: 0xc000000000270cd0
[    1.714304] Oops: Kernel access of bad area, sig: 11 [#1]
[    1.714414] SMP NR_CPUS=2048 NUMA PowerNV
[    1.714530] Modules linked in:
[    1.714647] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.7.0-kvm+ #118
[    1.714786] task: c000000ff0680010 task.stack: c000000ff0704000
[    1.714926] NIP: c000000000270cd0 LR: c000000000270ce8 CTR: 0000000000000000
[    1.715093] REGS: c000000ff0707900 TRAP: 0300   Not tainted  (4.7.0-kvm+)
[    1.715232] MSR: 9000000102009033 <SF,HV,VEC,EE,ME,IR,DR,RI,LE,TM[E]>  CR: 846b6824  XER: 20000000
[    1.715748] CFAR: c000000000008768 DAR: 0000000ff7a10000 DSISR: 42000000 SOFTE: 1
GPR00: c000000000270d08 c000000ff0707b80 c0000000011fb200 0000000000000000
GPR04: 0000000000000800 0000000000000000 0000000000000000 0000000000000000
GPR08: ffffffffffffffff 0000000000000000 0000000ff7a10000 c00000000122aae0
GPR12: c000000000a1e440 c00000000fb80000 c00000000000c188 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 c000000000cecad0
GPR24: c000000000d035b8 c000000000d6cd18 c000000000d6cd18 c000001fffa86300
GPR28: 0000000000000000 c000001fffa96300 c000000001230034 c00000000122eb18
[    1.717484] NIP [c000000000270cd0] refresh_zone_stat_thresholds+0x80/0x240
[    1.717568] LR [c000000000270ce8] refresh_zone_stat_thresholds+0x98/0x240
[    1.717648] Call Trace:
[    1.717687] [c000000ff0707b80] [c000000000270d08] refresh_zone_stat_thresholds+0xb8/0x240 (unreliable)

Both supplied potential fixes but one potentially misses checks and
another had redundant initialisations.  This version initialises
per_cpu_nodestats on a per-pgdat basis instead of on a per-zone basis.

Link: http://lkml.kernel.org/r/20160804092404.GI2799@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Paul Mackerras <paulus@ozlabs.org>
Reported-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-initialise-per_cpu_nodestats-for-all-online-pgdats-at-boot mm/page_alloc.c
--- a/mm/page_alloc.c~mm-initialise-per_cpu_nodestats-for-all-online-pgdats-at-boot
+++ a/mm/page_alloc.c
@@ -5257,11 +5257,6 @@ static void __meminit setup_zone_pageset
 	zone->pageset = alloc_percpu(struct per_cpu_pageset);
 	for_each_possible_cpu(cpu)
 		zone_pageset_init(zone, cpu);
-
-	if (!zone->zone_pgdat->per_cpu_nodestats) {
-		zone->zone_pgdat->per_cpu_nodestats =
-			alloc_percpu(struct per_cpu_nodestat);
-	}
 }
 
 /*
@@ -5270,10 +5265,15 @@ static void __meminit setup_zone_pageset
  */
 void __init setup_per_cpu_pageset(void)
 {
+	struct pglist_data *pgdat;
 	struct zone *zone;
 
 	for_each_populated_zone(zone)
 		setup_zone_pageset(zone);
+
+	for_each_online_pgdat(pgdat)
+		pgdat->per_cpu_nodestats =
+			alloc_percpu(struct per_cpu_nodestat);
 }
 
 static noinline __ref
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-initialise-per_cpu_nodestats-for-all-online-pgdats-at-boot.patch


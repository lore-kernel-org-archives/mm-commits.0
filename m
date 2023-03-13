Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF4CC6FD19
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 18:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCMSIE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Mar 2023 14:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjCMSH5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2023 14:07:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881647A922
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 11:07:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2EBE6145D
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 18:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4534BC433EF;
        Mon, 13 Mar 2023 18:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678730867;
        bh=ZYRfkwe43EUu3toAxJf558cTrVlKyHrzVeQBL5Jot6E=;
        h=Date:To:From:Subject:From;
        b=sZCXOxj1bCOBUZdLsbViFK3AV/fyx2oRdrqZqNg3Ln/bsztSDIHHZ5vYzXIJiFgCo
         PcdFk1Xxj07E4lEmxYg1E/2msUodMPxM5vkhV2s1LrtR6ER5njF6nNB6PGd4pifJH1
         6oEPq0nvEv+WJ89LC0w0846yAH0F0zWYCf4MujME=
Date:   Mon, 13 Mar 2023 11:07:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thomas.hellstrom@linux.intel.com, peterx@redhat.com,
        mhocko@suse.com, lstoakes@gmail.com, linux@armlinux.org.uk,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, hca@linux.ibm.com,
        frederic@kernel.org, dan.j.williams@intel.com, cl@linux.com,
        christian.koenig@amd.com, chenhuacai@kernel.org,
        atomlin@atomlin.com, mtosatti@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold.patch added to mm-unstable branch
Message-Id: <20230313180747.4534BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat: add pcp remote node draining via cpu_vm_stats_fold
has been added to the -mm mm-unstable branch.  Its filename is
     vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: vmstat: add pcp remote node draining via cpu_vm_stats_fold
Date: Mon, 13 Mar 2023 13:25:19 -0300

Large NUMA systems might have significant portions of system memory to be
trapped in pcp queues.  The number of pcp is determined by the number of
processors and nodes in a system.  A system with 4 processors and 2 nodes
has 8 pcps which is okay.  But a system with 1024 processors and 512 nodes
has 512k pcps with a high potential for large amount of memory being
caught in them.

Enable remote node draining for the CONFIG_HAVE_CMPXCHG_LOCAL case, where
vmstat_shepherd will perform the aging and draining via cpu_vm_stats_fold.

Link: https://lkml.kernel.org/r/20230313162634.561005765@redhat.com
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/vmstat.h~vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold
+++ a/include/linux/vmstat.h
@@ -297,7 +297,7 @@ extern void __dec_zone_state(struct zone
 extern void __dec_node_state(struct pglist_data *, enum node_stat_item);
 
 void quiet_vmstat(void);
-void cpu_vm_stats_fold(int cpu);
+void cpu_vm_stats_fold(int cpu, bool do_pagesets);
 void refresh_zone_stat_thresholds(void);
 
 struct ctl_table;
--- a/mm/page_alloc.c~vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold
+++ a/mm/page_alloc.c
@@ -8540,7 +8540,7 @@ static int page_alloc_cpu_dead(unsigned
 	 * Zero the differential counters of the dead processor
 	 * so that the vm statistics are consistent.
 	 */
-	cpu_vm_stats_fold(cpu);
+	cpu_vm_stats_fold(cpu, false);
 
 	for_each_populated_zone(zone)
 		zone_pcp_update(zone, 0);
--- a/mm/vmstat.c~vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold
+++ a/mm/vmstat.c
@@ -928,7 +928,7 @@ static int refresh_cpu_vm_stats(bool do_
  * There cannot be any access by the offline cpu and therefore
  * synchronization is simplified.
  */
-void cpu_vm_stats_fold(int cpu)
+void cpu_vm_stats_fold(int cpu, bool do_pagesets)
 {
 	struct pglist_data *pgdat;
 	struct zone *zone;
@@ -938,6 +938,9 @@ void cpu_vm_stats_fold(int cpu)
 
 	for_each_populated_zone(zone) {
 		struct per_cpu_zonestat *pzstats;
+#ifdef CONFIG_NUMA
+		struct per_cpu_pages *pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
+#endif
 
 		pzstats = per_cpu_ptr(zone->per_cpu_zonestats, cpu);
 
@@ -948,6 +951,11 @@ void cpu_vm_stats_fold(int cpu)
 				v = xchg(&pzstats->vm_stat_diff[i], 0);
 				atomic_long_add(v, &zone->vm_stat[i]);
 				global_zone_diff[i] += v;
+#ifdef CONFIG_NUMA
+				/* 3 seconds idle till flush */
+				if (do_pagesets)
+					pcp->expire = 3;
+#endif
 			}
 		}
 #ifdef CONFIG_NUMA
@@ -959,6 +967,38 @@ void cpu_vm_stats_fold(int cpu)
 				zone_numa_event_add(v, zone, i);
 			}
 		}
+
+		if (do_pagesets) {
+			cond_resched();
+			/*
+			 * Deal with draining the remote pageset of a
+			 * processor
+			 *
+			 * Check if there are pages remaining in this pageset
+			 * if not then there is nothing to expire.
+			 */
+			if (!pcp->expire || !pcp->count)
+				continue;
+
+			/*
+			 * We never drain zones local to this processor.
+			 */
+			if (zone_to_nid(zone) == cpu_to_node(cpu)) {
+				pcp->expire = 0;
+				continue;
+			}
+
+			WARN_ON(pcp->expire < 0);
+			/*
+			 * pcp->expire is only accessed from vmstat_shepherd context,
+			 * therefore no locking is required.
+			 */
+			if (--pcp->expire)
+				continue;
+
+			if (pcp->count)
+				drain_zone_pages(zone, pcp);
+		}
 #endif
 	}
 
@@ -2066,7 +2106,7 @@ static int refresh_all_vm_stats(void)
 
 	cpus_read_lock();
 	for_each_online_cpu(cpu) {
-		cpu_vm_stats_fold(cpu);
+		cpu_vm_stats_fold(cpu, true);
 		cond_resched();
 	}
 	cpus_read_unlock();
_

Patches currently in -mm which might be from mtosatti@redhat.com are

this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-loongarch-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-s390-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch
convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch
mm-vmstat-switch-counter-modification-to-cmpxchg.patch
vmstat-switch-per-cpu-vmstat-counters-to-32-bits.patch
mm-vmstat-use-xchg-in-cpu_vm_stats_fold.patch
mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely.patch
mm-vmstat-refresh-stats-remotely-instead-of-via-work-item.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold.patch


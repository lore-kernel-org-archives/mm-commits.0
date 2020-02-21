From: akpm@linux-foundation.org
Subject: [patch 12/15] mm/vmscan.c: don't round up scan size for
 online memory cgroup
Date: Thu, 20 Feb 2020 20:04:24 -0800
Message-ID: <20200221040424.Gk5Uf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgBUEE0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Feb 2020 23:04:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stable@vger.kernel.org, guro@fb.com, gshan@redhat.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org

From: Gavin Shan <gshan@redhat.com>
Subject: mm/vmscan.c: don't round up scan size for online memory cgroup

commit 68600f623d69 ("mm: don't miss the last page because of round-off
error") makes the scan size round up to @denominator regardless of the
memory cgroup's state, online or offline.  This affects the overall
reclaiming behavior: The corresponding LRU list is eligible for reclaiming
only when its size logically right shifted by @sc->priority is bigger than
zero in the former formula.  For example, the inactive anonymous LRU list
should have at least 0x4000 pages to be eligible for reclaiming when we
have 60/12 for swappiness/priority and without taking scan/rotation ratio
into account.  After the roundup is applied, the inactive anonymous LRU
list becomes eligible for reclaiming when its size is bigger than or equal
to 0x1000 in the same condition.

    (0x4000 >> 12) * 60 / (60 + 140 + 1) = 1
    ((0x1000 >> 12) * 60) + 200) / (60 + 140 + 1) = 1

aarch64 has 512MB huge page size when the base page size is 64KB.  The
memory cgroup that has a huge page is always eligible for reclaiming in
that case.  The reclaiming is likely to stop after the huge page is
reclaimed, meaing the further iteration on @sc->priority and the silbing
and child memory cgroups will be skipped.  The overall behaviour has been
changed.  This fixes the issue by applying the roundup to offlined memory
cgroups only, to give more preference to reclaim memory from offlined
memory cgroup.  It sounds reasonable as those memory is unlikedly to be
used by anyone.

The issue was found by starting up 8 VMs on a Ampere Mustang machine,
which has 8 CPUs and 16 GB memory.  Each VM is given with 2 vCPUs and 2GB
memory.  It took 264 seconds for all VMs to be completely up and 784MB
swap is consumed after that.  With this patch applied, it took 236 seconds
and 60MB swap to do same thing.  So there is 10% performance improvement
for my case.  Note that KSM is disable while THP is enabled in the
testing.

         total     used    free   shared  buff/cache   available
   Mem:  16196    10065    2049       16        4081        3749
   Swap:  8175      784    7391
         total     used    free   shared  buff/cache   available
   Mem:  16196    11324    3656       24        1215        2936
   Swap:  8175       60    8115

Link: http://lkml.kernel.org/r/20200211024514.8730-1-gshan@redhat.com
Fixes: 68600f623d69 ("mm: don't miss the last page because of round-off error")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>	[4.20+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-dont-round-up-scan-size-for-online-memory-cgroup
+++ a/mm/vmscan.c
@@ -2415,10 +2415,13 @@ out:
 			/*
 			 * Scan types proportional to swappiness and
 			 * their relative recent reclaim efficiency.
-			 * Make sure we don't miss the last page
-			 * because of a round-off error.
+			 * Make sure we don't miss the last page on
+			 * the offlined memory cgroups because of a
+			 * round-off error.
 			 */
-			scan = DIV64_U64_ROUND_UP(scan * fraction[file],
+			scan = mem_cgroup_online(memcg) ?
+			       div64_u64(scan * fraction[file], denominator) :
+			       DIV64_U64_ROUND_UP(scan * fraction[file],
 						  denominator);
 			break;
 		case SCAN_FILE:
_

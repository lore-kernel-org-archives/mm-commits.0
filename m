From: akpm@linux-foundation.org
Subject: [merged]
 proc-meminfo-estimate-available-memory-more-conservatively.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 14:33:56 -0800
Message-ID: <569973d4.qhHS1HKdleU6S1tI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: meminfo: estimate available memory more conservatively
has been removed from the -mm tree.  Its filename was
     proc-meminfo-estimate-available-memory-more-conservatively.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: proc: meminfo: estimate available memory more conservatively

The MemAvailable item in /proc/meminfo is to give users a hint of how much
memory is allocatable without causing swapping, so it excludes the zones'
low watermarks as unavailable to userspace.

However, for a userspace allocation, kswapd will actually reclaim until
the free pages hit a combination of the high watermark and the page
allocator's lowmem protection that keeps a certain amount of DMA and DMA32
memory from userspace as well.

Subtract the full amount we know to be unavailable to userspace from the
number of free pages when calculating MemAvailable.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/proc/meminfo.c~proc-meminfo-estimate-available-memory-more-conservatively fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~proc-meminfo-estimate-available-memory-more-conservatively
+++ a/fs/proc/meminfo.c
@@ -57,11 +57,8 @@ static int meminfo_proc_show(struct seq_
 	/*
 	 * Estimate the amount of memory available for userspace allocations,
 	 * without causing swapping.
-	 *
-	 * Free memory cannot be taken below the low watermark, before the
-	 * system starts swapping.
 	 */
-	available = i.freeram - wmark_low;
+	available = i.freeram - totalreserve_pages;
 
 	/*
 	 * Not all the page cache can be freed, otherwise the system will
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-switch-to-the-updated-jump-label-api.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch
mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-flatten-struct-cg_proto.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix.patch
mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix.patch
mm-memcontrol-add-sock-to-cgroup2-memorystat.patch


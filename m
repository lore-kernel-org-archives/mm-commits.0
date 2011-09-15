From: akpm@linux-foundation.org
Subject: [merged] numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:35:20 -0700
Message-ID: <201109151935.p8FJZKMu000426@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:9809 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934602Ab1IOTf0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:35:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, amwang@redhat.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     numa: fix NUMA compile error when sysfs and procfs are disabled
has been removed from the -mm tree.  Its filename was
     numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: numa: fix NUMA compile error when sysfs and procfs are disabled
From: David Rientjes <rientjes@google.com>

The vmstat_text array is only defined for CONFIG_SYSFS or CONFIG_PROC_FS,
yet it is referenced for per-node vmstat with CONFIG_NUMA:

	drivers/built-in.o: In function `node_read_vmstat':
	node.c:(.text+0x1106df): undefined reference to `vmstat_text'

in fa25c503dfa2 (mm: per-node vmstat: show proper vmstats).

Define the array for CONFIG_NUMA as well.

[akpm@linux-foundation.org: remove unneeded ifdefs]
Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Cong Wang <amwang@redhat.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmstat.c~numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled mm/vmstat.c
--- a/mm/vmstat.c~numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled
+++ a/mm/vmstat.c
@@ -659,7 +659,7 @@ static void walk_zones_in_node(struct se
 }
 #endif
 
-#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSFS)
+#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSFS) || defined(CONFIG_NUMA)
 #ifdef CONFIG_ZONE_DMA
 #define TEXT_FOR_DMA(xx) xx "_dma",
 #else
@@ -788,7 +788,7 @@ const char * const vmstat_text[] = {
 
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
-#endif /* CONFIG_PROC_FS || CONFIG_SYSFS */
+#endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA */
 
 
 #ifdef CONFIG_PROC_FS
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm.patch
oom-remove-oom_disable_count.patch
oom-fix-race-while-temporarily-setting-currents-oom_score_adj.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
cpusets-avoid-looping-when-storing-to-mems_allowed-if-one-node-remains-set.patch


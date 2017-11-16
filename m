From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-remove-timeout-from-__offline_memory.patch removed from
 -mm tree
Date: Thu, 16 Nov 2017 12:00:38 -0800
Message-ID: <20171116200038.MQrpZR9ap%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46312 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934367AbdKPUAk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:00:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, imammedo@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, qiuxishi@huawei.com, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com


The patch titled
     Subject: mm, memory_hotplug: remove timeout from __offline_memory
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-remove-timeout-from-__offline_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: remove timeout from __offline_memory

We have a hardcoded 120s timeout after which the memory offline fails
basically since the hot remove has been introduced.  This is essentially a
policy implemented in the kernel.  Moreover there is no way to adjust the
timeout and so we are sometimes facing memory offline failures if the
system is under a heavy memory pressure or very intensive CPU workload on
large machines.

It is not very clear what purpose the timeout actually serves.  The
offline operation is interruptible by a signal so if userspace wants some
timeout based termination this can be done trivially by sending a signal.

If there is a strong usecase to do this from the kernel then we should do
it properly and have a it tunable from the userspace with the timeout
disabled by default along with the explanation who uses it and for what
purporse.

Link: http://lkml.kernel.org/r/20170918070834.13083-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-remove-timeout-from-__offline_memory mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-timeout-from-__offline_memory
+++ a/mm/memory_hotplug.c
@@ -1590,9 +1590,9 @@ static void node_states_clear_node(int n
 }
 
 static int __ref __offline_pages(unsigned long start_pfn,
-		  unsigned long end_pfn, unsigned long timeout)
+		  unsigned long end_pfn)
 {
-	unsigned long pfn, nr_pages, expire;
+	unsigned long pfn, nr_pages;
 	long offlined_pages;
 	int ret, node;
 	unsigned long flags;
@@ -1630,12 +1630,8 @@ static int __ref __offline_pages(unsigne
 		goto failed_removal;
 
 	pfn = start_pfn;
-	expire = jiffies + timeout;
 repeat:
 	/* start memory hot removal */
-	ret = -EBUSY;
-	if (time_after(jiffies, expire))
-		goto failed_removal;
 	ret = -EINTR;
 	if (signal_pending(current))
 		goto failed_removal;
@@ -1708,7 +1704,7 @@ failed_removal:
 /* Must be protected by mem_hotplug_begin() or a device_lock */
 int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
 {
-	return __offline_pages(start_pfn, start_pfn + nr_pages, 120 * HZ);
+	return __offline_pages(start_pfn, start_pfn + nr_pages);
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch


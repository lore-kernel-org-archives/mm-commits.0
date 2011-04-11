From: akpm@linux-foundation.org
Subject: + mm-per-node-vmstat-show-proper-vmstats.patch added to -mm tree
Date: Mon, 11 Apr 2011 13:39:48 -0700
Message-ID: <201104112039.p3BKdm6B032278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755676Ab1DKUkW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 16:40:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, mrubin@google.com


The patch titled
     mm: per-node vmstat: show proper vmstats
has been added to the -mm tree.  Its filename is
     mm-per-node-vmstat-show-proper-vmstats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: per-node vmstat: show proper vmstats
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 2ac390370a ("writeback: add
/sys/devices/system/node/<node>/vmstat") added vmstat entry.  But
strangely it only show nr_written and nr_dirtied.

        # cat /sys/devices/system/node/node20/vmstat
        nr_written 0
        nr_dirtied 0

Of course, It's not adequate.  With this patch, the vmstat show all vm
stastics as /proc/vmstat.

        # cat /sys/devices/system/node/node0/vmstat
	nr_free_pages 899224
	nr_inactive_anon 201
	nr_active_anon 17380
	nr_inactive_file 31572
	nr_active_file 28277
	nr_unevictable 0
	nr_mlock 0
	nr_anon_pages 17321
	nr_mapped 8640
	nr_file_pages 60107
	nr_dirty 33
	nr_writeback 0
	nr_slab_reclaimable 6850
	nr_slab_unreclaimable 7604
	nr_page_table_pages 3105
	nr_kernel_stack 175
	nr_unstable 0
	nr_bounce 0
	nr_vmscan_write 0
	nr_writeback_temp 0
	nr_isolated_anon 0
	nr_isolated_file 0
	nr_shmem 260
	nr_dirtied 1050
	nr_written 938
	numa_hit 962872
	numa_miss 0
	numa_foreign 0
	numa_interleave 8617
	numa_local 962872
	numa_other 0
	nr_anon_transparent_hugepages 0

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |   15 ++++++++++-----
 mm/vmstat.c         |    2 +-
 2 files changed, 11 insertions(+), 6 deletions(-)

diff -puN drivers/base/node.c~mm-per-node-vmstat-show-proper-vmstats drivers/base/node.c
--- a/drivers/base/node.c~mm-per-node-vmstat-show-proper-vmstats
+++ a/drivers/base/node.c
@@ -175,15 +175,20 @@ static ssize_t node_read_numastat(struct
 }
 static SYSDEV_ATTR(numastat, S_IRUGO, node_read_numastat, NULL);
 
+extern const char * const vmstat_text[];
+
 static ssize_t node_read_vmstat(struct sys_device *dev,
 				struct sysdev_attribute *attr, char *buf)
 {
 	int nid = dev->id;
-	return sprintf(buf,
-		"nr_written %lu\n"
-		"nr_dirtied %lu\n",
-		node_page_state(nid, NR_WRITTEN),
-		node_page_state(nid, NR_DIRTIED));
+	int i;
+	int n = 0;
+
+	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+		n += sprintf(buf+n, "%s %lu\n", vmstat_text[i],
+			     node_page_state(nid, i));
+
+	return n;
 }
 static SYSDEV_ATTR(vmstat, S_IRUGO, node_read_vmstat, NULL);
 
diff -puN mm/vmstat.c~mm-per-node-vmstat-show-proper-vmstats mm/vmstat.c
--- a/mm/vmstat.c~mm-per-node-vmstat-show-proper-vmstats
+++ a/mm/vmstat.c
@@ -852,7 +852,7 @@ static const struct file_operations page
 #define TEXTS_FOR_ZONES(xx) TEXT_FOR_DMA(xx) TEXT_FOR_DMA32(xx) xx "_normal", \
 					TEXT_FOR_HIGHMEM(xx) xx "_movable",
 
-static const char * const vmstat_text[] = {
+const char * const vmstat_text[] = {
 	/* Zoned VM counters */
 	"nr_free_pages",
 	"nr_inactive_anon",
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

memcg-fix-mem_cgroup_rotate_reclaimable_page.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch


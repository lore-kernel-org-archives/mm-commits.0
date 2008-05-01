From: akpm@linux-foundation.org
Subject: - mm-add-nr_writeback_temp-counter.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:56 -0700
Message-ID: <200805010931.m419VuDf030918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757828AbYEAJce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:32:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, clameter@sgi.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     mm: Add NR_WRITEBACK_TEMP counter
has been removed from the -mm tree.  Its filename was
     mm-add-nr_writeback_temp-counter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: Add NR_WRITEBACK_TEMP counter
From: Miklos Szeredi <mszeredi@suse.cz>

Fuse will use temporary buffers to write back dirty data from memory mappings
(normal writes are done synchronously).  This is needed, because there cannot
be any guarantee about the time in which a write will complete.

By using temporary buffers, from the MM's point if view the page is written
back immediately.  If the writeout was due to memory pressure, this
effectively migrates data from a full zone to a less full zone.

This patch adds a new counter (NR_WRITEBACK_TEMP) for the number of pages used
as temporary buffers.

[Lee.Schermerhorn@hp.com: add vmstat_text for NR_WRITEBACK_TEMP]
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |    2 ++
 fs/proc/proc_misc.c    |    2 ++
 include/linux/mmzone.h |    1 +
 mm/page-writeback.c    |    3 ++-
 mm/vmstat.c            |    1 +
 5 files changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/base/node.c~mm-add-nr_writeback_temp-counter drivers/base/node.c
--- a/drivers/base/node.c~mm-add-nr_writeback_temp-counter
+++ a/drivers/base/node.c
@@ -77,6 +77,7 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d PageTables:   %8lu kB\n"
 		       "Node %d NFS_Unstable: %8lu kB\n"
 		       "Node %d Bounce:       %8lu kB\n"
+		       "Node %d WritebackTmp: %8lu kB\n"
 		       "Node %d Slab:         %8lu kB\n"
 		       "Node %d SReclaimable: %8lu kB\n"
 		       "Node %d SUnreclaim:   %8lu kB\n",
@@ -99,6 +100,7 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_PAGETABLE)),
 		       nid, K(node_page_state(nid, NR_UNSTABLE_NFS)),
 		       nid, K(node_page_state(nid, NR_BOUNCE)),
+		       nid, K(node_page_state(nid, NR_WRITEBACK_TEMP)),
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE) +
 				node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE)),
diff -puN fs/proc/proc_misc.c~mm-add-nr_writeback_temp-counter fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~mm-add-nr_writeback_temp-counter
+++ a/fs/proc/proc_misc.c
@@ -179,6 +179,7 @@ static int meminfo_read_proc(char *page,
 		"PageTables:   %8lu kB\n"
 		"NFS_Unstable: %8lu kB\n"
 		"Bounce:       %8lu kB\n"
+		"WritebackTmp: %8lu kB\n"
 		"CommitLimit:  %8lu kB\n"
 		"Committed_AS: %8lu kB\n"
 		"VmallocTotal: %8lu kB\n"
@@ -210,6 +211,7 @@ static int meminfo_read_proc(char *page,
 		K(global_page_state(NR_PAGETABLE)),
 		K(global_page_state(NR_UNSTABLE_NFS)),
 		K(global_page_state(NR_BOUNCE)),
+		K(global_page_state(NR_WRITEBACK_TEMP)),
 		K(allowed),
 		K(committed),
 		(unsigned long)VMALLOC_TOTAL >> 10,
diff -puN include/linux/mmzone.h~mm-add-nr_writeback_temp-counter include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-add-nr_writeback_temp-counter
+++ a/include/linux/mmzone.h
@@ -97,6 +97,7 @@ enum zone_stat_item {
 	NR_UNSTABLE_NFS,	/* NFS unstable pages */
 	NR_BOUNCE,
 	NR_VMSCAN_WRITE,
+	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
 	NUMA_MISS,		/* allocated in non intended node */
diff -puN mm/page-writeback.c~mm-add-nr_writeback_temp-counter mm/page-writeback.c
--- a/mm/page-writeback.c~mm-add-nr_writeback_temp-counter
+++ a/mm/page-writeback.c
@@ -211,7 +211,8 @@ clip_bdi_dirty_limit(struct backing_dev_
 	avail_dirty = dirty -
 		(global_page_state(NR_FILE_DIRTY) +
 		 global_page_state(NR_WRITEBACK) +
-		 global_page_state(NR_UNSTABLE_NFS));
+		 global_page_state(NR_UNSTABLE_NFS) +
+		 global_page_state(NR_WRITEBACK_TEMP));
 
 	if (avail_dirty < 0)
 		avail_dirty = 0;
diff -puN mm/vmstat.c~mm-add-nr_writeback_temp-counter mm/vmstat.c
--- a/mm/vmstat.c~mm-add-nr_writeback_temp-counter
+++ a/mm/vmstat.c
@@ -612,6 +612,7 @@ static const char * const vmstat_text[] 
 	"nr_unstable",
 	"nr_bounce",
 	"nr_vmscan_write",
+	"nr_writeback_temp",
 
 #ifdef CONFIG_NUMA
 	"numa_hit",
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-fix-permission-checking-in-sys_utimensat.patch


From: akpm@linux-foundation.org
Subject: + mm-add-nr_writeback_temp-counter.patch added to -mm tree
Date: Mon, 17 Mar 2008 22:08:50 -0700
Message-ID: <200803180508.m2I58ovY015467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886AbYCRFJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 01:09:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, clameter@sgi.com


The patch titled
     mm: Add NR_WRITEBACK_TEMP counter
has been added to the -mm tree.  Its filename is
     mm-add-nr_writeback_temp-counter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |    2 ++
 fs/proc/proc_misc.c    |    2 ++
 include/linux/mmzone.h |    1 +
 mm/page-writeback.c    |    3 ++-
 4 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/base/node.c~mm-add-nr_writeback_temp-counter drivers/base/node.c
--- a/drivers/base/node.c~mm-add-nr_writeback_temp-counter
+++ a/drivers/base/node.c
@@ -64,6 +64,7 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d PageTables:   %8lu kB\n"
 		       "Node %d NFS_Unstable: %8lu kB\n"
 		       "Node %d Bounce:       %8lu kB\n"
+		       "Node %d WritebackTmp: %8lu kB\n"
 		       "Node %d Slab:         %8lu kB\n"
 		       "Node %d SReclaimable: %8lu kB\n"
 		       "Node %d SUnreclaim:   %8lu kB\n",
@@ -86,6 +87,7 @@ static ssize_t node_read_meminfo(struct 
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
@@ -95,6 +95,7 @@ enum zone_stat_item {
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
_

Patches currently in -mm which might be from mszeredi@suse.cz are

mm-rotate_reclaimable_page-cleanup.patch
vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
vfs-remove-lives_below_in_same_fs.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-add-nr_writeback_temp-counter.patch
mm-allow-not-updating-bdi-stats-in-end_page_writeback.patch
fuse-support-writable-mmap.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch


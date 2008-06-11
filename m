From: akpm@linux-foundation.org
Subject: + vmscan-split-lru-lists-into-anon-file-sets.patch added to -mm tree
Date: Wed, 11 Jun 2008 12:59:31 -0700
Message-ID: <200806111959.m5BJxVHi015181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755415AbYFKUAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 16:00:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, Lee.Schermerhorn@hp.com


The patch titled
     vmscan: split LRU lists into anon & file sets
has been added to the -mm tree.  Its filename is
     vmscan-split-lru-lists-into-anon-file-sets.patch

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
Subject: vmscan: split LRU lists into anon & file sets
From: Rik van Riel <riel@redhat.com>

Split the LRU lists in two, one set for pages that are backed by real file
systems ("file") and one for pages that are backed by memory and swap
("anon").  The latter includes tmpfs.

The advantage of doing this is that the VM will not have to scan over lots
of anonymous pages (which we generally do not want to swap out), just to
find the page cache pages that it should evict.

This patch has the infrastructure and a basic policy to balance how much
we scan the anon lists and how much we scan the file lists.  The big
policy changes are in separate patches.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c        |   56 ++--
 fs/cifs/file.c             |    4 
 fs/nfs/dir.c               |    2 
 fs/ntfs/file.c             |    4 
 fs/proc/proc_misc.c        |   77 +++---
 fs/ramfs/file-nommu.c      |    4 
 include/linux/memcontrol.h |    2 
 include/linux/mm_inline.h  |   50 +++-
 include/linux/mmzone.h     |   47 +++
 include/linux/pagevec.h    |   29 +-
 include/linux/swap.h       |   20 +
 include/linux/vmstat.h     |   10 
 mm/filemap.c               |    9 
 mm/memcontrol.c            |   73 +++---
 mm/memory.c                |    6 
 mm/page-writeback.c        |    8 
 mm/page_alloc.c            |   25 +-
 mm/readahead.c             |    2 
 mm/swap.c                  |   14 -
 mm/swap_state.c            |    2 
 mm/vmscan.c                |  420 ++++++++++++++++++-----------------
 mm/vmstat.c                |   14 -
 22 files changed, 519 insertions(+), 359 deletions(-)

diff -puN drivers/base/node.c~vmscan-split-lru-lists-into-anon-file-sets drivers/base/node.c
--- a/drivers/base/node.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/drivers/base/node.c
@@ -58,34 +58,44 @@ static ssize_t node_read_meminfo(struct 
 	si_meminfo_node(&i, nid);
 
 	n = sprintf(buf, "\n"
-		       "Node %d MemTotal:     %8lu kB\n"
-		       "Node %d MemFree:      %8lu kB\n"
-		       "Node %d MemUsed:      %8lu kB\n"
-		       "Node %d Active:       %8lu kB\n"
-		       "Node %d Inactive:     %8lu kB\n"
+		       "Node %d MemTotal:       %8lu kB\n"
+		       "Node %d MemFree:        %8lu kB\n"
+		       "Node %d MemUsed:        %8lu kB\n"
+		       "Node %d Active:         %8lu kB\n"
+		       "Node %d Inactive:       %8lu kB\n"
+		       "Node %d Active(anon):   %8lu kB\n"
+		       "Node %d Inactive(anon): %8lu kB\n"
+		       "Node %d Active(file):   %8lu kB\n"
+		       "Node %d Inactive(file): %8lu kB\n"
 #ifdef CONFIG_HIGHMEM
-		       "Node %d HighTotal:    %8lu kB\n"
-		       "Node %d HighFree:     %8lu kB\n"
-		       "Node %d LowTotal:     %8lu kB\n"
-		       "Node %d LowFree:      %8lu kB\n"
+		       "Node %d HighTotal:      %8lu kB\n"
+		       "Node %d HighFree:       %8lu kB\n"
+		       "Node %d LowTotal:       %8lu kB\n"
+		       "Node %d LowFree:        %8lu kB\n"
 #endif
-		       "Node %d Dirty:        %8lu kB\n"
-		       "Node %d Writeback:    %8lu kB\n"
-		       "Node %d FilePages:    %8lu kB\n"
-		       "Node %d Mapped:       %8lu kB\n"
-		       "Node %d AnonPages:    %8lu kB\n"
-		       "Node %d PageTables:   %8lu kB\n"
-		       "Node %d NFS_Unstable: %8lu kB\n"
-		       "Node %d Bounce:       %8lu kB\n"
-		       "Node %d WritebackTmp: %8lu kB\n"
-		       "Node %d Slab:         %8lu kB\n"
-		       "Node %d SReclaimable: %8lu kB\n"
-		       "Node %d SUnreclaim:   %8lu kB\n",
+		       "Node %d Dirty:          %8lu kB\n"
+		       "Node %d Writeback:      %8lu kB\n"
+		       "Node %d FilePages:      %8lu kB\n"
+		       "Node %d Mapped:         %8lu kB\n"
+		       "Node %d AnonPages:      %8lu kB\n"
+		       "Node %d PageTables:     %8lu kB\n"
+		       "Node %d NFS_Unstable:   %8lu kB\n"
+		       "Node %d Bounce:         %8lu kB\n"
+		       "Node %d WritebackTmp:   %8lu kB\n"
+		       "Node %d Slab:           %8lu kB\n"
+		       "Node %d SReclaimable:   %8lu kB\n"
+		       "Node %d SUnreclaim:     %8lu kB\n",
 		       nid, K(i.totalram),
 		       nid, K(i.freeram),
 		       nid, K(i.totalram - i.freeram),
-		       nid, node_page_state(nid, NR_ACTIVE),
-		       nid, node_page_state(nid, NR_INACTIVE),
+		       nid, node_page_state(nid, NR_ACTIVE_ANON) +
+				node_page_state(nid, NR_ACTIVE_FILE),
+		       nid, node_page_state(nid, NR_INACTIVE_ANON) +
+				node_page_state(nid, NR_INACTIVE_FILE),
+		       nid, node_page_state(nid, NR_ACTIVE_ANON),
+		       nid, node_page_state(nid, NR_INACTIVE_ANON),
+		       nid, node_page_state(nid, NR_ACTIVE_FILE),
+		       nid, node_page_state(nid, NR_INACTIVE_FILE),
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),
 		       nid, K(i.freehigh),
diff -puN fs/cifs/file.c~vmscan-split-lru-lists-into-anon-file-sets fs/cifs/file.c
--- a/fs/cifs/file.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/fs/cifs/file.c
@@ -1775,7 +1775,7 @@ static void cifs_copy_cache_pages(struct
 		SetPageUptodate(page);
 		unlock_page(page);
 		if (!pagevec_add(plru_pvec, page))
-			__pagevec_lru_add(plru_pvec);
+			__pagevec_lru_add_file(plru_pvec);
 		data += PAGE_CACHE_SIZE;
 	}
 	return;
@@ -1909,7 +1909,7 @@ static int cifs_readpages(struct file *f
 		bytes_read = 0;
 	}
 
-	pagevec_lru_add(&lru_pvec);
+	pagevec_lru_add_file(&lru_pvec);
 
 /* need to free smb_read_data buf before exit */
 	if (smb_read_data) {
diff -puN fs/nfs/dir.c~vmscan-split-lru-lists-into-anon-file-sets fs/nfs/dir.c
--- a/fs/nfs/dir.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/fs/nfs/dir.c
@@ -1524,7 +1524,7 @@ static int nfs_symlink(struct inode *dir
 	if (!add_to_page_cache(page, dentry->d_inode->i_mapping, 0,
 							GFP_KERNEL)) {
 		pagevec_add(&lru_pvec, page);
-		pagevec_lru_add(&lru_pvec);
+		pagevec_lru_add_file(&lru_pvec);
 		SetPageUptodate(page);
 		unlock_page(page);
 	} else
diff -puN fs/ntfs/file.c~vmscan-split-lru-lists-into-anon-file-sets fs/ntfs/file.c
--- a/fs/ntfs/file.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/fs/ntfs/file.c
@@ -439,7 +439,7 @@ static inline int __ntfs_grab_cache_page
 			pages[nr] = *cached_page;
 			page_cache_get(*cached_page);
 			if (unlikely(!pagevec_add(lru_pvec, *cached_page)))
-				__pagevec_lru_add(lru_pvec);
+				__pagevec_lru_add_file(lru_pvec);
 			*cached_page = NULL;
 		}
 		index++;
@@ -2084,7 +2084,7 @@ err_out:
 						OSYNC_METADATA|OSYNC_DATA);
 		}
   	}
-	pagevec_lru_add(&lru_pvec);
+	pagevec_lru_add_file(&lru_pvec);
 	ntfs_debug("Done.  Returning %s (written 0x%lx, status %li).",
 			written ? "written" : "status", (unsigned long)written,
 			(long)status);
diff -puN fs/proc/proc_misc.c~vmscan-split-lru-lists-into-anon-file-sets fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/fs/proc/proc_misc.c
@@ -137,6 +137,8 @@ static int meminfo_read_proc(char *page,
 	unsigned long allowed;
 	struct vmalloc_info vmi;
 	long cached;
+	unsigned long pages[NR_LRU_LISTS];
+	int lru;
 
 /*
  * display in kilobytes.
@@ -155,48 +157,59 @@ static int meminfo_read_proc(char *page,
 
 	get_vmalloc_info(&vmi);
 
+	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
+		pages[lru] = global_page_state(lru);
+
 	/*
 	 * Tagged format, for easy grepping and expansion.
 	 */
 	len = sprintf(page,
-		"MemTotal:     %8lu kB\n"
-		"MemFree:      %8lu kB\n"
-		"Buffers:      %8lu kB\n"
-		"Cached:       %8lu kB\n"
-		"SwapCached:   %8lu kB\n"
-		"Active:       %8lu kB\n"
-		"Inactive:     %8lu kB\n"
+		"MemTotal:       %8lu kB\n"
+		"MemFree:        %8lu kB\n"
+		"Buffers:        %8lu kB\n"
+		"Cached:         %8lu kB\n"
+		"SwapCached:     %8lu kB\n"
+		"Active:         %8lu kB\n"
+		"Inactive:       %8lu kB\n"
+		"Active(anon):   %8lu kB\n"
+		"Inactive(anon): %8lu kB\n"
+		"Active(file):   %8lu kB\n"
+		"Inactive(file): %8lu kB\n"
 #ifdef CONFIG_HIGHMEM
-		"HighTotal:    %8lu kB\n"
-		"HighFree:     %8lu kB\n"
-		"LowTotal:     %8lu kB\n"
-		"LowFree:      %8lu kB\n"
-#endif
-		"SwapTotal:    %8lu kB\n"
-		"SwapFree:     %8lu kB\n"
-		"Dirty:        %8lu kB\n"
-		"Writeback:    %8lu kB\n"
-		"AnonPages:    %8lu kB\n"
-		"Mapped:       %8lu kB\n"
-		"Slab:         %8lu kB\n"
-		"SReclaimable: %8lu kB\n"
-		"SUnreclaim:   %8lu kB\n"
-		"PageTables:   %8lu kB\n"
-		"NFS_Unstable: %8lu kB\n"
-		"Bounce:       %8lu kB\n"
-		"WritebackTmp: %8lu kB\n"
-		"CommitLimit:  %8lu kB\n"
-		"Committed_AS: %8lu kB\n"
-		"VmallocTotal: %8lu kB\n"
-		"VmallocUsed:  %8lu kB\n"
-		"VmallocChunk: %8lu kB\n",
+		"HighTotal:      %8lu kB\n"
+		"HighFree:       %8lu kB\n"
+		"LowTotal:       %8lu kB\n"
+		"LowFree:        %8lu kB\n"
+#endif
+		"SwapTotal:      %8lu kB\n"
+		"SwapFree:       %8lu kB\n"
+		"Dirty:          %8lu kB\n"
+		"Writeback:      %8lu kB\n"
+		"AnonPages:      %8lu kB\n"
+		"Mapped:         %8lu kB\n"
+		"Slab:           %8lu kB\n"
+		"SReclaimable:   %8lu kB\n"
+		"SUnreclaim:     %8lu kB\n"
+		"PageTables:     %8lu kB\n"
+		"NFS_Unstable:   %8lu kB\n"
+		"Bounce:         %8lu kB\n"
+		"WritebackTmp:   %8lu kB\n"
+		"CommitLimit:    %8lu kB\n"
+		"Committed_AS:   %8lu kB\n"
+		"VmallocTotal:   %8lu kB\n"
+		"VmallocUsed:    %8lu kB\n"
+		"VmallocChunk:   %8lu kB\n",
 		K(i.totalram),
 		K(i.freeram),
 		K(i.bufferram),
 		K(cached),
 		K(total_swapcache_pages),
-		K(global_page_state(NR_ACTIVE)),
-		K(global_page_state(NR_INACTIVE)),
+		K(pages[LRU_ACTIVE_ANON]   + pages[LRU_ACTIVE_FILE]),
+		K(pages[LRU_INACTIVE_ANON] + pages[LRU_INACTIVE_FILE]),
+		K(pages[LRU_ACTIVE_ANON]),
+		K(pages[LRU_INACTIVE_ANON]),
+		K(pages[LRU_ACTIVE_FILE]),
+		K(pages[LRU_INACTIVE_FILE]),
 #ifdef CONFIG_HIGHMEM
 		K(i.totalhigh),
 		K(i.freehigh),
diff -puN fs/ramfs/file-nommu.c~vmscan-split-lru-lists-into-anon-file-sets fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/fs/ramfs/file-nommu.c
@@ -111,12 +111,12 @@ static int ramfs_nommu_expand_for_mappin
 			goto add_error;
 
 		if (!pagevec_add(&lru_pvec, page))
-			__pagevec_lru_add(&lru_pvec);
+			__pagevec_lru_add_file(&lru_pvec);
 
 		unlock_page(page);
 	}
 
-	pagevec_lru_add(&lru_pvec);
+	pagevec_lru_add_file(&lru_pvec);
 	return 0;
 
  fsize_exceeded:
diff -puN include/linux/memcontrol.h~vmscan-split-lru-lists-into-anon-file-sets include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscan-split-lru-lists-into-anon-file-sets
+++ a/include/linux/memcontrol.h
@@ -44,7 +44,7 @@ extern unsigned long mem_cgroup_isolate_
 					unsigned long *scanned, int order,
 					int mode, struct zone *z,
 					struct mem_cgroup *mem_cont,
-					int active);
+					int active, int file);
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
 
diff -puN include/linux/mm_inline.h~vmscan-split-lru-lists-into-anon-file-sets include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~vmscan-split-lru-lists-into-anon-file-sets
+++ a/include/linux/mm_inline.h
@@ -5,7 +5,7 @@
  * page_is_file_cache - should the page be on a file LRU or anon LRU?
  * @page: the page to test
  *
- * Returns !0 if @page is page cache page backed by a regular filesystem,
+ * Returns LRU_FILE if @page is page cache page backed by a regular filesystem,
  * or 0 if @page is anonymous, tmpfs or otherwise ram or swap backed.
  * Used by functions that manipulate the LRU lists, to sort a page
  * onto the right LRU list.
@@ -20,7 +20,7 @@ static inline int page_is_file_cache(str
 		return 0;
 
 	/* The page is page cache backed by a normal filesystem. */
-	return 1;
+	return LRU_FILE;
 }
 
 static inline void
@@ -38,39 +38,64 @@ del_page_from_lru_list(struct zone *zone
 }
 
 static inline void
-add_page_to_active_list(struct zone *zone, struct page *page)
+add_page_to_inactive_anon_list(struct zone *zone, struct page *page)
 {
-	add_page_to_lru_list(zone, page, LRU_ACTIVE);
+	add_page_to_lru_list(zone, page, LRU_INACTIVE_ANON);
 }
 
 static inline void
-add_page_to_inactive_list(struct zone *zone, struct page *page)
+add_page_to_active_anon_list(struct zone *zone, struct page *page)
 {
-	add_page_to_lru_list(zone, page, LRU_INACTIVE);
+	add_page_to_lru_list(zone, page, LRU_ACTIVE_ANON);
 }
 
 static inline void
-del_page_from_active_list(struct zone *zone, struct page *page)
+add_page_to_inactive_file_list(struct zone *zone, struct page *page)
 {
-	del_page_from_lru_list(zone, page, LRU_ACTIVE);
+	add_page_to_lru_list(zone, page, LRU_INACTIVE_FILE);
 }
 
 static inline void
-del_page_from_inactive_list(struct zone *zone, struct page *page)
+add_page_to_active_file_list(struct zone *zone, struct page *page)
 {
-	del_page_from_lru_list(zone, page, LRU_INACTIVE);
+	add_page_to_lru_list(zone, page, LRU_ACTIVE_FILE);
+}
+
+static inline void
+del_page_from_inactive_anon_list(struct zone *zone, struct page *page)
+{
+	del_page_from_lru_list(zone, page, LRU_INACTIVE_ANON);
+}
+
+static inline void
+del_page_from_active_anon_list(struct zone *zone, struct page *page)
+{
+	del_page_from_lru_list(zone, page, LRU_ACTIVE_ANON);
+}
+
+static inline void
+del_page_from_inactive_file_list(struct zone *zone, struct page *page)
+{
+	del_page_from_lru_list(zone, page, LRU_INACTIVE_FILE);
+}
+
+static inline void
+del_page_from_active_file_list(struct zone *zone, struct page *page)
+{
+	del_page_from_lru_list(zone, page, LRU_INACTIVE_FILE);
 }
 
 static inline void
 del_page_from_lru(struct zone *zone, struct page *page)
 {
-	enum lru_list l = LRU_INACTIVE;
+	enum lru_list l = LRU_BASE;
 
 	list_del(&page->lru);
 	if (PageActive(page)) {
 		__ClearPageActive(page);
-		l = LRU_ACTIVE;
+		l += LRU_ACTIVE;
 	}
+	l += page_is_file_cache(page);
 	__dec_zone_state(zone, NR_LRU_BASE + l);
 }
 
@@ -87,6 +112,7 @@ static inline enum lru_list page_lru(str
 
 	if (PageActive(page))
 		lru += LRU_ACTIVE;
+	lru += page_is_file_cache(page);
 
 	return lru;
 }
diff -puN include/linux/mmzone.h~vmscan-split-lru-lists-into-anon-file-sets include/linux/mmzone.h
--- a/include/linux/mmzone.h~vmscan-split-lru-lists-into-anon-file-sets
+++ a/include/linux/mmzone.h
@@ -82,21 +82,23 @@ enum zone_stat_item {
 	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
 	NR_LRU_BASE,
-	NR_INACTIVE = NR_LRU_BASE, /* must match order of LRU_[IN]ACTIVE */
-	NR_ACTIVE,	/*  "     "     "   "       "         */
+	NR_INACTIVE_ANON = NR_LRU_BASE, /* must match order of LRU_[IN]ACTIVE */
+	NR_ACTIVE_ANON,		/*  "     "     "   "       "         */
+	NR_INACTIVE_FILE,	/*  "     "     "   "       "         */
+	NR_ACTIVE_FILE,		/*  "     "     "   "       "         */
 	NR_ANON_PAGES,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
 			   only modified from process context */
 	NR_FILE_PAGES,
 	NR_FILE_DIRTY,
 	NR_WRITEBACK,
-	/* Second 128 byte cacheline */
 	NR_SLAB_RECLAIMABLE,
 	NR_SLAB_UNRECLAIMABLE,
 	NR_PAGETABLE,		/* used for pagetables */
 	NR_UNSTABLE_NFS,	/* NFS unstable pages */
 	NR_BOUNCE,
 	NR_VMSCAN_WRITE,
+	/* Second 128 byte cacheline */
 	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
@@ -108,17 +110,36 @@ enum zone_stat_item {
 #endif
 	NR_VM_ZONE_STAT_ITEMS };
 
+/*
+ * We do arithmetic on the LRU lists in various places in the code,
+ * so it is important to keep the active lists LRU_ACTIVE higher in
+ * the array than the corresponding inactive lists, and to keep
+ * the *_FILE lists LRU_FILE higher than the corresponding _ANON lists.
+ *
+ * This has to be kept in sync with the statistics in zone_stat_item
+ * above and the descriptions in vmstat_text in mm/vmstat.c
+ */
+#define LRU_BASE 0
+#define LRU_ACTIVE 1
+#define LRU_FILE 2
+
 enum lru_list {
-	LRU_BASE,
-	LRU_INACTIVE=LRU_BASE,	/* must match order of NR_[IN]ACTIVE */
-	LRU_ACTIVE,		/*  "     "     "   "       "        */
+	LRU_INACTIVE_ANON = LRU_BASE,
+	LRU_ACTIVE_ANON = LRU_BASE + LRU_ACTIVE,
+	LRU_INACTIVE_FILE = LRU_BASE + LRU_FILE,
+	LRU_ACTIVE_FILE = LRU_BASE + LRU_FILE + LRU_ACTIVE,
 	NR_LRU_LISTS };
 
 #define for_each_lru(l) for (l = 0; l < NR_LRU_LISTS; l++)
 
+static inline int is_file_lru(enum lru_list l)
+{
+	return (l == LRU_INACTIVE_FILE || l == LRU_ACTIVE_FILE);
+}
+
 static inline int is_active_lru(enum lru_list l)
 {
-	return (l == LRU_ACTIVE);
+	return (l == LRU_ACTIVE_ANON || l == LRU_ACTIVE_FILE);
 }
 
 struct per_cpu_pages {
@@ -269,6 +290,18 @@ struct zone {
 		struct list_head list;
 		unsigned long nr_scan;
 	} lru[NR_LRU_LISTS];
+
+	/*
+	 * The pageout code in vmscan.c keeps track of how many of the
+	 * mem/swap backed and file backed pages are refeferenced.
+	 * The higher the rotated/scanned ratio, the more valuable
+	 * that cache is.
+	 *
+	 * The anon LRU stats live in [0], file LRU stats in [1]
+	 */
+	unsigned long		recent_rotated[2];
+	unsigned long		recent_scanned[2];
+
 	unsigned long		pages_scanned;	   /* since last reclaim */
 	unsigned long		flags;		   /* zone flags, see below */
 
diff -puN include/linux/pagevec.h~vmscan-split-lru-lists-into-anon-file-sets include/linux/pagevec.h
--- a/include/linux/pagevec.h~vmscan-split-lru-lists-into-anon-file-sets
+++ a/include/linux/pagevec.h
@@ -81,20 +81,37 @@ static inline void pagevec_free(struct p
 		__pagevec_free(pvec);
 }
 
-static inline void __pagevec_lru_add(struct pagevec *pvec)
+static inline void __pagevec_lru_add_anon(struct pagevec *pvec)
 {
-	____pagevec_lru_add(pvec, LRU_INACTIVE);
+	____pagevec_lru_add(pvec, LRU_INACTIVE_ANON);
 }
 
-static inline void __pagevec_lru_add_active(struct pagevec *pvec)
+static inline void __pagevec_lru_add_active_anon(struct pagevec *pvec)
 {
-	____pagevec_lru_add(pvec, LRU_ACTIVE);
+	____pagevec_lru_add(pvec, LRU_ACTIVE_ANON);
 }
 
-static inline void pagevec_lru_add(struct pagevec *pvec)
+static inline void __pagevec_lru_add_file(struct pagevec *pvec)
+{
+	____pagevec_lru_add(pvec, LRU_INACTIVE_FILE);
+}
+
+static inline void __pagevec_lru_add_active_file(struct pagevec *pvec)
+{
+	____pagevec_lru_add(pvec, LRU_ACTIVE_FILE);
+}
+
+
+static inline void pagevec_lru_add_file(struct pagevec *pvec)
+{
+	if (pagevec_count(pvec))
+		__pagevec_lru_add_file(pvec);
+}
+
+static inline void pagevec_lru_add_anon(struct pagevec *pvec)
 {
 	if (pagevec_count(pvec))
-		__pagevec_lru_add(pvec);
+		__pagevec_lru_add_anon(pvec);
 }
 
 #endif /* _LINUX_PAGEVEC_H */
diff -puN include/linux/swap.h~vmscan-split-lru-lists-into-anon-file-sets include/linux/swap.h
--- a/include/linux/swap.h~vmscan-split-lru-lists-into-anon-file-sets
+++ a/include/linux/swap.h
@@ -184,14 +184,24 @@ extern void swap_setup(void);
  * lru_cache_add: add a page to the page lists
  * @page: the page to add
  */
-static inline void lru_cache_add(struct page *page)
+static inline void lru_cache_add_anon(struct page *page)
 {
-	__lru_cache_add(page, LRU_INACTIVE);
+	__lru_cache_add(page, LRU_INACTIVE_ANON);
 }
 
-static inline void lru_cache_add_active(struct page *page)
+static inline void lru_cache_add_active_anon(struct page *page)
 {
-	__lru_cache_add(page, LRU_ACTIVE);
+	__lru_cache_add(page, LRU_ACTIVE_ANON);
+}
+
+static inline void lru_cache_add_file(struct page *page)
+{
+	__lru_cache_add(page, LRU_INACTIVE_FILE);
+}
+
+static inline void lru_cache_add_active_file(struct page *page)
+{
+	__lru_cache_add(page, LRU_ACTIVE_FILE);
 }
 
 /* linux/mm/vmscan.c */
@@ -199,7 +209,7 @@ extern unsigned long try_to_free_pages(s
 					gfp_t gfp_mask);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
 							gfp_t gfp_mask);
-extern int __isolate_lru_page(struct page *page, int mode);
+extern int __isolate_lru_page(struct page *page, int mode, int file);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
 extern int remove_mapping(struct address_space *mapping, struct page *page);
diff -puN include/linux/vmstat.h~vmscan-split-lru-lists-into-anon-file-sets include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmscan-split-lru-lists-into-anon-file-sets
+++ a/include/linux/vmstat.h
@@ -159,6 +159,16 @@ static inline unsigned long zone_page_st
 	return x;
 }
 
+extern unsigned long global_lru_pages(void);
+
+static inline unsigned long zone_lru_pages(struct zone *zone)
+{
+	return (zone_page_state(zone, NR_ACTIVE_ANON)
+		+ zone_page_state(zone, NR_ACTIVE_FILE)
+		+ zone_page_state(zone, NR_INACTIVE_ANON)
+		+ zone_page_state(zone, NR_INACTIVE_FILE));
+}
+
 #ifdef CONFIG_NUMA
 /*
  * Determine the per node value of a stat item. This function
diff -puN mm/filemap.c~vmscan-split-lru-lists-into-anon-file-sets mm/filemap.c
--- a/mm/filemap.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/mm/filemap.c
@@ -33,6 +33,7 @@
 #include <linux/cpuset.h>
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
+#include <linux/mm_inline.h> /* for page_is_file_cache() */
 #include "internal.h"
 
 /*
@@ -493,8 +494,12 @@ int add_to_page_cache_lru(struct page *p
 				pgoff_t offset, gfp_t gfp_mask)
 {
 	int ret = add_to_page_cache(page, mapping, offset, gfp_mask);
-	if (ret == 0)
-		lru_cache_add(page);
+	if (ret == 0) {
+		if (page_is_file_cache(page))
+			lru_cache_add_file(page);
+		else
+			lru_cache_add_active_anon(page);
+	}
 	return ret;
 }
 
diff -puN mm/memcontrol.c~vmscan-split-lru-lists-into-anon-file-sets mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/mm/memcontrol.c
@@ -162,6 +162,7 @@ struct page_cgroup {
 };
 #define PAGE_CGROUP_FLAG_CACHE	(0x1)	/* charged as cache */
 #define PAGE_CGROUP_FLAG_ACTIVE (0x2)	/* page is active in this cgroup */
+#define PAGE_CGROUP_FLAG_FILE	(0x4)	/* page is file system backed */
 
 static int page_cgroup_nid(struct page_cgroup *pc)
 {
@@ -280,8 +281,12 @@ static void unlock_page_cgroup(struct pa
 static void __mem_cgroup_remove_list(struct mem_cgroup_per_zone *mz,
 			struct page_cgroup *pc)
 {
-	int from = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
-	int lru = !!from;
+	int lru = LRU_BASE;
+
+	if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
+		lru += LRU_ACTIVE;
+	if (pc->flags & PAGE_CGROUP_FLAG_FILE)
+		lru += LRU_FILE;
 
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
 
@@ -292,10 +297,12 @@ static void __mem_cgroup_remove_list(str
 static void __mem_cgroup_add_list(struct mem_cgroup_per_zone *mz,
 				struct page_cgroup *pc)
 {
-	int lru = LRU_INACTIVE;
+	int lru = LRU_BASE;
 
 	if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
 		lru += LRU_ACTIVE;
+	if (pc->flags & PAGE_CGROUP_FLAG_FILE)
+		lru += LRU_FILE;
 
 	MEM_CGROUP_ZSTAT(mz, lru) += 1;
 	list_add(&pc->lru, &mz->lists[lru]);
@@ -306,10 +313,9 @@ static void __mem_cgroup_add_list(struct
 static void __mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
 {
 	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
-	int lru = LRU_INACTIVE;
-
-	if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
-		lru += LRU_ACTIVE;
+	int from = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
+	int file = pc->flags & PAGE_CGROUP_FLAG_FILE;
+	int lru = LRU_FILE * !!file + !!from;
 
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
 
@@ -318,7 +324,7 @@ static void __mem_cgroup_move_lists(stru
 	else
 		pc->flags &= ~PAGE_CGROUP_FLAG_ACTIVE;
 
-	lru = !!active;
+	lru = LRU_FILE * !!file + !!active;
 	MEM_CGROUP_ZSTAT(mz, lru) += 1;
 	list_move(&pc->lru, &mz->lists[lru]);
 }
@@ -380,21 +386,6 @@ int mem_cgroup_calc_mapped_ratio(struct 
 }
 
 /*
- * This function is called from vmscan.c. In page reclaiming loop. balance
- * between active and inactive list is calculated. For memory controller
- * page reclaiming, we should use using mem_cgroup's imbalance rather than
- * zone's global lru imbalance.
- */
-long mem_cgroup_reclaim_imbalance(struct mem_cgroup *mem)
-{
-	unsigned long active, inactive;
-	/* active and inactive are the number of pages. 'long' is ok.*/
-	active = mem_cgroup_get_all_zonestat(mem, LRU_ACTIVE);
-	inactive = mem_cgroup_get_all_zonestat(mem, LRU_INACTIVE);
-	return (long) (active / (inactive + 1));
-}
-
-/*
  * prev_priority control...this will be used in memory reclaim path.
  */
 int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem)
@@ -439,7 +430,7 @@ unsigned long mem_cgroup_isolate_pages(u
 					unsigned long *scanned, int order,
 					int mode, struct zone *z,
 					struct mem_cgroup *mem_cont,
-					int active)
+					int active, int file)
 {
 	unsigned long nr_taken = 0;
 	struct page *page;
@@ -450,7 +441,7 @@ unsigned long mem_cgroup_isolate_pages(u
 	int nid = z->zone_pgdat->node_id;
 	int zid = zone_idx(z);
 	struct mem_cgroup_per_zone *mz;
-	int lru = !!active;
+	int lru = LRU_FILE * !!file + !!active;
 
 	BUG_ON(!mem_cont);
 	mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
@@ -466,6 +457,9 @@ unsigned long mem_cgroup_isolate_pages(u
 		if (unlikely(!PageLRU(page)))
 			continue;
 
+		/*
+		 * TODO: play better with lumpy reclaim, grabbing anything.
+		 */
 		if (PageActive(page) && !active) {
 			__mem_cgroup_move_lists(pc, true);
 			continue;
@@ -478,7 +472,7 @@ unsigned long mem_cgroup_isolate_pages(u
 		scan++;
 		list_move(&pc->lru, &pc_list);
 
-		if (__isolate_lru_page(page, mode) == 0) {
+		if (__isolate_lru_page(page, mode, file) == 0) {
 			list_move(&page->lru, dst);
 			nr_taken++;
 		}
@@ -562,9 +556,11 @@ static int mem_cgroup_charge_common(stru
 	 * If a page is accounted as a page cache, insert to inactive list.
 	 * If anon, insert to active list.
 	 */
-	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
+	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE) {
 		pc->flags = PAGE_CGROUP_FLAG_CACHE;
-	else
+		if (page_is_file_cache(page))
+			pc->flags |= PAGE_CGROUP_FLAG_FILE;
+	} else
 		pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
 
 	lock_page_cgroup(page);
@@ -915,14 +911,21 @@ static int mem_control_stat_show(struct 
 	}
 	/* showing # of active pages */
 	{
-		unsigned long active, inactive;
+		unsigned long active_anon, inactive_anon;
+		unsigned long active_file, inactive_file;
 
-		inactive = mem_cgroup_get_all_zonestat(mem_cont,
-						LRU_INACTIVE);
-		active = mem_cgroup_get_all_zonestat(mem_cont,
-						LRU_ACTIVE);
-		cb->fill(cb, "active", (active) * PAGE_SIZE);
-		cb->fill(cb, "inactive", (inactive) * PAGE_SIZE);
+		inactive_anon = mem_cgroup_get_all_zonestat(mem_cont,
+						LRU_INACTIVE_ANON);
+		active_anon = mem_cgroup_get_all_zonestat(mem_cont,
+						LRU_ACTIVE_ANON);
+		inactive_file = mem_cgroup_get_all_zonestat(mem_cont,
+						LRU_INACTIVE_FILE);
+		active_file = mem_cgroup_get_all_zonestat(mem_cont,
+						LRU_ACTIVE_FILE);
+		cb->fill(cb, "active_anon", (active_anon) * PAGE_SIZE);
+		cb->fill(cb, "inactive_anon", (inactive_anon) * PAGE_SIZE);
+		cb->fill(cb, "active_file", (active_file) * PAGE_SIZE);
+		cb->fill(cb, "inactive_file", (inactive_file) * PAGE_SIZE);
 	}
 	return 0;
 }
diff -puN mm/memory.c~vmscan-split-lru-lists-into-anon-file-sets mm/memory.c
--- a/mm/memory.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/mm/memory.c
@@ -1805,7 +1805,7 @@ gotten:
 		set_pte_at(mm, address, page_table, entry);
 		update_mmu_cache(vma, address, entry);
 		SetPageSwapBacked(new_page);
-		lru_cache_add_active(new_page);
+		lru_cache_add_active_anon(new_page);
 		page_add_new_anon_rmap(new_page, vma, address);
 
 		/* Free the old page.. */
@@ -2274,7 +2274,7 @@ static int do_anonymous_page(struct mm_s
 		goto release;
 	inc_mm_counter(mm, anon_rss);
 	SetPageSwapBacked(page);
-	lru_cache_add_active(page);
+	lru_cache_add_active_anon(page);
 	page_add_new_anon_rmap(page, vma, address);
 	set_pte_at(mm, address, page_table, entry);
 
@@ -2416,7 +2416,7 @@ static int __do_fault(struct mm_struct *
 		if (anon) {
                         inc_mm_counter(mm, anon_rss);
 			SetPageSwapBacked(page);
-                        lru_cache_add_active(page);
+                        lru_cache_add_active_anon(page);
                         page_add_new_anon_rmap(page, vma, address);
 		} else {
 			inc_mm_counter(mm, file_rss);
diff -puN mm/page-writeback.c~vmscan-split-lru-lists-into-anon-file-sets mm/page-writeback.c
--- a/mm/page-writeback.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/mm/page-writeback.c
@@ -329,9 +329,7 @@ static unsigned long highmem_dirtyable_m
 		struct zone *z =
 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
-		x += zone_page_state(z, NR_FREE_PAGES)
-			+ zone_page_state(z, NR_INACTIVE)
-			+ zone_page_state(z, NR_ACTIVE);
+		x += zone_page_state(z, NR_FREE_PAGES) + zone_lru_pages(z);
 	}
 	/*
 	 * Make sure that the number of highmem pages is never larger
@@ -355,9 +353,7 @@ unsigned long determine_dirtyable_memory
 {
 	unsigned long x;
 
-	x = global_page_state(NR_FREE_PAGES)
-		+ global_page_state(NR_INACTIVE)
-		+ global_page_state(NR_ACTIVE);
+	x = global_page_state(NR_FREE_PAGES) + global_lru_pages();
 
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
diff -puN mm/page_alloc.c~vmscan-split-lru-lists-into-anon-file-sets mm/page_alloc.c
--- a/mm/page_alloc.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/mm/page_alloc.c
@@ -1834,10 +1834,13 @@ void show_free_areas(void)
 		}
 	}
 
-	printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu\n"
+	printk("Active_anon:%lu active_file:%lu inactive_anon%lu\n"
+		" inactive_file:%lu dirty:%lu writeback:%lu unstable:%lu\n"
 		" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
-		global_page_state(NR_ACTIVE),
-		global_page_state(NR_INACTIVE),
+		global_page_state(NR_ACTIVE_ANON),
+		global_page_state(NR_ACTIVE_FILE),
+		global_page_state(NR_INACTIVE_ANON),
+		global_page_state(NR_INACTIVE_FILE),
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
 		global_page_state(NR_UNSTABLE_NFS),
@@ -1860,8 +1863,10 @@ void show_free_areas(void)
 			" min:%lukB"
 			" low:%lukB"
 			" high:%lukB"
-			" active:%lukB"
-			" inactive:%lukB"
+			" active_anon:%lukB"
+			" inactive_anon:%lukB"
+			" active_file:%lukB"
+			" inactive_file:%lukB"
 			" present:%lukB"
 			" pages_scanned:%lu"
 			" all_unreclaimable? %s"
@@ -1871,8 +1876,10 @@ void show_free_areas(void)
 			K(zone->pages_min),
 			K(zone->pages_low),
 			K(zone->pages_high),
-			K(zone_page_state(zone, NR_ACTIVE)),
-			K(zone_page_state(zone, NR_INACTIVE)),
+			K(zone_page_state(zone, NR_ACTIVE_ANON)),
+			K(zone_page_state(zone, NR_INACTIVE_ANON)),
+			K(zone_page_state(zone, NR_ACTIVE_FILE)),
+			K(zone_page_state(zone, NR_INACTIVE_FILE)),
 			K(zone->present_pages),
 			zone->pages_scanned,
 			(zone_is_all_unreclaimable(zone) ? "yes" : "no")
@@ -3427,6 +3434,10 @@ static void __paginginit free_area_init_
 			INIT_LIST_HEAD(&zone->lru[l].list);
 			zone->lru[l].nr_scan = 0;
 		}
+		zone->recent_rotated[0] = 0;
+		zone->recent_rotated[1] = 0;
+		zone->recent_scanned[0] = 0;
+		zone->recent_scanned[1] = 0;
 		zap_zone_vm_stats(zone);
 		zone->flags = 0;
 		if (!size)
diff -puN mm/readahead.c~vmscan-split-lru-lists-into-anon-file-sets mm/readahead.c
--- a/mm/readahead.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/mm/readahead.c
@@ -229,7 +229,7 @@ int do_page_cache_readahead(struct addre
  */
 unsigned long max_sane_readahead(unsigned long nr)
 {
-	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE)
+	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
 		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
 }
 
diff -puN mm/swap.c~vmscan-split-lru-lists-into-anon-file-sets mm/swap.c
--- a/mm/swap.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/mm/swap.c
@@ -116,7 +116,8 @@ static void pagevec_move_tail(struct pag
 			spin_lock(&zone->lru_lock);
 		}
 		if (PageLRU(page) && !PageActive(page)) {
-			list_move_tail(&page->lru, &zone->lru[LRU_INACTIVE].list);
+			int lru = page_is_file_cache(page);
+			list_move_tail(&page->lru, &zone->lru[lru].list);
 			pgmoved++;
 		}
 	}
@@ -157,11 +158,18 @@ void activate_page(struct page *page)
 
 	spin_lock_irq(&zone->lru_lock);
 	if (PageLRU(page) && !PageActive(page)) {
-		del_page_from_inactive_list(zone, page);
+		int file = page_is_file_cache(page);
+		int lru = LRU_BASE + file;
+		del_page_from_lru_list(zone, page, lru);
+
 		SetPageActive(page);
-		add_page_to_active_list(zone, page);
+		lru += LRU_ACTIVE;
+		add_page_to_lru_list(zone, page, lru);
 		__count_vm_event(PGACTIVATE);
 		mem_cgroup_move_lists(page, true);
+
+		zone->recent_rotated[!!file]++;
+		zone->recent_scanned[!!file]++;
 	}
 	spin_unlock_irq(&zone->lru_lock);
 }
diff -puN mm/swap_state.c~vmscan-split-lru-lists-into-anon-file-sets mm/swap_state.c
--- a/mm/swap_state.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/mm/swap_state.c
@@ -310,7 +310,7 @@ struct page *read_swap_cache_async(swp_e
 			/*
 			 * Initiate read into locked page and return.
 			 */
-			lru_cache_add_active(new_page);
+			lru_cache_add_active_anon(new_page);
 			swap_readpage(NULL, new_page);
 			return new_page;
 		}
diff -puN mm/vmscan.c~vmscan-split-lru-lists-into-anon-file-sets mm/vmscan.c
--- a/mm/vmscan.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/mm/vmscan.c
@@ -78,7 +78,7 @@ struct scan_control {
 	unsigned long (*isolate_pages)(unsigned long nr, struct list_head *dst,
 			unsigned long *scanned, int order, int mode,
 			struct zone *z, struct mem_cgroup *mem_cont,
-			int active);
+			int active, int file);
 };
 
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
@@ -680,7 +680,7 @@ keep:
  *
  * returns 0 on success, -ve errno on failure.
  */
-int __isolate_lru_page(struct page *page, int mode)
+int __isolate_lru_page(struct page *page, int mode, int file)
 {
 	int ret = -EINVAL;
 
@@ -696,6 +696,9 @@ int __isolate_lru_page(struct page *page
 	if (mode != ISOLATE_BOTH && (!PageActive(page) != !mode))
 		return ret;
 
+	if (mode != ISOLATE_BOTH && (!page_is_file_cache(page) != !file))
+		return ret;
+
 	ret = -EBUSY;
 	if (likely(get_page_unless_zero(page))) {
 		/*
@@ -726,12 +729,13 @@ int __isolate_lru_page(struct page *page
  * @scanned:	The number of pages that were scanned.
  * @order:	The caller's attempted allocation order
  * @mode:	One of the LRU isolation modes
+ * @file:	True [1] if isolating file [!anon] pages
  *
  * returns how many pages were moved onto *@dst.
  */
 static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		struct list_head *src, struct list_head *dst,
-		unsigned long *scanned, int order, int mode)
+		unsigned long *scanned, int order, int mode, int file)
 {
 	unsigned long nr_taken = 0;
 	unsigned long scan;
@@ -748,7 +752,7 @@ static unsigned long isolate_lru_pages(u
 
 		VM_BUG_ON(!PageLRU(page));
 
-		switch (__isolate_lru_page(page, mode)) {
+		switch (__isolate_lru_page(page, mode, file)) {
 		case 0:
 			list_move(&page->lru, dst);
 			nr_taken++;
@@ -791,10 +795,11 @@ static unsigned long isolate_lru_pages(u
 				break;
 
 			cursor_page = pfn_to_page(pfn);
+
 			/* Check that we have not crossed a zone boundary. */
 			if (unlikely(page_zone_id(cursor_page) != zone_id))
 				continue;
-			switch (__isolate_lru_page(cursor_page, mode)) {
+			switch (__isolate_lru_page(cursor_page, mode, file)) {
 			case 0:
 				list_move(&cursor_page->lru, dst);
 				nr_taken++;
@@ -819,30 +824,37 @@ static unsigned long isolate_pages_globa
 					unsigned long *scanned, int order,
 					int mode, struct zone *z,
 					struct mem_cgroup *mem_cont,
-					int active)
+					int active, int file)
 {
+	int lru = LRU_BASE;
 	if (active)
-		return isolate_lru_pages(nr, &z->lru[LRU_ACTIVE].list, dst,
-						scanned, order, mode);
-	else
-		return isolate_lru_pages(nr, &z->lru[LRU_INACTIVE].list, dst,
-						scanned, order, mode);
+		lru += LRU_ACTIVE;
+	if (file)
+		lru += LRU_FILE;
+	return isolate_lru_pages(nr, &z->lru[lru].list, dst, scanned, order,
+								mode, !!file);
 }
 
 /*
  * clear_active_flags() is a helper for shrink_active_list(), clearing
  * any active bits from the pages in the list.
  */
-static unsigned long clear_active_flags(struct list_head *page_list)
+static unsigned long clear_active_flags(struct list_head *page_list,
+					unsigned int *count)
 {
 	int nr_active = 0;
+	int lru;
 	struct page *page;
 
-	list_for_each_entry(page, page_list, lru)
+	list_for_each_entry(page, page_list, lru) {
+		lru = page_is_file_cache(page);
 		if (PageActive(page)) {
+			lru += LRU_ACTIVE;
 			ClearPageActive(page);
 			nr_active++;
 		}
+		count[lru]++;
+	}
 
 	return nr_active;
 }
@@ -880,12 +892,12 @@ int isolate_lru_page(struct page *page)
 
 		spin_lock_irq(&zone->lru_lock);
 		if (PageLRU(page) && get_page_unless_zero(page)) {
+			int lru = LRU_BASE;
 			ret = 0;
 			ClearPageLRU(page);
-			if (PageActive(page))
-				del_page_from_active_list(zone, page);
-			else
-				del_page_from_inactive_list(zone, page);
+
+			lru += page_is_file_cache(page) + !!PageActive(page);
+			del_page_from_lru_list(zone, page, lru);
 		}
 		spin_unlock_irq(&zone->lru_lock);
 	}
@@ -897,7 +909,7 @@ int isolate_lru_page(struct page *page)
  * of reclaimed pages
  */
 static unsigned long shrink_inactive_list(unsigned long max_scan,
-				struct zone *zone, struct scan_control *sc)
+			struct zone *zone, struct scan_control *sc, int file)
 {
 	LIST_HEAD(page_list);
 	struct pagevec pvec;
@@ -914,20 +926,32 @@ static unsigned long shrink_inactive_lis
 		unsigned long nr_scan;
 		unsigned long nr_freed;
 		unsigned long nr_active;
+		unsigned int count[NR_LRU_LISTS] = { 0, };
+		int mode = (sc->order > PAGE_ALLOC_COSTLY_ORDER) ?
+					ISOLATE_BOTH : ISOLATE_INACTIVE;
 
 		nr_taken = sc->isolate_pages(sc->swap_cluster_max,
-			     &page_list, &nr_scan, sc->order,
-			     (sc->order > PAGE_ALLOC_COSTLY_ORDER)?
-					     ISOLATE_BOTH : ISOLATE_INACTIVE,
-				zone, sc->mem_cgroup, 0);
-		nr_active = clear_active_flags(&page_list);
+			     &page_list, &nr_scan, sc->order, mode,
+				zone, sc->mem_cgroup, 0, file);
+		nr_active = clear_active_flags(&page_list, count);
 		__count_vm_events(PGDEACTIVATE, nr_active);
 
-		__mod_zone_page_state(zone, NR_ACTIVE, -nr_active);
-		__mod_zone_page_state(zone, NR_INACTIVE,
-						-(nr_taken - nr_active));
-		if (scan_global_lru(sc))
+		__mod_zone_page_state(zone, NR_ACTIVE_FILE,
+						-count[LRU_ACTIVE_FILE]);
+		__mod_zone_page_state(zone, NR_INACTIVE_FILE,
+						-count[LRU_INACTIVE_FILE]);
+		__mod_zone_page_state(zone, NR_ACTIVE_ANON,
+						-count[LRU_ACTIVE_ANON]);
+		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
+						-count[LRU_INACTIVE_ANON]);
+
+		if (scan_global_lru(sc)) {
 			zone->pages_scanned += nr_scan;
+			zone->recent_scanned[0] += count[LRU_INACTIVE_ANON];
+			zone->recent_scanned[0] += count[LRU_ACTIVE_ANON];
+			zone->recent_scanned[1] += count[LRU_INACTIVE_FILE];
+			zone->recent_scanned[1] += count[LRU_ACTIVE_FILE];
+		}
 		spin_unlock_irq(&zone->lru_lock);
 
 		nr_scanned += nr_scan;
@@ -947,7 +971,7 @@ static unsigned long shrink_inactive_lis
 			 * The attempt at page out may have made some
 			 * of the pages active, mark them inactive again.
 			 */
-			nr_active = clear_active_flags(&page_list);
+			nr_active = clear_active_flags(&page_list, count);
 			count_vm_events(PGDEACTIVATE, nr_active);
 
 			nr_freed += shrink_page_list(&page_list, sc,
@@ -977,6 +1001,10 @@ static unsigned long shrink_inactive_lis
 			SetPageLRU(page);
 			list_del(&page->lru);
 			add_page_to_lru_list(zone, page, page_lru(page));
+			if (PageActive(page) && scan_global_lru(sc)) {
+				int file = !!page_is_file_cache(page);
+				zone->recent_rotated[file]++;
+			}
 			if (!pagevec_add(&pvec, page)) {
 				spin_unlock_irq(&zone->lru_lock);
 				__pagevec_release(&pvec);
@@ -1007,115 +1035,7 @@ static inline void note_zone_scanning_pr
 
 static inline int zone_is_near_oom(struct zone *zone)
 {
-	return zone->pages_scanned >= (zone_page_state(zone, NR_ACTIVE)
-				+ zone_page_state(zone, NR_INACTIVE))*3;
-}
-
-/*
- * Determine we should try to reclaim mapped pages.
- * This is called only when sc->mem_cgroup is NULL.
- */
-static int calc_reclaim_mapped(struct scan_control *sc, struct zone *zone,
-				int priority)
-{
-	long mapped_ratio;
-	long distress;
-	long swap_tendency;
-	long imbalance;
-	int reclaim_mapped = 0;
-	int prev_priority;
-
-	if (scan_global_lru(sc) && zone_is_near_oom(zone))
-		return 1;
-	/*
-	 * `distress' is a measure of how much trouble we're having
-	 * reclaiming pages.  0 -> no problems.  100 -> great trouble.
-	 */
-	if (scan_global_lru(sc))
-		prev_priority = zone->prev_priority;
-	else
-		prev_priority = mem_cgroup_get_reclaim_priority(sc->mem_cgroup);
-
-	distress = 100 >> min(prev_priority, priority);
-
-	/*
-	 * The point of this algorithm is to decide when to start
-	 * reclaiming mapped memory instead of just pagecache.  Work out
-	 * how much memory
-	 * is mapped.
-	 */
-	if (scan_global_lru(sc))
-		mapped_ratio = ((global_page_state(NR_FILE_MAPPED) +
-				global_page_state(NR_ANON_PAGES)) * 100) /
-					vm_total_pages;
-	else
-		mapped_ratio = mem_cgroup_calc_mapped_ratio(sc->mem_cgroup);
-
-	/*
-	 * Now decide how much we really want to unmap some pages.  The
-	 * mapped ratio is downgraded - just because there's a lot of
-	 * mapped memory doesn't necessarily mean that page reclaim
-	 * isn't succeeding.
-	 *
-	 * The distress ratio is important - we don't want to start
-	 * going oom.
-	 *
-	 * A 100% value of vm_swappiness overrides this algorithm
-	 * altogether.
-	 */
-	swap_tendency = mapped_ratio / 2 + distress + sc->swappiness;
-
-	/*
-	 * If there's huge imbalance between active and inactive
-	 * (think active 100 times larger than inactive) we should
-	 * become more permissive, or the system will take too much
-	 * cpu before it start swapping during memory pressure.
-	 * Distress is about avoiding early-oom, this is about
-	 * making swappiness graceful despite setting it to low
-	 * values.
-	 *
-	 * Avoid div by zero with nr_inactive+1, and max resulting
-	 * value is vm_total_pages.
-	 */
-	if (scan_global_lru(sc)) {
-		imbalance  = zone_page_state(zone, NR_ACTIVE);
-		imbalance /= zone_page_state(zone, NR_INACTIVE) + 1;
-	} else
-		imbalance = mem_cgroup_reclaim_imbalance(sc->mem_cgroup);
-
-	/*
-	 * Reduce the effect of imbalance if swappiness is low,
-	 * this means for a swappiness very low, the imbalance
-	 * must be much higher than 100 for this logic to make
-	 * the difference.
-	 *
-	 * Max temporary value is vm_total_pages*100.
-	 */
-	imbalance *= (vm_swappiness + 1);
-	imbalance /= 100;
-
-	/*
-	 * If not much of the ram is mapped, makes the imbalance
-	 * less relevant, it's high priority we refill the inactive
-	 * list with mapped pages only in presence of high ratio of
-	 * mapped pages.
-	 *
-	 * Max temporary value is vm_total_pages*100.
-	 */
-	imbalance *= mapped_ratio;
-	imbalance /= 100;
-
-	/* apply imbalance feedback to swap_tendency */
-	swap_tendency += imbalance;
-
-	/*
-	 * Now use this metric to decide whether to start moving mapped
-	 * memory onto the inactive list.
-	 */
-	if (swap_tendency >= 100)
-		reclaim_mapped = 1;
-
-	return reclaim_mapped;
+	return zone->pages_scanned >= (zone_lru_pages(zone) * 3);
 }
 
 /*
@@ -1138,7 +1058,7 @@ static int calc_reclaim_mapped(struct sc
 
 
 static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
-				struct scan_control *sc, int priority)
+			struct scan_control *sc, int priority, int file)
 {
 	unsigned long pgmoved;
 	int pgdeactivate = 0;
@@ -1148,46 +1068,45 @@ static void shrink_active_list(unsigned 
 	LIST_HEAD(l_inactive);
 	struct page *page;
 	struct pagevec pvec;
-	int reclaim_mapped = 0;
-
-	if (sc->may_swap)
-		reclaim_mapped = calc_reclaim_mapped(sc, zone, priority);
+	enum lru_list lru;
 
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
 	pgmoved = sc->isolate_pages(nr_pages, &l_hold, &pgscanned, sc->order,
 					ISOLATE_ACTIVE, zone,
-					sc->mem_cgroup, 1);
+					sc->mem_cgroup, 1, file);
 	/*
 	 * zone->pages_scanned is used for detect zone's oom
 	 * mem_cgroup remembers nr_scan by itself.
 	 */
-	if (scan_global_lru(sc))
+	if (scan_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
+		zone->recent_scanned[!!file] += pgmoved;
+	}
 
-	__mod_zone_page_state(zone, NR_ACTIVE, -pgmoved);
+	if (file)
+		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
+	else
+		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
 	spin_unlock_irq(&zone->lru_lock);
 
 	while (!list_empty(&l_hold)) {
 		cond_resched();
 		page = lru_to_page(&l_hold);
 		list_del(&page->lru);
-		if (page_mapped(page)) {
-			if (!reclaim_mapped ||
-			    (total_swap_pages == 0 && PageAnon(page)) ||
-			    page_referenced(page, 0, sc->mem_cgroup)) {
-				list_add(&page->lru, &l_active);
-				continue;
-			}
-		} else if (TestClearPageReferenced(page)) {
+		if (page_referenced(page, 0, sc->mem_cgroup))
 			list_add(&page->lru, &l_active);
-			continue;
-		}
-		list_add(&page->lru, &l_inactive);
+		else
+			list_add(&page->lru, &l_inactive);
 	}
 
+	/*
+	 * Now put the pages back on the appropriate [file or anon] inactive
+	 * and active lists.
+	 */
 	pagevec_init(&pvec, 1);
 	pgmoved = 0;
+	lru = LRU_BASE + file * LRU_FILE;
 	spin_lock_irq(&zone->lru_lock);
 	while (!list_empty(&l_inactive)) {
 		page = lru_to_page(&l_inactive);
@@ -1197,11 +1116,11 @@ static void shrink_active_list(unsigned 
 		VM_BUG_ON(!PageActive(page));
 		ClearPageActive(page);
 
-		list_move(&page->lru, &zone->lru[LRU_INACTIVE].list);
+		list_move(&page->lru, &zone->lru[lru].list);
 		mem_cgroup_move_lists(page, false);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
-			__mod_zone_page_state(zone, NR_INACTIVE, pgmoved);
+			__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
 			spin_unlock_irq(&zone->lru_lock);
 			pgdeactivate += pgmoved;
 			pgmoved = 0;
@@ -1211,7 +1130,7 @@ static void shrink_active_list(unsigned 
 			spin_lock_irq(&zone->lru_lock);
 		}
 	}
-	__mod_zone_page_state(zone, NR_INACTIVE, pgmoved);
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
 	pgdeactivate += pgmoved;
 	if (buffer_heads_over_limit) {
 		spin_unlock_irq(&zone->lru_lock);
@@ -1220,6 +1139,7 @@ static void shrink_active_list(unsigned 
 	}
 
 	pgmoved = 0;
+	lru = LRU_ACTIVE + file * LRU_FILE;
 	while (!list_empty(&l_active)) {
 		page = lru_to_page(&l_active);
 		prefetchw_prev_lru_page(page, &l_active, flags);
@@ -1227,11 +1147,11 @@ static void shrink_active_list(unsigned 
 		SetPageLRU(page);
 		VM_BUG_ON(!PageActive(page));
 
-		list_move(&page->lru, &zone->lru[LRU_ACTIVE].list);
+		list_move(&page->lru, &zone->lru[lru].list);
 		mem_cgroup_move_lists(page, true);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
-			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
+			__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
 			pgmoved = 0;
 			spin_unlock_irq(&zone->lru_lock);
 			if (vm_swap_full())
@@ -1240,7 +1160,8 @@ static void shrink_active_list(unsigned 
 			spin_lock_irq(&zone->lru_lock);
 		}
 	}
-	__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
+	zone->recent_rotated[!!file] += pgmoved;
 
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	__count_vm_events(PGDEACTIVATE, pgdeactivate);
@@ -1251,16 +1172,103 @@ static void shrink_active_list(unsigned 
 	pagevec_release(&pvec);
 }
 
-static unsigned long shrink_list(enum lru_list l, unsigned long nr_to_scan,
+static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 	struct zone *zone, struct scan_control *sc, int priority)
 {
-	if (l == LRU_ACTIVE) {
-		shrink_active_list(nr_to_scan, zone, sc, priority);
+	int file = is_file_lru(lru);
+
+	if (lru == LRU_ACTIVE_ANON || lru == LRU_ACTIVE_FILE) {
+		shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
-	return shrink_inactive_list(nr_to_scan, zone, sc);
+	return shrink_inactive_list(nr_to_scan, zone, sc, file);
+}
+
+/*
+ * Determine how aggressively the anon and file LRU lists should be
+ * scanned.  The relative value of each set of LRU lists is determined
+ * by looking at the fraction of the pages scanned we did rotate back
+ * onto the active list instead of evict.
+ *
+ * percent[0] specifies how much pressure to put on ram/swap backed
+ * memory, while percent[1] determines pressure on the file LRUs.
+ */
+static void get_scan_ratio(struct zone *zone, struct scan_control * sc,
+					unsigned long *percent)
+{
+	unsigned long anon, file, free;
+	unsigned long anon_prio, file_prio;
+	unsigned long ap, fp;
+
+	anon  = zone_page_state(zone, NR_ACTIVE_ANON) +
+		zone_page_state(zone, NR_INACTIVE_ANON);
+	file  = zone_page_state(zone, NR_ACTIVE_FILE) +
+		zone_page_state(zone, NR_INACTIVE_FILE);
+	free  = zone_page_state(zone, NR_FREE_PAGES);
+
+	/* If we have no swap space, do not bother scanning anon pages. */
+	if (nr_swap_pages <= 0) {
+		percent[0] = 0;
+		percent[1] = 100;
+		return;
+	}
+
+	/* If we have very few page cache pages, force-scan anon pages. */
+	if (unlikely(file + free <= zone->pages_high)) {
+		percent[0] = 100;
+		percent[1] = 0;
+		return;
+	}
+
+	/*
+         * OK, so we have swap space and a fair amount of page cache
+         * pages.  We use the recently rotated / recently scanned
+         * ratios to determine how valuable each cache is.
+         *
+         * Because workloads change over time (and to avoid overflow)
+         * we keep these statistics as a floating average, which ends
+         * up weighing recent references more than old ones.
+         *
+         * anon in [0], file in [1]
+         */
+	if (unlikely(zone->recent_scanned[0] > anon / 4)) {
+		spin_lock_irq(&zone->lru_lock);
+		zone->recent_scanned[0] /= 2;
+		zone->recent_rotated[0] /= 2;
+		spin_unlock_irq(&zone->lru_lock);
+	}
+
+	if (unlikely(zone->recent_scanned[1] > file / 4)) {
+		spin_lock_irq(&zone->lru_lock);
+		zone->recent_scanned[1] /= 2;
+		zone->recent_rotated[1] /= 2;
+		spin_unlock_irq(&zone->lru_lock);
+	}
+
+	/*
+	 * With swappiness at 100, anonymous and file have the same priority.
+	 * This scanning priority is essentially the inverse of IO cost.
+	 */
+	anon_prio = sc->swappiness;
+	file_prio = 200 - sc->swappiness;
+
+	/*
+	 *                  anon       recent_rotated[0]
+	 * %anon = 100 * ----------- / ----------------- * IO cost
+	 *               anon + file      rotate_sum
+	 */
+	ap = (anon_prio + 1) * (zone->recent_scanned[0] + 1);
+	ap /= zone->recent_rotated[0] + 1;
+
+	fp = (file_prio + 1) * (zone->recent_scanned[1] + 1);
+	fp /= zone->recent_rotated[1] + 1;
+
+	/* Normalize to percentages */
+	percent[0] = 100 * ap / (ap + fp + 1);
+	percent[1] = 100 - percent[0];
 }
 
+
 /*
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
  */
@@ -1270,36 +1278,41 @@ static unsigned long shrink_zone(int pri
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
 	unsigned long nr_reclaimed = 0;
+	unsigned long percent[2];	/* anon @ 0; file @ 1 */
 	enum lru_list l;
 
-	if (scan_global_lru(sc)) {
-		/*
-		 * Add one to nr_to_scan just to make sure that the kernel
-		 * will slowly sift through the active list.
-		 */
-		for_each_lru(l) {
-			zone->lru[l].nr_scan += (zone_page_state(zone,
-					NR_LRU_BASE + l)  >> priority) + 1;
+	get_scan_ratio(zone, sc, percent);
+
+	for_each_lru(l) {
+		if (scan_global_lru(sc)) {
+			int file = is_file_lru(l);
+			int scan;
+			/*
+			 * Add one to nr_to_scan just to make sure that the
+			 * kernel will slowly sift through each list.
+			 */
+			scan = zone_page_state(zone, NR_LRU_BASE + l);
+			scan >>= priority;
+			scan = (scan * percent[file]) / 100;
+			zone->lru[l].nr_scan += scan + 1;
 			nr[l] = zone->lru[l].nr_scan;
 			if (nr[l] >= sc->swap_cluster_max)
 				zone->lru[l].nr_scan = 0;
 			else
 				nr[l] = 0;
+		} else {
+			/*
+			 * This reclaim occurs not because zone memory shortage
+			 * but because memory controller hits its limit.
+			 * Don't modify zone reclaim related data.
+			 */
+			nr[l] = mem_cgroup_calc_reclaim(sc->mem_cgroup, zone,
+								priority, l);
 		}
-	} else {
-		/*
-		 * This reclaim occurs not because zone memory shortage but
-		 * because memory controller hits its limit.
-		 * Then, don't modify zone reclaim related data.
-		 */
-		nr[LRU_ACTIVE] = mem_cgroup_calc_reclaim(sc->mem_cgroup,
-					zone, priority, LRU_ACTIVE);
-
-		nr[LRU_INACTIVE] = mem_cgroup_calc_reclaim(sc->mem_cgroup,
-					zone, priority, LRU_INACTIVE);
 	}
 
-	while (nr[LRU_ACTIVE] || nr[LRU_INACTIVE]) {
+	while (nr[LRU_ACTIVE_ANON] || nr[LRU_INACTIVE_ANON] ||
+			nr[LRU_ACTIVE_FILE] || nr[LRU_INACTIVE_FILE]) {
 		for_each_lru(l) {
 			if (nr[l]) {
 				nr_to_scan = min(nr[l],
@@ -1372,7 +1385,7 @@ static unsigned long shrink_zones(int pr
 
 	return nr_reclaimed;
 }
- 
+
 /*
  * This is the main entry point to direct page reclaim.
  *
@@ -1415,8 +1428,7 @@ static unsigned long do_try_to_free_page
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 				continue;
 
-			lru_pages += zone_page_state(zone, NR_ACTIVE)
-					+ zone_page_state(zone, NR_INACTIVE);
+			lru_pages += zone_lru_pages(zone);
 		}
 	}
 
@@ -1618,8 +1630,7 @@ loop_again:
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
 
-			lru_pages += zone_page_state(zone, NR_ACTIVE)
-					+ zone_page_state(zone, NR_INACTIVE);
+			lru_pages += zone_lru_pages(zone);
 		}
 
 		/*
@@ -1663,8 +1674,7 @@ loop_again:
 			if (zone_is_all_unreclaimable(zone))
 				continue;
 			if (nr_slab == 0 && zone->pages_scanned >=
-				(zone_page_state(zone, NR_ACTIVE)
-				+ zone_page_state(zone, NR_INACTIVE)) * 6)
+						(zone_lru_pages(zone) * 6))
 					zone_set_flag(zone,
 						      ZONE_ALL_UNRECLAIMABLE);
 			/*
@@ -1718,7 +1728,7 @@ out:
 
 /*
  * The background pageout daemon, started as a kernel thread
- * from the init process. 
+ * from the init process.
  *
  * This basically trickles out pages so that we have _some_
  * free memory available even if there is no other activity
@@ -1812,6 +1822,14 @@ void wakeup_kswapd(struct zone *zone, in
 	wake_up_interruptible(&pgdat->kswapd_wait);
 }
 
+unsigned long global_lru_pages(void)
+{
+	return global_page_state(NR_ACTIVE_ANON)
+		+ global_page_state(NR_ACTIVE_FILE)
+		+ global_page_state(NR_INACTIVE_ANON)
+		+ global_page_state(NR_INACTIVE_FILE);
+}
+
 #ifdef CONFIG_PM
 /*
  * Helper function for shrink_all_memory().  Tries to reclaim 'nr_pages' pages
@@ -1837,7 +1855,8 @@ static unsigned long shrink_all_zones(un
 
 		for_each_lru(l) {
 			/* For pass = 0 we don't shrink the active list */
-			if (pass == 0 && l == LRU_ACTIVE)
+			if (pass == 0 &&
+				(l == LRU_ACTIVE || l == LRU_ACTIVE_FILE))
 				continue;
 
 			zone->lru[l].nr_scan +=
@@ -1859,11 +1878,6 @@ static unsigned long shrink_all_zones(un
 	return ret;
 }
 
-static unsigned long count_lru_pages(void)
-{
-	return global_page_state(NR_ACTIVE) + global_page_state(NR_INACTIVE);
-}
-
 /*
  * Try to free `nr_pages' of memory, system-wide, and return the number of
  * freed pages.
@@ -1889,7 +1903,7 @@ unsigned long shrink_all_memory(unsigned
 
 	current->reclaim_state = &reclaim_state;
 
-	lru_pages = count_lru_pages();
+	lru_pages = global_lru_pages();
 	nr_slab = global_page_state(NR_SLAB_RECLAIMABLE);
 	/* If slab caches are huge, it's better to hit them first */
 	while (nr_slab >= lru_pages) {
@@ -1932,7 +1946,7 @@ unsigned long shrink_all_memory(unsigned
 
 			reclaim_state.reclaimed_slab = 0;
 			shrink_slab(sc.nr_scanned, sc.gfp_mask,
-					count_lru_pages());
+					global_lru_pages());
 			ret += reclaim_state.reclaimed_slab;
 			if (ret >= nr_pages)
 				goto out;
@@ -1949,7 +1963,7 @@ unsigned long shrink_all_memory(unsigned
 	if (!ret) {
 		do {
 			reclaim_state.reclaimed_slab = 0;
-			shrink_slab(nr_pages, sc.gfp_mask, count_lru_pages());
+			shrink_slab(nr_pages, sc.gfp_mask, global_lru_pages());
 			ret += reclaim_state.reclaimed_slab;
 		} while (ret < nr_pages && reclaim_state.reclaimed_slab > 0);
 	}
diff -puN mm/vmstat.c~vmscan-split-lru-lists-into-anon-file-sets mm/vmstat.c
--- a/mm/vmstat.c~vmscan-split-lru-lists-into-anon-file-sets
+++ a/mm/vmstat.c
@@ -602,8 +602,10 @@ const struct seq_operations pagetypeinfo
 static const char * const vmstat_text[] = {
 	/* Zoned VM counters */
 	"nr_free_pages",
-	"nr_inactive",
-	"nr_active",
+	"nr_inactive_anon",
+	"nr_active_anon",
+	"nr_inactive_file",
+	"nr_active_file",
 	"nr_anon_pages",
 	"nr_mapped",
 	"nr_file_pages",
@@ -671,7 +673,7 @@ static void zoneinfo_show_print(struct s
 		   "\n        min      %lu"
 		   "\n        low      %lu"
 		   "\n        high     %lu"
-		   "\n        scanned  %lu (a: %lu i: %lu)"
+		   "\n        scanned  %lu (aa: %lu ia: %lu af: %lu if: %lu)"
 		   "\n        spanned  %lu"
 		   "\n        present  %lu",
 		   zone_page_state(zone, NR_FREE_PAGES),
@@ -679,8 +681,10 @@ static void zoneinfo_show_print(struct s
 		   zone->pages_low,
 		   zone->pages_high,
 		   zone->pages_scanned,
-		   zone->lru[LRU_ACTIVE].nr_scan,
-		   zone->lru[LRU_INACTIVE].nr_scan,
+		   zone->lru[LRU_ACTIVE_ANON].nr_scan,
+		   zone->lru[LRU_INACTIVE_ANON].nr_scan,
+		   zone->lru[LRU_ACTIVE_FILE].nr_scan,
+		   zone->lru[LRU_INACTIVE_FILE].nr_scan,
 		   zone->spanned_pages,
 		   zone->present_pages);
 
_

Patches currently in -mm which might be from riel@redhat.com are

ntp-let-update_persistent_clock-sleep.patch
access_process_vm-device-memory-infrastructure.patch
access_process_vm-device-memory-infrastructure-fix.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_get_new-rcu-safe-fix.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-free-swap-space-on-swap-in-activation.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check.patch
vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch
more-aggressively-use-lumpy-reclaim.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-count-attempts-to-free-mlocked-page.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
make-mm-rmapc-anon_vma_cachep-static.patch


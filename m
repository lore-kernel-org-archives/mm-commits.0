From: akpm@linux-foundation.org
Subject: [patch 110/127] meminfo: break apart a very long seq_printf with
 #ifdefs
Date: Fri, 07 Oct 2016 17:02:23 -0700
Message-ID: <57f8378f.xlIeXYEPsVCKNDSt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39593 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753618AbcJHACY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:02:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com, adobriyan@gmail.com, andi@firstfloor.org, viro@zeniv.linux.org.uk

From: Joe Perches <joe@perches.com>
Subject: meminfo: break apart a very long seq_printf with #ifdefs

Use a specific routine to emit most lines so that the code is
easier to read and maintain.

akpm:
   text    data     bss     dec     hex filename
   2976       8       0    2984     ba8 fs/proc/meminfo.o before
   2669       8       0    2677     a75 fs/proc/meminfo.o after

Link: http://lkml.kernel.org/r/8fce7fdef2ba081a4ef531594e97da8a9feebb58.1470810406.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c |  211 +++++++++++++++++++-------------------------
 1 file changed, 95 insertions(+), 116 deletions(-)

diff -puN fs/proc/meminfo.c~meminfo-break-apart-a-very-long-seq_printf-with-ifdefs fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~meminfo-break-apart-a-very-long-seq_printf-with-ifdefs
+++ a/fs/proc/meminfo.c
@@ -23,6 +23,25 @@ void __attribute__((weak)) arch_report_m
 {
 }
 
+static void show_val_kb(struct seq_file *m, const char *s, unsigned long num)
+{
+	char v[32];
+	static const char blanks[7] = {' ', ' ', ' ', ' ',' ', ' ', ' '};
+	int len;
+
+	len = num_to_str(v, sizeof(v), num << (PAGE_SHIFT - 10));
+
+	seq_write(m, s, 16);
+
+	if (len > 0) {
+		if (len < 8)
+			seq_write(m, blanks, 8 - len);
+
+		seq_write(m, v, len);
+	}
+	seq_write(m, " kB\n", 4);
+}
+
 static int meminfo_proc_show(struct seq_file *m, void *v)
 {
 	struct sysinfo i;
@@ -32,10 +51,6 @@ static int meminfo_proc_show(struct seq_
 	unsigned long pages[NR_LRU_LISTS];
 	int lru;
 
-/*
- * display in kilobytes.
- */
-#define K(x) ((x) << (PAGE_SHIFT - 10))
 	si_meminfo(&i);
 	si_swapinfo(&i);
 	committed = percpu_counter_read_positive(&vm_committed_as);
@@ -50,136 +65,100 @@ static int meminfo_proc_show(struct seq_
 
 	available = si_mem_available();
 
-	/*
-	 * Tagged format, for easy grepping and expansion.
-	 */
-	seq_printf(m,
-		"MemTotal:       %8lu kB\n"
-		"MemFree:        %8lu kB\n"
-		"MemAvailable:   %8lu kB\n"
-		"Buffers:        %8lu kB\n"
-		"Cached:         %8lu kB\n"
-		"SwapCached:     %8lu kB\n"
-		"Active:         %8lu kB\n"
-		"Inactive:       %8lu kB\n"
-		"Active(anon):   %8lu kB\n"
-		"Inactive(anon): %8lu kB\n"
-		"Active(file):   %8lu kB\n"
-		"Inactive(file): %8lu kB\n"
-		"Unevictable:    %8lu kB\n"
-		"Mlocked:        %8lu kB\n"
-#ifdef CONFIG_HIGHMEM
-		"HighTotal:      %8lu kB\n"
-		"HighFree:       %8lu kB\n"
-		"LowTotal:       %8lu kB\n"
-		"LowFree:        %8lu kB\n"
-#endif
-#ifndef CONFIG_MMU
-		"MmapCopy:       %8lu kB\n"
-#endif
-		"SwapTotal:      %8lu kB\n"
-		"SwapFree:       %8lu kB\n"
-		"Dirty:          %8lu kB\n"
-		"Writeback:      %8lu kB\n"
-		"AnonPages:      %8lu kB\n"
-		"Mapped:         %8lu kB\n"
-		"Shmem:          %8lu kB\n"
-		"Slab:           %8lu kB\n"
-		"SReclaimable:   %8lu kB\n"
-		"SUnreclaim:     %8lu kB\n"
-		"KernelStack:    %8lu kB\n"
-		"PageTables:     %8lu kB\n"
-#ifdef CONFIG_QUICKLIST
-		"Quicklists:     %8lu kB\n"
-#endif
-		"NFS_Unstable:   %8lu kB\n"
-		"Bounce:         %8lu kB\n"
-		"WritebackTmp:   %8lu kB\n"
-		"CommitLimit:    %8lu kB\n"
-		"Committed_AS:   %8lu kB\n"
-		"VmallocTotal:   %8lu kB\n"
-		"VmallocUsed:    %8lu kB\n"
-		"VmallocChunk:   %8lu kB\n"
-#ifdef CONFIG_MEMORY_FAILURE
-		"HardwareCorrupted: %5lu kB\n"
-#endif
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		"AnonHugePages:  %8lu kB\n"
-		"ShmemHugePages: %8lu kB\n"
-		"ShmemPmdMapped: %8lu kB\n"
-#endif
-#ifdef CONFIG_CMA
-		"CmaTotal:       %8lu kB\n"
-		"CmaFree:        %8lu kB\n"
-#endif
-		,
-		K(i.totalram),
-		K(i.freeram),
-		K(available),
-		K(i.bufferram),
-		K(cached),
-		K(total_swapcache_pages()),
-		K(pages[LRU_ACTIVE_ANON]   + pages[LRU_ACTIVE_FILE]),
-		K(pages[LRU_INACTIVE_ANON] + pages[LRU_INACTIVE_FILE]),
-		K(pages[LRU_ACTIVE_ANON]),
-		K(pages[LRU_INACTIVE_ANON]),
-		K(pages[LRU_ACTIVE_FILE]),
-		K(pages[LRU_INACTIVE_FILE]),
-		K(pages[LRU_UNEVICTABLE]),
-		K(global_page_state(NR_MLOCK)),
+	show_val_kb(m, "MemTotal:       ", i.totalram);
+	show_val_kb(m, "MemFree:        ", i.freeram);
+	show_val_kb(m, "MemAvailable:   ", available);
+	show_val_kb(m, "Buffers:        ", i.bufferram);
+	show_val_kb(m, "Cached:         ", cached);
+	show_val_kb(m, "SwapCached:     ", total_swapcache_pages());
+	show_val_kb(m, "Active:         ", pages[LRU_ACTIVE_ANON] +
+					   pages[LRU_ACTIVE_FILE]);
+	show_val_kb(m, "Inactive:       ", pages[LRU_INACTIVE_ANON] +
+					   pages[LRU_INACTIVE_FILE]);
+	show_val_kb(m, "Active(anon):   ", pages[LRU_ACTIVE_ANON]);
+	show_val_kb(m, "Inactive(anon): ", pages[LRU_INACTIVE_ANON]);
+	show_val_kb(m, "Active(file):   ", pages[LRU_ACTIVE_FILE]);
+	show_val_kb(m, "Inactive(file): ", pages[LRU_INACTIVE_FILE]);
+	show_val_kb(m, "Unevictable:    ", pages[LRU_UNEVICTABLE]);
+	show_val_kb(m, "Mlocked:        ", global_page_state(NR_MLOCK));
+
 #ifdef CONFIG_HIGHMEM
-		K(i.totalhigh),
-		K(i.freehigh),
-		K(i.totalram-i.totalhigh),
-		K(i.freeram-i.freehigh),
+	show_val_kb(m, "HighTotal:      ", i.totalhigh);
+	show_val_kb(m, "HighFree:       ", i.freehigh);
+	show_val_kb(m, "LowTotal:       ", i.totalram - i.totalhigh);
+	show_val_kb(m, "LowFree:        ", i.freeram - i.freehigh);
 #endif
+
 #ifndef CONFIG_MMU
-		K((unsigned long) atomic_long_read(&mmap_pages_allocated)),
+	show_val_kb(m, "MmapCopy:       ",
+		    (unsigned long)atomic_long_read(&mmap_pages_allocated));
 #endif
-		K(i.totalswap),
-		K(i.freeswap),
-		K(global_node_page_state(NR_FILE_DIRTY)),
-		K(global_node_page_state(NR_WRITEBACK)),
-		K(global_node_page_state(NR_ANON_MAPPED)),
-		K(global_node_page_state(NR_FILE_MAPPED)),
-		K(i.sharedram),
-		K(global_page_state(NR_SLAB_RECLAIMABLE) +
-				global_page_state(NR_SLAB_UNRECLAIMABLE)),
-		K(global_page_state(NR_SLAB_RECLAIMABLE)),
-		K(global_page_state(NR_SLAB_UNRECLAIMABLE)),
-		global_page_state(NR_KERNEL_STACK_KB),
-		K(global_page_state(NR_PAGETABLE)),
+
+	show_val_kb(m, "SwapTotal:      ", i.totalswap);
+	show_val_kb(m, "SwapFree:       ", i.freeswap);
+	show_val_kb(m, "Dirty:          ",
+		    global_node_page_state(NR_FILE_DIRTY));
+	show_val_kb(m, "Writeback:      ",
+		    global_node_page_state(NR_WRITEBACK));
+	show_val_kb(m, "AnonPages:      ",
+		    global_node_page_state(NR_ANON_MAPPED));
+	show_val_kb(m, "Mapped:         ",
+		    global_node_page_state(NR_FILE_MAPPED));
+	show_val_kb(m, "Shmem:          ", i.sharedram);
+	show_val_kb(m, "Slab:           ",
+		    global_page_state(NR_SLAB_RECLAIMABLE) +
+		    global_page_state(NR_SLAB_UNRECLAIMABLE));
+
+	show_val_kb(m, "SReclaimable:   ",
+		    global_page_state(NR_SLAB_RECLAIMABLE));
+	show_val_kb(m, "SUnreclaim:     ",
+		    global_page_state(NR_SLAB_UNRECLAIMABLE));
+	seq_printf(m, "KernelStack:    %8lu kB\n",
+		   global_page_state(NR_KERNEL_STACK_KB));
+	show_val_kb(m, "PageTables:     ",
+		    global_page_state(NR_PAGETABLE));
 #ifdef CONFIG_QUICKLIST
-		K(quicklist_total_size()),
+	show_val_kb(m, "Quicklists:     ", quicklist_total_size());
 #endif
-		K(global_node_page_state(NR_UNSTABLE_NFS)),
-		K(global_page_state(NR_BOUNCE)),
-		K(global_node_page_state(NR_WRITEBACK_TEMP)),
-		K(vm_commit_limit()),
-		K(committed),
-		(unsigned long)VMALLOC_TOTAL >> 10,
-		0ul, // used to be vmalloc 'used'
-		0ul  // used to be vmalloc 'largest_chunk'
+
+	show_val_kb(m, "NFS_Unstable:   ",
+		    global_node_page_state(NR_UNSTABLE_NFS));
+	show_val_kb(m, "Bounce:         ",
+		    global_page_state(NR_BOUNCE));
+	show_val_kb(m, "WritebackTmp:   ",
+		    global_node_page_state(NR_WRITEBACK_TEMP));
+	show_val_kb(m, "CommitLimit:    ", vm_commit_limit());
+	show_val_kb(m, "Committed_AS:   ", committed);
+	seq_printf(m, "VmallocTotal:   %8lu kB\n",
+		   (unsigned long)VMALLOC_TOTAL >> 10);
+	show_val_kb(m, "VmallocUsed:    ", 0ul);
+	show_val_kb(m, "VmallocChunk:   ", 0ul);
+
 #ifdef CONFIG_MEMORY_FAILURE
-		, atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
+	seq_printf(m, "HardwareCorrupted: %5lu kB\n",
+		   atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10));
 #endif
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		, K(global_node_page_state(NR_ANON_THPS) * HPAGE_PMD_NR)
-		, K(global_node_page_state(NR_SHMEM_THPS) * HPAGE_PMD_NR)
-		, K(global_node_page_state(NR_SHMEM_PMDMAPPED) * HPAGE_PMD_NR)
+	show_val_kb(m, "AnonHugePages:  ",
+		    global_node_page_state(NR_ANON_THPS) * HPAGE_PMD_NR);
+	show_val_kb(m, "ShmemHugePages: ",
+		    global_node_page_state(NR_SHMEM_THPS) * HPAGE_PMD_NR);
+	show_val_kb(m, "ShmemPmdMapped: ",
+		    global_node_page_state(NR_SHMEM_PMDMAPPED) * HPAGE_PMD_NR);
 #endif
+
 #ifdef CONFIG_CMA
-		, K(totalcma_pages)
-		, K(global_page_state(NR_FREE_CMA_PAGES))
+	show_val_kb(m, "CmaTotal:       ", totalcma_pages);
+	show_val_kb(m, "CmaFree:        ",
+		    global_page_state(NR_FREE_CMA_PAGES));
 #endif
-		);
 
 	hugetlb_report_meminfo(m);
 
 	arch_report_meminfo(m);
 
 	return 0;
-#undef K
 }
 
 static int meminfo_proc_open(struct inode *inode, struct file *file)
_

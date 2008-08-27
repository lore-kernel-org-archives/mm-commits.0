From: akpm@linux-foundation.org
Subject: + mm-show-quicklist-usage-in-proc-meminfo.patch added to -mm tree
Date: Wed, 27 Aug 2008 15:34:12 -0700
Message-ID: <200808272234.m7RMYCOC026191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085AbYH0Weo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 18:34:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, tokunaga.keiich@jp.fujitsu.com


The patch titled
     mm: show quicklist usage in /proc/meminfo
has been added to the -mm tree.  Its filename is
     mm-show-quicklist-usage-in-proc-meminfo.patch

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
Subject: mm: show quicklist usage in /proc/meminfo
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Quicklists can consume several GB of memory.  We should provide a means of
monitoring this.

After this patch is applied, /proc/meminfo will output the following:

% cat /proc/meminfo

MemTotal:      7715392 kB
MemFree:       5401600 kB
Buffers:         80384 kB
Cached:         300800 kB
SwapCached:          0 kB
Active:         235584 kB
Inactive:       262656 kB
SwapTotal:     2031488 kB
SwapFree:      2031488 kB
Dirty:            3520 kB
Writeback:           0 kB
AnonPages:      117696 kB
Mapped:          38528 kB
Slab:          1589952 kB
SReclaimable:    23104 kB
SUnreclaim:    1566848 kB
PageTables:      14656 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
WritebackTmp:        0 kB
CommitLimit:   5889152 kB
Committed_AS:   393152 kB
VmallocTotal: 17592177655808 kB
VmallocUsed:     29056 kB
VmallocChunk: 17592177626432 kB
Quicklists:     130944 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:    262144 kB

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Keiichiro Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c       |    7 +++++--
 include/linux/quicklist.h |    7 +++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff -puN fs/proc/proc_misc.c~mm-show-quicklist-usage-in-proc-meminfo fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~mm-show-quicklist-usage-in-proc-meminfo
+++ a/fs/proc/proc_misc.c
@@ -24,6 +24,7 @@
 #include <linux/tty.h>
 #include <linux/string.h>
 #include <linux/mman.h>
+#include <linux/quicklist.h>
 #include <linux/proc_fs.h>
 #include <linux/ioport.h>
 #include <linux/mm.h>
@@ -189,7 +190,8 @@ static int meminfo_read_proc(char *page,
 		"Committed_AS: %8lu kB\n"
 		"VmallocTotal: %8lu kB\n"
 		"VmallocUsed:  %8lu kB\n"
-		"VmallocChunk: %8lu kB\n",
+		"VmallocChunk: %8lu kB\n"
+		"Quicklists:   %8lu kB\n",
 		K(i.totalram),
 		K(i.freeram),
 		K(i.bufferram),
@@ -221,7 +223,8 @@ static int meminfo_read_proc(char *page,
 		K(committed),
 		(unsigned long)VMALLOC_TOTAL >> 10,
 		vmi.used >> 10,
-		vmi.largest_chunk >> 10
+		vmi.largest_chunk >> 10,
+		K(quicklist_total_size())
 		);
 
 		len += hugetlb_report_meminfo(page + len);
diff -puN include/linux/quicklist.h~mm-show-quicklist-usage-in-proc-meminfo include/linux/quicklist.h
--- a/include/linux/quicklist.h~mm-show-quicklist-usage-in-proc-meminfo
+++ a/include/linux/quicklist.h
@@ -80,6 +80,13 @@ void quicklist_trim(int nr, void (*dtor)
 
 unsigned long quicklist_total_size(void);
 
+#else
+
+static inline unsigned long quicklist_total_size(void)
+{
+	return 0;
+}
+
 #endif
 
 #endif /* LINUX_QUICKLIST_H */
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-show-quicklist-usage-in-proc-meminfo.patch
mm-size-of-quicklists-shouldnt-be-proportional-to-the-number-of-cpus.patch
linux-next.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-nommu-fix.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
unevictable-lru-page-statistics.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update-2.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-__mlock_vma_pages_range-comment-block.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-return-value-for-munmap-mlock-vma-race.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscam-kill-unused-lru-functions.patch
mlock-revert-mainline-handling-of-mlock-error-return.patch
mlock-make-mlock-error-return-posixly-correct.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-unlockless-reclaim.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch


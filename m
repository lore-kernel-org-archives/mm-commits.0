From: akpm@linux-foundation.org
Subject: + mm-show-quicklist-memory-usage-in-proc-meminfo.patch added to -mm tree
Date: Wed, 20 Aug 2008 11:36:14 -0700
Message-ID: <200808201836.m7KIaEaW025133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752884AbYHTSg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 14:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, stable@kernel.org


The patch titled
     mm: show quicklist memory usage in /proc/meminfo
has been added to the -mm tree.  Its filename is
     mm-show-quicklist-memory-usage-in-proc-meminfo.patch

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
Subject: mm: show quicklist memory usage in /proc/meminfo
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

At present the quicklists store some page for each CPU as a cache.  (Each
CPU has node_free_pages/16 pages)

It is used for page table cache.  Then, exit() increase cache, the other
hand fork() spent it.

So, if apache type (one parent and many child model) middleware run, One
CPU process fork(), Other CPU process the middleware work and exit().

At that time, One CPU don't have page table cache at all, Others have
maximum caches.

	QList_max = (#ofCPUs - 1) x Free / 16
	=> QList_max / (Free + QList_max) = (#ofCPUs - 1) / (16 + #ofCPUs - 1)

So, How much quicklist spent memory at maximum case?  That is #CPUs
proposional because it is per CPU cache but cache amount calculation
doesn't use #ofCPUs.

	Above calculation mean

	 Number of CPUs per node            2    4    8   16
	 ==============================  ====================
	 QList_max / (Free + QList_max)   5.8%  16%  30%  48%


Wow!  Quicklist can spent about 50% memory at worst case.  More
unfortunately, it doesn't have any cache shrinking mechanism.  So it cause
some wrong thing.

1. End user misunderstand to memory leak happend.
	=> /proc/meminfo should display amount quicklist

2. It can cause OOM killer
	=> Amount of quicklists shouldn't be proportional to number of CPUs.



This patch:

Quicklists can consume several GB memory.  So, if end user can't see how
much memory is used, he can fail to understand why a memory leak happend.

after this patch applied, /proc/meminfo output following.

% cat /proc/meminfo

MemTotal:        7701504 kB
MemFree:         5159040 kB
Buffers:          112960 kB
Cached:           337536 kB
SwapCached:            0 kB
Active:           218944 kB
Inactive:         350848 kB
Active(anon):     120832 kB
Inactive(anon):        0 kB
Active(file):      98112 kB
Inactive(file):   350848 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       2031488 kB
SwapFree:        2031488 kB
Dirty:               320 kB
Writeback:             0 kB
AnonPages:        119488 kB
Mapped:            38528 kB
Slab:            1595712 kB
SReclaimable:      23744 kB
SUnreclaim:      1571968 kB
PageTables:        14336 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     5882240 kB
Committed_AS:     356672 kB
VmallocTotal:   17592177655808 kB
VmallocUsed:       29056 kB
VmallocChunk:   17592177626304 kB
Quicklists:       283776 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:    262144 kB

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c       |    6 ++++--
 include/linux/quicklist.h |    7 +++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/proc/proc_misc.c~mm-show-quicklist-memory-usage-in-proc-meminfo fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~mm-show-quicklist-memory-usage-in-proc-meminfo
+++ a/fs/proc/proc_misc.c
@@ -189,7 +189,8 @@ static int meminfo_read_proc(char *page,
 		"Committed_AS: %8lu kB\n"
 		"VmallocTotal: %8lu kB\n"
 		"VmallocUsed:  %8lu kB\n"
-		"VmallocChunk: %8lu kB\n",
+		"VmallocChunk:   %8lu kB\n"
+		"Quicklists:     %8lu kB\n",
 		K(i.totalram),
 		K(i.freeram),
 		K(i.bufferram),
@@ -221,7 +222,8 @@ static int meminfo_read_proc(char *page,
 		K(committed),
 		(unsigned long)VMALLOC_TOTAL >> 10,
 		vmi.used >> 10,
-		vmi.largest_chunk >> 10
+		vmi.largest_chunk >> 10,
+		K(quicklist_total_size())
 		);
 
 		len += hugetlb_report_meminfo(page + len);
diff -puN include/linux/quicklist.h~mm-show-quicklist-memory-usage-in-proc-meminfo include/linux/quicklist.h
--- a/include/linux/quicklist.h~mm-show-quicklist-memory-usage-in-proc-meminfo
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

mm-show-free-swap-as-signed.patch
mm-show-quicklist-memory-usage-in-proc-meminfo.patch
mm-quicklist-shouldnt-be-proportional-to-number-of-cpus.patch
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
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscam-kill-unused-lru-functions.patch
mm-unlockless-reclaim.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch


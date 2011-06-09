From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-hugepages-can-cause-negative-commitlimit.patch removed from -mm tree
Date: Thu, 09 Jun 2011 16:40:14 -0700
Message-ID: <201106092340.p59NeECh008557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756904Ab1FIXkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 19:40:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rja@sgi.com, aarcange@redhat.com, aquini@linux.com, cl@linux.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: hugepages can cause negative commitlimit
has been removed from the -mm tree.  Its filename was
     mm-hugepages-can-cause-negative-commitlimit.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: hugepages can cause negative commitlimit
From: Russ Anderson <rja@sgi.com>

If the total size of hugepages allocated on a system is over half of the
total memory size, commitlimit becomes a negative number.

What happens in fs/proc/meminfo.c is this calculation:

        allowed = ((totalram_pages - hugetlb_total_pages())
                * sysctl_overcommit_ratio / 100) + total_swap_pages;

The problem is that hugetlb_total_pages() is larger than totalram_pages
resulting in a negative number.  Since allowed is an unsigned long the
negative shows up as a big number.

A similar calculation occurs in __vm_enough_memory() in mm/mmap.c.

A symptom of this problem is that /proc/meminfo prints a very large
CommitLimit number.

CommitLimit:    737869762947802600 kB

To reproduce the problem reserve over half of memory as hugepages.  For
example "default_hugepagesz=1G hugepagesz=1G hugepages=64 Then look at
/proc/meminfo "CommitLimit:" to see if it is too big.

The fix is to not subtract hugetlb_total_pages().  When hugepages are
allocated totalram_pages is decremented so there is no need to subtract
out hugetlb_total_pages() a second time.

Example of "CommitLimit:" being too big.

uv1-sys:~ # cat /proc/meminfo
MemTotal:       32395508 kB
MemFree:        32029276 kB
Buffers:            8656 kB
Cached:            89548 kB
SwapCached:            0 kB
Active:            55336 kB
Inactive:          73916 kB
Active(anon):      31220 kB
Inactive(anon):       36 kB
Active(file):      24116 kB
Inactive(file):    73880 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:              1692 kB
Writeback:             0 kB
AnonPages:         31132 kB
Mapped:            15668 kB
Shmem:               152 kB
Slab:              70256 kB
SReclaimable:      17148 kB
SUnreclaim:        53108 kB
KernelStack:        6536 kB
PageTables:         3704 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    737869762947802600 kB
Committed_AS:     394044 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      713960 kB
VmallocChunk:   34325764204 kB
HardwareCorrupted:     0 kB
HugePages_Total:      32
HugePages_Free:       32
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:    1048576 kB
DirectMap4k:       16384 kB
DirectMap2M:     2064384 kB
DirectMap1G:    65011712 kB

Reported-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Russ Anderson <rja@sgi.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rafael Aquini <aquini@linux.com>
Cc: <stable@kernel.org>		[2.6.39+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c |    2 +-
 mm/mmap.c         |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/proc/meminfo.c~mm-hugepages-can-cause-negative-commitlimit fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-hugepages-can-cause-negative-commitlimit
+++ a/fs/proc/meminfo.c
@@ -36,7 +36,7 @@ static int meminfo_proc_show(struct seq_
 	si_meminfo(&i);
 	si_swapinfo(&i);
 	committed = percpu_counter_read_positive(&vm_committed_as);
-	allowed = ((totalram_pages - hugetlb_total_pages())
+	allowed = (totalram_pages
 		* sysctl_overcommit_ratio / 100) + total_swap_pages;
 
 	cached = global_page_state(NR_FILE_PAGES) -
diff -puN mm/mmap.c~mm-hugepages-can-cause-negative-commitlimit mm/mmap.c
--- a/mm/mmap.c~mm-hugepages-can-cause-negative-commitlimit
+++ a/mm/mmap.c
@@ -167,8 +167,7 @@ int __vm_enough_memory(struct mm_struct 
 		goto error;
 	}
 
-	allowed = (totalram_pages - hugetlb_total_pages())
-	       	* sysctl_overcommit_ratio / 100;
+	allowed = totalram_pages * sysctl_overcommit_ratio / 100;
 	/*
 	 * Leave the last 3% for root
 	 */
_

Patches currently in -mm which might be from rja@sgi.com are



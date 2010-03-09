From: akpm@linux-foundation.org
Subject: [merged] mm-document-proc-pagetypeinfo.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:30 -0800
Message-ID: <201003091904.o29J4U39031044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755618Ab0CITFN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:05:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: document /proc/pagetypeinfo
has been removed from the -mm tree.  Its filename was
     mm-document-proc-pagetypeinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: document /proc/pagetypeinfo
From: Mel Gorman <mel@csn.ul.ie>

Add documentation for /proc/pagetypeinfo.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   45 ++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~mm-document-proc-pagetypeinfo Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-document-proc-pagetypeinfo
+++ a/Documentation/filesystems/proc.txt
@@ -438,6 +438,7 @@ Table 1-5: Kernel info in /proc
  modules     List of loaded modules                            
  mounts      Mounted filesystems                               
  net         Networking info (see text)                        
+ pagetypeinfo Additional page allocator information (see text)  (2.5)
  partitions  Table of partitions known to the system           
  pci	     Deprecated info of PCI bus (new way -> /proc/bus/pci/,
              decoupled by lspci					(2.4)
@@ -592,7 +593,7 @@ Node 0, zone      DMA      0      4     
 Node 0, zone   Normal      1      0      0      1    101      8 ...
 Node 0, zone  HighMem      2      0      0      1      1      0 ...
 
-Memory fragmentation is a problem under some workloads, and buddyinfo is a 
+External fragmentation is a problem under some workloads, and buddyinfo is a
 useful tool for helping diagnose these problems.  Buddyinfo will give you a 
 clue as to how big an area you can safely allocate, or why a previous
 allocation failed.
@@ -602,6 +603,48 @@ available.  In this case, there are 0 ch
 ZONE_DMA, 4 chunks of 2^1*PAGE_SIZE in ZONE_DMA, 101 chunks of 2^4*PAGE_SIZE 
 available in ZONE_NORMAL, etc... 
 
+More information relevant to external fragmentation can be found in
+pagetypeinfo.
+
+> cat /proc/pagetypeinfo
+Page block order: 9
+Pages per block:  512
+
+Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10
+Node    0, zone      DMA, type    Unmovable      0      0      0      1      1      1      1      1      1      1      0
+Node    0, zone      DMA, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0
+Node    0, zone      DMA, type      Movable      1      1      2      1      2      1      1      0      1      0      2
+Node    0, zone      DMA, type      Reserve      0      0      0      0      0      0      0      0      0      1      0
+Node    0, zone      DMA, type      Isolate      0      0      0      0      0      0      0      0      0      0      0
+Node    0, zone    DMA32, type    Unmovable    103     54     77      1      1      1     11      8      7      1      9
+Node    0, zone    DMA32, type  Reclaimable      0      0      2      1      0      0      0      0      1      0      0
+Node    0, zone    DMA32, type      Movable    169    152    113     91     77     54     39     13      6      1    452
+Node    0, zone    DMA32, type      Reserve      1      2      2      2      2      0      1      1      1      1      0
+Node    0, zone    DMA32, type      Isolate      0      0      0      0      0      0      0      0      0      0      0
+
+Number of blocks type     Unmovable  Reclaimable      Movable      Reserve      Isolate
+Node 0, zone      DMA            2            0            5            1            0
+Node 0, zone    DMA32           41            6          967            2            0
+
+Fragmentation avoidance in the kernel works by grouping pages of different
+migrate types into the same contiguous regions of memory called page blocks.
+A page block is typically the size of the default hugepage size e.g. 2MB on
+X86-64. By keeping pages grouped based on their ability to move, the kernel
+can reclaim pages within a page block to satisfy a high-order allocation.
+
+The pagetypinfo begins with information on the size of a page block. It
+then gives the same type of information as buddyinfo except broken down
+by migrate-type and finishes with details on how many page blocks of each
+type exist.
+
+If min_free_kbytes has been tuned correctly (recommendations made by hugeadm
+from libhugetlbfs http://sourceforge.net/projects/libhugetlbfs/), one can
+make an estimate of the likely number of huge pages that can be allocated
+at a given point in time. All the "Movable" blocks should be allocatable
+unless memory has been mlock()'d. Some of the Reclaimable blocks should
+also be allocatable although a lot of filesystem metadata may have to be
+reclaimed to achieve this.
+
 ..............................................................................
 
 meminfo:
_

Patches currently in -mm which might be from mel@csn.ul.ie are

page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch


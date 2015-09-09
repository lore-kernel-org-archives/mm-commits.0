From: akpm@linux-foundation.org
Subject: [folded-merged] proc-add-kpageidle-file-fix-5.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 15:05:55 -0700
Message-ID: <55f0ad43.2gvM9DZJKdaSpPbX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbbIIWF4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:05:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, corbet@lwn.net, gorcunov@openvz.org, gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, raghavendra.kt@linux.vnet.ibm.com, rientjes@google.com, walken@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: add idle page tracking description
has been removed from the -mm tree.  Its filename was
     proc-add-kpageidle-file-fix-5.patch

This patch was dropped because it was folded into proc-add-kpageidle-file.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Documentation: add idle page tracking description

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/00-INDEX               |    2 
 Documentation/vm/idle_page_tracking.txt |   94 ++++++++++++++++++++++
 Documentation/vm/pagemap.txt            |   11 --
 mm/Kconfig                              |    2 
 4 files changed, 99 insertions(+), 10 deletions(-)

diff -puN Documentation/vm/00-INDEX~proc-add-kpageidle-file-fix-5 Documentation/vm/00-INDEX
--- a/Documentation/vm/00-INDEX~proc-add-kpageidle-file-fix-5
+++ a/Documentation/vm/00-INDEX
@@ -14,6 +14,8 @@ hugetlbpage.txt
 	- a brief summary of hugetlbpage support in the Linux kernel.
 hwpoison.txt
 	- explains what hwpoison is
+idle_page_tracking.txt
+	- description of the idle page tracking feature.
 ksm.txt
 	- how to use the Kernel Samepage Merging feature.
 numa
diff -puN /dev/null Documentation/vm/idle_page_tracking.txt
--- /dev/null
+++ a/Documentation/vm/idle_page_tracking.txt
@@ -0,0 +1,94 @@
+MOTIVATION
+
+The idle page tracking feature allows to track which memory pages are being
+accessed by a workload and which are idle. This information can be useful for
+estimating the workload's working set size, which, in turn, can be taken into
+account when configuring the workload parameters, setting memory cgroup limits,
+or deciding where to place the workload within a compute cluster.
+
+USER API
+
+If CONFIG_IDLE_PAGE_TRACKING was enabled on compile time, a new read-write file
+is present on the proc filesystem, /proc/kpageidle.
+
+The file implements a bitmap where each bit corresponds to a memory page. The
+bitmap is represented by an array of 8-byte integers, and the page at PFN #i is
+mapped to bit #i%64 of array element #i/64, byte order is native. When a bit is
+set, the corresponding page is idle.
+
+A page is considered idle if it has not been accessed since it was marked idle
+(for more details on what "accessed" actually means see the IMPLEMENTATION
+DETAILS section). To mark a page idle one has to set the bit corresponding to
+the page by writing to the file. A value written to the file is OR-ed with the
+current bitmap value.
+
+Only accesses to user memory pages are tracked. These are pages mapped to a
+process address space, page cache and buffer pages, swap cache pages. For other
+page types (e.g. SLAB pages) an attempt to mark a page idle is silently ignored,
+and hence such pages are never reported idle.
+
+For huge pages the idle flag is set only on the head page, so one has to read
+/proc/kpageflags in order to correctly count idle huge pages.
+
+Reading from or writing to /proc/kpageidle will return -EINVAL if you are not
+starting the read/write on an 8-byte boundary, or if the size of the read/write
+is not a multiple of 8 bytes. Writing to this file beyond max PFN will return
+-ENXIO.
+
+That said, in order to estimate the amount of pages that are not used by a
+workload one should:
+
+ 1. Mark all the workload's pages as idle by setting corresponding bits in the
+    /proc/kpageidle bitmap. The pages can be found by reading /proc/pid/pagemap
+    if the workload is represented by a process, or by filtering out alien pages
+    using /proc/kpagecgroup in case the workload is placed in a memory cgroup.
+
+ 2. Wait until the workload accesses its working set.
+
+ 3. Read /proc/kpageidle and count the number of bits set. If one wants to
+    ignore certain types of pages, e.g. mlocked pages since they are not
+    reclaimable, he or she can filter them out using /proc/kpageflags.
+
+See Documentation/vm/pagemap.txt for more information about /proc/pid/pagemap,
+/proc/kpageflags, and /proc/kpagecgroup.
+
+IMPLEMENTATION DETAILS
+
+The kernel internally keeps track of accesses to user memory pages in order to
+reclaim unreferenced pages first on memory shortage conditions. A page is
+considered referenced if it has been recently accessed via a process address
+space, in which case one or more PTEs it is mapped to will have the Accessed bit
+set, or marked accessed explicitly by the kernel (see mark_page_accessed()). The
+latter happens when:
+
+ - a userspace process reads or writes a page using a system call (e.g. read(2)
+   or write(2))
+
+ - a page that is used for storing filesystem buffers is read or written,
+   because a process needs filesystem metadata stored in it (e.g. lists a
+   directory tree)
+
+ - a page is accessed by a device driver using get_user_pages()
+
+When a dirty page is written to swap or disk as a result of memory reclaim or
+exceeding the dirty memory limit, it is not marked referenced.
+
+The idle memory tracking feature adds a new page flag, the Idle flag. This flag
+is set manually, by writing to /proc/kpageidle (see the USER API section), and
+cleared automatically whenever a page is referenced as defined above.
+
+When a page is marked idle, the Accessed bit must be cleared in all PTEs it is
+mapped to, otherwise we will not be able to detect accesses to the page coming
+from a process address space. To avoid interference with the reclaimer, which,
+as noted above, uses the Accessed bit to promote actively referenced pages, one
+more page flag is introduced, the Young flag. When the PTE Accessed bit is
+cleared as a result of setting or updating a page's Idle flag, the Young flag
+is set on the page. The reclaimer treats the Young flag as an extra PTE
+Accessed bit and therefore will consider such a page as referenced.
+
+Since the idle memory tracking feature is based on the memory reclaimer logic,
+it only works with pages that are on an LRU list, other pages are silently
+ignored. That means it will ignore a user memory page if it is isolated, but
+since there are usually not many of them, it should not affect the overall
+result noticeably. In order not to stall scanning of /proc/kpageidle, locked
+pages may be skipped too.
diff -puN Documentation/vm/pagemap.txt~proc-add-kpageidle-file-fix-5 Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~proc-add-kpageidle-file-fix-5
+++ a/Documentation/vm/pagemap.txt
@@ -75,15 +75,8 @@ There are five components to pagemap:
    memory cgroup each page is charged to, indexed by PFN. Only available when
    CONFIG_MEMCG is set.
 
- * /proc/kpageidle.  This file implements a bitmap where each bit corresponds
-   to a page, indexed by PFN. When the bit is set, the corresponding page is
-   idle. A page is considered idle if it has not been accessed since it was
-   marked idle. To mark a page idle one should set the bit corresponding to the
-   page by writing to the file. A value written to the file is OR-ed with the
-   current bitmap value. Only user memory pages can be marked idle, for other
-   page types input is silently ignored. Writing to this file beyond max PFN
-   results in the ENXIO error. Only available when CONFIG_IDLE_PAGE_TRACKING is
-   set.
+ * /proc/kpageidle.  This file comprises API of the idle page tracking feature.
+   See Documentation/vm/idle_page_tracking.txt for more details.
 
 Short descriptions to the page flags:
 
diff -puN mm/Kconfig~proc-add-kpageidle-file-fix-5 mm/Kconfig
--- a/mm/Kconfig~proc-add-kpageidle-file-fix-5
+++ a/mm/Kconfig
@@ -660,7 +660,7 @@ config IDLE_PAGE_TRACKING
 	  be useful to tune memory cgroup limits and/or for job placement
 	  within a compute cluster.
 
-	  See Documentation/vm/pagemap.txt for more details.
+	  See Documentation/vm/idle_page_tracking.txt for more details.
 
 config ZONE_DEVICE
 	bool "Device memory (pmem, etc...) hotplug support" if EXPERT
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-add-page_cgroup_ino-helper.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
proc-add-kpageidle-file.patch
proc-add-kpageidle-file-fix-6.patch
proc-add-kpageidle-file-fix-6-fix-2.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch


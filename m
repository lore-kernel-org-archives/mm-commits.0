From: akpm@linux-foundation.org
Subject: [merged] fs-proc-include-cma-info-in-proc-meminfo.patch removed
 from -mm tree
Date: Fri, 19 Dec 2014 12:36:40 -0800
Message-ID: <54948c58.WpfZtQvs208Nszp2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaLSUgl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 15:36:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pintu.k@samsung.com, aquini@redhat.com, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, m.szyprowski@samsung.com, mina86@mina86.com, vishnu.ps@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/meminfo.c: include cma info in proc/meminfo
has been removed from the -mm tree.  Its filename was
     fs-proc-include-cma-info-in-proc-meminfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pintu Kumar <pintu.k@samsung.com>
Subject: fs/proc/meminfo.c: include cma info in proc/meminfo

This patch include CMA info (CMATotal, CMAFree) in /proc/meminfo. 
Currently, in a CMA enabled system, if somebody wants to know the total
CMA size declared, there is no way to tell, other than the dmesg or
/var/log/messages logs.

With this patch we are showing the CMA info as part of meminfo, so that it
can be determined at any point of time.  This will be populated only when
CMA is enabled.

Below is the sample output from a ARM based device with RAM:512MB and CMA:16MB.

MemTotal:         471172 kB
MemFree:          111712 kB
MemAvailable:     271172 kB
.
.
.
CmaTotal:          16384 kB
CmaFree:            6144 kB

This patch also fix below checkpatch errors that were found during these changes.

ERROR: space required after that ',' (ctx:ExV)
199: FILE: fs/proc/meminfo.c:199:
+       ,atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
        ^

ERROR: space required after that ',' (ctx:ExV)
202: FILE: fs/proc/meminfo.c:202:
+       ,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
        ^

ERROR: space required after that ',' (ctx:ExV)
206: FILE: fs/proc/meminfo.c:206:
+       ,K(totalcma_pages)
        ^

total: 3 errors, 0 warnings, 2 checks, 236 lines checked

Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN fs/proc/meminfo.c~fs-proc-include-cma-info-in-proc-meminfo fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~fs-proc-include-cma-info-in-proc-meminfo
+++ a/fs/proc/meminfo.c
@@ -12,6 +12,9 @@
 #include <linux/vmstat.h>
 #include <linux/atomic.h>
 #include <linux/vmalloc.h>
+#ifdef CONFIG_CMA
+#include <linux/cma.h>
+#endif
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include "internal.h"
@@ -138,6 +141,10 @@ static int meminfo_proc_show(struct seq_
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		"AnonHugePages:  %8lu kB\n"
 #endif
+#ifdef CONFIG_CMA
+		"CmaTotal:       %8lu kB\n"
+		"CmaFree:        %8lu kB\n"
+#endif
 		,
 		K(i.totalram),
 		K(i.freeram),
@@ -187,12 +194,16 @@ static int meminfo_proc_show(struct seq_
 		vmi.used >> 10,
 		vmi.largest_chunk >> 10
 #ifdef CONFIG_MEMORY_FAILURE
-		,atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
+		, atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
+		, K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
 		   HPAGE_PMD_NR)
 #endif
+#ifdef CONFIG_CMA
+		, K(totalcma_pages)
+		, K(global_page_state(NR_FREE_CMA_PAGES))
+#endif
 		);
 
 	hugetlb_report_meminfo(m);
_

Patches currently in -mm which might be from pintu.k@samsung.com are

origin.patch


From: akpm@linux-foundation.org
Subject: + fs-proc-include-cma-info-in-proc-meminfo.patch added to -mm
 tree
Date: Wed, 22 Oct 2014 13:00:56 -0700
Message-ID: <54480cf8.HBugO7mBYoFYtAEC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583AbaJVUA4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 16:00:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pintu.k@samsung.com, aquini@redhat.com, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, m.szyprowski@samsung.com, mina86@mina86.com, vishnu.ps@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: proc: include cma info in proc/meminfo
has been added to the -mm tree.  Its filename is
     fs-proc-include-cma-info-in-proc-meminfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-include-cma-info-in-proc-meminfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-include-cma-info-in-proc-meminfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pintu Kumar <pintu.k@samsung.com>
Subject: fs: proc: include cma info in proc/meminfo

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
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
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

vmalloc-replace-printk-with-pr_warn.patch
vmscan-replace-printk-with-pr_err.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch


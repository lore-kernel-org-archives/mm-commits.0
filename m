From: akpm@linux-foundation.org
Subject: + numa-use-last_cpupid_shift-to-calculate-last_cpupid_mask.patch
 added to -mm tree
Date: Tue, 01 Apr 2014 14:04:06 -0700
Message-ID: <533b29c6.EcU0C74fRXF6bYoP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaDAVEH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2014 17:04:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pingfank@linux.vnet.ibm.com, peterz@infradead.org, paulus@samba.org, mel@csn.ul.ie, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, srikar@linux.vnet.ibm.com

Subject: + numa-use-last_cpupid_shift-to-calculate-last_cpupid_mask.patch added to -mm tree
To: srikar@linux.vnet.ibm.com,aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,mel@csn.ul.ie,paulus@samba.org,peterz@infradead.org,pingfank@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Tue, 01 Apr 2014 14:04:06 -0700


The patch titled
     Subject: numa: use LAST_CPUPID_SHIFT to calculate LAST_CPUPID_MASK
has been added to the -mm tree.  Its filename is
     numa-use-last_cpupid_shift-to-calculate-last_cpupid_mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/numa-use-last_cpupid_shift-to-calculate-last_cpupid_mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/numa-use-last_cpupid_shift-to-calculate-last_cpupid_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: numa: use LAST_CPUPID_SHIFT to calculate LAST_CPUPID_MASK

LAST_CPUPID_MASK is calculated using LAST_CPUPID_WIDTH.  However
LAST_CPUPID_WIDTH itself can be 0.  (when LAST_CPUPID_NOT_IN_PAGE_FLAGS is
set).  In such a case LAST_CPUPID_MASK turns out to be 0.

But with recent commit 1ae71d0319: (mm: numa: bugfix for
LAST_CPUPID_NOT_IN_PAGE_FLAGS) if LAST_CPUPID_MASK is 0,
page_cpupid_xchg_last() and page_cpupid_reset_last() causes
page->_last_cpupid to be set to 0.

This causes performance regression. Its almost as if numa_balancing is
off.

Fix LAST_CPUPID_MASK by using LAST_CPUPID_SHIFT instead of
LAST_CPUPID_WIDTH.



Some performance numbers and perf stats with and without the fix.

(3.14-rc6)
----------
numa01

 Performance counter stats for '/usr/bin/time -f %e %S %U %c %w -o start_bench.out -a ./numa01':

         12,27,462 cs                                                           [100.00%]
          2,41,957 migrations                                                   [100.00%]
       1,68,01,713 faults                                                       [100.00%]
    7,99,35,29,041 cache-misses
            98,808 migrate:mm_migrate_pages                                     [100.00%]

    1407.690148814 seconds time elapsed

numa02

 Performance counter stats for '/usr/bin/time -f %e %S %U %c %w -o start_bench.out -a ./numa02':

            63,065 cs                                                           [100.00%]
            14,364 migrations                                                   [100.00%]
          2,08,118 faults                                                       [100.00%]
      25,32,59,404 cache-misses
                12 migrate:mm_migrate_pages                                     [100.00%]

      63.840827219 seconds time elapsed


(3.14-rc6 with fix)
-------------------
numa01

 Performance counter stats for '/usr/bin/time -f %e %S %U %c %w -o start_bench.out -a ./numa01':

          9,68,911 cs                                                           [100.00%]
          1,01,414 migrations                                                   [100.00%]
         88,38,697 faults                                                       [100.00%]
    4,42,92,51,042 cache-misses
          4,25,060 migrate:mm_migrate_pages                                     [100.00%]

     685.965331189 seconds time elapsed

numa02

 Performance counter stats for '/usr/bin/time -f %e %S %U %c %w -o start_bench.out -a ./numa02':

            17,543 cs                                                           [100.00%]
             2,962 migrations                                                   [100.00%]
          1,17,843 faults                                                       [100.00%]
      11,80,61,644 cache-misses
            12,358 migrate:mm_migrate_pages                                     [100.00%]

      20.380132343 seconds time elapsed



Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mel Gorman <mel@csn.ul.ie>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~numa-use-last_cpupid_shift-to-calculate-last_cpupid_mask include/linux/mm.h
--- a/include/linux/mm.h~numa-use-last_cpupid_shift-to-calculate-last_cpupid_mask
+++ a/include/linux/mm.h
@@ -695,7 +695,7 @@ void do_set_pte(struct vm_area_struct *v
 #define ZONES_MASK		((1UL << ZONES_WIDTH) - 1)
 #define NODES_MASK		((1UL << NODES_WIDTH) - 1)
 #define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
-#define LAST_CPUPID_MASK	((1UL << LAST_CPUPID_WIDTH) - 1)
+#define LAST_CPUPID_MASK	((1UL << LAST_CPUPID_SHIFT) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
 static inline enum zone_type page_zonenum(const struct page *page)
_

Patches currently in -mm which might be from srikar@linux.vnet.ibm.com are

origin.patch
numa-use-last_cpupid_shift-to-calculate-last_cpupid_mask.patch
linux-next.patch


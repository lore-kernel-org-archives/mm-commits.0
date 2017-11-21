From: akpm@linux-foundation.org
Subject: + mm-show-total-hugetlb-memory-consumption-in-proc-meminfo.patch
 added to -mm tree
Date: Mon, 20 Nov 2017 16:51:21 -0800
Message-ID: <5a137889.Lph/vzVBrmNTGmjD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58034 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751880AbdKUAvW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 19:51:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@intel.com, hannes@cmpxchg.org, mhocko@suse.com, mike.kravetz@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: show total hugetlb memory consumption in /proc/meminfo
has been added to the -mm tree.  Its filename is
     mm-show-total-hugetlb-memory-consumption-in-proc-meminfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-show-total-hugetlb-memory-consumption-in-proc-meminfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-show-total-hugetlb-memory-consumption-in-proc-meminfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: show total hugetlb memory consumption in /proc/meminfo

Currently we display some hugepage statistics (total, free, etc) in
/proc/meminfo, but only for default hugepage size (e.g.  2Mb).

If hugepages of different sizes are used (like 2Mb and 1Gb on x86-64),
/proc/meminfo output can be confusing, as non-default sized hugepages are
not reflected at all, and there are no signs that they are existing and
consuming system memory.

To solve this problem, let's display the total amount of memory, consumed
by hugetlb pages of all sized (both free and used).  Let's call it
"Hugetlb", and display size in kB to match generic /proc/meminfo style.

For example, (1024 2Mb pages and 2 1Gb pages are pre-allocated):
  $ cat /proc/meminfo
  MemTotal:        8168984 kB
  MemFree:         3789276 kB
  <...>
  CmaFree:               0 kB
  HugePages_Total:    1024
  HugePages_Free:     1024
  HugePages_Rsvd:        0
  HugePages_Surp:        0
  Hugepagesize:       2048 kB
  Hugetlb:         4194304 kB
  DirectMap4k:       32632 kB
  DirectMap2M:     4161536 kB
  DirectMap1G:     6291456 kB

Also, this patch updates corresponding docs to reflect Hugetlb entry
meaning and difference between Hugetlb and HugePages_Total * Hugepagesize.

Link: http://lkml.kernel.org/r/20171115231409.12131-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hugetlbpage.txt |   27 ++++++++++++++-------
 mm/hugetlb.c                     |   36 +++++++++++++++++++----------
 2 files changed, 42 insertions(+), 21 deletions(-)

diff -puN Documentation/vm/hugetlbpage.txt~mm-show-total-hugetlb-memory-consumption-in-proc-meminfo Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~mm-show-total-hugetlb-memory-consumption-in-proc-meminfo
+++ a/Documentation/vm/hugetlbpage.txt
@@ -20,19 +20,20 @@ options.
 
 The /proc/meminfo file provides information about the total number of
 persistent hugetlb pages in the kernel's huge page pool.  It also displays
-information about the number of free, reserved and surplus huge pages and the
-default huge page size.  The huge page size is needed for generating the
-proper alignment and size of the arguments to system calls that map huge page
-regions.
+default huge page size and information about the number of free, reserved
+and surplus huge pages in the pool of huge pages of default size.
+The huge page size is needed for generating the proper alignment and
+size of the arguments to system calls that map huge page regions.
 
 The output of "cat /proc/meminfo" will include lines like:
 
 .....
-HugePages_Total: vvv
-HugePages_Free:  www
-HugePages_Rsvd:  xxx
-HugePages_Surp:  yyy
-Hugepagesize:    zzz kB
+HugePages_Total: uuu
+HugePages_Free:  vvv
+HugePages_Rsvd:  www
+HugePages_Surp:  xxx
+Hugepagesize:    yyy kB
+Hugetlb:         zzz kB
 
 where:
 HugePages_Total is the size of the pool of huge pages.
@@ -47,6 +48,14 @@ HugePages_Surp  is short for "surplus,"
                 the pool above the value in /proc/sys/vm/nr_hugepages. The
                 maximum number of surplus huge pages is controlled by
                 /proc/sys/vm/nr_overcommit_hugepages.
+Hugepagesize    is the default hugepage size (in Kb).
+Hugetlb         is the total amount of memory (in kB), consumed by huge
+                pages of all sizes.
+                If huge pages of different sizes are in use, this number
+                will exceed HugePages_Total * Hugepagesize. To get more
+                detailed information, please, refer to
+                /sys/kernel/mm/hugepages (described below).
+
 
 /proc/filesystems should also show a filesystem of type "hugetlbfs" configured
 in the kernel.
diff -puN mm/hugetlb.c~mm-show-total-hugetlb-memory-consumption-in-proc-meminfo mm/hugetlb.c
--- a/mm/hugetlb.c~mm-show-total-hugetlb-memory-consumption-in-proc-meminfo
+++ a/mm/hugetlb.c
@@ -2975,20 +2975,32 @@ out:
 
 void hugetlb_report_meminfo(struct seq_file *m)
 {
-	struct hstate *h = &default_hstate;
+	struct hstate *h;
+	unsigned long total = 0;
+
 	if (!hugepages_supported())
 		return;
-	seq_printf(m,
-			"HugePages_Total:   %5lu\n"
-			"HugePages_Free:    %5lu\n"
-			"HugePages_Rsvd:    %5lu\n"
-			"HugePages_Surp:    %5lu\n"
-			"Hugepagesize:   %8lu kB\n",
-			h->nr_huge_pages,
-			h->free_huge_pages,
-			h->resv_huge_pages,
-			h->surplus_huge_pages,
-			1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
+
+	for_each_hstate(h) {
+		unsigned long count = h->nr_huge_pages;
+
+		total += (PAGE_SIZE << huge_page_order(h)) * count;
+
+		if (h == &default_hstate)
+			seq_printf(m,
+				   "HugePages_Total:   %5lu\n"
+				   "HugePages_Free:    %5lu\n"
+				   "HugePages_Rsvd:    %5lu\n"
+				   "HugePages_Surp:    %5lu\n"
+				   "Hugepagesize:   %8lu kB\n",
+				   count,
+				   h->free_huge_pages,
+				   h->resv_huge_pages,
+				   h->surplus_huge_pages,
+				   (PAGE_SIZE << huge_page_order(h)) / 1024);
+	}
+
+	seq_printf(m, "Hugetlb:        %8lu kB\n", total / 1024);
 }
 
 int hugetlb_report_node_meminfo(int nid, char *buf)
_

Patches currently in -mm which might be from guro@fb.com are

mm-show-total-hugetlb-memory-consumption-in-proc-meminfo.patch


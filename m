From: akpm@linux-foundation.org
Subject: [alternative-merged] mm-add-zone_device-statistics-to-smaps.patch removed from -mm tree
Date: Mon, 21 Nov 2016 22:46:38 -0800
Message-ID: <5833e9ce.wfWd5RUry6w1Xr2I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbcKVGqk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 01:46:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.hansen@intel.com, hch@lst.de, khandual@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add ZONE_DEVICE statistics to smaps
has been removed from the -mm tree.  Its filename was
     mm-add-zone_device-statistics-to-smaps.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: add ZONE_DEVICE statistics to smaps

ZONE_DEVICE pages are mapped into a process via the filesystem-dax and
device-dax mechanisms.  There are also proposals to use ZONE_DEVICE pages
for other usages outside of dax.  Add statistics to smaps so applications
can debug that they are obtaining the mappings they expect, or otherwise
accounting them.

Link: http://lkml.kernel.org/r/147881591739.39198.1358237993213024627.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~mm-add-zone_device-statistics-to-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-add-zone_device-statistics-to-smaps
+++ a/fs/proc/task_mmu.c
@@ -445,6 +445,8 @@ struct mem_size_stats {
 	unsigned long swap;
 	unsigned long shared_hugetlb;
 	unsigned long private_hugetlb;
+	unsigned long device;
+	unsigned long device_huge;
 	u64 pss;
 	u64 swap_pss;
 	bool check_shmem_swap;
@@ -458,6 +460,8 @@ static void smaps_account(struct mem_siz
 
 	if (PageAnon(page))
 		mss->anonymous += size;
+	else if (is_zone_device_page(page))
+		mss->device += size;
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
@@ -575,7 +579,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	else if (PageSwapBacked(page))
 		mss->shmem_thp += HPAGE_PMD_SIZE;
 	else if (is_zone_device_page(page))
-		/* pass */;
+		mss->device_huge += HPAGE_PMD_SIZE;
 	else
 		VM_BUG_ON_PAGE(1, page);
 	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd));
@@ -774,6 +778,8 @@ static int show_smap(struct seq_file *m,
 		   "ShmemPmdMapped: %8lu kB\n"
 		   "Shared_Hugetlb: %8lu kB\n"
 		   "Private_Hugetlb: %7lu kB\n"
+		   "Device:         %8lu kB\n"
+		   "DeviceHugePages: %7lu kB\n"
 		   "Swap:           %8lu kB\n"
 		   "SwapPss:        %8lu kB\n"
 		   "KernelPageSize: %8lu kB\n"
@@ -792,6 +798,8 @@ static int show_smap(struct seq_file *m,
 		   mss.shmem_thp >> 10,
 		   mss.shared_hugetlb >> 10,
 		   mss.private_hugetlb >> 10,
+		   mss.device >> 10,
+		   mss.device_huge >> 10,
 		   mss.swap >> 10,
 		   (unsigned long)(mss.swap_pss >> (10 + PSS_SHIFT)),
 		   vma_kernel_pagesize(vma) >> 10,
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-disable-numa-migration-faults-for-dax-vmas.patch


From: akpm@linux-foundation.org
Subject: [merged]
 hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported.patch removed from -mm tree
Date: Wed, 07 May 2014 12:05:01 -0700
Message-ID: <536a83dd.RqzDKIvmG0dcHQAs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaEGTFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 15:05:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, nacc@linux.vnet.ibm.com

Subject: [merged] hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported.patch removed from -mm tree
To: nacc@linux.vnet.ibm.com,aneesh.kumar@linux.vnet.ibm.com,mgorman@suse.de,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 12:05:01 -0700


The patch titled
     Subject: hugetlb: ensure hugepage access is denied if hugepages are not supported
has been removed from the -mm tree.  Its filename was
     hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: hugetlb: ensure hugepage access is denied if hugepages are not supported

Currently, I am seeing the following when I `mount -t hugetlbfs /none
/dev/hugetlbfs`, and then simply do a `ls /dev/hugetlbfs`.  I think it's
related to the fact that hugetlbfs is properly not correctly setting
itself up in this state?:

Unable to handle kernel paging request for data at address 0x00000031
Faulting instruction address: 0xc000000000245710
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=2048 NUMA pSeries
....
									

In KVM guests on Power, in a guest not backed by hugepages, we see the
following:

AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:         64 kB

HPAGE_SHIFT == 0 in this configuration, which indicates that hugepages
are not supported at boot-time, but this is only checked in
hugetlb_init(). Extract the check to a helper function, and use it in a
few relevant places.

This does make hugetlbfs not supported (not registered at all) in this
environment. I believe this is fine, as there are no valid hugepages and
that won't change at runtime.

[akpm@linux-foundation.org: use pr_info(), per Mel]
[akpm@linux-foundation.org: fix build when HPAGE_SHIFT is undefined]
Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |    5 +++++
 include/linux/hugetlb.h |   10 ++++++++++
 mm/hugetlb.c            |   19 ++++++++++++++-----
 3 files changed, 29 insertions(+), 5 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported
+++ a/fs/hugetlbfs/inode.c
@@ -1030,6 +1030,11 @@ static int __init init_hugetlbfs_fs(void
 	int error;
 	int i;
 
+	if (!hugepages_supported()) {
+		pr_info("hugetlbfs: disabling because there are no supported hugepage sizes\n");
+		return -ENOTSUPP;
+	}
+
 	error = bdi_init(&hugetlbfs_backing_dev_info);
 	if (error)
 		return error;
diff -puN include/linux/hugetlb.h~hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported
+++ a/include/linux/hugetlb.h
@@ -412,6 +412,16 @@ static inline spinlock_t *huge_pte_lockp
 	return &mm->page_table_lock;
 }
 
+static inline bool hugepages_supported(void)
+{
+	/*
+	 * Some platform decide whether they support huge pages at boot
+	 * time. On these, such as powerpc, HPAGE_SHIFT is set to 0 when
+	 * there is no such support
+	 */
+	return HPAGE_SHIFT != 0;
+}
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
diff -puN mm/hugetlb.c~hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported
+++ a/mm/hugetlb.c
@@ -1981,11 +1981,7 @@ static int __init hugetlb_init(void)
 {
 	int i;
 
-	/* Some platform decide whether they support huge pages at boot
-	 * time. On these, such as powerpc, HPAGE_SHIFT is set to 0 when
-	 * there is no such support
-	 */
-	if (HPAGE_SHIFT == 0)
+	if (!hugepages_supported())
 		return 0;
 
 	if (!size_to_hstate(default_hstate_size)) {
@@ -2112,6 +2108,9 @@ static int hugetlb_sysctl_handler_common
 	unsigned long tmp;
 	int ret;
 
+	if (!hugepages_supported())
+		return -ENOTSUPP;
+
 	tmp = h->max_huge_pages;
 
 	if (write && h->order >= MAX_ORDER)
@@ -2165,6 +2164,9 @@ int hugetlb_overcommit_handler(struct ct
 	unsigned long tmp;
 	int ret;
 
+	if (!hugepages_supported())
+		return -ENOTSUPP;
+
 	tmp = h->nr_overcommit_huge_pages;
 
 	if (write && h->order >= MAX_ORDER)
@@ -2190,6 +2192,8 @@ out:
 void hugetlb_report_meminfo(struct seq_file *m)
 {
 	struct hstate *h = &default_hstate;
+	if (!hugepages_supported())
+		return;
 	seq_printf(m,
 			"HugePages_Total:   %5lu\n"
 			"HugePages_Free:    %5lu\n"
@@ -2206,6 +2210,8 @@ void hugetlb_report_meminfo(struct seq_f
 int hugetlb_report_node_meminfo(int nid, char *buf)
 {
 	struct hstate *h = &default_hstate;
+	if (!hugepages_supported())
+		return 0;
 	return sprintf(buf,
 		"Node %d HugePages_Total: %5u\n"
 		"Node %d HugePages_Free:  %5u\n"
@@ -2220,6 +2226,9 @@ void hugetlb_show_meminfo(void)
 	struct hstate *h;
 	int nid;
 
+	if (!hugepages_supported())
+		return;
+
 	for_each_node_state(nid, N_MEMORY)
 		for_each_hstate(h)
 			pr_info("Node %d hugepages_total=%u hugepages_free=%u hugepages_surp=%u hugepages_size=%lukB\n",
_

Patches currently in -mm which might be from nacc@linux.vnet.ibm.com are

origin.patch


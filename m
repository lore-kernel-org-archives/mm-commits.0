From: akpm@linux-foundation.org
Subject: [folded] hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix-fix.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:37:52 -0800
Message-ID: <201101132337.p0DNbqGQ007453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757120Ab1AMXiC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:38:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: caiqian@redhat.com, aarcange@redhat.com, emunson@mgebm.net, mhocko@suse.cz, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix-fix.patch

This patch was dropped because it was folded into hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix-fix
From: CAI Qian <caiqian@redhat.com>

add checking in hugetlb_overcommit_handler()

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/hugetlb.c~hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix-fix
+++ a/mm/hugetlb.c
@@ -1456,6 +1456,7 @@ static ssize_t nr_overcommit_hugepages_s
 	struct hstate *h = kobj_to_hstate(kobj, NULL);
 	return sprintf(buf, "%lu\n", h->nr_overcommit_huge_pages);
 }
+
 static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
@@ -1942,6 +1943,9 @@ int hugetlb_overcommit_handler(struct ct
 	if (!write)
 		tmp = h->nr_overcommit_huge_pages;
 
+	if (write && h->order >= MAX_ORDER)
+		return -EINVAL;
+
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
 	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
_

Patches currently in -mm which might be from caiqian@redhat.com are

hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch
hugetlb-fix-handling-of-parse-errors-in-sysfs.patch
ksm-drain-pagevecs-to-lru.patch


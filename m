From: akpm@linux-foundation.org
Subject: [merged] hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:15 -0800
Message-ID: <201101142252.p0EMq5FV005585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753976Ab1ANWwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@mgebm.net, aarcange@redhat.com, caiqian@redhat.com, mhocko@suse.cz, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: do not allow pagesize >= MAX_ORDER pool adjustment
has been removed from the -mm tree.  Its filename was
     hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: do not allow pagesize >= MAX_ORDER pool adjustment
From: Eric B Munson <emunson@mgebm.net>

Huge pages with order >= MAX_ORDER must be allocated at boot via the
kernel command line, they cannot be allocated or freed once the kernel is
up and running.  Currently we allow values to be written to the sysfs and
sysctl files controling pool size for these huge page sizes.  This patch
makes the store functions for nr_hugepages and nr_overcommit_hugepages
return -EINVAL when the pool for a page size >= MAX_ORDER is changed.

[akpm@linux-foundation.org: avoid multiple return paths in nr_hugepages_store_common()]
[caiqian@redhat.com: add checking in hugetlb_overcommit_handler()]
Signed-off-by: Eric B Munson <emunson@mgebm.net>
Reported-by: CAI Qian <caiqian@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment
+++ a/mm/hugetlb.c
@@ -1363,6 +1363,7 @@ static ssize_t nr_hugepages_show_common(
 
 	return sprintf(buf, "%lu\n", nr_huge_pages);
 }
+
 static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
 			struct kobject *kobj, struct kobj_attribute *attr,
 			const char *buf, size_t len)
@@ -1375,11 +1376,16 @@ static ssize_t nr_hugepages_store_common
 
 	err = strict_strtoul(buf, 10, &count);
 	if (err) {
-		NODEMASK_FREE(nodes_allowed);
-		return 0;
+		err = 0;		/* This seems wrong */
+		goto out;
 	}
 
 	h = kobj_to_hstate(kobj, &nid);
+	if (h->order >= MAX_ORDER) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (nid == NUMA_NO_NODE) {
 		/*
 		 * global hstate attribute
@@ -1405,6 +1411,9 @@ static ssize_t nr_hugepages_store_common
 		NODEMASK_FREE(nodes_allowed);
 
 	return len;
+out:
+	NODEMASK_FREE(nodes_allowed);
+	return err;
 }
 
 static ssize_t nr_hugepages_show(struct kobject *kobj,
@@ -1447,6 +1456,7 @@ static ssize_t nr_overcommit_hugepages_s
 	struct hstate *h = kobj_to_hstate(kobj, NULL);
 	return sprintf(buf, "%lu\n", h->nr_overcommit_huge_pages);
 }
+
 static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
@@ -1454,6 +1464,9 @@ static ssize_t nr_overcommit_hugepages_s
 	unsigned long input;
 	struct hstate *h = kobj_to_hstate(kobj, NULL);
 
+	if (h->order >= MAX_ORDER)
+		return -EINVAL;
+
 	err = strict_strtoul(buf, 10, &input);
 	if (err)
 		return 0;
@@ -1864,6 +1877,9 @@ static int hugetlb_sysctl_handler_common
 	if (!write)
 		tmp = h->max_huge_pages;
 
+	if (write && h->order >= MAX_ORDER)
+		return -EINVAL;
+
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
 	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
@@ -1927,6 +1943,9 @@ int hugetlb_overcommit_handler(struct ct
 	if (!write)
 		tmp = h->nr_overcommit_huge_pages;
 
+	if (write && h->order >= MAX_ORDER)
+		return -EINVAL;
+
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
 	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
_

Patches currently in -mm which might be from emunson@mgebm.net are

origin.patch


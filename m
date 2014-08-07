From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-generalize-writes-to-nr_hugepages.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:05:23 -0700
Message-ID: <53e3dc03.ooqUC21K9Rj0pC8h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:45389 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaHGUFY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:24 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so608542yha.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, davidlohr@hp.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, lcapitulino@redhat.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: generalize writes to nr_hugepages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-generalize-writes-to-nr_hugepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, hugetlb: generalize writes to nr_hugepages

Three different interfaces alter the maximum number of hugepages for an
hstate:

 - /proc/sys/vm/nr_hugepages for global number of hugepages of the default
   hstate,

 - /sys/kernel/mm/hugepages/hugepages-X/nr_hugepages for global number of
   hugepages for a specific hstate, and

 - /sys/kernel/mm/hugepages/hugepages-X/nr_hugepages/mempolicy for number of
   hugepages for a specific hstate over the set of allowed nodes.

Generalize the code so that a single function handles all of these writes
instead of duplicating the code in two different functions.

This decreases the number of lines of code, but also reduces the size of
.text by about half a percent since set_max_huge_pages() can be inlined.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Luiz Capitulino <lcapitulino@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   58 +++++++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-generalize-writes-to-nr_hugepages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-generalize-writes-to-nr_hugepages
+++ a/mm/hugetlb.c
@@ -1734,21 +1734,13 @@ static ssize_t nr_hugepages_show_common(
 	return sprintf(buf, "%lu\n", nr_huge_pages);
 }
 
-static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
-			struct kobject *kobj, struct kobj_attribute *attr,
-			const char *buf, size_t len)
+static ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
+					   struct hstate *h, int nid,
+					   unsigned long count, size_t len)
 {
 	int err;
-	int nid;
-	unsigned long count;
-	struct hstate *h;
 	NODEMASK_ALLOC(nodemask_t, nodes_allowed, GFP_KERNEL | __GFP_NORETRY);
 
-	err = kstrtoul(buf, 10, &count);
-	if (err)
-		goto out;
-
-	h = kobj_to_hstate(kobj, &nid);
 	if (hstate_is_gigantic(h) && !gigantic_page_supported()) {
 		err = -EINVAL;
 		goto out;
@@ -1784,6 +1776,23 @@ out:
 	return err;
 }
 
+static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
+					 struct kobject *kobj, const char *buf,
+					 size_t len)
+{
+	struct hstate *h;
+	unsigned long count;
+	int nid;
+	int err;
+
+	err = kstrtoul(buf, 10, &count);
+	if (err)
+		return err;
+
+	h = kobj_to_hstate(kobj, &nid);
+	return __nr_hugepages_store_common(obey_mempolicy, h, nid, count, len);
+}
+
 static ssize_t nr_hugepages_show(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *buf)
 {
@@ -1793,7 +1802,7 @@ static ssize_t nr_hugepages_show(struct
 static ssize_t nr_hugepages_store(struct kobject *kobj,
 	       struct kobj_attribute *attr, const char *buf, size_t len)
 {
-	return nr_hugepages_store_common(false, kobj, attr, buf, len);
+	return nr_hugepages_store_common(false, kobj, buf, len);
 }
 HSTATE_ATTR(nr_hugepages);
 
@@ -1812,7 +1821,7 @@ static ssize_t nr_hugepages_mempolicy_sh
 static ssize_t nr_hugepages_mempolicy_store(struct kobject *kobj,
 	       struct kobj_attribute *attr, const char *buf, size_t len)
 {
-	return nr_hugepages_store_common(true, kobj, attr, buf, len);
+	return nr_hugepages_store_common(true, kobj, buf, len);
 }
 HSTATE_ATTR(nr_hugepages_mempolicy);
 #endif
@@ -2248,36 +2257,21 @@ static int hugetlb_sysctl_handler_common
 			 void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct hstate *h = &default_hstate;
-	unsigned long tmp;
+	unsigned long tmp = h->max_huge_pages;
 	int ret;
 
 	if (!hugepages_supported())
 		return -ENOTSUPP;
 
-	tmp = h->max_huge_pages;
-
-	if (write && hstate_is_gigantic(h) && !gigantic_page_supported())
-		return -EINVAL;
-
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
 	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
 	if (ret)
 		goto out;
 
-	if (write) {
-		NODEMASK_ALLOC(nodemask_t, nodes_allowed,
-						GFP_KERNEL | __GFP_NORETRY);
-		if (!(obey_mempolicy &&
-			       init_nodemask_of_mempolicy(nodes_allowed))) {
-			NODEMASK_FREE(nodes_allowed);
-			nodes_allowed = &node_states[N_MEMORY];
-		}
-		h->max_huge_pages = set_max_huge_pages(h, tmp, nodes_allowed);
-
-		if (nodes_allowed != &node_states[N_MEMORY])
-			NODEMASK_FREE(nodes_allowed);
-	}
+	if (write)
+		ret = __nr_hugepages_store_common(obey_mempolicy, h,
+						  NUMA_NO_NODE, tmp, *length);
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch


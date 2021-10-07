Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB861C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89AF161108
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbhJGTPa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Oct 2021 15:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243853AbhJGTPa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Oct 2021 15:15:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8E5260F23;
        Thu,  7 Oct 2021 19:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633634016;
        bh=gKDXFjDkbA9LAh4ATHtxR1fXt/CrY2n4EO8ivsG+q7A=;
        h=Date:From:To:Subject:From;
        b=czVyj6ueEfwBmeUpxo1itvvdTPLuhr02vReggK+eO+eFTsoCmWaEOkHCQs1zFCfkD
         Fe7Ykftl7Jeawr2yfKuLd2VMAXiCYLdIzlAarePYIPIbG1qGNa9BzNtx89dgZ6FazW
         3pWWrs9HLEY6LYw8GKH3/5gerXzVt+ZoK2WPIqDs=
Date:   Thu, 07 Oct 2021 12:13:35 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, david@redhat.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@linux.dev, nghialm78@gmail.com, osalvador@suse.de,
        rientjes@google.com, songmuchun@bytedance.com, ziy@nvidia.com
Subject:  + hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
 added to -mm tree
Message-ID: <20211007191335.agVza-1ri%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: add demote hugetlb page sysfs interfaces
has been added to the -mm tree.  Its filename is
     hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: add demote hugetlb page sysfs interfaces

Patch series "hugetlb: add demote/split page functionality", v4.

The concurrent use of multiple hugetlb page sizes on a single system is
becoming more common.  One of the reasons is better TLB support for
gigantic page sizes on x86 hardware.  In addition, hugetlb pages are being
used to back VMs in hosting environments.

When using hugetlb pages to back VMs, it is often desirable to preallocate
hugetlb pools.  This avoids the delay and uncertainty of allocating
hugetlb pages at VM startup.  In addition, preallocating huge pages
minimizes the issue of memory fragmentation that increases the longer the
system is up and running.

In such environments, a combination of larger and smaller hugetlb pages
are preallocated in anticipation of backing VMs of various sizes.  Over
time, the preallocated pool of smaller hugetlb pages may become depleted
while larger hugetlb pages still remain.  In such situations, it is
desirable to convert larger hugetlb pages to smaller hugetlb pages.

Converting larger to smaller hugetlb pages can be accomplished today by
first freeing the larger page to the buddy allocator and then allocating
the smaller pages.  For example, to convert 50 GB pages on x86:
gb_pages=`cat .../hugepages-1048576kB/nr_hugepages`
m2_pages=`cat .../hugepages-2048kB/nr_hugepages`
echo $(($gb_pages - 50)) > .../hugepages-1048576kB/nr_hugepages
echo $(($m2_pages + 25600)) > .../hugepages-2048kB/nr_hugepages

On an idle system this operation is fairly reliable and results are as
expected.  The number of 2MB pages is increased as expected and the time
of the operation is a second or two.

However, when there is activity on the system the following issues
arise:
1) This process can take quite some time, especially if allocation of
   the smaller pages is not immediate and requires migration/compaction.
2) There is no guarantee that the total size of smaller pages allocated
   will match the size of the larger page which was freed.  This is
   because the area freed by the larger page could quickly be
   fragmented.
In a test environment with a load that continually fills the page cache
with clean pages, results such as the following can be observed:

Unexpected number of 2MB pages allocated: Expected 25600, have 19944
real    0m42.092s
user    0m0.008s
sys     0m41.467s

To address these issues, introduce the concept of hugetlb page demotion. 
Demotion provides a means of 'in place' splitting of a hugetlb page to
pages of a smaller size.  This avoids freeing pages to buddy and then
trying to allocate from buddy.

Page demotion is controlled via sysfs files that reside in the per-hugetlb
page size and per node directories.
- demote_size   Target page size for demotion, a smaller huge page size.
		File can be written to chose a smaller huge page size if
		multiple are available.
- demote        Writable number of hugetlb pages to be demoted

To demote 50 GB huge pages, one would:
cat .../hugepages-1048576kB/free_hugepages   /* optional, verify free pages */
cat .../hugepages-1048576kB/demote_size      /* optional, verify target size */
echo 50 > .../hugepages-1048576kB/demote

Only hugetlb pages which are free at the time of the request can be
demoted.  Demotion does not add to the complexity of surplus pages and
honors reserved huge pages.  Therefore, when a value is written to the
sysfs demote file, that value is only the maximum number of pages which
will be demoted.  It is possible fewer will actually be demoted.  The
recently introduced per-hstate mutex is used to synchronize demote
operations with other operations that modify hugetlb pools.

Real world use cases
--------------------
The above scenario describes a real world use case where hugetlb pages are
used to back VMs on x86.  Both issues of long allocation times and not
necessarily getting the expected number of smaller huge pages after a free
and allocate cycle have been experienced.  The occurrence of these issues
is dependent on other activity within the host and can not be predicted.


This patch (of 5):

Two new sysfs files are added to demote hugtlb pages.  These files are
both per-hugetlb page size and per node.  Files are:

  demote_size - The size in Kb that pages are demoted to. (read-write)
  demote - The number of huge pages to demote. (write-only)

By default, demote_size is the next smallest huge page size.  Valid huge
page sizes less than huge page size may be written to this file.  When
huge pages are demoted, they are demoted to this size.

Writing a value to demote will result in an attempt to demote that number
of hugetlb pages to an appropriate number of demote_size pages.

NOTE: Demote interfaces are only provided for huge page sizes if there is
a smaller target demote huge page size.  For example, on x86 1GB huge
pages will have demote interfaces.  2MB huge pages will not have demote
interfaces.

This patch does not provide full demote functionality.  It only provides
the sysfs interfaces.

It also provides documentation for the new interfaces.

Link: https://lkml.kernel.org/r/20211007181918.136982-2-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20211007181918.136982-2-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: David Rientjes <rientjes@google.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Nghia Le <nghialm78@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/hugetlbpage.rst |   30 +++
 include/linux/hugetlb.h                      |    1 
 mm/hugetlb.c                                 |  155 ++++++++++++++++-
 3 files changed, 183 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/hugetlbpage.rst~hugetlb-add-demote-hugetlb-page-sysfs-interfaces
+++ a/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -234,8 +234,12 @@ will exist, of the form::
 
 	hugepages-${size}kB
 
-Inside each of these directories, the same set of files will exist::
+Inside each of these directories, the set of files contained in ``/proc``
+will exist.  In addition, two additional interfaces for demoting huge
+pages may exist::
 
+        demote
+        demote_size
 	nr_hugepages
 	nr_hugepages_mempolicy
 	nr_overcommit_hugepages
@@ -243,7 +247,29 @@ Inside each of these directories, the sa
 	resv_hugepages
 	surplus_hugepages
 
-which function as described above for the default huge page-sized case.
+The demote interfaces provide the ability to split a huge page into
+smaller huge pages.  For example, the x86 architecture supports both
+1GB and 2MB huge pages sizes.  A 1GB huge page can be split into 512
+2MB huge pages.  Demote interfaces are not available for the smallest
+huge page size.  The demote interfaces are:
+
+demote_size
+        is the size of demoted pages.  When a page is demoted a corresponding
+        number of huge pages of demote_size will be created.  By default,
+        demote_size is set to the next smaller huge page size.  If there are
+        multiple smaller huge page sizes, demote_size can be set to any of
+        these smaller sizes.  Only huge page sizes less than the current huge
+        pages size are allowed.
+
+demote
+        is used to demote a number of huge pages.  A user with root privileges
+        can write to this file.  It may not be possible to demote the
+        requested number of huge pages.  To determine how many pages were
+        actually demoted, compare the value of nr_hugepages before and after
+        writing to the demote interface.  demote is a write only interface.
+
+The interfaces which are the same as in ``/proc`` (all except demote and
+demote_size) function as described above for the default huge page-sized case.
 
 .. _mem_policy_and_hp_alloc:
 
--- a/include/linux/hugetlb.h~hugetlb-add-demote-hugetlb-page-sysfs-interfaces
+++ a/include/linux/hugetlb.h
@@ -586,6 +586,7 @@ struct hstate {
 	int next_nid_to_alloc;
 	int next_nid_to_free;
 	unsigned int order;
+	unsigned int demote_order;
 	unsigned long mask;
 	unsigned long max_huge_pages;
 	unsigned long nr_huge_pages;
--- a/mm/hugetlb.c~hugetlb-add-demote-hugetlb-page-sysfs-interfaces
+++ a/mm/hugetlb.c
@@ -2986,7 +2986,7 @@ free:
 
 static void __init hugetlb_init_hstates(void)
 {
-	struct hstate *h;
+	struct hstate *h, *h2;
 
 	for_each_hstate(h) {
 		if (minimum_order > huge_page_order(h))
@@ -2995,6 +2995,22 @@ static void __init hugetlb_init_hstates(
 		/* oversize hugepages were init'ed in early boot */
 		if (!hstate_is_gigantic(h))
 			hugetlb_hstate_alloc_pages(h);
+
+		/*
+		 * Set demote order for each hstate.  Note that
+		 * h->demote_order is initially 0.
+		 * - We can not demote gigantic pages if runtime freeing
+		 *   is not supported, so skip this.
+		 */
+		if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+			continue;
+		for_each_hstate(h2) {
+			if (h2 == h)
+				continue;
+			if (h2->order < h->order &&
+			    h2->order > h->demote_order)
+				h->demote_order = h2->order;
+		}
 	}
 	VM_BUG_ON(minimum_order == UINT_MAX);
 }
@@ -3235,9 +3251,31 @@ out:
 	return 0;
 }
 
+static int demote_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
+	__must_hold(&hugetlb_lock)
+{
+	int rc = 0;
+
+	lockdep_assert_held(&hugetlb_lock);
+
+	/* We should never get here if no demote order */
+	if (!h->demote_order) {
+		pr_warn("HugeTLB: NULL demote order passed to demote_pool_huge_page.\n");
+		return -EINVAL;		/* internal error */
+	}
+
+	/*
+	 * TODO - demote fucntionality will be added in subsequent patch
+	 */
+	return rc;
+}
+
 #define HSTATE_ATTR_RO(_name) \
 	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 
+#define HSTATE_ATTR_WO(_name) \
+	static struct kobj_attribute _name##_attr = __ATTR_WO(_name)
+
 #define HSTATE_ATTR(_name) \
 	static struct kobj_attribute _name##_attr = \
 		__ATTR(_name, 0644, _name##_show, _name##_store)
@@ -3433,6 +3471,105 @@ static ssize_t surplus_hugepages_show(st
 }
 HSTATE_ATTR_RO(surplus_hugepages);
 
+static ssize_t demote_store(struct kobject *kobj,
+	       struct kobj_attribute *attr, const char *buf, size_t len)
+{
+	unsigned long nr_demote;
+	unsigned long nr_available;
+	nodemask_t nodes_allowed, *n_mask;
+	struct hstate *h;
+	int err = 0;
+	int nid;
+
+	err = kstrtoul(buf, 10, &nr_demote);
+	if (err)
+		return err;
+	h = kobj_to_hstate(kobj, &nid);
+
+	/* Synchronize with other sysfs operations modifying huge pages */
+	mutex_lock(&h->resize_lock);
+
+	if (nid != NUMA_NO_NODE) {
+		init_nodemask_of_node(&nodes_allowed, nid);
+		n_mask = &nodes_allowed;
+	} else {
+		n_mask = &node_states[N_MEMORY];
+	}
+
+	spin_lock_irq(&hugetlb_lock);
+	while (nr_demote) {
+		/*
+		 * Check for available pages to demote each time thorough the
+		 * loop as demote_pool_huge_page will drop hugetlb_lock.
+		 *
+		 * NOTE: demote_pool_huge_page does not yet drop hugetlb_lock
+		 * but will when full demote functionality is added in a later
+		 * patch.
+		 */
+		if (nid != NUMA_NO_NODE)
+			nr_available = h->free_huge_pages_node[nid];
+		else
+			nr_available = h->free_huge_pages;
+		nr_available -= h->resv_huge_pages;
+		if (!nr_available)
+			break;
+
+		err = demote_pool_huge_page(h, n_mask);
+		if (err)
+			break;
+
+		nr_demote--;
+	}
+
+	spin_unlock_irq(&hugetlb_lock);
+	mutex_unlock(&h->resize_lock);
+
+	if (err)
+		return err;
+	return len;
+}
+HSTATE_ATTR_WO(demote);
+
+static ssize_t demote_size_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	int nid;
+	struct hstate *h = kobj_to_hstate(kobj, &nid);
+	unsigned long demote_size = (PAGE_SIZE << h->demote_order) / SZ_1K;
+
+	return sysfs_emit(buf, "%lukB\n", demote_size);
+}
+
+static ssize_t demote_size_store(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct hstate *h, *demote_hstate;
+	unsigned long demote_size;
+	unsigned int demote_order;
+	int nid;
+
+	demote_size = (unsigned long)memparse(buf, NULL);
+
+	demote_hstate = size_to_hstate(demote_size);
+	if (!demote_hstate)
+		return -EINVAL;
+	demote_order = demote_hstate->order;
+
+	/* demote order must be smaller than hstate order */
+	h = kobj_to_hstate(kobj, &nid);
+	if (demote_order >= h->order)
+		return -EINVAL;
+
+	/* resize_lock synchronizes access to demote size and writes */
+	mutex_lock(&h->resize_lock);
+	h->demote_order = demote_order;
+	mutex_unlock(&h->resize_lock);
+
+	return count;
+}
+HSTATE_ATTR(demote_size);
+
 static struct attribute *hstate_attrs[] = {
 	&nr_hugepages_attr.attr,
 	&nr_overcommit_hugepages_attr.attr,
@@ -3449,6 +3586,16 @@ static const struct attribute_group hsta
 	.attrs = hstate_attrs,
 };
 
+static struct attribute *hstate_demote_attrs[] = {
+	&demote_size_attr.attr,
+	&demote_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group hstate_demote_attr_group = {
+	.attrs = hstate_demote_attrs,
+};
+
 static int hugetlb_sysfs_add_hstate(struct hstate *h, struct kobject *parent,
 				    struct kobject **hstate_kobjs,
 				    const struct attribute_group *hstate_attr_group)
@@ -3466,6 +3613,12 @@ static int hugetlb_sysfs_add_hstate(stru
 		hstate_kobjs[hi] = NULL;
 	}
 
+	if (h->demote_order) {
+		if (sysfs_create_group(hstate_kobjs[hi],
+					&hstate_demote_attr_group))
+			pr_warn("HugeTLB unable to create demote interfaces for %s\n", h->name);
+	}
+
 	return retval;
 }
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch
hugetlb-be-sure-to-free-demoted-cma-pages-to-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E60C4338F
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 23:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7082760F55
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 23:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbhHPX3y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 19:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234672AbhHPX3v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 19:29:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5B8E606A5;
        Mon, 16 Aug 2021 23:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629156559;
        bh=RJ7VhYvj1vPsIgR2aH3eKN0p4b/pV2ruF9EKxMaNL8w=;
        h=Date:From:To:Subject:From;
        b=n1zAXDCFS3k6dPdMES2e56rQOH7cbKqzPiMQTseyQ1wEtR+9bMv/BE5K1tTO8GvFD
         r9/bSkUCwGFMpB5Pn67ZSA5WBMcgPcYGPak6Hp95UpPp81CkYBx9ibChE15YIbqW/m
         c2sqSVBp80uUzNFE2+yYC1Kd74r9GcYCs3+wy0fI=
Date:   Mon, 16 Aug 2021 16:29:18 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        songmuchun@bytedance.com, rientjes@google.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mhocko@suse.com, david@redhat.com,
        mike.kravetz@oracle.com
Subject:  + hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
 added to -mm tree
Message-ID: <20210816232918.ViA4_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
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

Patch series "hugetlb: add demote/split page functionality".

The concurrent use of multiple hugetlb page sizes on a single system is
becoming more common.  One of the reasons is better TLB support for
gigantic page sizes on x86 hardware.  In addition, hugetlb pages are being
used to back VMs in hosting environments.

When using hugetlb pages to back VMs in such environments, it is sometimes
desirable to preallocate hugetlb pools.  This avoids the delay and
uncertainty of allocating hugetlb pages at VM startup.  In addition,
preallocating huge pages minimizes the issue of memory fragmentation that
increases the longer the system is up and running.

In such environments, a combination of larger and smaller hugetlb pages
are preallocated in anticipation of backing VMs of various sizes.  Over
time, the preallocated pool of smaller hugetlb pages may become depleted
while larger hugetlb pages still remain.  In such situations, it may be
desirable to convert larger hugetlb pages to smaller hugetlb pages.

Converting larger to smaller hugetlb pages can be accomplished today by
first freeing the larger page to the buddy allocator and then allocating
the smaller pages.  However, there are two issues with this approach:

1) This process can take quite some time, especially if allocation of
   the smaller pages is not immediate and requires migration/compaction.

2) There is no guarantee that the total size of smaller pages allocated
   will match the size of the larger page which was freed.  This is
   because the area freed by the larger page could quickly be
   fragmented.

To address these issues, introduce the concept of hugetlb page demotion. 
Demotion provides a means of 'in place' splitting a hugetlb page to pages
of a smaller size.  For example, on x86 one 1G page can be demoted to 512
2M pages.  Page demotion is controlled via sysfs files.

- demote_size   Read only target page size for demotion

- demote        Writable number of hugetlb pages to be demoted

Only hugetlb pages which are free at the time of the request can be
demoted.  Demotion does not add to the complexity surplus pages.  Demotion
also honors reserved huge pages.  Therefore, when a value is written to
the sysfs demote file, that value is only the maximum number of pages
which will be demoted.  It is possible fewer will actually be demoted.

If demote_size is PAGESIZE, demote will simply free pages to the buddy
allocator.

Real world use cases
--------------------

There are groups today using hugetlb pages to back VMs on x86.  Their use
case is as described above.  They have experienced the issues with
performance and not necessarily getting the expected number smaller huge
pages after free/allocate cycle.

Notes to reviewers
------------------

Patches 1-5 provide the basic demote functionality.  They are built on
	next-20210721.
Patch 3 deals with this issue of speculative page references as
	discussed in [1] and [2].  It builds on the ideas used in
	patches currently in mmotm.  There have been few comments on
	those patches in mmotm, so I do not feel the approach has been
	well vetted.
Patches 6-8 are an optimization to deal with vmemmap optimized pages.
	This was discussed in the RFC.  IMO, the code may not be worth
	the benefit.  They could be dropped with no loss of
	functionality.  In addition, Muchun has recently sent patches to
	further optimize hugetlb vmemmap reduction by only requiring one
	vmemmap page per huge page [3].  These patches do not take Muchun's
	new patches into account.

[1] https://lore.kernel.org/linux-mm/CAG48ez23q0Jy9cuVnwAe7t_fdhMk2S7N5Hdi-GLcCeq5bsfLxw@mail.gmail.com/
[2] https://lore.kernel.org/linux-mm/20210710002441.167759-1-mike.kravetz@oracle.com/
[3] https://lore.kernel.org/linux-mm/20210714091800.42645-1-songmuchun@bytedance.com/
[4] https://lore.kernel.org/linux-mm/20210721230511.201823-1-mike.kravetz@oracle.com/
[5] https://lore.kernel.org/linux-mm/20210309001855.142453-1-mike.kravetz@oracle.com/


This patch (of 8):

Two new sysfs files are added to demote hugtlb pages.  These files are
both per-hugetlb page size and per node.  Files are:

  demote_size - The size in Kb that pages are demoted to. (read-only)
  demote - The number of huge pages to demote. (write-only)

Writing a value to demote will result in an attempt to demote that number
of hugetlb pages to an appropriate number of demote_size pages.

This patch does not provide full demote functionality.  It only provides
the sysfs interfaces and uses existing code to free pages to the buddy
allocator if demote_size == PAGESIZE.

Link: https://lkml.kernel.org/r/20210816224953.157796-1-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20210816224953.157796-2-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 
 mm/hugetlb.c            |  121 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 121 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~hugetlb-add-demote-hugetlb-page-sysfs-interfaces
+++ a/include/linux/hugetlb.h
@@ -596,6 +596,7 @@ struct hstate {
 	int next_nid_to_alloc;
 	int next_nid_to_free;
 	unsigned int order;
+	unsigned int demote_order;
 	unsigned long mask;
 	unsigned long max_huge_pages;
 	unsigned long nr_huge_pages;
--- a/mm/hugetlb.c~hugetlb-add-demote-hugetlb-page-sysfs-interfaces
+++ a/mm/hugetlb.c
@@ -2966,7 +2966,7 @@ free:
 
 static void __init hugetlb_init_hstates(void)
 {
-	struct hstate *h;
+	struct hstate *h, *h2;
 
 	for_each_hstate(h) {
 		if (minimum_order > huge_page_order(h))
@@ -2975,6 +2975,17 @@ static void __init hugetlb_init_hstates(
 		/* oversize hugepages were init'ed in early boot */
 		if (!hstate_is_gigantic(h))
 			hugetlb_hstate_alloc_pages(h);
+
+		/*
+		 * Set demote order for each hstate.  Note that
+		 * h->demote_order is initially 0.
+		 */
+		for_each_hstate(h2) {
+			if (h2 == h)
+				continue;
+			if (h2->order < h->order && h2->order > h->demote_order)
+				h->demote_order = h2->order;
+		}
 	}
 	VM_BUG_ON(minimum_order == UINT_MAX);
 }
@@ -3215,9 +3226,36 @@ out:
 	return 0;
 }
 
+static int demote_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
+	__must_hold(&hugetlb_lock)
+{
+	int rc = 0;
+
+	lockdep_assert_held(&hugetlb_lock);
+	/* If no demote order, free to buddy */
+	if (!h->demote_order) {
+		struct page *page = remove_pool_huge_page(h, nodes_allowed, 0);
+
+		if (!page)
+			return rc;
+		spin_unlock_irq(&hugetlb_lock);
+		update_and_free_page(h, page, false);
+		spin_lock_irq(&hugetlb_lock);
+		return 1;
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
@@ -3413,12 +3451,91 @@ static ssize_t surplus_hugepages_show(st
 }
 HSTATE_ATTR_RO(surplus_hugepages);
 
+static ssize_t demote_store(struct kobject *kobj,
+	       struct kobj_attribute *attr, const char *buf, size_t len)
+{
+	unsigned long nr_demote;
+	unsigned long nr_available;
+	nodemask_t nodes_allowed, *n_mask;
+	struct hstate *h;
+	int err;
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
+	spin_lock_irq(&hugetlb_lock);
+	if (nid != NUMA_NO_NODE) {
+		nr_available = h->free_huge_pages_node[nid];
+		init_nodemask_of_node(&nodes_allowed, nid);
+		n_mask = &nodes_allowed;
+	} else {
+		nr_available = h->free_huge_pages;
+		n_mask = &node_states[N_MEMORY];
+	}
+	nr_available -= h->resv_huge_pages;
+	if (nr_available <= 0)
+		goto out;
+	nr_demote = min(nr_available, nr_demote);
+
+	while (nr_demote) {
+		if (!demote_pool_huge_page(h, n_mask))
+			break;
+
+		/*
+		 * We may have dropped the lock in the routines to
+		 * demote/free a page.  Recompute nr_demote as counts could
+		 * have changed and we want to make sure we do not demote
+		 * a reserved huge page.
+		 */
+		nr_demote--;
+		if (nid != NUMA_NO_NODE)
+			nr_available = h->free_huge_pages_node[nid];
+		else
+			nr_available = h->free_huge_pages;
+		nr_available -= h->resv_huge_pages;
+		if (nr_available <= 0)
+			nr_demote = 0;
+		else
+			nr_demote = min(nr_available, nr_demote);
+	}
+
+out:
+	spin_unlock_irq(&hugetlb_lock);
+	mutex_unlock(&h->resize_lock);
+
+	return len;
+}
+HSTATE_ATTR_WO(demote);
+
+static ssize_t demote_size_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h;
+	unsigned long demote_size;
+	int nid;
+
+	h = kobj_to_hstate(kobj, &nid);
+	demote_size = h->demote_order;
+
+	return sysfs_emit(buf, "%lukB\n",
+			(unsigned long)(PAGE_SIZE << h->demote_order) / SZ_1K);
+}
+HSTATE_ATTR_RO(demote_size);
+
 static struct attribute *hstate_attrs[] = {
 	&nr_hugepages_attr.attr,
 	&nr_overcommit_hugepages_attr.attr,
 	&free_hugepages_attr.attr,
 	&resv_hugepages_attr.attr,
 	&surplus_hugepages_attr.attr,
+	&demote_size_attr.attr,
+	&demote_attr.attr,
 #ifdef CONFIG_NUMA
 	&nr_hugepages_mempolicy_attr.attr,
 #endif
@@ -3488,6 +3605,8 @@ static struct attribute *per_node_hstate
 	&nr_hugepages_attr.attr,
 	&free_hugepages_attr.attr,
 	&surplus_hugepages_attr.attr,
+	&demote_size_attr.attr,
+	&demote_attr.attr,
 	NULL,
 };
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch
hugetlb-drop-ref-count-earlier-after-page-allocation.patch
hugetlb-before-freeing-hugetlb-page-set-dtor-to-appropriate-value.patch
hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch
hugetlb-document-the-demote-sysfs-interfaces.patch
hugetlb-vmemmap-optimizations-when-demoting-hugetlb-pages.patch
hugetlb-prepare-destroy-and-prep-routines-for-vmemmap-optimized-pages.patch
hugetlb-optimized-demote-vmemmap-optimizatized-pages.patch


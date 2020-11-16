Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F2EFC388F9
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 23:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1534C2225B
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 23:16:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZygCJjWL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgKPXPo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 18:15:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgKPXPo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 18:15:44 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4190A2223D;
        Mon, 16 Nov 2020 23:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605568541;
        bh=tFF5ul0G+DlSWb2IVh9IJ3VOBcql7nCm1SlSgKfby3o=;
        h=Date:From:To:Subject:From;
        b=ZygCJjWLqxYXfUjYOzse8esQEEisB2znFxaAreQ7HvbEASrDoUuArcY44XgZRK36r
         XqrVc5e6mhCHMnffpjBdsIPA6Qm7MPJxW5m67dSm1igimGyfaM5wLPaX2CVnjj4nk8
         APQXf5pnbNXOLeFgeSFn9vt6cmkP+PddqU308zsE=
Date:   Mon, 16 Nov 2020 15:15:39 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, gregkh@linuxfoundation.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, joe@perches.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, willy@infradead.org
Subject:  + mm-use-sysfs_emit-for-struct-kobject-uses.patch added
 to -mm tree
Message-ID: <20201116231539.Df38xNKqD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use sysfs_emit for struct kobject * uses
has been added to the -mm tree.  Its filename is
     mm-use-sysfs_emit-for-struct-kobject-uses.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-sysfs_emit-for-struct-kobject-uses.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-sysfs_emit-for-struct-kobject-uses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: mm: use sysfs_emit for struct kobject * uses

Patch series "mm: Convert sysfs sprintf family to sysfs_emit", v2.

Use the new sysfs_emit family and not the sprintf family.


This patch (of 5):

Use the sysfs_emit function instead of the sprintf family.

Done with cocci script as in commit 3c6bff3cf988
("RDMA: Convert sysfs kobject * show functions to use sysfs_emit()")

Link: https://lkml.kernel.org/r/cover.1605376435.git.joe@perches.com
Link: https://lkml.kernel.org/r/9c249215bad6df616ba0410ad980042694970c1b.1605376435.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   28 ++++++++++++++++------------
 mm/hugetlb.c     |   13 +++++++------
 mm/khugepaged.c  |   22 +++++++++++-----------
 mm/ksm.c         |   32 ++++++++++++++++----------------
 mm/swap_state.c  |    3 ++-
 5 files changed, 52 insertions(+), 46 deletions(-)

--- a/mm/huge_memory.c~mm-use-sysfs_emit-for-struct-kobject-uses
+++ a/mm/huge_memory.c
@@ -164,11 +164,11 @@ static ssize_t enabled_show(struct kobje
 			    struct kobj_attribute *attr, char *buf)
 {
 	if (test_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags))
-		return sprintf(buf, "[always] madvise never\n");
+		return sysfs_emit(buf, "[always] madvise never\n");
 	else if (test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags))
-		return sprintf(buf, "always [madvise] never\n");
+		return sysfs_emit(buf, "always [madvise] never\n");
 	else
-		return sprintf(buf, "always madvise [never]\n");
+		return sysfs_emit(buf, "always madvise [never]\n");
 }
 
 static ssize_t enabled_store(struct kobject *kobj,
@@ -233,14 +233,18 @@ static ssize_t defrag_show(struct kobjec
 			   struct kobj_attribute *attr, char *buf)
 {
 	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags))
-		return sprintf(buf, "[always] defer defer+madvise madvise never\n");
+		return sysfs_emit(buf,
+				  "[always] defer defer+madvise madvise never\n");
 	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags))
-		return sprintf(buf, "always [defer] defer+madvise madvise never\n");
+		return sysfs_emit(buf,
+				  "always [defer] defer+madvise madvise never\n");
 	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags))
-		return sprintf(buf, "always defer [defer+madvise] madvise never\n");
+		return sysfs_emit(buf,
+				  "always defer [defer+madvise] madvise never\n");
 	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags))
-		return sprintf(buf, "always defer defer+madvise [madvise] never\n");
-	return sprintf(buf, "always defer defer+madvise madvise [never]\n");
+		return sysfs_emit(buf,
+				  "always defer defer+madvise [madvise] never\n");
+	return sysfs_emit(buf, "always defer defer+madvise madvise [never]\n");
 }
 
 static ssize_t defrag_store(struct kobject *kobj,
@@ -281,10 +285,10 @@ static struct kobj_attribute defrag_attr
 	__ATTR(defrag, 0644, defrag_show, defrag_store);
 
 static ssize_t use_zero_page_show(struct kobject *kobj,
-		struct kobj_attribute *attr, char *buf)
+				  struct kobj_attribute *attr, char *buf)
 {
 	return single_hugepage_flag_show(kobj, attr, buf,
-				TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
+					 TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
 }
 static ssize_t use_zero_page_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
@@ -296,9 +300,9 @@ static struct kobj_attribute use_zero_pa
 	__ATTR(use_zero_page, 0644, use_zero_page_show, use_zero_page_store);
 
 static ssize_t hpage_pmd_size_show(struct kobject *kobj,
-		struct kobj_attribute *attr, char *buf)
+				   struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%lu\n", HPAGE_PMD_SIZE);
+	return sysfs_emit(buf, "%lu\n", HPAGE_PMD_SIZE);
 }
 static struct kobj_attribute hpage_pmd_size_attr =
 	__ATTR_RO(hpage_pmd_size);
--- a/mm/hugetlb.c~mm-use-sysfs_emit-for-struct-kobject-uses
+++ a/mm/hugetlb.c
@@ -2758,7 +2758,7 @@ static ssize_t nr_hugepages_show_common(
 	else
 		nr_huge_pages = h->nr_huge_pages_node[nid];
 
-	return sprintf(buf, "%lu\n", nr_huge_pages);
+	return sysfs_emit(buf, "%lu\n", nr_huge_pages);
 }
 
 static ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
@@ -2831,7 +2831,8 @@ HSTATE_ATTR(nr_hugepages);
  * huge page alloc/free.
  */
 static ssize_t nr_hugepages_mempolicy_show(struct kobject *kobj,
-				       struct kobj_attribute *attr, char *buf)
+					   struct kobj_attribute *attr,
+					   char *buf)
 {
 	return nr_hugepages_show_common(kobj, attr, buf);
 }
@@ -2849,7 +2850,7 @@ static ssize_t nr_overcommit_hugepages_s
 					struct kobj_attribute *attr, char *buf)
 {
 	struct hstate *h = kobj_to_hstate(kobj, NULL);
-	return sprintf(buf, "%lu\n", h->nr_overcommit_huge_pages);
+	return sysfs_emit(buf, "%lu\n", h->nr_overcommit_huge_pages);
 }
 
 static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
@@ -2887,7 +2888,7 @@ static ssize_t free_hugepages_show(struc
 	else
 		free_huge_pages = h->free_huge_pages_node[nid];
 
-	return sprintf(buf, "%lu\n", free_huge_pages);
+	return sysfs_emit(buf, "%lu\n", free_huge_pages);
 }
 HSTATE_ATTR_RO(free_hugepages);
 
@@ -2895,7 +2896,7 @@ static ssize_t resv_hugepages_show(struc
 					struct kobj_attribute *attr, char *buf)
 {
 	struct hstate *h = kobj_to_hstate(kobj, NULL);
-	return sprintf(buf, "%lu\n", h->resv_huge_pages);
+	return sysfs_emit(buf, "%lu\n", h->resv_huge_pages);
 }
 HSTATE_ATTR_RO(resv_hugepages);
 
@@ -2912,7 +2913,7 @@ static ssize_t surplus_hugepages_show(st
 	else
 		surplus_huge_pages = h->surplus_huge_pages_node[nid];
 
-	return sprintf(buf, "%lu\n", surplus_huge_pages);
+	return sysfs_emit(buf, "%lu\n", surplus_huge_pages);
 }
 HSTATE_ATTR_RO(surplus_hugepages);
 
--- a/mm/khugepaged.c~mm-use-sysfs_emit-for-struct-kobject-uses
+++ a/mm/khugepaged.c
@@ -124,7 +124,7 @@ static ssize_t scan_sleep_millisecs_show
 					 struct kobj_attribute *attr,
 					 char *buf)
 {
-	return sprintf(buf, "%u\n", khugepaged_scan_sleep_millisecs);
+	return sysfs_emit(buf, "%u\n", khugepaged_scan_sleep_millisecs);
 }
 
 static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
@@ -152,7 +152,7 @@ static ssize_t alloc_sleep_millisecs_sho
 					  struct kobj_attribute *attr,
 					  char *buf)
 {
-	return sprintf(buf, "%u\n", khugepaged_alloc_sleep_millisecs);
+	return sysfs_emit(buf, "%u\n", khugepaged_alloc_sleep_millisecs);
 }
 
 static ssize_t alloc_sleep_millisecs_store(struct kobject *kobj,
@@ -180,7 +180,7 @@ static ssize_t pages_to_scan_show(struct
 				  struct kobj_attribute *attr,
 				  char *buf)
 {
-	return sprintf(buf, "%u\n", khugepaged_pages_to_scan);
+	return sysfs_emit(buf, "%u\n", khugepaged_pages_to_scan);
 }
 static ssize_t pages_to_scan_store(struct kobject *kobj,
 				   struct kobj_attribute *attr,
@@ -205,7 +205,7 @@ static ssize_t pages_collapsed_show(stru
 				    struct kobj_attribute *attr,
 				    char *buf)
 {
-	return sprintf(buf, "%u\n", khugepaged_pages_collapsed);
+	return sysfs_emit(buf, "%u\n", khugepaged_pages_collapsed);
 }
 static struct kobj_attribute pages_collapsed_attr =
 	__ATTR_RO(pages_collapsed);
@@ -214,7 +214,7 @@ static ssize_t full_scans_show(struct ko
 			       struct kobj_attribute *attr,
 			       char *buf)
 {
-	return sprintf(buf, "%u\n", khugepaged_full_scans);
+	return sysfs_emit(buf, "%u\n", khugepaged_full_scans);
 }
 static struct kobj_attribute full_scans_attr =
 	__ATTR_RO(full_scans);
@@ -223,7 +223,7 @@ static ssize_t khugepaged_defrag_show(st
 				      struct kobj_attribute *attr, char *buf)
 {
 	return single_hugepage_flag_show(kobj, attr, buf,
-				TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG);
+					 TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG);
 }
 static ssize_t khugepaged_defrag_store(struct kobject *kobj,
 				       struct kobj_attribute *attr,
@@ -248,7 +248,7 @@ static ssize_t khugepaged_max_ptes_none_
 					     struct kobj_attribute *attr,
 					     char *buf)
 {
-	return sprintf(buf, "%u\n", khugepaged_max_ptes_none);
+	return sysfs_emit(buf, "%u\n", khugepaged_max_ptes_none);
 }
 static ssize_t khugepaged_max_ptes_none_store(struct kobject *kobj,
 					      struct kobj_attribute *attr,
@@ -273,7 +273,7 @@ static ssize_t khugepaged_max_ptes_swap_
 					     struct kobj_attribute *attr,
 					     char *buf)
 {
-	return sprintf(buf, "%u\n", khugepaged_max_ptes_swap);
+	return sysfs_emit(buf, "%u\n", khugepaged_max_ptes_swap);
 }
 
 static ssize_t khugepaged_max_ptes_swap_store(struct kobject *kobj,
@@ -297,10 +297,10 @@ static struct kobj_attribute khugepaged_
 	       khugepaged_max_ptes_swap_store);
 
 static ssize_t khugepaged_max_ptes_shared_show(struct kobject *kobj,
-					     struct kobj_attribute *attr,
-					     char *buf)
+					       struct kobj_attribute *attr,
+					       char *buf)
 {
-	return sprintf(buf, "%u\n", khugepaged_max_ptes_shared);
+	return sysfs_emit(buf, "%u\n", khugepaged_max_ptes_shared);
 }
 
 static ssize_t khugepaged_max_ptes_shared_store(struct kobject *kobj,
--- a/mm/ksm.c~mm-use-sysfs_emit-for-struct-kobject-uses
+++ a/mm/ksm.c
@@ -2833,7 +2833,7 @@ static void wait_while_offlining(void)
 static ssize_t sleep_millisecs_show(struct kobject *kobj,
 				    struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%u\n", ksm_thread_sleep_millisecs);
+	return sysfs_emit(buf, "%u\n", ksm_thread_sleep_millisecs);
 }
 
 static ssize_t sleep_millisecs_store(struct kobject *kobj,
@@ -2857,7 +2857,7 @@ KSM_ATTR(sleep_millisecs);
 static ssize_t pages_to_scan_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%u\n", ksm_thread_pages_to_scan);
+	return sysfs_emit(buf, "%u\n", ksm_thread_pages_to_scan);
 }
 
 static ssize_t pages_to_scan_store(struct kobject *kobj,
@@ -2880,7 +2880,7 @@ KSM_ATTR(pages_to_scan);
 static ssize_t run_show(struct kobject *kobj, struct kobj_attribute *attr,
 			char *buf)
 {
-	return sprintf(buf, "%lu\n", ksm_run);
+	return sysfs_emit(buf, "%lu\n", ksm_run);
 }
 
 static ssize_t run_store(struct kobject *kobj, struct kobj_attribute *attr,
@@ -2927,9 +2927,9 @@ KSM_ATTR(run);
 
 #ifdef CONFIG_NUMA
 static ssize_t merge_across_nodes_show(struct kobject *kobj,
-				struct kobj_attribute *attr, char *buf)
+				       struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%u\n", ksm_merge_across_nodes);
+	return sysfs_emit(buf, "%u\n", ksm_merge_across_nodes);
 }
 
 static ssize_t merge_across_nodes_store(struct kobject *kobj,
@@ -2984,9 +2984,9 @@ KSM_ATTR(merge_across_nodes);
 #endif
 
 static ssize_t use_zero_pages_show(struct kobject *kobj,
-				struct kobj_attribute *attr, char *buf)
+				   struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%u\n", ksm_use_zero_pages);
+	return sysfs_emit(buf, "%u\n", ksm_use_zero_pages);
 }
 static ssize_t use_zero_pages_store(struct kobject *kobj,
 				   struct kobj_attribute *attr,
@@ -3008,7 +3008,7 @@ KSM_ATTR(use_zero_pages);
 static ssize_t max_page_sharing_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%u\n", ksm_max_page_sharing);
+	return sysfs_emit(buf, "%u\n", ksm_max_page_sharing);
 }
 
 static ssize_t max_page_sharing_store(struct kobject *kobj,
@@ -3049,21 +3049,21 @@ KSM_ATTR(max_page_sharing);
 static ssize_t pages_shared_show(struct kobject *kobj,
 				 struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%lu\n", ksm_pages_shared);
+	return sysfs_emit(buf, "%lu\n", ksm_pages_shared);
 }
 KSM_ATTR_RO(pages_shared);
 
 static ssize_t pages_sharing_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%lu\n", ksm_pages_sharing);
+	return sysfs_emit(buf, "%lu\n", ksm_pages_sharing);
 }
 KSM_ATTR_RO(pages_sharing);
 
 static ssize_t pages_unshared_show(struct kobject *kobj,
 				   struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%lu\n", ksm_pages_unshared);
+	return sysfs_emit(buf, "%lu\n", ksm_pages_unshared);
 }
 KSM_ATTR_RO(pages_unshared);
 
@@ -3080,21 +3080,21 @@ static ssize_t pages_volatile_show(struc
 	 */
 	if (ksm_pages_volatile < 0)
 		ksm_pages_volatile = 0;
-	return sprintf(buf, "%ld\n", ksm_pages_volatile);
+	return sysfs_emit(buf, "%ld\n", ksm_pages_volatile);
 }
 KSM_ATTR_RO(pages_volatile);
 
 static ssize_t stable_node_dups_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%lu\n", ksm_stable_node_dups);
+	return sysfs_emit(buf, "%lu\n", ksm_stable_node_dups);
 }
 KSM_ATTR_RO(stable_node_dups);
 
 static ssize_t stable_node_chains_show(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%lu\n", ksm_stable_node_chains);
+	return sysfs_emit(buf, "%lu\n", ksm_stable_node_chains);
 }
 KSM_ATTR_RO(stable_node_chains);
 
@@ -3103,7 +3103,7 @@ stable_node_chains_prune_millisecs_show(
 					struct kobj_attribute *attr,
 					char *buf)
 {
-	return sprintf(buf, "%u\n", ksm_stable_node_chains_prune_millisecs);
+	return sysfs_emit(buf, "%u\n", ksm_stable_node_chains_prune_millisecs);
 }
 
 static ssize_t
@@ -3127,7 +3127,7 @@ KSM_ATTR(stable_node_chains_prune_millis
 static ssize_t full_scans_show(struct kobject *kobj,
 			       struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%lu\n", ksm_scan.seqnr);
+	return sysfs_emit(buf, "%lu\n", ksm_scan.seqnr);
 }
 KSM_ATTR_RO(full_scans);
 
--- a/mm/swap_state.c~mm-use-sysfs_emit-for-struct-kobject-uses
+++ a/mm/swap_state.c
@@ -901,7 +901,8 @@ struct page *swapin_readahead(swp_entry_
 static ssize_t vma_ra_enabled_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%s\n", enable_vma_readahead ? "true" : "false");
+	return sysfs_emit(buf, "%s\n",
+			  enable_vma_readahead ? "true" : "false");
 }
 static ssize_t vma_ra_enabled_store(struct kobject *kobj,
 				      struct kobj_attribute *attr,
_

Patches currently in -mm which might be from joe@perches.com are

mm-zswap-make-struct-kernel_param_ops-definitions-const.patch
mm-use-sysfs_emit-for-struct-kobject-uses.patch
mm-huge_memory-convert-remaining-use-of-sprintf-to-sysfs_emit-and-neatening.patch
mm-backing-dev-use-sysfs_emit-in-macro-defining-functions.patch
mm-shmem-convert-shmem_enabled_show-to-use-sysfs_emit_at.patch
mm-slub-convert-sysfs-sprintf-family-to-sysfs_emit-sysfs_emit_at.patch
checkpatch-prefer-static-const-declarations.patch
checkpatch-allow-fix-removal-of-unnecessary-break-statements.patch
checkpatch-update-__attribute__sectionname-quote-removal.patch
checkpatch-update-__attribute__sectionname-quote-removal-v2.patch
checkpatch-add-__alias-and-__weak-to-suggested-__attribute__-conversions.patch
treewide-remove-stringification-from-__alias-macro-definition.patch


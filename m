Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71982C43334
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jun 2022 20:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378805AbiFPUta (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 16:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378878AbiFPUsy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 16:48:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138D45EBCE
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 13:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93BFF61E0C
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 20:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4790C34114;
        Thu, 16 Jun 2022 20:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655412531;
        bh=iOHHAzJLMzmhT/nJ4E8XGcVD0iBopJATEOtMbNMcE4s=;
        h=Date:To:From:Subject:From;
        b=1DM3+zzWOft9voo6i4b9vqZu0yfGpInYX7uU3Bl53yfm19ukk7zXBo/bLsyftte2U
         Oj1MVVaJ3f3sX5Brn1KAuVV6yB9cSE+q5Kxg4rFMYb+9phH2EIk3dZX0/CNYSYFFgq
         ccNNEcJMZ1zVz75GhxbUEHieSoQqqdOn3oQcwPkQ=
Date:   Thu, 16 Jun 2022 13:48:50 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, surenb@google.com,
        shy828301@gmail.com, peterx@redhat.com, neilb@suse.de,
        mike.kravetz@oracle.com, dhowells@redhat.com, david@redhat.com,
        apopple@nvidia.com, aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-use-helper-macro-__attr_rw.patch removed from -mm tree
Message-Id: <20220616204850.E4790C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: use helper macro __ATTR_RW
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-use-helper-macro-__attr_rw.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/khugepaged: use helper macro __ATTR_RW
Date: Sat, 11 Jun 2022 16:47:29 +0800

Use helper macro __ATTR_RW to define the khugepaged attributes.  Minor
readability improvement.

Link: https://lkml.kernel.org/r/20220611084731.55155-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: "Zach O'Keefe" <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-helper-macro-__attr_rw
+++ a/mm/khugepaged.c
@@ -147,8 +147,7 @@ static ssize_t scan_sleep_millisecs_stor
 	return count;
 }
 static struct kobj_attribute scan_sleep_millisecs_attr =
-	__ATTR(scan_sleep_millisecs, 0644, scan_sleep_millisecs_show,
-	       scan_sleep_millisecs_store);
+	__ATTR_RW(scan_sleep_millisecs);
 
 static ssize_t alloc_sleep_millisecs_show(struct kobject *kobj,
 					  struct kobj_attribute *attr,
@@ -175,8 +174,7 @@ static ssize_t alloc_sleep_millisecs_sto
 	return count;
 }
 static struct kobj_attribute alloc_sleep_millisecs_attr =
-	__ATTR(alloc_sleep_millisecs, 0644, alloc_sleep_millisecs_show,
-	       alloc_sleep_millisecs_store);
+	__ATTR_RW(alloc_sleep_millisecs);
 
 static ssize_t pages_to_scan_show(struct kobject *kobj,
 				  struct kobj_attribute *attr,
@@ -200,8 +198,7 @@ static ssize_t pages_to_scan_store(struc
 	return count;
 }
 static struct kobj_attribute pages_to_scan_attr =
-	__ATTR(pages_to_scan, 0644, pages_to_scan_show,
-	       pages_to_scan_store);
+	__ATTR_RW(pages_to_scan);
 
 static ssize_t pages_collapsed_show(struct kobject *kobj,
 				    struct kobj_attribute *attr,
@@ -221,13 +218,13 @@ static ssize_t full_scans_show(struct ko
 static struct kobj_attribute full_scans_attr =
 	__ATTR_RO(full_scans);
 
-static ssize_t khugepaged_defrag_show(struct kobject *kobj,
+static ssize_t defrag_show(struct kobject *kobj,
 				      struct kobj_attribute *attr, char *buf)
 {
 	return single_hugepage_flag_show(kobj, attr, buf,
 					 TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG);
 }
-static ssize_t khugepaged_defrag_store(struct kobject *kobj,
+static ssize_t defrag_store(struct kobject *kobj,
 				       struct kobj_attribute *attr,
 				       const char *buf, size_t count)
 {
@@ -235,8 +232,7 @@ static ssize_t khugepaged_defrag_store(s
 				 TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG);
 }
 static struct kobj_attribute khugepaged_defrag_attr =
-	__ATTR(defrag, 0644, khugepaged_defrag_show,
-	       khugepaged_defrag_store);
+	__ATTR_RW(defrag);
 
 /*
  * max_ptes_none controls if khugepaged should collapse hugepages over
@@ -246,13 +242,13 @@ static struct kobj_attribute khugepaged_
  * runs. Increasing max_ptes_none will instead potentially reduce the
  * free memory in the system during the khugepaged scan.
  */
-static ssize_t khugepaged_max_ptes_none_show(struct kobject *kobj,
+static ssize_t max_ptes_none_show(struct kobject *kobj,
 					     struct kobj_attribute *attr,
 					     char *buf)
 {
 	return sysfs_emit(buf, "%u\n", khugepaged_max_ptes_none);
 }
-static ssize_t khugepaged_max_ptes_none_store(struct kobject *kobj,
+static ssize_t max_ptes_none_store(struct kobject *kobj,
 					      struct kobj_attribute *attr,
 					      const char *buf, size_t count)
 {
@@ -268,17 +264,16 @@ static ssize_t khugepaged_max_ptes_none_
 	return count;
 }
 static struct kobj_attribute khugepaged_max_ptes_none_attr =
-	__ATTR(max_ptes_none, 0644, khugepaged_max_ptes_none_show,
-	       khugepaged_max_ptes_none_store);
+	__ATTR_RW(max_ptes_none);
 
-static ssize_t khugepaged_max_ptes_swap_show(struct kobject *kobj,
+static ssize_t max_ptes_swap_show(struct kobject *kobj,
 					     struct kobj_attribute *attr,
 					     char *buf)
 {
 	return sysfs_emit(buf, "%u\n", khugepaged_max_ptes_swap);
 }
 
-static ssize_t khugepaged_max_ptes_swap_store(struct kobject *kobj,
+static ssize_t max_ptes_swap_store(struct kobject *kobj,
 					      struct kobj_attribute *attr,
 					      const char *buf, size_t count)
 {
@@ -295,17 +290,16 @@ static ssize_t khugepaged_max_ptes_swap_
 }
 
 static struct kobj_attribute khugepaged_max_ptes_swap_attr =
-	__ATTR(max_ptes_swap, 0644, khugepaged_max_ptes_swap_show,
-	       khugepaged_max_ptes_swap_store);
+	__ATTR_RW(max_ptes_swap);
 
-static ssize_t khugepaged_max_ptes_shared_show(struct kobject *kobj,
+static ssize_t max_ptes_shared_show(struct kobject *kobj,
 					       struct kobj_attribute *attr,
 					       char *buf)
 {
 	return sysfs_emit(buf, "%u\n", khugepaged_max_ptes_shared);
 }
 
-static ssize_t khugepaged_max_ptes_shared_store(struct kobject *kobj,
+static ssize_t max_ptes_shared_store(struct kobject *kobj,
 					      struct kobj_attribute *attr,
 					      const char *buf, size_t count)
 {
@@ -322,8 +316,7 @@ static ssize_t khugepaged_max_ptes_share
 }
 
 static struct kobj_attribute khugepaged_max_ptes_shared_attr =
-	__ATTR(max_ptes_shared, 0644, khugepaged_max_ptes_shared_show,
-	       khugepaged_max_ptes_shared_store);
+	__ATTR_RW(max_ptes_shared);
 
 static struct attribute *khugepaged_attr[] = {
 	&khugepaged_defrag_attr.attr,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

maintainers-add-myself-as-a-memory-failure-reviewer.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-memremap-fix-wrong-function-name-above-memremap_pages.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
lib-test_hmm-avoid-accessing-uninitialized-pages.patch
mm-memremap-fix-memunmap_pages-race-with-get_dev_pagemap.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch


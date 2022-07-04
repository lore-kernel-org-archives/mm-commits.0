Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92750CCA473
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbiGDBNH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbiGDBMG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:12:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFABB6446
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:11:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50407B80CF0
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50FEC341C6;
        Mon,  4 Jul 2022 01:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897062;
        bh=d1nDKkJcDwyHUQdd/4h3pvFoOAdLdEMvUbh4Wle76tY=;
        h=Date:To:From:Subject:From;
        b=y4vIRHdCJfqPzoH3Yq5tADCickMeySBD9aFYAmfbfwwr8xsTV/KRw1nZbkotyOR7u
         od/8CyhZBJzI7l9B4aYfy838+386u2Vi9yYwshVz4ynl2WBzTIGoGwBV1C2JHKJKA/
         HwzNomqLPdVuQTIZtEdYIPdpPdb9umgTGsDPIgkI=
Date:   Sun, 03 Jul 2022 18:11:01 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, surenb@google.com,
        shy828301@gmail.com, peterx@redhat.com, neilb@suse.de,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-use-helper-macro-__attr_rw.patch removed from -mm tree
Message-Id: <20220704011101.E50FEC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: use helper macro __ATTR_RW
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-use-helper-macro-__attr_rw.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/khugepaged: use helper macro __ATTR_RW
Date: Sat, 25 Jun 2022 17:28:14 +0800

Use helper macro __ATTR_RW to define the khugepaged attributes.  Minor
readability improvement.

Link: https://lkml.kernel.org/r/20220625092816.4856-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   67 ++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 37 deletions(-)

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
@@ -221,22 +218,21 @@ static ssize_t full_scans_show(struct ko
 static struct kobj_attribute full_scans_attr =
 	__ATTR_RO(full_scans);
 
-static ssize_t khugepaged_defrag_show(struct kobject *kobj,
-				      struct kobj_attribute *attr, char *buf)
+static ssize_t defrag_show(struct kobject *kobj,
+			   struct kobj_attribute *attr, char *buf)
 {
 	return single_hugepage_flag_show(kobj, attr, buf,
 					 TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG);
 }
-static ssize_t khugepaged_defrag_store(struct kobject *kobj,
-				       struct kobj_attribute *attr,
-				       const char *buf, size_t count)
+static ssize_t defrag_store(struct kobject *kobj,
+			    struct kobj_attribute *attr,
+			    const char *buf, size_t count)
 {
 	return single_hugepage_flag_store(kobj, attr, buf, count,
 				 TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG);
 }
 static struct kobj_attribute khugepaged_defrag_attr =
-	__ATTR(defrag, 0644, khugepaged_defrag_show,
-	       khugepaged_defrag_store);
+	__ATTR_RW(defrag);
 
 /*
  * max_ptes_none controls if khugepaged should collapse hugepages over
@@ -246,15 +242,15 @@ static struct kobj_attribute khugepaged_
  * runs. Increasing max_ptes_none will instead potentially reduce the
  * free memory in the system during the khugepaged scan.
  */
-static ssize_t khugepaged_max_ptes_none_show(struct kobject *kobj,
-					     struct kobj_attribute *attr,
-					     char *buf)
+static ssize_t max_ptes_none_show(struct kobject *kobj,
+				  struct kobj_attribute *attr,
+				  char *buf)
 {
 	return sysfs_emit(buf, "%u\n", khugepaged_max_ptes_none);
 }
-static ssize_t khugepaged_max_ptes_none_store(struct kobject *kobj,
-					      struct kobj_attribute *attr,
-					      const char *buf, size_t count)
+static ssize_t max_ptes_none_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count)
 {
 	int err;
 	unsigned long max_ptes_none;
@@ -268,19 +264,18 @@ static ssize_t khugepaged_max_ptes_none_
 	return count;
 }
 static struct kobj_attribute khugepaged_max_ptes_none_attr =
-	__ATTR(max_ptes_none, 0644, khugepaged_max_ptes_none_show,
-	       khugepaged_max_ptes_none_store);
+	__ATTR_RW(max_ptes_none);
 
-static ssize_t khugepaged_max_ptes_swap_show(struct kobject *kobj,
-					     struct kobj_attribute *attr,
-					     char *buf)
+static ssize_t max_ptes_swap_show(struct kobject *kobj,
+				  struct kobj_attribute *attr,
+				  char *buf)
 {
 	return sysfs_emit(buf, "%u\n", khugepaged_max_ptes_swap);
 }
 
-static ssize_t khugepaged_max_ptes_swap_store(struct kobject *kobj,
-					      struct kobj_attribute *attr,
-					      const char *buf, size_t count)
+static ssize_t max_ptes_swap_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count)
 {
 	int err;
 	unsigned long max_ptes_swap;
@@ -295,19 +290,18 @@ static ssize_t khugepaged_max_ptes_swap_
 }
 
 static struct kobj_attribute khugepaged_max_ptes_swap_attr =
-	__ATTR(max_ptes_swap, 0644, khugepaged_max_ptes_swap_show,
-	       khugepaged_max_ptes_swap_store);
+	__ATTR_RW(max_ptes_swap);
 
-static ssize_t khugepaged_max_ptes_shared_show(struct kobject *kobj,
-					       struct kobj_attribute *attr,
-					       char *buf)
+static ssize_t max_ptes_shared_show(struct kobject *kobj,
+				    struct kobj_attribute *attr,
+				    char *buf)
 {
 	return sysfs_emit(buf, "%u\n", khugepaged_max_ptes_shared);
 }
 
-static ssize_t khugepaged_max_ptes_shared_store(struct kobject *kobj,
-					      struct kobj_attribute *attr,
-					      const char *buf, size_t count)
+static ssize_t max_ptes_shared_store(struct kobject *kobj,
+				     struct kobj_attribute *attr,
+				     const char *buf, size_t count)
 {
 	int err;
 	unsigned long max_ptes_shared;
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

mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch


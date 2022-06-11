Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C225C43334
	for <mm-commits@archiver.kernel.org>; Sat, 11 Jun 2022 20:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiFKUg0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Jun 2022 16:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbiFKUgU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Jun 2022 16:36:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816F06BFD4
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 13:36:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B6CC612A0
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 20:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6A9C34116;
        Sat, 11 Jun 2022 20:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654979778;
        bh=+VqEQKz5XdRCZwUgiWfd0rSsS4xuvZ9hFo2K+tfI+tY=;
        h=Date:To:From:Subject:From;
        b=enSCC8YKLwCmQrhuk+PkM4ivdUv/jt/mXplZCykyLlagnMW4tGIg3yWdLq5pnuVVG
         7D/H1VEgadVKPBfWx5hF20FcuNcFRR+V62C1PsU2oPasXJhrYCr+8DPaV/j+nbYnk9
         rIEkrON/0Mkm3iEKA0xSdEpARGbpSxdXur8p9Uy0=
Date:   Sat, 11 Jun 2022 13:36:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, neilb@suse.de,
        mike.kravetz@oracle.com, dhowells@redhat.com, david@redhat.com,
        apopple@nvidia.com, aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-use-helper-macro-__attr_rw.patch added to mm-unstable branch
Message-Id: <20220611203618.5D6A9C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: use helper macro __ATTR_RW
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-use-helper-macro-__attr_rw.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-use-helper-macro-__attr_rw.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
mm-khugepaged-remove-unneeded-shmem_huge_enabled-check.patch
mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch
mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch


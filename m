Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E509BC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbjDFCpu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbjDFCpG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846C19000
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 192F964230
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B61C433D2;
        Thu,  6 Apr 2023 02:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749104;
        bh=Lgp95muBaZKLmfA4L5gHCpJUMfx5qSnApyq/fOS4G/c=;
        h=Date:To:From:Subject:From;
        b=qRUsW8unIdN9E/U9q+liIhqUPsGTd74BKum0s/aQWxXLpL4lvh2+vYJ6ZNZzcs/PD
         16JCts9FvmPomzcbUukE1YhNJ2vjrH4SbRvivqD0nOvbs+I5QJLBqUyYa+uXr1rPI1
         1ZDrVYVJ3rCxm+aP3wsdsXxhjGSWHRIllVxS3mHs=
Date:   Wed, 05 Apr 2023 19:45:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        david@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pefer-fault_around_pages-to-fault_around_bytes.patch removed from -mm tree
Message-Id: <20230406024504.72B61C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: prefer fault_around_pages to fault_around_bytes
has been removed from the -mm tree.  Its filename was
     mm-pefer-fault_around_pages-to-fault_around_bytes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: prefer fault_around_pages to fault_around_bytes
Date: Fri, 17 Mar 2023 21:58:26 +0000

All use of this value is now at page granularity, so specify the variable
as such too.  This simplifies the logic.

We maintain the debugfs entry to ensure that there are no user-visible
changes.

Link: https://lkml.kernel.org/r/4995bad07fe9baa51c786fa0d81819dddfb57654.1679089214.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

--- a/mm/memory.c~mm-pefer-fault_around_pages-to-fault_around_bytes
+++ a/mm/memory.c
@@ -4405,13 +4405,13 @@ vm_fault_t finish_fault(struct vm_fault
 	return ret;
 }
 
-static unsigned long fault_around_bytes __read_mostly =
-	rounddown_pow_of_two(65536);
+static unsigned long fault_around_pages __read_mostly =
+	65536 >> PAGE_SHIFT;
 
 #ifdef CONFIG_DEBUG_FS
 static int fault_around_bytes_get(void *data, u64 *val)
 {
-	*val = fault_around_bytes;
+	*val = fault_around_pages << PAGE_SHIFT;
 	return 0;
 }
 
@@ -4423,10 +4423,13 @@ static int fault_around_bytes_set(void *
 {
 	if (val / PAGE_SIZE > PTRS_PER_PTE)
 		return -EINVAL;
-	if (val > PAGE_SIZE)
-		fault_around_bytes = rounddown_pow_of_two(val);
-	else
-		fault_around_bytes = PAGE_SIZE; /* rounddown_pow_of_two(0) is undefined */
+
+	/*
+	 * The minimum value is 1 page, however this results in no fault-around
+	 * at all. See should_fault_around().
+	 */
+	fault_around_pages = max(rounddown_pow_of_two(val) >> PAGE_SHIFT, 1UL);
+
 	return 0;
 }
 DEFINE_DEBUGFS_ATTRIBUTE(fault_around_bytes_fops,
@@ -4452,18 +4455,18 @@ late_initcall(fault_around_debugfs);
  * This function doesn't cross VMA or page table boundaries, in order to call
  * map_pages() and acquire a PTE lock only once.
  *
- * fault_around_bytes defines how many bytes we'll try to map.
+ * fault_around_pages defines how many pages we'll try to map.
  * do_fault_around() expects it to be set to a power of two less than or equal
  * to PTRS_PER_PTE.
  *
  * The virtual address of the area that we map is naturally aligned to
- * fault_around_bytes rounded down to the machine page size
+ * fault_around_pages * PAGE_SIZE rounded down to the machine page size
  * (and therefore to page order).  This way it's easier to guarantee
  * that we don't cross page table boundaries.
  */
 static vm_fault_t do_fault_around(struct vm_fault *vmf)
 {
-	pgoff_t nr_pages = READ_ONCE(fault_around_bytes) >> PAGE_SHIFT;
+	pgoff_t nr_pages = READ_ONCE(fault_around_pages);
 	pgoff_t pte_off = pte_index(vmf->address);
 	/* The page offset of vmf->address within the VMA. */
 	pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
@@ -4498,7 +4501,8 @@ static inline bool should_fault_around(s
 	if (uffd_disable_fault_around(vmf->vma))
 		return false;
 
-	return fault_around_bytes >> PAGE_SHIFT > 1;
+	/* A single page implies no faulting 'around' at all. */
+	return fault_around_pages > 1;
 }
 
 static vm_fault_t do_read_fault(struct vm_fault *vmf)
_

Patches currently in -mm which might be from lstoakes@gmail.com are



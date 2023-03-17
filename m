Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B67C74A5B
	for <mm-commits@archiver.kernel.org>; Fri, 17 Mar 2023 23:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjCQXmL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Mar 2023 19:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjCQXmF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Mar 2023 19:42:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C955C1F934
        for <mm-commits@vger.kernel.org>; Fri, 17 Mar 2023 16:41:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 27C28CE2198
        for <mm-commits@vger.kernel.org>; Fri, 17 Mar 2023 23:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6E7C433EF;
        Fri, 17 Mar 2023 23:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679096515;
        bh=clCfaENZTc2RsGvV5GFArZkmS0vtZG1VqF1jHCINqRA=;
        h=Date:To:From:Subject:From;
        b=YuTvlfzuHPp8U4ykD6JTkj/RUAqb1hNATPYIdWkn/OOpje38JHLEO1d/7Z2GeeUDJ
         +FWfCQ5Q3vuhw7E/YDVvj22tFMwLh4cOaLiFb1mClDPlO1o8jx9K3Fl39JCyGdOpVT
         3nGuHPQ3dS/0vtRd/pct6hpiNkfu8Y9tCNVIvpGY=
Date:   Fri, 17 Mar 2023 16:41:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        david@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pefer-fault_around_pages-to-fault_around_bytes.patch added to mm-unstable branch
Message-Id: <20230317234155.3F6E7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: prefer fault_around_pages to fault_around_bytes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pefer-fault_around_pages-to-fault_around_bytes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pefer-fault_around_pages-to-fault_around_bytes.patch

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


--- a/mm/memory.c~mm-pefer-fault_around_pages-to-fault_around_bytes
+++ a/mm/memory.c
@@ -4393,13 +4393,13 @@ vm_fault_t finish_fault(struct vm_fault
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
 
@@ -4411,10 +4411,13 @@ static int fault_around_bytes_set(void *
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
@@ -4440,18 +4443,18 @@ late_initcall(fault_around_debugfs);
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
@@ -4486,7 +4489,8 @@ static inline bool should_fault_around(s
 	if (uffd_disable_fault_around(vmf->vma))
 		return false;
 
-	return fault_around_bytes >> PAGE_SHIFT > 1;
+	/* A single page implies no faulting 'around' at all. */
+	return fault_around_pages > 1;
 }
 
 static vm_fault_t do_read_fault(struct vm_fault *vmf)
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch
mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages.patch
mm-refactor-do_fault_around.patch
mm-pefer-fault_around_pages-to-fault_around_bytes.patch


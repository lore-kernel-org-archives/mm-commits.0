Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF108C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbjDFCtZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbjDFCsZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:48:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7012A8A6D
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5188964224
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4C6C433EF;
        Thu,  6 Apr 2023 02:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749150;
        bh=9pu0TjMzfCpmLA9Bfkw7EIKN7VJ9svNt1Fx+a+jA+kU=;
        h=Date:To:From:Subject:From;
        b=aXC10EVwbIhXDmMcV5dL/qSJWJltzf2nGRcGqabDwPZySYYC1VHky9MTK2YBveX9+
         1g+qmJs7vZHvGpsaNyPnuqD7RZ7g7VEns5cR42SKiRP+FABKHUgiw9SushJv79Dq/L
         +E4lWJU2say4cviTqpBzrYaDr4gB0xsMKsxS7u84=
Date:   Wed, 05 Apr 2023 19:45:50 -0700
To:     mm-commits@vger.kernel.org, djwong@kernel.org, dhowells@redhat.com,
        david@fromorbit.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hold-the-rcu-read-lock-over-calls-to-map_pages.patch removed from -mm tree
Message-Id: <20230406024550.AC4C6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hold the RCU read lock over calls to ->map_pages
has been removed from the -mm tree.  Its filename was
     mm-hold-the-rcu-read-lock-over-calls-to-map_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: hold the RCU read lock over calls to ->map_pages
Date: Mon, 27 Mar 2023 18:45:15 +0100

Prevent filesystems from doing things which sleep in their map_pages
method.  This is in preparation for a pagefault path protected only by
RCU.

Link: https://lkml.kernel.org/r/20230327174515.1811532-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/locking.rst |    4 ++--
 mm/memory.c                           |   11 ++++++++---
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/Documentation/filesystems/locking.rst~mm-hold-the-rcu-read-lock-over-calls-to-map_pages
+++ a/Documentation/filesystems/locking.rst
@@ -645,7 +645,7 @@ ops		mmap_lock	PageLocked(page)
 open:		yes
 close:		yes
 fault:		yes		can return with page locked
-map_pages:	yes
+map_pages:	read
 page_mkwrite:	yes		can return with page locked
 pfn_mkwrite:	yes
 access:		yes
@@ -661,7 +661,7 @@ locked. The VM will unlock the page.
 
 ->map_pages() is called when VM asks to map easy accessible pages.
 Filesystem should find and map pages associated with offsets from "start_pgoff"
-till "end_pgoff". ->map_pages() is called with page table locked and must
+till "end_pgoff". ->map_pages() is called with the RCU lock held and must
 not block.  If it's not possible to reach a page without blocking,
 filesystem should skip it. Filesystem should use do_set_pte() to setup
 page table entry. Pointer to entry associated with the page is passed in
--- a/mm/memory.c~mm-hold-the-rcu-read-lock-over-calls-to-map_pages
+++ a/mm/memory.c
@@ -4450,6 +4450,7 @@ static vm_fault_t do_fault_around(struct
 	/* The page offset of vmf->address within the VMA. */
 	pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
 	pgoff_t from_pte, to_pte;
+	vm_fault_t ret;
 
 	/* The PTE offset of the start address, clamped to the VMA. */
 	from_pte = max(ALIGN_DOWN(pte_off, nr_pages),
@@ -4465,9 +4466,13 @@ static vm_fault_t do_fault_around(struct
 			return VM_FAULT_OOM;
 	}
 
-	return vmf->vma->vm_ops->map_pages(vmf,
-		vmf->pgoff + from_pte - pte_off,
-		vmf->pgoff + to_pte - pte_off);
+	rcu_read_lock();
+	ret = vmf->vma->vm_ops->map_pages(vmf,
+			vmf->pgoff + from_pte - pte_off,
+			vmf->pgoff + to_pte - pte_off);
+	rcu_read_unlock();
+
+	return ret;
 }
 
 /* Return true if we should do read fault-around, false otherwise */
_

Patches currently in -mm which might be from willy@infradead.org are

hugetlb-remove-pageheadhuge.patch


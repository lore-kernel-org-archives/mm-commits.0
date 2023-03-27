Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C7EC6FD1D
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 19:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjC0Tyd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 15:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbjC0Tyb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 15:54:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74225198E
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 12:54:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12AD961483
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 19:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBFFC433EF;
        Mon, 27 Mar 2023 19:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679946869;
        bh=R8ZADf/DPI+SnRAUXXbQ5N7dnbwnnyLsyXeZ/GEwnnI=;
        h=Date:To:From:Subject:From;
        b=JpLKphZtuvH6qAgcgLWOpw9H8zW6z+s447clvuCEugCfTpTco1IMXHGR0P1j+cNik
         6YZ0KmHuldB5GQfL8KxzbIVoZhnXdAS9FvUU3r/UHSoDuqV+5TWOJwzH0ecO5d2Zg+
         V1eNvHTOPl06QxmkyumN0hEXJ5trrnKqny60XY7A=
Date:   Mon, 27 Mar 2023 12:54:28 -0700
To:     mm-commits@vger.kernel.org, djwong@kernel.org, dhowells@redhat.com,
        david@fromorbit.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hold-the-rcu-read-lock-over-calls-to-map_pages.patch added to mm-unstable branch
Message-Id: <20230327195429.6DBFFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hold the RCU read lock over calls to ->map_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hold-the-rcu-read-lock-over-calls-to-map_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hold-the-rcu-read-lock-over-calls-to-map_pages.patch

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
@@ -4459,6 +4459,7 @@ static vm_fault_t do_fault_around(struct
 	/* The page offset of vmf->address within the VMA. */
 	pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
 	pgoff_t from_pte, to_pte;
+	vm_fault_t ret;
 
 	/* The PTE offset of the start address, clamped to the VMA. */
 	from_pte = max(ALIGN_DOWN(pte_off, nr_pages),
@@ -4474,9 +4475,13 @@ static vm_fault_t do_fault_around(struct
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

xfs-remove-xfs_filemap_map_pages-wrapper.patch
afs-split-afs_pagecache_valid-out-of-afs_validate.patch
mm-hold-the-rcu-read-lock-over-calls-to-map_pages.patch


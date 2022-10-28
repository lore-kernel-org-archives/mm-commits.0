Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA18FA3749
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiJ1VHl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJ1VHc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:07:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A75A249894
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:07:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0748E629FD
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8F4C433C1;
        Fri, 28 Oct 2022 21:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991250;
        bh=g5IDYOTDc9Ijy6CivP9Ys2vukJQam30ihXRFJi1Ijfk=;
        h=Date:To:From:Subject:From;
        b=bWNpofHdjl46gnKytIkyUWm21aIFxmR1upfAhEccYHLdYNADrKKqTidd1bO+fHixE
         +vN6nGUBF5z3p/1JkNM11R7YhIoMwjWmjHaEKsDANmQXyNPnLBeOkhL/FNYxuqie7w
         ib6MeckwdvTUSjWnLFBHVy8ICkMFkHEK1UETE+5Q=
Date:   Fri, 28 Oct 2022 14:07:29 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com,
        willy@infradead.org, rdunlap@infradead.org, peterx@redhat.com,
        aarcange@redhat.com, ira.weiny@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-ensure-proper-fallback-if-page-faults.patch removed from -mm tree
Message-Id: <20221028210730.4B8F4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: ensure proper fallback if page faults
has been removed from the -mm tree.  Its filename was
     mm-shmem-ensure-proper-fallback-if-page-faults.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: mm/shmem: ensure proper fallback if page faults
Date: Tue, 25 Oct 2022 15:01:08 -0700

The kernel test robot flagged a recursive lock as a result of a conversion
from kmap_atomic() to kmap_local_folio()[Link]

The cause was due to the code depending on the kmap_atomic() side effect
of disabling page faults.  In that case the code expects the fault to fail
and take the fallback case.

git archaeology implied that the recursion may not be an actual bug.[1]
However, depending on the implementation of the mmap_lock and the
condition of the call there may still be a deadlock.[2] So this is not
purely a lockdep issue.  Considering a single threaded call stack there
are 3 options.

	1) Different mm's are in play (no issue)
	2) Readlock implementation is recursive and same mm is in play
	   (no issue)
	3) Readlock implementation is _not_ recursive (issue)

The mmap_lock is recursive so with a single thread there is no issue.

However, Matthew pointed out a deadlock scenario when you consider
additional process' and threads thusly.

"The readlock implementation is only recursive if nobody else has taken a
write lock.  If you have a multithreaded process, one of the other threads
can call mmap() and that will prevent recursion (due to fairness).  Even
if it's a different process that you're trying to acquire the mmap read
lock on, you can still get into a deadly embrace.  eg:

process A thread 1 takes read lock on own mmap_lock
process A thread 2 calls mmap, blocks taking write lock
process B thread 1 takes page fault, read lock on own mmap lock
process B thread 2 calls mmap, blocks taking write lock
process A thread 1 blocks taking read lock on process B
process B thread 1 blocks taking read lock on process A

Now all four threads are blocked waiting for each other."

Regardless using pagefault_disable() ensures that no matter what locking
implementation is used a deadlock will not occur.  Add an explicit
pagefault_disable() and a big comment to explain this for future souls
looking at this code.

[1] https://lore.kernel.org/all/Y1MymJ%2FINb45AdaY@iweiny-desk3/
[2] https://lore.kernel.org/lkml/Y1bXBtGTCym77%2FoD@casper.infradead.org/

Link: https://lkml.kernel.org/r/20221025220108.2366043-1-ira.weiny@intel.com
Link: https://lore.kernel.org/r/202210211215.9dc6efb5-yujie.liu@intel.com
Fixes: 7a7256d5f512 ("shmem: convert shmem_mfill_atomic_pte() to use a folio")
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: kernel test robot <yujie.liu@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/shmem.c~mm-shmem-ensure-proper-fallback-if-page-faults
+++ a/mm/shmem.c
@@ -2424,9 +2424,26 @@ int shmem_mfill_atomic_pte(struct mm_str
 
 		if (!zeropage) {	/* COPY */
 			page_kaddr = kmap_local_folio(folio, 0);
+			/*
+			 * The read mmap_lock is held here.  Despite the
+			 * mmap_lock being read recursive a deadlock is still
+			 * possible if a writer has taken a lock.  For example:
+			 *
+			 * process A thread 1 takes read lock on own mmap_lock
+			 * process A thread 2 calls mmap, blocks taking write lock
+			 * process B thread 1 takes page fault, read lock on own mmap lock
+			 * process B thread 2 calls mmap, blocks taking write lock
+			 * process A thread 1 blocks taking read lock on process B
+			 * process B thread 1 blocks taking read lock on process A
+			 *
+			 * Disable page faults to prevent potential deadlock
+			 * and retry the copy outside the mmap_lock.
+			 */
+			pagefault_disable();
 			ret = copy_from_user(page_kaddr,
 					     (const void __user *)src_addr,
 					     PAGE_SIZE);
+			pagefault_enable();
 			kunmap_local(page_kaddr);
 
 			/* fallback to copy_from_user outside mmap_lock */
_

Patches currently in -mm which might be from ira.weiny@intel.com are



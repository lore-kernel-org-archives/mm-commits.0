Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A0CC38A02
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiJ1VII (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiJ1VHc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:07:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DE3249892
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:07:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58972629FD
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A119EC433D7;
        Fri, 28 Oct 2022 21:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991248;
        bh=G2jcXINRzn0P3N7WBKzgva73xVINra1I2Os0xfjMsho=;
        h=Date:To:From:Subject:From;
        b=uKIwniP+H77k+78peIaDS8/ZUDFALm1Az+wJgYEzp8r9gpFgjadQy9OAUlwrr2haM
         3yuhrLsv57u0Z7jWDF6tqqwVUR0+nB2LtzyHEfXgA/P+kWaJayyvq0+yrjh8eQvqaU
         DzgCofKPponKe+Zb2lt3e+1MUx7TUMKVsosek/6s=
Date:   Fri, 28 Oct 2022 14:07:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        axelrasmussen@google.com, akpm@linux-foundation.org,
        aarcange@redhat.com, ira.weiny@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page.patch removed from -mm tree
Message-Id: <20221028210728.A119EC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/userfaultfd: replace kmap/kmap_atomic() with kmap_local_page()
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: mm/userfaultfd: replace kmap/kmap_atomic() with kmap_local_page()
Date: Sun, 23 Oct 2022 21:34:52 -0700

kmap() and kmap_atomic() are being deprecated in favor of
kmap_local_page() which is appropriate for any thread local context.[1]

A recent locking bug report with userfaultfd showed that the conversion of
the kmap_atomic()'s in those code flows requires care with regard to the
prevention of deadlock.[2]

git archaeology implied that the recursion may not be an actual bug.[3]
However, depending on the implementation of the mmap_lock and the
condition of the call there may still be a deadlock.[4] So this is not
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
implementation is used a deadlock will not occur.

Complete kmap conversion in userfaultfd by replacing the kmap() and
kmap_atomic() calls with kmap_local_page().  When replacing the
kmap_atomic() call ensure page faults continue to be disabled to support
the correct fall back behavior and add a comment to inform future souls of
the requirement.

[1] https://lore.kernel.org/all/20220813220034.806698-1-ira.weiny@intel.com/
[2] https://lore.kernel.org/all/Y1Mh2S7fUGQ%2FiKFR@iweiny-desk3/
[3] https://lore.kernel.org/all/Y1MymJ%2FINb45AdaY@iweiny-desk3/
[4] https://lore.kernel.org/lkml/Y1bXBtGTCym77%2FoD@casper.infradead.org/

[ira.weiny@intel.com: v2]
  Link: https://lkml.kernel.org/r/20221025220136.2366143-1-ira.weiny@intel.com
Link: https://lkml.kernel.org/r/20221024043452.1491677-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/userfaultfd.c~mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page
+++ a/mm/userfaultfd.c
@@ -157,11 +157,28 @@ static int mcopy_atomic_pte(struct mm_st
 		if (!page)
 			goto out;
 
-		page_kaddr = kmap_atomic(page);
+		page_kaddr = kmap_local_page(page);
+		/*
+		 * The read mmap_lock is held here.  Despite the
+		 * mmap_lock being read recursive a deadlock is still
+		 * possible if a writer has taken a lock.  For example:
+		 *
+		 * process A thread 1 takes read lock on own mmap_lock
+		 * process A thread 2 calls mmap, blocks taking write lock
+		 * process B thread 1 takes page fault, read lock on own mmap lock
+		 * process B thread 2 calls mmap, blocks taking write lock
+		 * process A thread 1 blocks taking read lock on process B
+		 * process B thread 1 blocks taking read lock on process A
+		 *
+		 * Disable page faults to prevent potential deadlock
+		 * and retry the copy outside the mmap_lock.
+		 */
+		pagefault_disable();
 		ret = copy_from_user(page_kaddr,
 				     (const void __user *) src_addr,
 				     PAGE_SIZE);
-		kunmap_atomic(page_kaddr);
+		pagefault_enable();
+		kunmap_local(page_kaddr);
 
 		/* fallback to copy_from_user outside mmap_lock */
 		if (unlikely(ret)) {
@@ -646,11 +663,11 @@ retry:
 			mmap_read_unlock(dst_mm);
 			BUG_ON(!page);
 
-			page_kaddr = kmap(page);
+			page_kaddr = kmap_local_page(page);
 			err = copy_from_user(page_kaddr,
 					     (const void __user *) src_addr,
 					     PAGE_SIZE);
-			kunmap(page);
+			kunmap_local(page_kaddr);
 			if (unlikely(err)) {
 				err = -EFAULT;
 				goto out;
_

Patches currently in -mm which might be from ira.weiny@intel.com are



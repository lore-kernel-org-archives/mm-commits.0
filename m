Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95243C67871
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 00:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiJYAOO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiJYANr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 20:13:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1C91A0C2E
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 15:32:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E69F0614AF
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 22:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31323C433C1;
        Mon, 24 Oct 2022 22:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666650730;
        bh=7Y9V18fGeuIhA1WjSUGxXHUuBjLLztr8X41RAmt42uM=;
        h=Date:To:From:Subject:From;
        b=QGexwiHlVYYxBjae0LUsQcONmC8qmfiA8Ht9eo5fJQNPiu76SWcLagTypkPGSY6N3
         5oDZNv1vnVxE6zhRckFc0kp5zYMfYW69lFGAl814hySRYen1Tnj8mRax9Iq+i7h8hu
         3okB016jPoSylXeMhAywyiIuMx0wdloUd024xV28=
Date:   Mon, 24 Oct 2022 15:32:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        axelrasmussen@google.com, akpm@linux-foundation.org,
        aarcange@redhat.com, ira.weiny@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page.patch added to mm-unstable branch
Message-Id: <20221024223210.31323C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/userfaultfd: replace kmap/kmap_atomic() with kmap_local_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page.patch

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
From: Ira Weiny <ira.weiny@intel.com>
Subject: mm/userfaultfd: replace kmap/kmap_atomic() with kmap_local_page()
Date: Sun, 23 Oct 2022 21:34:52 -0700

kmap() and kmap_atomic() are being deprecated in favor of
kmap_local_page() which is appropriate for any thread local context.[1]

A recent locking bug report with userfaultfd showed that the conversion of
these kmap_atomic()'s required care with regard to the prevention of
deadlock.[2]

Complete kmap conversion in userfaultfd by replacing the kmap() and
kmap_atomic() calls with kmap_local_page().  When replacing the
kmap_atomic() call ensure page faults continue to be disabled to support
the correct fall back behavior and add a comment to inform future souls of
the requirement.

[1] https://lore.kernel.org/all/20220813220034.806698-1-ira.weiny@intel.com/
[2] https://lore.kernel.org/all/Y1Mh2S7fUGQ%2FiKFR@iweiny-desk3/

Link: https://lkml.kernel.org/r/20221024043452.1491677-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page
+++ a/mm/userfaultfd.c
@@ -157,11 +157,18 @@ static int mcopy_atomic_pte(struct mm_st
 		if (!page)
 			goto out;
 
-		page_kaddr = kmap_atomic(page);
+		page_kaddr = kmap_local_page(page);
+		/*
+		 * The mmap_lock is held here.  Disable page faults to
+		 * prevent deadlock should copy_from_user() fault.  The
+		 * copy will be retried outside the mmap_lock.
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
@@ -646,11 +653,11 @@ retry:
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

mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page.patch


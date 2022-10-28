Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0591EC38A02
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 20:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJ1Ubd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 16:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJ1Ubc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 16:31:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0763121A855
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 13:31:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9668F629FD
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 20:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49DFC433C1;
        Fri, 28 Oct 2022 20:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666989091;
        bh=lkWQSv+w8Jtg4U47j9BiR5/BJ4rTrSyN5ntfkyO2IP0=;
        h=Date:To:From:Subject:From;
        b=bspol8FW70r3iQTNElRlQVdHc9w7wKcff+5u1elvp7se5J1WBDhOt4WbkuVbPQl7s
         gHUkf6+3meYDSnT+J+1K89LTjkHTJdpvvZsxN2UBW3GtG4v+bSnaslnsYYzp06ZWPw
         Rk1h4mYA+2/Q/ZM61YW8pQeAmaDQebP53vAIgNhU=
Date:   Fri, 28 Oct 2022 13:31:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        akpm@linux-foundation.org, aarcange@redhat.com,
        ira.weiny@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page-v2.patch removed from -mm tree
Message-Id: <20221028203130.D49DFC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page-v2
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page-v2.patch

This patch was dropped because it was folded into mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page.patch

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page-v2
Date: Tue, 25 Oct 2022 15:01:36 -0700

Update the commit message and comment based on additional discussion

Thanks to Matt for pointing out the deadlock potential despite recursive
reads.  

Link: https://lkml.kernel.org/r/20221025220136.2366143-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page-v2
+++ a/mm/userfaultfd.c
@@ -159,9 +159,19 @@ static int mcopy_atomic_pte(struct mm_st
 
 		page_kaddr = kmap_local_page(page);
 		/*
-		 * The mmap_lock is held here.  Disable page faults to
-		 * prevent deadlock should copy_from_user() fault.  The
-		 * copy will be retried outside the mmap_lock.
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
 		 */
 		pagefault_disable();
 		ret = copy_from_user(page_kaddr,
_

Patches currently in -mm which might be from ira.weiny@intel.com are

mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page.patch
mm-shmem-ensure-proper-fallback-if-page-faults.patch


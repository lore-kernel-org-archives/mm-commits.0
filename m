Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A60C38A02
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 02:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiJZCDr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Oct 2022 22:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiJZCDp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2022 22:03:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D271833E2A
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 19:03:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AD1FB81FDF
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 02:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FF2C433D6;
        Wed, 26 Oct 2022 02:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666749822;
        bh=pptR85L0lYdLNV6IA0whrHErejm2dpCZHkStQ4ynRjE=;
        h=Date:To:From:Subject:From;
        b=xohL6P5+fGwFFcfA8oLtLhsu8WusJjj6UqJW08TN/tSbT4x6LP79walG/7lASGSPm
         sozS7IZ/X4TB81qszNmWMez+jYpv2PWlRaFt3jhXSmS/XbHguxwuBX/IfFWtJ2hBeb
         ji9cenVal2fekbpSXv5iU5DxdVvmIb8NTob/uMMU=
Date:   Tue, 25 Oct 2022 19:03:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        akpm@linux-foundation.org, aarcange@redhat.com,
        ira.weiny@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20221026020342.18FF2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page-v2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
mm-userfaultfd-replace-kmap-kmap_atomic-with-kmap_local_page-v2.patch


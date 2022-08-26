Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E9B9ECAAA2
	for <mm-commits@archiver.kernel.org>; Fri, 26 Aug 2022 01:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243812AbiHZBF6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Aug 2022 21:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243808AbiHZBF5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2022 21:05:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B780BC926B
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 18:05:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2E841CE2DE4
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 01:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90149C433D6;
        Fri, 26 Aug 2022 01:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661475953;
        bh=Ozk/05XRRyj/cw6IFTXpiQcaO2BrR9+ufuazDwytGwg=;
        h=Date:To:From:Subject:From;
        b=fPDmPJLESLhlOS0OT6Q+9HiqKu/QqBO8ekb3QI0wFlPIy2L+UjuUfqSEBayzYVEvZ
         pWqmh4mHLKGrCVVg0iDsX4bh9G2E251ndiCXbvjC2I0TSRaPyTpBsukSTh9RVi+dWC
         2IdQ8rH7hPvJnE0UztyMTaQb6O6mh0gWskse/FB8=
Date:   Thu, 25 Aug 2022 18:05:52 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-use-maple-tree-navigation-instead-of-vma-linked-list-fix.patch added to mm-unstable branch
Message-Id: <20220826010553.90149C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect: fix maple tree start address in do_mprotect_pkey()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-use-maple-tree-navigation-instead-of-vma-linked-list-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-use-maple-tree-navigation-instead-of-vma-linked-list-fix.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mprotect: fix maple tree start address in do_mprotect_pkey()
Date: Thu, 25 Aug 2022 20:30:24 +0000

Use the untagged_addr() instead of the address passed into the function.

Link: https://lkml.kernel.org/r/20220825202939.3041660-1-Liam.Howlett@oracle.com
Fixes: 3338b715d25d ("mm/mprotect: use maple tree navigation instead of vma linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mprotect.c~mm-mprotect-use-maple-tree-navigation-instead-of-vma-linked-list-fix
+++ a/mm/mprotect.c
@@ -676,7 +676,7 @@ static int do_mprotect_pkey(unsigned lon
 	const bool rier = (current->personality & READ_IMPLIES_EXEC) &&
 				(prot & PROT_READ);
 	struct mmu_gather tlb;
-	MA_STATE(mas, &current->mm->mm_mt, start, start);
+	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 
 	start = untagged_addr(start);
 
@@ -708,6 +708,7 @@ static int do_mprotect_pkey(unsigned lon
 	if ((pkey != -1) && !mm_pkey_is_allocated(current->mm, pkey))
 		goto out;
 
+	mas_set(&mas, start);
 	vma = mas_find(&mas, ULONG_MAX);
 	error = -ENOMEM;
 	if (!vma)
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

binder_alloc-add-missing-mmap_lock-calls-when-using-the-vma.patch
maple-tree-add-new-data-structure-fix.patch
mm-mprotect-use-maple-tree-navigation-instead-of-vma-linked-list-fix.patch
mm-vmscan-use-vma-iterator-instead-of-vm_next.patch


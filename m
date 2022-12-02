Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA35C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 20:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiLBU4K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 15:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbiLBU4K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 15:56:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EEDDB624
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 12:56:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 171A0622EF
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 20:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E732C433D6;
        Fri,  2 Dec 2022 20:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670014568;
        bh=6b7S1yq9ZDKAST8i52dNNNVhO2jj6OsORi8zwZZLrM4=;
        h=Date:To:From:Subject:From;
        b=cDQqlo0qCZBV8s0TWzgctOPbnWvSxzWWRwfBNzaq+QdXcJ8UzrpCwoUAs1Y8W1p+S
         bhBLlEHU1onK5Y3WLcPOzkk+toiinU+12S+oYNrbVE2vyezMx1esAKhBImoZn+aJlu
         s/AbMDHs61wOBuCAp7TDCaGzwI5xkTCK9ql7eCQs=
Date:   Fri, 02 Dec 2022 12:56:07 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-properly-unaccount-memory-on-mas_preallocate-failure.patch added to mm-unstable branch
Message-Id: <20221202205608.5E732C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: properly unaccount memory on mas_preallocate() failure
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-properly-unaccount-memory-on-mas_preallocate-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-properly-unaccount-memory-on-mas_preallocate-failure.patch

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
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/mmap: properly unaccount memory on mas_preallocate() failure
Date: Fri, 2 Dec 2022 15:53:39 +1100

security_vm_enough_memory_mm() accounts memory via a call to
vm_acct_memory().  Therefore any subsequent failures should unaccount for
this memory prior to returning the error.

Link: https://lkml.kernel.org/r/20221202045339.2999017-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Fixes: 28c5609fb236 ("mm/mmap: preallocate maple nodes for brk vma expansion")
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmap-properly-unaccount-memory-on-mas_preallocate-failure
+++ a/mm/mmap.c
@@ -2950,7 +2950,7 @@ static int do_brk_flags(struct ma_state
 	    ((vma->vm_flags & ~VM_SOFTDIRTY) == flags)) {
 		mas_set_range(mas, vma->vm_start, addr + len - 1);
 		if (mas_preallocate(mas, vma, GFP_KERNEL))
-			return -ENOMEM;
+			goto unacct_fail;
 
 		vma_adjust_trans_huge(vma, vma->vm_start, addr + len, 0);
 		if (vma->anon_vma) {
@@ -2972,7 +2972,7 @@ static int do_brk_flags(struct ma_state
 	/* create a vma struct for an anonymous mapping */
 	vma = vm_area_alloc(mm);
 	if (!vma)
-		goto vma_alloc_fail;
+		goto unacct_fail;
 
 	vma_set_anonymous(vma);
 	vma->vm_start = addr;
@@ -2997,7 +2997,7 @@ out:
 
 mas_store_fail:
 	vm_area_free(vma);
-vma_alloc_fail:
+unacct_fail:
 	vm_unacct_memory(len >> PAGE_SHIFT);
 	return -ENOMEM;
 }
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-mmap-properly-unaccount-memory-on-mas_preallocate-failure.patch


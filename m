Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09947C001B2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbiLLCRP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiLLCPa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:15:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C961A19C
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3729260EC6
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890B0C433EF;
        Mon, 12 Dec 2022 02:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811289;
        bh=xX4DGCDL3AIvQnjBKbM/rFMFkHNphaYzUwHOjssZs+A=;
        h=Date:To:From:Subject:From;
        b=Oe9/r7uusuUan/hz0pbHOcJWRI/RRoNl3SKZcQ72b961+KTEzc0AaUmUHwyERNaG3
         iVGgnbJ3QVOJA6NRSUvD6bw2bPyMLq+Oq+ehWt8ej8Rjvln/ReFb0IEfZEA4Q5D7k2
         sdcA5s+ChyByr3+bmNNXGG8LVR6zg4Tsyuz43xf8=
Date:   Sun, 11 Dec 2022 18:14:48 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-properly-unaccount-memory-on-mas_preallocate-failure.patch removed from -mm tree
Message-Id: <20221212021449.890B0C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: properly unaccount memory on mas_preallocate() failure
has been removed from the -mm tree.  Its filename was
     mm-mmap-properly-unaccount-memory-on-mas_preallocate-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/mmap: properly unaccount memory on mas_preallocate() failure
Date: Fri, 2 Dec 2022 15:53:39 +1100

security_vm_enough_memory_mm() accounts memory via a call to
vm_acct_memory().  Therefore any subsequent failures should unaccount for
this memory prior to returning the error.

Link: https://lkml.kernel.org/r/20221202045339.2999017-1-apopple@nvidia.com
Fixes: 28c5609fb236 ("mm/mmap: preallocate maple nodes for brk vma expansion")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmap-properly-unaccount-memory-on-mas_preallocate-failure
+++ a/mm/mmap.c
@@ -2953,7 +2953,7 @@ static int do_brk_flags(struct ma_state
 				addr >> PAGE_SHIFT, NULL_VM_UFFD_CTX, NULL)) {
 		mas_set_range(mas, vma->vm_start, addr + len - 1);
 		if (mas_preallocate(mas, vma, GFP_KERNEL))
-			return -ENOMEM;
+			goto unacct_fail;
 
 		vma_adjust_trans_huge(vma, vma->vm_start, addr + len, 0);
 		if (vma->anon_vma) {
@@ -2975,7 +2975,7 @@ static int do_brk_flags(struct ma_state
 	/* create a vma struct for an anonymous mapping */
 	vma = vm_area_alloc(mm);
 	if (!vma)
-		goto vma_alloc_fail;
+		goto unacct_fail;
 
 	vma_set_anonymous(vma);
 	vma->vm_start = addr;
@@ -3000,7 +3000,7 @@ out:
 
 mas_store_fail:
 	vm_area_free(vma);
-vma_alloc_fail:
+unacct_fail:
 	vm_unacct_memory(len >> PAGE_SHIFT);
 	return -ENOMEM;
 }
_

Patches currently in -mm which might be from apopple@nvidia.com are



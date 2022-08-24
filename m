Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE963C00140
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 17:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239407AbiHXR6U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 13:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239804AbiHXR6S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 13:58:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C594D807
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 10:58:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6497B61703
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 17:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E65C433D6;
        Wed, 24 Aug 2022 17:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661363896;
        bh=+XjlTL4Hf/dndGxwP1b/+HIVKM5c5NJw0EgDAzD157s=;
        h=Date:To:From:Subject:From;
        b=GqKQGve5X4Y2Gkxbrf/dDzqRpSqS0jedwnViYGKia9tYCe5o5amKJJTTgUxLJOQx3
         x8Z3EKyDfCPC1KeGiIPkR/ow57e2tjiVnDkChYsIb8stfey4Aabz8qh7zD6618dN3P
         R+p9hiJ2zrGtw6QkZU4AXvKoZ/tEE1kV/CAqu1rI=
Date:   Wed, 24 Aug 2022 10:58:16 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nommu-remove-uses-of-vma-linked-list-fix.patch added to mm-unstable branch
Message-Id: <20220824175816.B7E65C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu: fix error handling in split_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     nommu-remove-uses-of-vma-linked-list-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nommu-remove-uses-of-vma-linked-list-fix.patch

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
From: Yang Yingliang <yangyingliang@huawei.com>
Subject: mm/nommu: fix error handling in split_vma()
Date: Wed, 24 Aug 2022 12:24:24 +0800

The memory allocated before calling mas_preallocate() is leaked if it
fails.  'mas' won't be modify until calling mas_preallocate(), so move it
up and add error label for free the memory.

Link: https://lkml.kernel.org/r/20220824042424.2031508-1-yangyingliang@huawei.com
Fixes: 8aff7dbeaeb1 ("nommu: remove uses of VMA linked list")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/nommu.c~nommu-remove-uses-of-vma-linked-list-fix
+++ a/mm/nommu.c
@@ -1361,9 +1361,13 @@ int split_vma(struct mm_struct *mm, stru
 		return -ENOMEM;
 
 	new = vm_area_dup(vma);
-	if (!new) {
-		kmem_cache_free(vm_region_jar, region);
-		return -ENOMEM;
+	if (!new)
+		goto err_vma_dup;
+
+	if (mas_preallocate(&mas, vma, GFP_KERNEL)) {
+		pr_warn("Allocation of vma tree for process %d failed\n",
+			current->pid);
+		goto err_mas_preallocate;
 	}
 
 	/* most fields are the same, copy all, and then fixup */
@@ -1394,11 +1398,6 @@ int split_vma(struct mm_struct *mm, stru
 	add_nommu_region(vma->vm_region);
 	add_nommu_region(new->vm_region);
 	up_write(&nommu_region_sem);
-	if (mas_preallocate(&mas, vma, GFP_KERNEL)) {
-		pr_warn("Allocation of vma tree for process %d failed\n",
-		       current->pid);
-		return -ENOMEM;
-	}
 
 	setup_vma_to_mm(vma, mm);
 	setup_vma_to_mm(new, mm);
@@ -1406,6 +1405,12 @@ int split_vma(struct mm_struct *mm, stru
 	mas_store(&mas, vma);
 	vma_mas_store(new, &mas);
 	return 0;
+
+err_mas_preallocate:
+	vm_area_free(new);
+err_vma_dup:
+	kmem_cache_free(vm_region_jar, region);
+	return -ENOMEM;
 }
 
 /*
_

Patches currently in -mm which might be from yangyingliang@huawei.com are

nommu-remove-uses-of-vma-linked-list-fix.patch


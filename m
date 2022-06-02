Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB04DC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Jun 2022 18:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbiFBSQY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Jun 2022 14:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbiFBSQY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2022 14:16:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3494C13D0C
        for <mm-commits@vger.kernel.org>; Thu,  2 Jun 2022 11:16:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F4FBB82051
        for <mm-commits@vger.kernel.org>; Thu,  2 Jun 2022 18:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14896C34114;
        Thu,  2 Jun 2022 18:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654193778;
        bh=enYn2ekoTsyH9mY+wgXs6qXZXgFH7gRqpKiaD6kSqVw=;
        h=Date:To:From:Subject:From;
        b=mDDjGleTArIHGEyIdV7opOL4kfRuvkqaUYZyZ4rYbkStVa995vtkfq+PzfSPs/oSA
         3++pehGgSe5FkQMsuCpZjb3cvoC7+SVplbKZA3sVQZzpOv8hJknpJWxDNfWgzV2jOM
         M+srvGPlHoYPF+N725zLS+dBhgepQFwpHB9NdTL8=
Date:   Thu, 02 Jun 2022 11:16:17 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nommu-remove-uses-of-vma-linked-list-fix-fix.patch added to mm-unstable branch
Message-Id: <20220602181618.14896C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu: fix compile warning in do_mmap()
has been added to the -mm mm-unstable branch.  Its filename is
     nommu-remove-uses-of-vma-linked-list-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nommu-remove-uses-of-vma-linked-list-fix-fix.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/nommu: fix compile warning in do_mmap()
Date: Thu, 2 Jun 2022 09:44:38 -0400

vma is passed in to preallocate nodes since storing NULL could result in
less nodes needed than an actual value being stored.  Fix this by moving
the preallocation call to below the vma allocation & be sure to undo
other allocations in the failure path.

Also fix the type error in the short-lived linked list modification.

Link: https://lkml.kernel.org/r/20220602141145.i44sjd3mxvqaofvt@revolver
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/nommu.c~nommu-remove-uses-of-vma-linked-list-fix-fix
+++ a/mm/nommu.c
@@ -590,8 +590,8 @@ static void mas_add_vma_to_mm(struct ma_
 
 	setup_vma_to_mm(vma, mm);
 
-	prev = mas_prev(&mas, 0);
-	mas_reset(&mas);
+	prev = mas_prev(mas, 0);
+	mas_reset(mas);
 	/* add the VMA to the tree */
 	vma_mas_store(vma, mas);
 	__vma_link_list(mm, vma, prev);
@@ -1078,9 +1078,6 @@ unsigned long do_mmap(struct file *file,
 	vm_flags = determine_vm_flags(file, prot, flags, capabilities);
 
 
-	if (mas_preallocate(&mas, vma, GFP_KERNEL))
-		goto error_maple_preallocate;
-
 	/* we're going to need to record the mapping */
 	region = kmem_cache_zalloc(vm_region_jar, GFP_KERNEL);
 	if (!region)
@@ -1090,6 +1087,9 @@ unsigned long do_mmap(struct file *file,
 	if (!vma)
 		goto error_getting_vma;
 
+	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+		goto error_maple_preallocate;
+
 	region->vm_usage = 1;
 	region->vm_flags = vm_flags;
 	region->vm_pgoff = pgoff;
@@ -1262,7 +1262,6 @@ sharing_violation:
 	goto error;
 
 error_getting_vma:
-	mas_destroy(&mas);
 	kmem_cache_free(vm_region_jar, region);
 	pr_warn("Allocation of vma for %lu byte allocation from process %d failed\n",
 			len, current->pid);
@@ -1270,13 +1269,14 @@ error_getting_vma:
 	return -ENOMEM;
 
 error_getting_region:
-	mas_destroy(&mas);
 	pr_warn("Allocation of vm region for %lu byte allocation from process %d failed\n",
 			len, current->pid);
 	show_free_areas(0, NULL);
 	return -ENOMEM;
 
 error_maple_preallocate:
+	kmem_cache_free(vm_region_jar, region);
+	vm_area_free(vma);
 	pr_warn("Allocation of vma tree for process %d failed\n", current->pid);
 	show_free_areas(0, NULL);
 	return -ENOMEM;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

nommu-remove-uses-of-vma-linked-list-fix.patch
nommu-remove-uses-of-vma-linked-list-fix-fix.patch


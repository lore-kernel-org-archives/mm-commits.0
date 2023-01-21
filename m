Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA93C05027
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjAUBHN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjAUBG6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:06:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233D772C3E
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:06:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADEEA61E1F
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC58C433EF;
        Sat, 21 Jan 2023 01:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263216;
        bh=yCXoIfBU83/QlkHWMYWske/DsSRzlJSHfbdpGpgzLO4=;
        h=Date:To:From:Subject:From;
        b=T+ArvvXMI5vNLrWquRXAc6tRV/3y4vylIAcnfFqjrZhTzB2oNggvFgVXGkm/UGaZl
         rbPYt0xyvvKu0KT8MZBIZe/rzcj0LnyPwLa7m+Y8DvMMgAFS1Vmfg7VXEqjIIFDWbS
         9QzKase6iBezVA0sZGQR48HB6qAsnyoCm4VqfXmE=
Date:   Fri, 20 Jan 2023 17:06:55 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, lkp@intel.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store.patch added to mm-unstable branch
Message-Id: <20230121010656.0DC58C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr-test.h: stop using vma_mas_store() for maple tree store
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store.patch

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
Subject: mm/damon/vaddr-test.h: stop using vma_mas_store() for maple tree store
Date: Fri, 20 Jan 2023 11:26:31 -0500

Prepare for the removal of the vma_mas_store() function by open coding the
maple tree store in this test code.  Set the range of the maple state and
call the store function directly.

Link: https://lkml.kernel.org/r/20230120162650.984577-31-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/vaddr-test.h~mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store
+++ a/mm/damon/vaddr-test.h
@@ -14,19 +14,26 @@
 
 #include <kunit/test.h>
 
-static void __link_vmas(struct maple_tree *mt, struct vm_area_struct *vmas,
+static int __link_vmas(struct maple_tree *mt, struct vm_area_struct *vmas,
 			ssize_t nr_vmas)
 {
-	int i;
+	int i, ret = -ENOMEM;
 	MA_STATE(mas, mt, 0, 0);
 
 	if (!nr_vmas)
-		return;
+		return 0;
 
 	mas_lock(&mas);
-	for (i = 0; i < nr_vmas; i++)
-		vma_mas_store(&vmas[i], &mas);
+	for (i = 0; i < nr_vmas; i++) {
+		mas_set_range(&mas, vmas[i].vm_start, vmas[i].vm_end - 1);
+		if (mas_store_gfp(&mas, &vmas[i], GFP_KERNEL))
+			goto failed;
+	}
+
+	ret = 0;
+failed:
 	mas_unlock(&mas);
+	return ret;
 }
 
 /*
@@ -71,7 +78,8 @@ static void damon_test_three_regions_in_
 	};
 
 	mt_init_flags(&mm.mm_mt, MM_MT_FLAGS);
-	__link_vmas(&mm.mm_mt, vmas, ARRAY_SIZE(vmas));
+	if (__link_vmas(&mm.mm_mt, vmas, ARRAY_SIZE(vmas)))
+		kunit_skip(test, "Failed to create VMA tree");
 
 	__damon_va_three_regions(&mm, regions);
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch
maple_tree-fix-mas_prev-and-mas_find-state-handling.patch
nommu-pass-through-vma-iterator-to-shrink_vma.patch
mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store.patch
mm-mremap-convert-vma_adjust-to-vma_expand.patch


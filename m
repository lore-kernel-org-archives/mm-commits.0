Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DACFC19F29
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239548AbiG3BIU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbiG3BIQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C243B979
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE6B6B82A26
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76302C433B5;
        Sat, 30 Jul 2022 01:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143293;
        bh=m7Xxe2UF0ZlzIVR72yT8jNiYgICKEdOTf9CwmsiaoiQ=;
        h=Date:To:From:Subject:From;
        b=e2Xatk3sRCuRzVwOp8rBtu5pWhj8nsOrSG4qv1d5FFRv7SE6iN6QZRnuj0Eq9KxWI
         79C9dj6ZF8vuq4IasfW+Had5qaW53rLG5KVvy4Gyx1jx6sV7eaw9+eY1iBwao65voT
         dS/ci/Dxh07SawI+/uw9Cs+z/R+e5rJfjHEEgR+o=
Date:   Fri, 29 Jul 2022 18:08:12 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch removed from -mm tree
Message-Id: <20220730010813.76302C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap.c: fix missing call to vm_unacct_memory in mmap_region
has been removed from the -mm tree.  Its filename was
     mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mmap.c: fix missing call to vm_unacct_memory in mmap_region
Date: Sat, 18 Jun 2022 16:20:27 +0800

Since the beginning, charged is set to 0 to avoid calling vm_unacct_memory
twice because vm_unacct_memory will be called by above unmap_region.  But
since commit 4f74d2c8e827 ("vm: remove 'nr_accounted' calculations from
the unmap_vmas() interfaces"), unmap_region doesn't call vm_unacct_memory
anymore.  So charged shouldn't be set to 0 now otherwise the calling to
paired vm_unacct_memory will be missed and leads to imbalanced account.

Link: https://lkml.kernel.org/r/20220618082027.43391-1-linmiaohe@huawei.com
Fixes: 4f74d2c8e827 ("vm: remove 'nr_accounted' calculations from the unmap_vmas() interfaces")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/mmap.c~mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region
+++ a/mm/mmap.c
@@ -1847,7 +1847,6 @@ unmap_and_free_vma:
 
 	/* Undo any partial mapping done by a device driver. */
 	unmap_region(mm, vma, prev, vma->vm_start, vma->vm_end);
-	charged = 0;
 	if (vm_flags & VM_SHARED)
 		mapping_unmap_writable(file->f_mapping);
 free_vma:
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch


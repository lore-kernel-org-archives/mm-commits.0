Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E11CCCA480
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiGRAWD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiGRAUp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E40E263D
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D839B80EEF
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C361C341C0;
        Mon, 18 Jul 2022 00:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103527;
        bh=04VgPt4ovXcqR1JLTqGsxNPKf9Zm26fa3cIEjA9g/k0=;
        h=Date:To:From:Subject:From;
        b=ZuATnQWlT0/OvdwWzRi9hcfm+96SCHLiPGeu+UQoXPkfKWc11qGo+jWE/v+Y/dApW
         txWXB44I5QqpX9yIHkXv8a79mNPyjRb5FnLzKsIPuJlPIWnVsPRIB5LKmB2bxvmoo1
         mm6WEWyGWJI6MwdJCdotFdZ6YyILmXxsH8oT8FVY=
Date:   Sun, 17 Jul 2022 17:18:46 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-fix-obsolete-comment-of-find_extend_vma.patch removed from -mm tree
Message-Id: <20220718001847.0C361C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: fix obsolete comment of find_extend_vma
has been removed from the -mm tree.  Its filename was
     mm-mmap-fix-obsolete-comment-of-find_extend_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mmap: fix obsolete comment of find_extend_vma
Date: Sat, 9 Jul 2022 17:25:27 +0800

mmget_still_valid() has already been removed via commit 4d45e75a9955 ("mm:
remove the now-unnecessary mmget_still_valid() hack").  Update the
corresponding comment.

Link: https://lkml.kernel.org/r/20220709092527.47778-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-fix-obsolete-comment-of-find_extend_vma
+++ a/mm/mmap.c
@@ -2541,7 +2541,6 @@ find_extend_vma(struct mm_struct *mm, un
 	vma = find_vma_prev(mm, addr, &prev);
 	if (vma && (vma->vm_start <= addr))
 		return vma;
-	/* don't alter vm_end if the coredump is running */
 	if (!prev || expand_stack(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch


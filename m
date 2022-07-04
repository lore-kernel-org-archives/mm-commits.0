Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6529C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbiGDBNL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiGDBMG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:12:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D417644A
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:11:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA685B80BD1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AB2C341C7;
        Mon,  4 Jul 2022 01:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897060;
        bh=YzgI/w3aGpHnUt2kJlT+gR29x3gKWk0OobT8IbJLUNA=;
        h=Date:To:From:Subject:From;
        b=fd3Fa/CIdlWwlK2rXq1qix9WQw0YGLzKyRktOzFIsTbAfD4uw7/qTB4ZEtsYjM1s2
         Dm8HVfFN/KBCtjXzn3CULIxrg+QYyP/9p3WEIHjLpvBJoB0kO3pSqEaanZbEIPk86v
         I0133mFkOFJEswIG1Ip4gYbt+MdMSm9CJWImTKxY=
Date:   Sun, 03 Jul 2022 18:11:00 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, surenb@google.com,
        shy828301@gmail.com, peterx@redhat.com, neilb@suse.de,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-minor-cleanup-for-collapse_file.patch removed from -mm tree
Message-Id: <20220704011100.A2AB2C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: minor cleanup for collapse_file
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-minor-cleanup-for-collapse_file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/khugepaged: minor cleanup for collapse_file
Date: Sat, 25 Jun 2022 17:28:13 +0800

nr_none is always 0 for non-shmem case because the page can be read from
the backend store.  So when nr_none !  = 0, it must be in is_shmem case. 
Also only adjust the nrpages and uncharge shmem when nr_none != 0 to save
cpu cycles.

Link: https://lkml.kernel.org/r/20220625092816.4856-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-minor-cleanup-for-collapse_file
+++ a/mm/khugepaged.c
@@ -1881,8 +1881,8 @@ out_unlock:
 
 	if (nr_none) {
 		__mod_lruvec_page_state(new_page, NR_FILE_PAGES, nr_none);
-		if (is_shmem)
-			__mod_lruvec_page_state(new_page, NR_SHMEM, nr_none);
+		/* nr_none is always 0 for non-shmem. */
+		__mod_lruvec_page_state(new_page, NR_SHMEM, nr_none);
 	}
 
 	/* Join all the small entries into a single multi-index entry */
@@ -1946,10 +1946,10 @@ xa_unlocked:
 
 		/* Something went wrong: roll back page cache changes */
 		xas_lock_irq(&xas);
-		mapping->nrpages -= nr_none;
-
-		if (is_shmem)
+		if (nr_none) {
+			mapping->nrpages -= nr_none;
 			shmem_uncharge(mapping->host, nr_none);
+		}
 
 		xas_set(&xas, start);
 		xas_for_each(&xas, page, end - 1) {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch


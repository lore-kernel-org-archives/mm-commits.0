Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5787C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiGRAWC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiGRAUg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3170113E
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D7B2B80EE7
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AFDC341CA;
        Mon, 18 Jul 2022 00:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103526;
        bh=1sFwvtXdgYUrNFU/fY99tigKUwMyASN7vfNic7UD4Jk=;
        h=Date:To:From:Subject:From;
        b=W8e72uRH7yQ2rnd13zk5MXxbP7U+8An03NintBxEQNpuhOED+SmbL/tQFd3nqdupe
         eubs4V4KWlXZyDm7bRat2G+/wIvHmXOG0W77B4c1gLJPA2MOh4HXAxzb+e3aMGRdiu
         fDJtmeeDHfCBZkV5oaiHxyJPdHTJypoQIqSSJwxo=
Date:   Sun, 17 Jul 2022 17:18:45 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_vma_mappedc-use-helper-function-huge_pte_lock.patch removed from -mm tree
Message-Id: <20220718001846.15AFDC341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_vma_mapped.c: use helper function huge_pte_lock
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mappedc-use-helper-function-huge_pte_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_vma_mapped.c: use helper function huge_pte_lock
Date: Sat, 9 Jul 2022 17:24:40 +0800

Use helper function huge_pte_lock() to lock the huge pte to simplify the
code a bit.  No functional change intended.

Link: https://lkml.kernel.org/r/20220709092440.43018-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mappedc-use-helper-function-huge_pte_lock
+++ a/mm/page_vma_mapped.c
@@ -174,8 +174,7 @@ bool page_vma_mapped_walk(struct page_vm
 		if (!pvmw->pte)
 			return false;
 
-		pvmw->ptl = huge_pte_lockptr(hstate, mm, pvmw->pte);
-		spin_lock(pvmw->ptl);
+		pvmw->ptl = huge_pte_lock(hstate, mm, pvmw->pte);
 		if (!check_pte(pvmw))
 			return not_found(pvmw);
 		return true;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3238C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354171AbiE0QfX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347485AbiE0QfQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:35:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3D83B2AE
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:35:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E420B82562
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393C4C385A9;
        Fri, 27 May 2022 16:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669312;
        bh=iIGi6RsHd0Ty8yeI72a7GJX1+YA+OuM4csWqOBumW9M=;
        h=Date:To:From:Subject:From;
        b=x9REY4iXD8C/EV9ysU1H/Wsk8nYOeXN3ON7kRIk5CmvmiuychMwochs/u616v2ZUP
         1dHjNdfeYUsZ1o+6kQrOMSUuaW+k6M5XaoxN6gxbKnNiTRKcI8jqgK4u9gnpZ18PCA
         cJmjY2tdw1DIIxYab5XRR+UGLxnsF3iZYVqSm3PU=
Date:   Fri, 27 May 2022 09:35:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, rcampbell@nvidia.com, peterx@redhat.com,
        neilb@suse.de, naoya.horiguchi@nec.com, hughd@google.com,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-fix-infinite-loop-when-swap-in-shmem-error-at-swapoff-time.patch removed from -mm tree
Message-Id: <20220527163512.393C4C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: fix infinite loop when swap in shmem error at swapoff time
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-infinite-loop-when-swap-in-shmem-error-at-swapoff-time.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/shmem: fix infinite loop when swap in shmem error at swapoff time
Date: Thu, 19 May 2022 20:50:29 +0800

When swap in shmem error at swapoff time, there would be a infinite loop
in the while loop in shmem_unuse_inode().  It's because swapin error is
deliberately ignored now and thus info->swapped will never reach 0.  So we
can't escape the loop in shmem_unuse().

In order to fix the issue, swapin_error entry is stored in the mapping
when swapin error occurs.  So the swapcache page can be freed and the user
won't end up with a permanently mounted swap because a sector is bad.  If
the page is accessed later, the user process will be killed so that
corrupted data is never consumed.  On the other hand, if the page is never
accessed, the user won't even notice it.

Link: https://lkml.kernel.org/r/20220519125030.21486-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reported-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/mm/shmem.c~mm-shmem-fix-infinite-loop-when-swap-in-shmem-error-at-swapoff-time
+++ a/mm/shmem.c
@@ -1174,6 +1174,10 @@ static int shmem_find_swap_entries(struc
 			continue;
 
 		entry = radix_to_swp_entry(folio);
+		/*
+		 * swapin error entries can be found in the mapping. But they're
+		 * deliberately ignored here as we've done everything we can do.
+		 */
 		if (swp_type(entry) != type)
 			continue;
 
@@ -1671,6 +1675,36 @@ static int shmem_replace_page(struct pag
 	return error;
 }
 
+static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
+					 struct folio *folio, swp_entry_t swap)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	swp_entry_t swapin_error;
+	void *old;
+
+	swapin_error = make_swapin_error_entry(&folio->page);
+	old = xa_cmpxchg_irq(&mapping->i_pages, index,
+			     swp_to_radix_entry(swap),
+			     swp_to_radix_entry(swapin_error), 0);
+	if (old != swp_to_radix_entry(swap))
+		return;
+
+	folio_wait_writeback(folio);
+	delete_from_swap_cache(&folio->page);
+	spin_lock_irq(&info->lock);
+	/*
+	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks won't
+	 * be 0 when inode is released and thus trigger WARN_ON(inode->i_blocks) in
+	 * shmem_evict_inode.
+	 */
+	info->alloced--;
+	info->swapped--;
+	shmem_recalc_inode(inode);
+	spin_unlock_irq(&info->lock);
+	swap_free(swap);
+}
+
 /*
  * Swap in the page pointed to by *pagep.
  * Caller has to make sure that *pagep contains a valid swapped page.
@@ -1694,6 +1728,9 @@ static int shmem_swapin_folio(struct ino
 	swap = radix_to_swp_entry(*foliop);
 	*foliop = NULL;
 
+	if (is_swapin_error_entry(swap))
+		return -EIO;
+
 	/* Look it up and read it in.. */
 	page = lookup_swap_cache(swap, NULL, 0);
 	if (!page) {
@@ -1761,6 +1798,8 @@ static int shmem_swapin_folio(struct ino
 failed:
 	if (!shmem_confirm_swap(mapping, index, swap))
 		error = -EEXIST;
+	if (error == -EIO)
+		shmem_set_folio_swapin_error(inode, index, folio, swap);
 unlock:
 	if (folio) {
 		folio_unlock(folio);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9785BC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243135AbiCYBgn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357369AbiCYBew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3311C12E7
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 957FDB82725
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3703CC340EC;
        Fri, 25 Mar 2022 01:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171971;
        bh=c6XDwU3crGeLQbDB2wB4Kp4qW7BKaqHOqgjMD6FdAu0=;
        h=Date:To:From:Subject:From;
        b=ysyEd2TOUeENEXKzH8xo7C6jrPs29wUEr5FAImMLITwoXGJklju9SEP2pU/u9fcXG
         6qxeshKwUPpAtkq1K0pI4bZegn87cIG2f+CKIMzuUOFF1/5v48YoYf6smMckOYYSpy
         +MBnVRjUzwbhaTW6HQvJpq803Mk5Wor9jkAW9E5Y=
Date:   Thu, 24 Mar 2022 18:32:50 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        kirill.shutemov@linux.intel.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch removed from -mm tree
Message-Id: <20220325013251.3703CC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: ClearPageDoubleMap in first page_add_file_rmap()
has been removed from the -mm tree.  Its filename was
     mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: ClearPageDoubleMap in first page_add_file_rmap()

PageDoubleMap is maintained differently for anon and for shmem+file: the
shmem+file one was never cleared, because a safe place to do so could not
be found; so it would blight future use of the cached hugepage until
evicted.

See https://lore.kernel.org/lkml/1571938066-29031-1-git-send-email-yang.shi@linux.alibaba.com/

But page_add_file_rmap() does provide a safe place to do so (though later
than one might wish): allowing testing to return to an initial state
without a damaging drop_caches.

Link: https://lkml.kernel.org/r/61c5cf99-a962-9a25-597a-53ab1bd8fbc0@google.com
Fixes: 9a73f61bdb8a ("thp, mlock: do not mlock PTE-mapped file huge pages")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/rmap.c~mm-thp-clearpagedoublemap-in-first-page_add_file_rmap
+++ a/mm/rmap.c
@@ -1252,6 +1252,17 @@ void page_add_file_rmap(struct page *pag
 		}
 		if (!atomic_inc_and_test(compound_mapcount_ptr(page)))
 			goto out;
+
+		/*
+		 * It is racy to ClearPageDoubleMap in page_remove_file_rmap();
+		 * but page lock is held by all page_add_file_rmap() compound
+		 * callers, and SetPageDoubleMap below warns if !PageLocked:
+		 * so here is a place that DoubleMap can be safely cleared.
+		 */
+		VM_WARN_ON_ONCE(!PageLocked(page));
+		if (nr == nr_pages && PageDoubleMap(page))
+			ClearPageDoubleMap(page);
+
 		if (PageSwapBacked(page))
 			__mod_lruvec_page_state(page, NR_SHMEM_PMDMAPPED,
 						nr_pages);
_

Patches currently in -mm which might be from hughd@google.com are

mm-delete-__clearpagewaiters.patch
mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch
mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch
mm-warn-on-deleting-redirtied-only-if-accounted.patch
mm-unmap_mapping_range_tree-with-i_mmap_rwsem-shared.patch


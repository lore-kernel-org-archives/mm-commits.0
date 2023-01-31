Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5708BC54EAA
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 00:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjAaAOn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 19:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjAaAOk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 19:14:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545161F5D8
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 16:14:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED5EAB818C2
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 00:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936BBC433D2;
        Tue, 31 Jan 2023 00:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675124074;
        bh=Sl6YL3UPzcWaLiUXZzGTda/rEqZIM8mQ3PSuY4ddsiQ=;
        h=Date:To:From:Subject:From;
        b=LLSWwDZd4EKP5QynwdZBnIhGomwkHpgebEd4uf4r8bKk1quqP0RAuCUC7o/qVKjm2
         V3ZTaAqFkQnjiFsQM/gxiKIRU9M8liicg+S0FNYcYkV/OlapIm4OwCvfhqOLyaIAkm
         vtr92no3EUS/S6NoOolGuxtVktP9NNvKyL34yDFk=
Date:   Mon, 30 Jan 2023 16:14:33 -0800
To:     mm-commits@vger.kernel.org, jane.chu@oracle.com,
        fengwei.yin@intel.com, david@redhat.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch added to mm-unstable branch
Message-Id: <20230131001434.936BBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: convert queue_pages_required() to queue_folio_required()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/mempolicy: convert queue_pages_required() to queue_folio_required()
Date: Mon, 30 Jan 2023 12:18:32 -0800

Replace queue_pages_required() with queue_folio_required(). 
queue_folio_required() does the same as queue_pages_required(), except
takes in a folio instead of a page.

Link: https://lkml.kernel.org/r/20230130201833.27042-6-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: "Yin, Fengwei" <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mempolicy.c~mm-mempolicy-convert-queue_pages_required-to-queue_folio_required
+++ a/mm/mempolicy.c
@@ -427,15 +427,15 @@ struct queue_pages {
 };
 
 /*
- * Check if the page's nid is in qp->nmask.
+ * Check if the folio's nid is in qp->nmask.
  *
  * If MPOL_MF_INVERT is set in qp->flags, check if the nid is
  * in the invert of qp->nmask.
  */
-static inline bool queue_pages_required(struct page *page,
+static inline bool queue_folio_required(struct folio *folio,
 					struct queue_pages *qp)
 {
-	int nid = page_to_nid(page);
+	int nid = folio_nid(folio);
 	unsigned long flags = qp->flags;
 
 	return node_isset(nid, *qp->nmask) == !(flags & MPOL_MF_INVERT);
@@ -469,7 +469,7 @@ static int queue_folios_pmd(pmd_t *pmd,
 		walk->action = ACTION_CONTINUE;
 		goto unlock;
 	}
-	if (!queue_pages_required(&folio->page, qp))
+	if (!queue_folio_required(folio, qp))
 		goto unlock;
 
 	flags = qp->flags;
@@ -530,7 +530,7 @@ static int queue_folios_pte_range(pmd_t
 		 */
 		if (folio_test_reserved(folio))
 			continue;
-		if (!queue_pages_required(&folio->page, qp))
+		if (!queue_folio_required(folio, qp))
 			continue;
 		if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
 			/* MPOL_MF_STRICT must be specified if we get here */
@@ -575,7 +575,7 @@ static int queue_folios_hugetlb(pte_t *p
 	if (!pte_present(entry))
 		goto unlock;
 	folio = pfn_folio(pte_pfn(entry));
-	if (!queue_pages_required(&folio->page, qp))
+	if (!queue_folio_required(folio, qp))
 		goto unlock;
 
 	if (flags == MPOL_MF_STRICT) {
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-khugepaged-introduce-release_pte_folio-to-replace-release_pte_page.patch
mm-khugepaged-convert-release_pte_pages-to-use-folios.patch
pagemap-add-filemap_grab_folio.patch
filemap-added-filemap_get_folios_tag.patch
filemap-convert-__filemap_fdatawait_range-to-use-filemap_get_folios_tag.patch
page-writeback-convert-write_cache_pages-to-use-filemap_get_folios_tag.patch
afs-convert-afs_writepages_region-to-use-filemap_get_folios_tag.patch
btrfs-convert-btree_write_cache_pages-to-use-filemap_get_folio_tag.patch
btrfs-convert-extent_write_cache_pages-to-use-filemap_get_folios_tag.patch
ceph-convert-ceph_writepages_start-to-use-filemap_get_folios_tag.patch
cifs-convert-wdata_alloc_and_fillpages-to-use-filemap_get_folios_tag.patch
ext4-convert-mpage_prepare_extent_to_map-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_fsync_node_pages-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_flush_inline_data-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_sync_node_pages-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_write_cache_pages-to-use-filemap_get_folios_tag.patch
f2fs-convert-last_fsync_dnode-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_sync_meta_pages-to-use-filemap_get_folios_tag.patch
gfs2-convert-gfs2_write_cache_jdata-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_lookup_dirty_node_buffers-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_btree_lookup_dirty_buffers-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_copy_dirty_pages-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_clear_dirty_pages-to-use-filemap_get_folios_tag.patch
filemap-remove-find_get_pages_range_tag.patch
mm-add-folio_estimated_sharers.patch
mm-mempolicy-convert-queue_pages_pmd-to-queue_folios_pmd.patch
mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range.patch
mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch
mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch
mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch


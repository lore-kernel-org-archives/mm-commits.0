Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5257C46467
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 05:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjANFZv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Jan 2023 00:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjANFZn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Jan 2023 00:25:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1C135BF
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 21:25:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05681606A0
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 05:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBD6C433D2;
        Sat, 14 Jan 2023 05:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673673934;
        bh=QCLG6ZZVoXFjCPoETkmN0EC6lTR/yMBS8cfsu+iSapY=;
        h=Date:To:From:Subject:From;
        b=y195LEMwIz9sLHFXybJ8gl03mnCz+XrvFx8nS6Pp1T2dd6OMDFq4BjTkE22UnhmCZ
         dwsCNXzau+VyZCS6+vLZxWOSAJH3O11ZbEqIkgHvNf8fjzRWAwQu9I9miKq12zen0K
         K/68MgImU8pCgRDzNDwhi1HUJ2a/iY4ePwicuL+U=
Date:   Fri, 13 Jan 2023 21:25:33 -0800
To:     mm-commits@vger.kernel.org, chao@kernel.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + f2fs-convert-f2fs_flush_inline_data-to-use-filemap_get_folios_tag.patch added to mm-unstable branch
Message-Id: <20230114052534.5CBD6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: f2fs: convert f2fs_flush_inline_data() to use filemap_get_folios_tag()
has been added to the -mm mm-unstable branch.  Its filename is
     f2fs-convert-f2fs_flush_inline_data-to-use-filemap_get_folios_tag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/f2fs-convert-f2fs_flush_inline_data-to-use-filemap_get_folios_tag.patch

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
Subject: f2fs: convert f2fs_flush_inline_data() to use filemap_get_folios_tag()
Date: Wed, 4 Jan 2023 13:14:37 -0800

Convert function to use a folio_batch instead of pagevec. This is in
preparation for the removal of find_get_pages_tag().

Link: https://lkml.kernel.org/r/20230104211448.4804-13-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Chao Yu <chao@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/f2fs/node.c~f2fs-convert-f2fs_flush_inline_data-to-use-filemap_get_folios_tag
+++ a/fs/f2fs/node.c
@@ -1890,17 +1890,18 @@ static bool flush_dirty_inode(struct pag
 void f2fs_flush_inline_data(struct f2fs_sb_info *sbi)
 {
 	pgoff_t index = 0;
-	struct pagevec pvec;
-	int nr_pages;
+	struct folio_batch fbatch;
+	int nr_folios;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 
-	while ((nr_pages = pagevec_lookup_tag(&pvec,
-			NODE_MAPPING(sbi), &index, PAGECACHE_TAG_DIRTY))) {
+	while ((nr_folios = filemap_get_folios_tag(NODE_MAPPING(sbi), &index,
+					(pgoff_t)-1, PAGECACHE_TAG_DIRTY,
+					&fbatch))) {
 		int i;
 
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		for (i = 0; i < nr_folios; i++) {
+			struct page *page = &fbatch.folios[i]->page;
 
 			if (!IS_DNODE(page))
 				continue;
@@ -1927,7 +1928,7 @@ continue_unlock:
 			}
 			unlock_page(page);
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 }
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-memory-add-vm_normal_folio.patch
madvise-convert-madvise_cold_or_pageout_pte_range-to-use-folios.patch
mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios.patch
mm-swap-convert-deactivate_page-to-folio_deactivate.patch
ext4-convert-mext_page_double_lock-to-mext_folio_double_lock.patch
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


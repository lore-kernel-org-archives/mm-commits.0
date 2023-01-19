Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3CFC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjASBPy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjASBOm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE9C689DE
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AA1561B0E
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B71C433EF;
        Thu, 19 Jan 2023 01:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090849;
        bh=M5LeXIsaPWrjLkWZOMWm0udJK9gsr41gPqugpEvfuYk=;
        h=Date:To:From:Subject:From;
        b=A3YSie0MxFdnxASFJ0DQM+GXCfqgOkZf36SXJRlyHMKaQgLsgJGWvUADPcXP6pBWw
         eSY7ipdMyt2QpyBY3BtdlN/balc6A3l8Y4BLVSdXhp0jwPzJ4a8eLwaGRIh72R5qg+
         8+UdZLFoxtVMSa3qQrWo3/p8eFKI/HLVDgXYEkvs=
Date:   Wed, 18 Jan 2023 17:14:09 -0800
To:     mm-commits@vger.kernel.org, jack@suse.cz, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch removed from -mm tree
Message-Id: <20230119011409.92B71C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: gfs2: replace obvious uses of b_page with b_folio
has been removed from the -mm tree.  Its filename was
     gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: gfs2: replace obvious uses of b_page with b_folio
Date: Thu, 15 Dec 2022 21:43:58 +0000

These places just use b_page to get to the buffer's address_space.

Link: https://lkml.kernel.org/r/20221215214402.3522366-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/glops.c   |    2 +-
 fs/gfs2/log.c     |    2 +-
 fs/gfs2/meta_io.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/gfs2/glops.c~gfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/gfs2/glops.c
@@ -39,7 +39,7 @@ static void gfs2_ail_error(struct gfs2_g
 	       "AIL buffer %p: blocknr %llu state 0x%08lx mapping %p page "
 	       "state 0x%lx\n",
 	       bh, (unsigned long long)bh->b_blocknr, bh->b_state,
-	       bh->b_page->mapping, bh->b_page->flags);
+	       bh->b_folio->mapping, bh->b_folio->flags);
 	fs_err(sdp, "AIL glock %u:%llu mapping %p\n",
 	       gl->gl_name.ln_type, gl->gl_name.ln_number,
 	       gfs2_glock2aspace(gl));
--- a/fs/gfs2/log.c~gfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/gfs2/log.c
@@ -127,7 +127,7 @@ __acquires(&sdp->sd_ail_lock)
 			continue;
 		gl = bd->bd_gl;
 		list_move(&bd->bd_ail_st_list, &tr->tr_ail1_list);
-		mapping = bh->b_page->mapping;
+		mapping = bh->b_folio->mapping;
 		if (!mapping)
 			continue;
 		spin_unlock(&sdp->sd_ail_lock);
--- a/fs/gfs2/meta_io.c~gfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/gfs2/meta_io.c
@@ -334,7 +334,7 @@ int gfs2_meta_wait(struct gfs2_sbd *sdp,
 
 void gfs2_remove_from_journal(struct buffer_head *bh, int meta)
 {
-	struct address_space *mapping = bh->b_page->mapping;
+	struct address_space *mapping = bh->b_folio->mapping;
 	struct gfs2_sbd *sdp = gfs2_mapping2sbd(mapping);
 	struct gfs2_bufdata *bd = bh->b_private;
 	struct gfs2_trans *tr = current->journal_info;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch
mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch
doc-clarify-refcount-section-by-referring-to-folios-pages.patch
mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch
mm-convert-page_remove_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch
mm-add-folio_add_new_anon_rmap.patch
mm-add-folio_add_new_anon_rmap-fix-2.patch
page_alloc-use-folio-fields-directly.patch
mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch
mm-use-entire_mapcount-in-__page_dup_rmap.patch
mm-debug-remove-call-to-head_compound_mapcount.patch
hugetlb-remove-uses-of-folio_mapcount_ptr.patch
mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch
mm-remove-head_compound_mapcount-and-_ptr-functions.patch
mm-reimplement-compound_order.patch
mm-reimplement-compound_nr.patch
mm-reimplement-compound_nr-fix.patch
mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch
mm-convert-is_transparent_hugepage-to-use-a-folio.patch
mm-convert-destroy_large_folio-to-use-folio_dtor.patch
hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch
mm-remove-first-tail-page-members-from-struct-page.patch
doc-correct-struct-folio-kernel-doc.patch
mm-move-page-deferred_list-to-folio-_deferred_list.patch
mm-huge_memory-remove-page_deferred_list.patch
mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch
mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch
shmem-convert-shmem_write_end-to-use-a-folio.patch
mm-add-vma_alloc_zeroed_movable_folio.patch
mm-convert-do_anonymous_page-to-use-a-folio.patch
mm-convert-wp_page_copy-to-use-folios.patch
mm-use-a-folio-in-copy_pte_range.patch
mm-use-a-folio-in-copy_present_pte.patch
mm-fs-convert-inode_attach_wb-to-take-a-folio.patch
mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch
mm-remove-page_evictable.patch
mm-remove-mlock_vma_page.patch
mm-remove-munlock_vma_page.patch
mm-clean-up-mlock_page-munlock_page-references-in-comments.patch
rmap-add-folio-parameter-to-__page_set_anon_rmap.patch
filemap-convert-filemap_map_pmd-to-take-a-folio.patch
filemap-convert-filemap_range_has_page-to-use-a-folio.patch
readahead-convert-readahead_expand-to-use-a-folio.patch


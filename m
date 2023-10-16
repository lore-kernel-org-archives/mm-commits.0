Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2273ECDB465
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbjJPWLA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233574AbjJPWK7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:10:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E789A1
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:10:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367B0C433C7;
        Mon, 16 Oct 2023 22:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697494257;
        bh=E60Viv6nn8zDuZKZoXRos5tSk1DnxI582H1vEYoYe1o=;
        h=Date:To:From:Subject:From;
        b=NAmR7syadkOSLv1KfEkb7joLEpxsgH2eO16HMyTXeHEcF+Zi3S2xKEtU6TQK0J1Mh
         8eA97ZUkIimgGdPn6M+rriCnbjpOYrzkHpE1PMluI1sRi/uHaFeDoLOeEXosHp5AlA
         wThTrWxOqya2++AvIffrWA2m+KQKISM92flfc0S0=
Date:   Mon, 16 Oct 2023 15:10:56 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gfs2-convert-gfs2_getbuf-to-folios.patch added to mm-unstable branch
Message-Id: <20231016221057.367B0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gfs2: convert gfs2_getbuf() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     gfs2-convert-gfs2_getbuf-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gfs2-convert-gfs2_getbuf-to-folios.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: gfs2: convert gfs2_getbuf() to folios
Date: Mon, 16 Oct 2023 21:10:54 +0100

Remove several folio->page->folio conversions.  Also use __GFP_NOFAIL
instead of calling yield() and the new get_nth_bh().

Link: https://lkml.kernel.org/r/20231016201114.1928083-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/meta_io.c |   39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

--- a/fs/gfs2/meta_io.c~gfs2-convert-gfs2_getbuf-to-folios
+++ a/fs/gfs2/meta_io.c
@@ -115,7 +115,7 @@ struct buffer_head *gfs2_getbuf(struct g
 {
 	struct address_space *mapping = gfs2_glock2aspace(gl);
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
-	struct page *page;
+	struct folio *folio;
 	struct buffer_head *bh;
 	unsigned int shift;
 	unsigned long index;
@@ -129,36 +129,31 @@ struct buffer_head *gfs2_getbuf(struct g
 	bufnum = blkno - (index << shift);  /* block buf index within page */
 
 	if (create) {
-		for (;;) {
-			page = grab_cache_page(mapping, index);
-			if (page)
-				break;
-			yield();
-		}
-		if (!page_has_buffers(page))
-			create_empty_buffers(page, sdp->sd_sb.sb_bsize, 0);
+		folio = __filemap_get_folio(mapping, index,
+				FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+				mapping_gfp_mask(mapping) | __GFP_NOFAIL);
+		bh = folio_buffers(folio);
+		if (!bh)
+			bh = folio_create_empty_buffers(folio,
+				sdp->sd_sb.sb_bsize, 0);
 	} else {
-		page = find_get_page_flags(mapping, index,
-						FGP_LOCK|FGP_ACCESSED);
-		if (!page)
+		folio = __filemap_get_folio(mapping, index,
+				FGP_LOCK | FGP_ACCESSED, 0);
+		if (IS_ERR(folio))
 			return NULL;
-		if (!page_has_buffers(page)) {
-			bh = NULL;
-			goto out_unlock;
-		}
+		bh = folio_buffers(folio);
 	}
 
-	/* Locate header for our buffer within our page */
-	for (bh = page_buffers(page); bufnum--; bh = bh->b_this_page)
-		/* Do nothing */;
-	get_bh(bh);
+	if (!bh)
+		goto out_unlock;
 
+	bh = get_nth_bh(bh, bufnum);
 	if (!buffer_mapped(bh))
 		map_bh(bh, sdp->sd_vfs, blkno);
 
 out_unlock:
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 
 	return bh;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch
iomap-hold-state_lock-over-call-to-ifs_set_range_uptodate.patch
iomap-protect-read_bytes_pending-with-the-state_lock.patch
mm-add-folio_end_read.patch
ext4-use-folio_end_read.patch
buffer-use-folio_end_read.patch
iomap-use-folio_end_read.patch
bitops-add-xor_unlock_is_negative_byte.patch
alpha-implement-xor_unlock_is_negative_byte.patch
m68k-implement-xor_unlock_is_negative_byte.patch
mips-implement-xor_unlock_is_negative_byte.patch
powerpc-implement-arch_xor_unlock_is_negative_byte-on-32-bit.patch
riscv-implement-xor_unlock_is_negative_byte.patch
s390-implement-arch_xor_unlock_is_negative_byte.patch
mm-delete-checks-for-xor_unlock_is_negative_byte.patch
mm-add-folio_xor_flags_has_waiters.patch
mm-make-__end_folio_writeback-return-void.patch
mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback.patch
filemap-remove-use-of-wait-bookmarks.patch
sched-remove-wait-bookmarks.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-make-folio_create_empty_buffers-return-a-buffer_head.patch
mpage-convert-map_buffer_to_folio-to-folio_create_empty_buffers.patch
ext4-convert-to-folio_create_empty_buffers.patch
buffer-add-get_nth_bh.patch
gfs2-convert-inode-unstuffing-to-use-a-folio.patch
gfs2-convert-gfs2_getbuf-to-folios.patch
gfs2-convert-gfs2_getjdatabuf-to-use-a-folio.patch
gfs2-convert-gfs2_write_buf_to_page-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_freeze_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_grab_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio.patch
nilfs2-convert-nilfs_mdt_forget_block-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_get_frozen_buffer-to-use-a-folio.patch
nilfs2-remove-nilfs_page_get_nth_block.patch
nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-folio_create_empty_buffers.patch
ntfs-convert-ntfs_read_block-to-use-a-folio.patch
ntfs-convert-ntfs_writepage-to-use-a-folio.patch
ntfs-convert-ntfs_prepare_pages_for_non_resident_write-to-folios.patch
ntfs3-convert-ntfs_zero_range-to-use-a-folio.patch
ocfs2-convert-ocfs2_map_page_blocks-to-use-a-folio.patch
reiserfs-convert-writepage-to-use-a-folio.patch
ufs-add-ufs_get_locked_folio-and-ufs_put_locked_folio.patch
ufs-use-ufs_get_locked_folio-in-ufs_alloc_lastblock.patch
ufs-convert-ufs_change_blocknr-to-use-folios.patch
ufs-remove-ufs_get_locked_page.patch
buffer-remove-folio_create_empty_buffers.patch


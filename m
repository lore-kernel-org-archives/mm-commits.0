Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B6EC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 00:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbiCGAXN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 19:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiCGAXM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 19:23:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429B41E3F7
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 16:22:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0CADB80EE3
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 00:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76352C340EC;
        Mon,  7 Mar 2022 00:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646612535;
        bh=CllsbinAn7Nxlve0VOaijm7LeqWDrE6MvhNyvny3EkA=;
        h=Date:To:From:Subject:From;
        b=b2K1LuQkqBnEgSa9IVowwq/rXeIlNRKLfAxExrROybLsD8H9xUjb1jgoE6L9aaNtN
         +zpOFmBXBg/tGBKnTjHFhpv1qagJTEH/E9f5LHwteAAg+twH2bFGRwNRqcPlsQC6Yd
         3Z2cNsA/yvBD9BkvukOj9aJlQY73GDlfE2vQzTMU=
Date:   Sun, 06 Mar 2022 16:22:14 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, jack@suse.de,
        hch@lst.de, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-warn-on-deleting-redirtied-only-if-accounted.patch added to -mm tree
Message-Id: <20220307002215.76352C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: warn on deleting redirtied only if accounted
has been added to the -mm tree.  Its filename is
     mm-warn-on-deleting-redirtied-only-if-accounted.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-warn-on-deleting-redirtied-only-if-accounted.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-warn-on-deleting-redirtied-only-if-accounted.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: warn on deleting redirtied only if accounted

filemap_unaccount_folio() has a WARN_ON_ONCE(folio_test_dirty(folio)).  It
is good to warn of late dirtying on a persistent filesystem, but late
dirtying on tmpfs can only lose data which is expected to be thrown away;
and it's a pity if that warning comes ONCE on tmpfs, then hides others
which really matter.  Make it conditional on mapping_cap_writeback().

Cleanup: then folio_account_cleaned() no longer needs to check that for
itself, and so no longer needs to know the mapping.

Link: https://lkml.kernel.org/r/b5a1106c-7226-a5c6-ad41-ad4832cae1f@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    3 +--
 mm/filemap.c            |   14 +++++++++-----
 mm/page-writeback.c     |   18 ++++++++----------
 3 files changed, 18 insertions(+), 17 deletions(-)

--- a/include/linux/pagemap.h~mm-warn-on-deleting-redirtied-only-if-accounted
+++ a/include/linux/pagemap.h
@@ -991,8 +991,7 @@ static inline void __set_page_dirty(stru
 {
 	__folio_mark_dirty(page_folio(page), mapping, warn);
 }
-void folio_account_cleaned(struct folio *folio, struct address_space *mapping,
-			  struct bdi_writeback *wb);
+void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
 void __folio_cancel_dirty(struct folio *folio);
 static inline void folio_cancel_dirty(struct folio *folio)
 {
--- a/mm/filemap.c~mm-warn-on-deleting-redirtied-only-if-accounted
+++ a/mm/filemap.c
@@ -193,16 +193,20 @@ static void filemap_unaccount_folio(stru
 	/*
 	 * At this point folio must be either written or cleaned by
 	 * truncate.  Dirty folio here signals a bug and loss of
-	 * unwritten data.
+	 * unwritten data - on ordinary filesystems.
 	 *
-	 * This fixes dirty accounting after removing the folio entirely
+	 * But it's harmless on in-memory filesystems like tmpfs; and can
+	 * occur when a driver which did get_user_pages() sets page dirty
+	 * before putting it, while the inode is being finally evicted.
+	 *
+	 * Below fixes dirty accounting after removing the folio entirely
 	 * but leaves the dirty flag set: it has no effect for truncated
 	 * folio and anyway will be cleared before returning folio to
 	 * buddy allocator.
 	 */
-	if (WARN_ON_ONCE(folio_test_dirty(folio)))
-		folio_account_cleaned(folio, mapping,
-					inode_to_wb(mapping->host));
+	if (WARN_ON_ONCE(folio_test_dirty(folio) &&
+			 mapping_can_writeback(mapping)))
+		folio_account_cleaned(folio, inode_to_wb(mapping->host));
 }
 
 /*
--- a/mm/page-writeback.c~mm-warn-on-deleting-redirtied-only-if-accounted
+++ a/mm/page-writeback.c
@@ -2548,16 +2548,14 @@ static void folio_account_dirtied(struct
  *
  * Caller must hold lock_page_memcg().
  */
-void folio_account_cleaned(struct folio *folio, struct address_space *mapping,
-			  struct bdi_writeback *wb)
+void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
 {
-	if (mapping_can_writeback(mapping)) {
-		long nr = folio_nr_pages(folio);
-		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
-		zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
-		wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
-		task_io_account_cancelled_write(nr * PAGE_SIZE);
-	}
+	long nr = folio_nr_pages(folio);
+
+	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
+	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
+	wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
+	task_io_account_cancelled_write(nr * PAGE_SIZE);
 }
 
 /*
@@ -2768,7 +2766,7 @@ void __folio_cancel_dirty(struct folio *
 		wb = unlocked_inode_to_wb_begin(inode, &cookie);
 
 		if (folio_test_clear_dirty(folio))
-			folio_account_cleaned(folio, mapping, wb);
+			folio_account_cleaned(folio, wb);
 
 		unlocked_inode_to_wb_end(inode, &cookie);
 		folio_memcg_unlock(folio);
_

Patches currently in -mm which might be from hughd@google.com are

mm-fs-delete-pf_swapwrite.patch
tmpfs-support-for-file-creation-time-fix.patch
shmem-mapping_set_exiting-to-help-mapped-resilience.patch
mm-_install_special_mapping-apply-vm_locked_clear_mask.patch
mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch
mm-delete-__clearpagewaiters.patch
mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch
mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch
mm-warn-on-deleting-redirtied-only-if-accounted.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06BB5C38142
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 22:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjAaWjD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 17:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjAaWjB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 17:39:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A66B7DB0
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 14:39:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B27D3B81D79
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 22:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FC7C433D2;
        Tue, 31 Jan 2023 22:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675204737;
        bh=Lr+whohq/RQB7NCXMtLdHUJbauuADi+u4j+rT2Egm1U=;
        h=Date:To:From:Subject:From;
        b=zU6aUduGJCHebOaIlppLxlFEJd5SvgN50VwB1bsDQ3f32vuHsNIF85AXN603LU8CO
         oqOtci3M0oj/DswVgx19g3WDCYZpMqRtcxOTPgAho0YzZOjXh8f7WR5Rh9jvW8TWzC
         MOUK1pty9yFVAtUFuKqIeBOT/ZOU04MqZuFcQ+e8=
Date:   Tue, 31 Jan 2023 14:38:56 -0800
To:     mm-commits@vger.kernel.org, jack@suse.cz, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mpage-convert-__mpage_writepage-to-use-a-folio-more-fully-fix.patch added to mm-unstable branch
Message-Id: <20230131223857.58FC7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mpage-convert-__mpage_writepage-to-use-a-folio-more-fully-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mpage-convert-__mpage_writepage-to-use-a-folio-more-fully-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mpage-convert-__mpage_writepage-to-use-a-folio-more-fully-fix.patch

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
From: Matthew Wilcox <willy@infradead.org>
Subject: mpage-convert-__mpage_writepage-to-use-a-folio-more-fully-fix
Date: Tue, 31 Jan 2023 15:06:16 +0000

fix accidentally-triggering WARN_ON_ONCE

Link: https://lkml.kernel.org/r/Y9kuaBgXf9lKJ8b0@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reported-by: >syzbot+707bba7f823c7b02fa43@syzkaller.appspotmail.com>
Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/mpage.c~mpage-convert-__mpage_writepage-to-use-a-folio-more-fully-fix
+++ a/fs/mpage.c
@@ -554,6 +554,9 @@ static int __mpage_writepage(struct foli
 	first_unmapped = page_block;
 
 page_is_mapped:
+	/* Don't bother writing beyond EOF, truncate will discard the folio */
+	if (folio_pos(folio) >= i_size)
+		goto confused;
 	length = folio_size(folio);
 	if (folio_pos(folio) + length > i_size) {
 		/*
@@ -565,8 +568,6 @@ page_is_mapped:
 		 * written out to the file."
 		 */
 		length = i_size - folio_pos(folio);
-		if (WARN_ON_ONCE(folio_pos(folio) >= i_size))
-			goto confused;
 		folio_zero_segment(folio, length, folio_size(folio));
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are

highmem-round-down-the-address-passed-to-kunmap_flush_on_unmap.patch
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
mm-add-memcpy_from_file_folio.patch
fs-convert-writepage_t-callback-to-pass-a-folio.patch
mpage-convert-__mpage_writepage-to-use-a-folio-more-fully.patch
mpage-convert-__mpage_writepage-to-use-a-folio-more-fully-fix.patch


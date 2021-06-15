Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04DAC48BDF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8849B6137D
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhFOXZ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 19:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230082AbhFOXZZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 19:25:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBF7761350;
        Tue, 15 Jun 2021 23:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623799399;
        bh=qQnMeBukOjYLxv/NsGqQ/WcSXFMjVM7jf5xepbwSsHU=;
        h=Date:From:To:Subject:From;
        b=deq7cGkljcRBRfZqpyQYgGYEB3DjIc2gt/0zJMyagoi9/RoNC8Ezb+FHasGQysU8B
         SJ7Ij4C4ktfRp+MiHk1kwuLjy7FYAd3Higz5S7y7F+UiP9wxYNVJdFrrB6YlKq+aNp
         IoN1KvNhL4fdOLOjt63Q3iVAA82DgdpV8++eUoJs=
Date:   Tue, 15 Jun 2021 16:23:18 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, gregkh@linuxfoundation.org, hch@lst.de,
        jack@suse.cz, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  +
 mm-writeback-use-__set_page_dirty-in-__set_page_dirty_nobuffers.patch added
 to -mm tree
Message-ID: <20210615232318.W3hN7qEom%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/writeback: use __set_page_dirty in __set_page_dirty_nobuffers
has been added to the -mm tree.  Its filename is
     mm-writeback-use-__set_page_dirty-in-__set_page_dirty_nobuffers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-writeback-use-__set_page_dirty-in-__set_page_dirty_nobuffers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-writeback-use-__set_page_dirty-in-__set_page_dirty_nobuffers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/writeback: use __set_page_dirty in __set_page_dirty_nobuffers

This is fundamentally the same code, so just call it instead of
duplicating it.

Link: https://lkml.kernel.org/r/20210615162342.1669332-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/mm/page-writeback.c~mm-writeback-use-__set_page_dirty-in-__set_page_dirty_nobuffers
+++ a/mm/page-writeback.c
@@ -2508,20 +2508,12 @@ int __set_page_dirty_nobuffers(struct pa
 	lock_page_memcg(page);
 	if (!TestSetPageDirty(page)) {
 		struct address_space *mapping = page_mapping(page);
-		unsigned long flags;
 
 		if (!mapping) {
 			unlock_page_memcg(page);
 			return 1;
 		}
-
-		xa_lock_irqsave(&mapping->i_pages, flags);
-		BUG_ON(page_mapping(page) != mapping);
-		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
-		account_page_dirtied(page, mapping);
-		__xa_set_mark(&mapping->i_pages, page_index(page),
-				   PAGECACHE_TAG_DIRTY);
-		xa_unlock_irqrestore(&mapping->i_pages, flags);
+		__set_page_dirty(page, mapping, !PagePrivate(page));
 		unlock_page_memcg(page);
 
 		if (mapping->host) {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-mark-idle-page-tracking-as-broken.patch
writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-3.patch
mm-writeback-move-__set_page_dirty-to-core-mm.patch
mm-writeback-use-__set_page_dirty-in-__set_page_dirty_nobuffers.patch
iomap-use-__set_page_dirty_nobuffers.patch
fs-remove-anon_set_page_dirty.patch
fs-remove-noop_set_page_dirty.patch
mm-move-page-dirtying-prototypes-from-mmh.patch
mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch
mm-optimise-nth_page-for-contiguous-memmap.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page-fix-2.patch
mm-thp-fix-strncpy-warning.patch


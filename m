Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7F9C48BDF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C309861350
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhFOXZa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 19:25:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231261AbhFOXZa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 19:25:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB14A61245;
        Tue, 15 Jun 2021 23:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623799404;
        bh=MyP+zQUBVykQTnY8seH4MTEq7k5EEMOgGXg0wCDXvf8=;
        h=Date:From:To:Subject:From;
        b=D/U6xipplQGvJHM3ogITVihyhmdF2Au1JsWdG8eC/wiOpn4InTXjPYZAe4dVzFAkZ
         X/Y1F9zaYE8rEfDy373CMFO9Tk7hCyGRKc5jkDbwvp8oHl4DcrxN6T5l+/EDHPi4qc
         fmIWcpVYN+QzrxDAykaur7pu1NBQZYyJxz3YRfHk=
Date:   Tue, 15 Jun 2021 16:23:23 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, gregkh@linuxfoundation.org, hch@lst.de,
        jack@suse.cz, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  + fs-remove-anon_set_page_dirty.patch added to -mm tree
Message-ID: <20210615232323.upPx3iYt5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: remove anon_set_page_dirty()
has been added to the -mm tree.  Its filename is
     fs-remove-anon_set_page_dirty.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-remove-anon_set_page_dirty.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-remove-anon_set_page_dirty.patch

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
Subject: fs: remove anon_set_page_dirty()

Use __set_page_dirty_no_writeback() instead.  This will set the dirty bit
on the page, which will be used to avoid calling set_page_dirty() in the
future.  It will have no effect on actually writing the page back, as the
pages are not on any LRU lists.

Link: https://lkml.kernel.org/r/20210615162342.1669332-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/fs/libfs.c~fs-remove-anon_set_page_dirty
+++ a/fs/libfs.c
@@ -1217,19 +1217,10 @@ void kfree_link(void *p)
 }
 EXPORT_SYMBOL(kfree_link);
 
-/*
- * nop .set_page_dirty method so that people can use .page_mkwrite on
- * anon inodes.
- */
-static int anon_set_page_dirty(struct page *page)
-{
-	return 0;
-};
-
 struct inode *alloc_anon_inode(struct super_block *s)
 {
 	static const struct address_space_operations anon_aops = {
-		.set_page_dirty = anon_set_page_dirty,
+		.set_page_dirty = __set_page_dirty_no_writeback,
 	};
 	struct inode *inode = new_inode_pseudo(s);
 
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


Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0973C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F86421655
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881351;
	bh=DkeL4laMwSGyDsDSdBtUaF5R55w6TmpaywKHrZn6Hfs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BotCQLr6Ryt0tVVkJUcXI70MnFFSiRqnO0fF9ieVPIlnrdJjj7mHXxSGOrmOycUMt
	 UdScpTdp8OHUPyrKHIiU7cM2kMBxRBCXkoov5COmhUIhujNrMK9SAwI8/UQTqyxmwk
	 19avLrv2/HhfzLTv2YYThJ91brHpLAoeM6sKPq8Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392715AbgJPUtL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391060AbgJPUtK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:49:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAEF620878;
        Fri, 16 Oct 2020 20:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881350;
        bh=DkeL4laMwSGyDsDSdBtUaF5R55w6TmpaywKHrZn6Hfs=;
        h=Date:From:To:Subject:From;
        b=IM3KzYIQ60GwGn30Boutf2x0lg15MAvHKTN5vetSuMbVfpnx6gNWQKA/3PMQiJrJz
         A1QyU/rBeJMKUqkkN5CTr3JJR3mCnXzS8CHqAFbuVzkwCiqNfNxj5+ucHPxGhXoEYa
         iu265nVGB+CQOO+jEtw59dsuhsUua0R1xWWblipg=
Date:   Fri, 16 Oct 2020 13:49:09 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, ebiggers@google.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-filemap-fold-ra_submit-into-do_sync_mmap_readahead.patch removed from
 -mm tree
Message-ID: <20201016204909.UdJZuKVWZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: fold ra_submit into do_sync_mmap_readahead
has been removed from the -mm tree.  Its filename was
     mm-filemap-fold-ra_submit-into-do_sync_mmap_readahead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: mm/filemap: fold ra_submit into do_sync_mmap_readahead

Fold ra_submit() into its last remaining user and pass the
readahead_control struct to both do_page_cache_ra() and
page_cache_sync_ra().

Link: https://lkml.kernel.org/r/20200903140844.14194-9-willy@infradead.org
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c  |   10 +++++-----
 mm/internal.h |   10 ----------
 2 files changed, 5 insertions(+), 15 deletions(-)

--- a/mm/filemap.c~mm-filemap-fold-ra_submit-into-do_sync_mmap_readahead
+++ a/mm/filemap.c
@@ -2588,8 +2588,8 @@ static struct file *do_sync_mmap_readahe
 	struct file *file = vmf->vma->vm_file;
 	struct file_ra_state *ra = &file->f_ra;
 	struct address_space *mapping = file->f_mapping;
+	DEFINE_READAHEAD(ractl, file, mapping, vmf->pgoff);
 	struct file *fpin = NULL;
-	pgoff_t offset = vmf->pgoff;
 	unsigned int mmap_miss;
 
 	/* If we don't want any read-ahead, don't bother */
@@ -2600,8 +2600,7 @@ static struct file *do_sync_mmap_readahe
 
 	if (vmf->vma->vm_flags & VM_SEQ_READ) {
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-		page_cache_sync_readahead(mapping, ra, file, offset,
-					  ra->ra_pages);
+		page_cache_sync_ra(&ractl, ra, ra->ra_pages);
 		return fpin;
 	}
 
@@ -2621,10 +2620,11 @@ static struct file *do_sync_mmap_readahe
 	 * mmap read-around
 	 */
 	fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-	ra->start = max_t(long, 0, offset - ra->ra_pages / 2);
+	ra->start = max_t(long, 0, vmf->pgoff - ra->ra_pages / 2);
 	ra->size = ra->ra_pages;
 	ra->async_size = ra->ra_pages / 4;
-	ra_submit(ra, mapping, file);
+	ractl._index = ra->start;
+	do_page_cache_ra(&ractl, ra->size, ra->async_size);
 	return fpin;
 }
 
--- a/mm/internal.h~mm-filemap-fold-ra_submit-into-do_sync_mmap_readahead
+++ a/mm/internal.h
@@ -59,16 +59,6 @@ static inline void force_page_cache_read
 	force_page_cache_ra(&ractl, nr_to_read);
 }
 
-/*
- * Submit IO for the read-ahead request in file_ra_state.
- */
-static inline void ra_submit(struct file_ra_state *ra,
-		struct address_space *mapping, struct file *file)
-{
-	DEFINE_READAHEAD(ractl, file, mapping, ra->start);
-	do_page_cache_ra(&ractl, ra->size, ra->async_size);
-}
-
 struct page *find_get_entry(struct address_space *mapping, pgoff_t index);
 struct page *find_lock_entry(struct address_space *mapping, pgoff_t index);
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

mutex-subsystem-synchro-test-module.patch


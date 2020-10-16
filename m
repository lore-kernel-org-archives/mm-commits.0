Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 028C3C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C0532087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817597;
	bh=gL7xdmAxlDw//+zXcYjJ5H9TkI3Jy5FLmhVk7b/p8o8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Uux7pGH009/zuB2Z2XTM5mmzqzafTzDwCklvFjp7jvVEDl7TTUUrnWCbJLgCWvL+p
	 FfkGIoTamgqohnOQ2RtueN75FD5dZoQSiGmdBaYyPjIFu/toHzTbO+eGqoWo9K34W+
	 t3dkbTtGEqsk87+iss8nXyv1u0CHNgPbw4MtEN2E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404480AbgJPDGg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404476AbgJPDGd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:06:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3590620789;
        Fri, 16 Oct 2020 03:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817592;
        bh=gL7xdmAxlDw//+zXcYjJ5H9TkI3Jy5FLmhVk7b/p8o8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=U30XW4ifexL811uoX33eu423vqRxsNSH38EsE32Zx1EzvxKNclHbpgvMueVvdlt1c
         e1pNya/4nYTNsyoo7CTsZ/at8D8PwKAaXtdpD9LqdqOwRq84yvL84XByx8MrL5Ec/8
         uRt+NdQlnJlHXMl1I/a+kz7p41sMFaite9xPikIY=
Date:   Thu, 15 Oct 2020 20:06:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dhowells@redhat.com,
        ebiggers@google.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 039/156] mm/filemap: fold ra_submit into
 do_sync_mmap_readahead
Message-ID: <20201016030631.gVcgnxSKr%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

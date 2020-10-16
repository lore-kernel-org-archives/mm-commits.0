Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 532BDC43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8486208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817598;
	bh=pSLe2EuBluH2YyJnqXQeN/6NP+42ZTBfr9BcxV+VQhE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ErtmCjk37EygARe1STiLqKlnDui3GxcY+AVLPTAb4AVHssjuuAFtgakozgbO+bzWc
	 AFnilB2xriw6aVBouhDBGuD3lAeqOB5QsP7dg2lp+rfG12JCv4cX+Oq7Y70qy4rT30
	 yU96yIHlcArxdfuw4Yqkc90dFz7G0qyMaqcr3Kgw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404476AbgJPDGh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404479AbgJPDGg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:06:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ACC720878;
        Fri, 16 Oct 2020 03:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817595;
        bh=pSLe2EuBluH2YyJnqXQeN/6NP+42ZTBfr9BcxV+VQhE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qOOd3h0aqcxVl5lHy06HiXUrMMqF83J0FcchRoZxnD1xqglHLdwyYn5aFu+eOH0ho
         +0UD2nfpTrbyd7Nl8qEHMpgUTWbIxkimkNsS+BSBbQJcZ0XfDBtD4JrCfjpeg+/k41
         88plSSUicneGuN3vdnAyuCIclrprvAcqUj6DeAnc=
Date:   Thu, 15 Oct 2020 20:06:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dhowells@redhat.com,
        ebiggers@google.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 040/156] mm/readahead: pass a file_ra_state into
 force_page_cache_ra
Message-ID: <20201016030635.RiZwaOJC9%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Subject: mm/readahead: pass a file_ra_state into force_page_cache_ra

The file_ra_state being passed into page_cache_sync_readahead() was being
ignored in favour of using the one embedded in the struct file.  The only
caller for which this makes a difference is the fsverity code if the file
has been marked as POSIX_FADV_RANDOM, but it's confusing and worth fixing.

Link: https://lkml.kernel.org/r/20200903140844.14194-10-willy@infradead.org
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |    5 +++--
 mm/readahead.c |    5 ++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/mm/internal.h~mm-readahead-pass-a-file_ra_state-into-force_page_cache_ra
+++ a/mm/internal.h
@@ -51,12 +51,13 @@ void unmap_page_range(struct mmu_gather
 
 void do_page_cache_ra(struct readahead_control *, unsigned long nr_to_read,
 		unsigned long lookahead_size);
-void force_page_cache_ra(struct readahead_control *, unsigned long nr);
+void force_page_cache_ra(struct readahead_control *, struct file_ra_state *,
+		unsigned long nr);
 static inline void force_page_cache_readahead(struct address_space *mapping,
 		struct file *file, pgoff_t index, unsigned long nr_to_read)
 {
 	DEFINE_READAHEAD(ractl, file, mapping, index);
-	force_page_cache_ra(&ractl, nr_to_read);
+	force_page_cache_ra(&ractl, &file->f_ra, nr_to_read);
 }
 
 struct page *find_get_entry(struct address_space *mapping, pgoff_t index);
--- a/mm/readahead.c~mm-readahead-pass-a-file_ra_state-into-force_page_cache_ra
+++ a/mm/readahead.c
@@ -272,11 +272,10 @@ void do_page_cache_ra(struct readahead_c
  * memory at once.
  */
 void force_page_cache_ra(struct readahead_control *ractl,
-		unsigned long nr_to_read)
+		struct file_ra_state *ra, unsigned long nr_to_read)
 {
 	struct address_space *mapping = ractl->mapping;
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
-	struct file_ra_state *ra = &ractl->file->f_ra;
 	unsigned long max_pages, index;
 
 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages &&
@@ -562,7 +561,7 @@ void page_cache_sync_ra(struct readahead
 
 	/* be dumb */
 	if (ractl->file && (ractl->file->f_mode & FMODE_RANDOM)) {
-		force_page_cache_ra(ractl, req_count);
+		force_page_cache_ra(ractl, ra, req_count);
 		return;
 	}
 
_

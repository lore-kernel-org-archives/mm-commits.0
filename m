Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A236C433E9
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C66C20FC3
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599161099;
	bh=3wPkCuIC1PMLsfaEQf3MSEeedKfOYdO8VlrrcLiaDag=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=EaDAR5qUwmFDkdMtTFA7qSkzQoQNzsLrTggKC5E3ogXEbY/QTHLcnvS4V0Jt7xEk7
	 yZJMJXHlIY1A7VXH5oU1CHH6uezthnx3OqcjNehwSL7OYSB/wCBnH6mefTgMD7fT7a
	 BKjE5jIZ5CLv4cnUqlTF2LqYcaasoQuVLXhpzhm0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgICTY7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 15:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729066AbgICTY5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 15:24:57 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3E3020BED;
        Thu,  3 Sep 2020 19:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599161096;
        bh=3wPkCuIC1PMLsfaEQf3MSEeedKfOYdO8VlrrcLiaDag=;
        h=Date:From:To:Subject:From;
        b=essLfMqLc8mOS1/Bnka3+u6AS8iaBOGR6urJvBlAILV/8M3k8d4gSBlqJTQoqhbek
         3eVcc1jOIc6b3mTnHdi+fZz6hwuSmzGCuiSE5i6A3h4CuPvEAF1Tlxqz1NS4M4bojx
         IrmF3FaeNdu74kp9P4TVYgTd9caGi258K7kabn58=
Date:   Thu, 03 Sep 2020 12:24:56 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ebiggers@google.com, dhowells@redhat.com
Subject:  +
 mm-readahead-pass-readahead_control-to-force_page_cache_ra.patch added to -mm
 tree
Message-ID: <20200903192456.R--qK%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/readahead: pass readahead_control to force_page_cache_ra
has been added to the -mm tree.  Its filename is
     mm-readahead-pass-readahead_control-to-force_page_cache_ra.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-readahead-pass-readahead_control-to-force_page_cache_ra.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-readahead-pass-readahead_control-to-force_page_cache_ra.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: mm/readahead: pass readahead_control to force_page_cache_ra

Reimplement force_page_cache_readahead() as a wrapper around
force_page_cache_ra().  Pass the existing readahead_control from
page_cache_sync_readahead().

Link: https://lkml.kernel.org/r/20200903140844.14194-7-willy@infradead.org
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |   13 +++++++++----
 mm/readahead.c |   18 ++++++++++--------
 2 files changed, 19 insertions(+), 12 deletions(-)

--- a/mm/internal.h~mm-readahead-pass-readahead_control-to-force_page_cache_ra
+++ a/mm/internal.h
@@ -49,10 +49,15 @@ void unmap_page_range(struct mmu_gather
 			     unsigned long addr, unsigned long end,
 			     struct zap_details *details);
 
-void force_page_cache_readahead(struct address_space *, struct file *,
-		pgoff_t index, unsigned long nr_to_read);
-void do_page_cache_ra(struct readahead_control *,
-		unsigned long nr_to_read, unsigned long lookahead_size);
+void do_page_cache_ra(struct readahead_control *, unsigned long nr_to_read,
+		unsigned long lookahead_size);
+void force_page_cache_ra(struct readahead_control *, unsigned long nr);
+static inline void force_page_cache_readahead(struct address_space *mapping,
+		struct file *file, pgoff_t index, unsigned long nr_to_read)
+{
+	DEFINE_READAHEAD(ractl, file, mapping, index);
+	force_page_cache_ra(&ractl, nr_to_read);
+}
 
 /*
  * Submit IO for the read-ahead request in file_ra_state.
--- a/mm/readahead.c~mm-readahead-pass-readahead_control-to-force_page_cache_ra
+++ a/mm/readahead.c
@@ -271,13 +271,13 @@ void do_page_cache_ra(struct readahead_c
  * Chunk the readahead into 2 megabyte units, so that we don't pin too much
  * memory at once.
  */
-void force_page_cache_readahead(struct address_space *mapping,
-		struct file *file, pgoff_t index, unsigned long nr_to_read)
+void force_page_cache_ra(struct readahead_control *ractl,
+		unsigned long nr_to_read)
 {
-	DEFINE_READAHEAD(ractl, file, mapping, index);
+	struct address_space *mapping = ractl->mapping;
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
-	struct file_ra_state *ra = &file->f_ra;
-	unsigned long max_pages;
+	struct file_ra_state *ra = &ractl->file->f_ra;
+	unsigned long max_pages, index;
 
 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages &&
 			!mapping->a_ops->readahead))
@@ -287,14 +287,16 @@ void force_page_cache_readahead(struct a
 	 * If the request exceeds the readahead window, allow the read to
 	 * be up to the optimal hardware IO size
 	 */
+	index = readahead_index(ractl);
 	max_pages = max_t(unsigned long, bdi->io_pages, ra->ra_pages);
-	nr_to_read = min(nr_to_read, max_pages);
+	nr_to_read = min_t(unsigned long, nr_to_read, max_pages);
 	while (nr_to_read) {
 		unsigned long this_chunk = (2 * 1024 * 1024) / PAGE_SIZE;
 
 		if (this_chunk > nr_to_read)
 			this_chunk = nr_to_read;
-		do_page_cache_ra(&ractl, this_chunk, 0);
+		ractl->_index = index;
+		do_page_cache_ra(ractl, this_chunk, 0);
 
 		index += this_chunk;
 		nr_to_read -= this_chunk;
@@ -576,7 +578,7 @@ void page_cache_sync_readahead(struct ad
 
 	/* be dumb */
 	if (filp && (filp->f_mode & FMODE_RANDOM)) {
-		force_page_cache_readahead(mapping, filp, index, req_count);
+		force_page_cache_ra(&ractl, req_count);
 		return;
 	}
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

fix-khugepageds-request-size-in-collapse_file.patch
mm-readahead-make-ondemand_readahead-take-a-readahead_control.patch
mm-readahead-pass-readahead_control-to-force_page_cache_ra.patch
mm-filemap-fold-ra_submit-into-do_sync_mmap_readahead.patch
mm-readahead-pass-a-file_ra_state-into-force_page_cache_ra.patch
mutex-subsystem-synchro-test-module.patch


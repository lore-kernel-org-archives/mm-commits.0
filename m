Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EB8C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C702D2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816190;
	bh=PuHtxa1XKOXLdDCsKIDu/Y8AvzQgNpNNJqmT+WREfeM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=MhnCra90aqlhuvnZrI3qsUSCxVTVw1SVQOGeMsY7mqqAPkU0iiIGOBYe/+Fl7mwGW
	 /+kqVRcsbqOpuezASs6lOi36S0pTjm3aq2zkg36kROVhJVWcfYrILlWKvIf2jf3DhN
	 NbeI6lRr+eCWCcsNizbTI3c5qjrEpeuKi+Im6aLM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393819AbgJPCnK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730617AbgJPCnK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:43:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A2C320897;
        Fri, 16 Oct 2020 02:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816189;
        bh=PuHtxa1XKOXLdDCsKIDu/Y8AvzQgNpNNJqmT+WREfeM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KuVJC2HPJAgl3g6qXpOSbakYDeB0ZLEOW28JSbS93PaWWEK7WJk6xXhrXpIJ7bp7X
         zeIt36GjZAR9W7cReOxUZ0sRYr7S1eKAH8XMzXrdaJ7cVflz/VUHjNWl9hwcbHo7DN
         8CvKwzwXo0WQ/h3RRc74K7FdxIwAoCkUX04nFO0Q=
Date:   Thu, 15 Oct 2020 19:43:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dhowells@redhat.com,
        ebiggers@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 037/156] mm/readahead: pass readahead_control to
 force_page_cache_ra
Message-ID: <20201016024308.DLctj5DPA%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

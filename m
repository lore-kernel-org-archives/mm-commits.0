Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3B1C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC26521655
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881355;
	bh=UHLdUwXFKqZS9T9wmvUKj2UJG6ftK8Ty29tu7Ynkio4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=s+Cm2NxNDJp3AXfwhmxFZYLPxBx9QPFtBG7yeWeWjuyWX1SBP5tIpV5FUmL4UTOeU
	 yl2MeMZd6NkMKN2LdvsCIQVSTx8h6pMouRGvwxAjHWJzZN4p5nNTA8iabeWnrniEQB
	 9v3ThmJOgfmMjDwsD8UimqypMAP18GiAxCsLmPu4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392716AbgJPUtP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391060AbgJPUtP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:49:15 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5F552145D;
        Fri, 16 Oct 2020 20:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881353;
        bh=UHLdUwXFKqZS9T9wmvUKj2UJG6ftK8Ty29tu7Ynkio4=;
        h=Date:From:To:Subject:From;
        b=HUQeFP1qBfRkqwnU7yyyouWeZg2BxnkkZIDrCj7m0teCGzhdZV/FNKGBZwIAra+Ve
         pT/Rh3FjHghN43YlyJ+DyDUj1dn+pEVydBPjGhlCMzUiNbJY5evOmYploQ8Vf5MJYc
         1gvfa70jM+eWYu0bAAgNgzAgFJT058Kcp/IPz6eo=
Date:   Fri, 16 Oct 2020 13:49:12 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, ebiggers@google.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-readahead-pass-a-file_ra_state-into-force_page_cache_ra.patch removed
 from -mm tree
Message-ID: <20201016204912.EtpoHF5--%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/readahead: pass a file_ra_state into force_page_cache_ra
has been removed from the -mm tree.  Its filename was
     mm-readahead-pass-a-file_ra_state-into-force_page_cache_ra.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from dhowells@redhat.com are

mutex-subsystem-synchro-test-module.patch


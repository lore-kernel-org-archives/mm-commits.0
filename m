Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3728AC43461
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F3DC20DD4
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599161097;
	bh=qSj8iZv7s3WbV8fttEvQ0Uyj6CYlVt7m+awZxXylrh0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LIFjkE71SEadnJOa1MiNMIOXDzZ73Kms1w/L2Wz02pd2zRiR8FJj89uyhNTfnXtnO
	 N1pekiSzRaAVI2LRXNgLZxq3oN/nk1OJ1ToDax32/5lL7fs7BgNZa/kcB/WYi+vcXV
	 icl9wuU60mHtMZ8diBZ3cD95oBncbGkBXRwEOmCI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgICTY4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 15:24:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729096AbgICTYz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 15:24:55 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3A862098B;
        Thu,  3 Sep 2020 19:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599161094;
        bh=qSj8iZv7s3WbV8fttEvQ0Uyj6CYlVt7m+awZxXylrh0=;
        h=Date:From:To:Subject:From;
        b=glDo7aKFxywnm6vppxeIx+gqjTtABEPWnkovM26c9b6XWhPsrZp97nH7NQbw46lUV
         pTTcCJEyKJnmAxWXM6xDSsMm2hwz4S4qmccdLEX94vM9bMEvUSlF4edW8jUaLNLHuB
         MfM6i0p4XVCG6dBAeQ9KSnIUctsexdmukTDJH9cA=
Date:   Thu, 03 Sep 2020 12:24:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ebiggers@google.com, dhowells@redhat.com
Subject:  +
 mm-readahead-make-ondemand_readahead-take-a-readahead_control.patch added to
 -mm tree
Message-ID: <20200903192454.Nr8Kr%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/readahead: make ondemand_readahead take a readahead_control
has been added to the -mm tree.  Its filename is
     mm-readahead-make-ondemand_readahead-take-a-readahead_control.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-readahead-make-ondemand_readahead-take-a-readahead_control.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-readahead-make-ondemand_readahead-take-a-readahead_control.patch

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
Subject: mm/readahead: make ondemand_readahead take a readahead_control

Make ondemand_readahead() take a readahead_control struct in preparation
for making do_sync_mmap_readahead() pass down an RAC struct.

Link: https://lkml.kernel.org/r/20200903140844.14194-6-willy@infradead.org
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/mm/readahead.c~mm-readahead-make-ondemand_readahead-take-a-readahead_control
+++ a/mm/readahead.c
@@ -431,15 +431,14 @@ static int try_context_readahead(struct
 /*
  * A minimal readahead algorithm for trivial sequential/random reads.
  */
-static void ondemand_readahead(struct address_space *mapping,
-		struct file_ra_state *ra, struct file *file,
-		bool hit_readahead_marker, pgoff_t index,
+static void ondemand_readahead(struct readahead_control *ractl,
+		struct file_ra_state *ra, bool hit_readahead_marker,
 		unsigned long req_size)
 {
-	DEFINE_READAHEAD(ractl, file, mapping, index);
-	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
+	struct backing_dev_info *bdi = inode_to_bdi(ractl->mapping->host);
 	unsigned long max_pages = ra->ra_pages;
 	unsigned long add_pages;
+	unsigned long index = readahead_index(ractl);
 	pgoff_t prev_index;
 
 	/*
@@ -477,7 +476,8 @@ static void ondemand_readahead(struct ad
 		pgoff_t start;
 
 		rcu_read_lock();
-		start = page_cache_next_miss(mapping, index + 1, max_pages);
+		start = page_cache_next_miss(ractl->mapping, index + 1,
+				max_pages);
 		rcu_read_unlock();
 
 		if (!start || start - index > max_pages)
@@ -510,14 +510,15 @@ static void ondemand_readahead(struct ad
 	 * Query the page cache and look for the traces(cached history pages)
 	 * that a sequential stream would leave behind.
 	 */
-	if (try_context_readahead(mapping, ra, index, req_size, max_pages))
+	if (try_context_readahead(ractl->mapping, ra, index, req_size,
+			max_pages))
 		goto readit;
 
 	/*
 	 * standalone, small random read
 	 * Read as is, and do not pollute the readahead state.
 	 */
-	do_page_cache_ra(&ractl, req_size, 0);
+	do_page_cache_ra(ractl, req_size, 0);
 	return;
 
 initial_readahead:
@@ -543,8 +544,8 @@ readit:
 		}
 	}
 
-	ractl._index = ra->start;
-	do_page_cache_ra(&ractl, ra->size, ra->async_size);
+	ractl->_index = ra->start;
+	do_page_cache_ra(ractl, ra->size, ra->async_size);
 }
 
 /**
@@ -564,6 +565,8 @@ void page_cache_sync_readahead(struct ad
 			       struct file_ra_state *ra, struct file *filp,
 			       pgoff_t index, unsigned long req_count)
 {
+	DEFINE_READAHEAD(ractl, filp, mapping, index);
+
 	/* no read-ahead */
 	if (!ra->ra_pages)
 		return;
@@ -578,7 +581,7 @@ void page_cache_sync_readahead(struct ad
 	}
 
 	/* do read-ahead */
-	ondemand_readahead(mapping, ra, filp, false, index, req_count);
+	ondemand_readahead(&ractl, ra, false, req_count);
 }
 EXPORT_SYMBOL_GPL(page_cache_sync_readahead);
 
@@ -602,6 +605,8 @@ page_cache_async_readahead(struct addres
 			   struct page *page, pgoff_t index,
 			   unsigned long req_count)
 {
+	DEFINE_READAHEAD(ractl, filp, mapping, index);
+
 	/* no read-ahead */
 	if (!ra->ra_pages)
 		return;
@@ -624,7 +629,7 @@ page_cache_async_readahead(struct addres
 		return;
 
 	/* do read-ahead */
-	ondemand_readahead(mapping, ra, filp, true, index, req_count);
+	ondemand_readahead(&ractl, ra, true, req_count);
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

fix-khugepageds-request-size-in-collapse_file.patch
mm-readahead-make-ondemand_readahead-take-a-readahead_control.patch
mm-readahead-pass-readahead_control-to-force_page_cache_ra.patch
mm-filemap-fold-ra_submit-into-do_sync_mmap_readahead.patch
mm-readahead-pass-a-file_ra_state-into-force_page_cache_ra.patch
mutex-subsystem-synchro-test-module.patch


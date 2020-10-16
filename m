Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB379C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 432B72087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817584;
	bh=yyFL5fzT/yBx5cbHvAbxukI1C8Anhbx3Cq6PwDlhscM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RuhECAuRbabtTx72O0TQ/+uftfQRuhbK3SJs5W2CNx6BzE56gW4vqAmWPJtrFpH8l
	 P7206Tj5XoG9RwQ+d6zjQyt6Kg7/BfSZxSJREGFsXTEviBpF45saoK5ILdL5SNop1l
	 TH+neked4gX0qkTdDme0sAMC0w3Vythd00wtZPF4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393952AbgJPDGX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393950AbgJPDGX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:06:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 901CA20789;
        Fri, 16 Oct 2020 03:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817582;
        bh=yyFL5fzT/yBx5cbHvAbxukI1C8Anhbx3Cq6PwDlhscM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oPr2RI2WU6uR7V5RGUzIg0vNMTxsI5o3KCvedzvWmyEJlKOqjvG1wACu5RywHmQZ1
         a0xDHS9yQvehTQTCIRPtIJGk3H1qLOplgunlBLL5nEL97eIibVz+ZPYecZ5vWqIBfO
         RHii8P/o2L2KF1sk/C3bFY9+JoYLsNwZbRkz5kRg=
Date:   Thu, 15 Oct 2020 20:06:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dhowells@redhat.com,
        ebiggers@google.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 036/156] mm/readahead: make ondemand_readahead
 take a readahead_control
Message-ID: <20201016030621.nersm5GPa%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

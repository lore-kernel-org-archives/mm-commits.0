Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB8CC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46A3220897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817577;
	bh=0dbxhaKGsjorcCDJA505MCo5Jne8TSPsXPilpnIETrM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=cOkhYbRh5xAOfXtoRxTcw8euiVu7rpVzSlOdf64afww5V5fkbPyuwqbPJ3Ift8yKe
	 VCV3XigcDd4DdFl46Jw8xhGvkGXRUHUKDsGa2fBVTd4Ybby29YxHO8wQkLmubL1qC8
	 zTILkkgPqGvVhTmhx2vDSeEhJIQT5YFUg9pSe0NA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgJPDGQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393950AbgJPDGM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:06:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AEBD20878;
        Fri, 16 Oct 2020 03:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817572;
        bh=0dbxhaKGsjorcCDJA505MCo5Jne8TSPsXPilpnIETrM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OY57CCDcOgDi6tIOcn22oRlyNNxwHYg92K3M/c6OkpJBnMvceiig0WOn78NvuZEkg
         l2qttMqvDcJqUAap55ZEBpzqF6oWRtLyFxMqmWTY/R362EWMNWV8j6mKAKEyvUYH/c
         YJwTx9b7Brr0v+s26dYJgK18tQQ3FgDFCJJbw56Y=
Date:   Thu, 15 Oct 2020 20:06:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dhowells@redhat.com,
        ebiggers@google.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 033/156] mm/readahead: add DEFINE_READAHEAD
Message-ID: <20201016030610.cJnGeBbHG%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/readahead: add DEFINE_READAHEAD

Patch series "Readahead patches for 5.9/5.10".

These are infrastructure for both the THP patchset and for the fscache
rewrite,

For both pieces of infrastructure being build on top of this patchset, we
want the ractl to be available higher in the call-stack.

For David's work, he wants to add the 'critical page' to the ractl so that
he knows which page NEEDS to be brought in from storage, and which ones
are nice-to-have.  We might want something similar in block storage too. 
It used to be simple -- the first page was the critical one, but then mmap
added fault-around and so for that usecase, the middle page is the
critical one.  Anyway, I don't have any code to show that yet, we just
know that the lowest point in the callchain where we have that information
is do_sync_mmap_readahead() and so the ractl needs to start its life
there.

For THP, we havew the code that needs it.  It's actually the apex patch to
the series; the one which finally starts to allocate THPs and present them
to consenting filesystems:
http://git.infradead.org/users/willy/pagecache.git/commitdiff/798bcf30ab2eff278caad03a9edca74d2f8ae760

This patch (of 8):

Allow for a more concise definition of a struct readahead_control.

Link: https://lkml.kernel.org/r/20200903140844.14194-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20200903140844.14194-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Eric Biggers <ebiggers@google.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    7 +++++++
 mm/readahead.c          |    6 +-----
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/include/linux/pagemap.h~mm-readahead-add-define_readahead
+++ a/include/linux/pagemap.h
@@ -812,6 +812,13 @@ struct readahead_control {
 	unsigned int _batch_count;
 };
 
+#define DEFINE_READAHEAD(rac, f, m, i)					\
+	struct readahead_control rac = {				\
+		.file = f,						\
+		.mapping = m,						\
+		._index = i,						\
+	}
+
 /**
  * readahead_page - Get the next page to read.
  * @rac: The current readahead request.
--- a/mm/readahead.c~mm-readahead-add-define_readahead
+++ a/mm/readahead.c
@@ -179,11 +179,7 @@ void page_cache_readahead_unbounded(stru
 {
 	LIST_HEAD(page_pool);
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
-	struct readahead_control rac = {
-		.mapping = mapping,
-		.file = file,
-		._index = index,
-	};
+	DEFINE_READAHEAD(rac, file, mapping, index);
 	unsigned long i;
 
 	/*
_

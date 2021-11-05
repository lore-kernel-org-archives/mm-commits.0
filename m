Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596BAC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FA416125F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhKEUja (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231842AbhKEUj3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:39:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99ECB6127A;
        Fri,  5 Nov 2021 20:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144609;
        bh=uhBELLkR39FKXoBKx2krq9Lq6sztERzbvXjBlZH47K0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gY+GAuJAyVtKLlQlVJNdAF49s9cSxTpohchxSe3IT5jw+eLTzWc1InXVTMIj2UDGH
         kxL2sWLXtkCyixW4USENl/ykcBobeLuS2fU6nMEGWUkxf/4q3EhnEKsnWb4VN27VPo
         h1CuxsiNzXFi9vQYXBNY6zcTpyjOkZrSy8SRprbk=
Date:   Fri, 05 Nov 2021 13:36:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dhowells@redhat.com, jlayton@kernel.org,
        kent.overstreet@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 041/262] mm: stop filemap_read() from grabbing a
 superfluous page
Message-ID: <20211105203649.fsgWgNvjd%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Subject: mm: stop filemap_read() from grabbing a superfluous page

Under some circumstances, filemap_read() will allocate sufficient pages to
read to the end of the file, call readahead/readpages on them and copy the
data over - and then it will allocate another page at the EOF and call
readpage on that and then ignore it.  This is unnecessary and a waste of
time and resources.

filemap_read() *does* check for this, but only after it has already done
the allocation and I/O.  Fix this by checking before calling
filemap_get_pages() also.

Link: https://lkml.kernel.org/r/163472463105.3126792.7056099385135786492.stgit@warthog.procyon.org.uk
Link: https://lore.kernel.org/r/160588481358.3465195.16552616179674485179.stgit@warthog.procyon.org.uk/
Link: https://lore.kernel.org/r/163456863216.2614702.6384850026368833133.stgit@warthog.procyon.org.uk/
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/filemap.c~mm-stop-filemap_read-from-grabbing-a-superfluous-page
+++ a/mm/filemap.c
@@ -2625,6 +2625,9 @@ ssize_t filemap_read(struct kiocb *iocb,
 		if ((iocb->ki_flags & IOCB_WAITQ) && already_read)
 			iocb->ki_flags |= IOCB_NOWAIT;
 
+		if (unlikely(iocb->ki_pos >= i_size_read(inode)))
+			break;
+
 		error = filemap_get_pages(iocb, iter, &pvec);
 		if (error < 0)
 			break;
_

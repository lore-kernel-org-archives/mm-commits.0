Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C425C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 22:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 368806109F
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 22:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhJTWXj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Oct 2021 18:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhJTWXj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 Oct 2021 18:23:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C58BA611CC;
        Wed, 20 Oct 2021 22:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634768484;
        bh=m6axXKolvuUUljiAdw/W0yy+Jl35t1TYO8cWpi5+fLE=;
        h=Date:From:To:Subject:From;
        b=R1k4PJQCJGoJdeIzAZolHdzYILL+y1pyZGY5xlfRjIKRalWQg5TGetd5Nyth7d3I7
         d9h5/Yr5xkWAss5KPLkAI8TpoO1H88eoMiZq+iiTEq33UUey27e9H0jIY0udTUIuHd
         FBftgNC3kAdwKi7Tfn2XstZNAkReYfNc3amkhs0M=
Date:   Wed, 20 Oct 2021 15:21:23 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, jlayton@kernel.org, kent.overstreet@gmail.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  +
 mm-stop-filemap_read-from-grabbing-a-superfluous-page.patch added to -mm
 tree
Message-ID: <20211020222123.QR1-pNC7S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: stop filemap_read() from grabbing a superfluous page
has been added to the -mm tree.  Its filename is
     mm-stop-filemap_read-from-grabbing-a-superfluous-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-stop-filemap_read-from-grabbing-a-superfluous-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-stop-filemap_read-from-grabbing-a-superfluous-page.patch

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

Patches currently in -mm which might be from dhowells@redhat.com are

mm-stop-filemap_read-from-grabbing-a-superfluous-page.patch
mutex-subsystem-synchro-test-module.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 230B7C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F00E261260
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhKKCoK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233954AbhKKCoI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A095E610F7;
        Thu, 11 Nov 2021 02:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598479;
        bh=EhNWjL2DS5a/X5KFS6rf+1qKSKXRkXJiyh3H8gDBjoY=;
        h=Date:From:To:Subject:From;
        b=HgSu/GesAwVuy207U0UaSlTM7qSa/q1Pi0Z1WSxhPYfahoh3wsQyQXOi7r1AFH9Fe
         rqIo8uYInqjs6va/JSdTG2tgdOFsLKHXPh7wALyBcHGWpPDRrrCjZC965GLL+uwJ8c
         sR8n3lTfRNR88mnLsK9j32cGPCXYff61YZw2pDe8=
Date:   Wed, 10 Nov 2021 18:41:17 -0800
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, jlayton@kernel.org, kent.overstreet@gmail.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-stop-filemap_read-from-grabbing-a-superfluous-page.patch removed from
 -mm tree
Message-ID: <20211111024117.Gsd_UoR2Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: stop filemap_read() from grabbing a superfluous page
has been removed from the -mm tree.  Its filename was
     mm-stop-filemap_read-from-grabbing-a-superfluous-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mutex-subsystem-synchro-test-module.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A0FC001DC
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 16:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjG0Qf7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 12:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjG0Qf6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 12:35:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C45113
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 09:35:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 457F661ED0
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 16:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D906C433C7;
        Thu, 27 Jul 2023 16:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690475756;
        bh=XAYEjRG//BKrIgwSHwgunwUXBccF7Lu4+Q/L9Bmkpy8=;
        h=Date:To:From:Subject:From;
        b=j/2al1dvDZTMYPMLJR5SEpNY8dbl/GYix85LFGayeAZaI279FwmCK8KE647RbD1tP
         0VLluj3etoHeDeGMi0XPx4LfQtLcQIygdFEc0m2odiInOpD04i6dFo4Zrqvm/YMf/9
         55Puf6elnIE6/VxEOAxiiZnR9GFGa0PsfkDtCKeM=
Date:   Thu, 27 Jul 2023 09:35:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, jhubbard@nvidia.com, hughd@google.com,
        hch@lst.de, david@redhat.com, chuck.lever@oracle.com,
        axboe@kernel.dk, dhowells@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-apply-a-couple-of-filemap_splice_read-fixes-to-shmem_splice_read.patch added to mm-unstable branch
Message-Id: <20230727163556.9D906C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: apply a couple of filemap_splice_read() fixes to shmem_splice_read()
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-apply-a-couple-of-filemap_splice_read-fixes-to-shmem_splice_read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-apply-a-couple-of-filemap_splice_read-fixes-to-shmem_splice_read.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: shmem: apply a couple of filemap_splice_read() fixes to shmem_splice_read()
Date: Thu, 27 Jul 2023 17:10:16 +0100

Fix shmem_splice_read() to use the inode from in->f_mapping->host rather
than file_inode(in) and to skip the splice if it starts after s_maxbytes,
analogously with fixes to filemap_splice_read().

Link: https://lkml.kernel.org/r/20230727161016.169066-3-dhowells@redhat.com
Fixes: bd194b187115 ("shmem: Implement splice-read")
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~shmem-apply-a-couple-of-filemap_splice_read-fixes-to-shmem_splice_read
+++ a/mm/shmem.c
@@ -2797,13 +2797,16 @@ static ssize_t shmem_file_splice_read(st
 				      struct pipe_inode_info *pipe,
 				      size_t len, unsigned int flags)
 {
-	struct inode *inode = file_inode(in);
+	struct inode *inode = in->f_mapping->host;
 	struct address_space *mapping = inode->i_mapping;
 	struct folio *folio = NULL;
 	size_t total_spliced = 0, used, npages, n, part;
 	loff_t isize;
 	int error = 0;
 
+	if (unlikely(*ppos >= inode->i_sb->s_maxbytes))
+		return 0;
+
 	/* Work out how much data we can actually add into the pipe */
 	used = pipe_occupancy(pipe->head, pipe->tail);
 	npages = max_t(ssize_t, pipe->max_usage - used, 0);
_

Patches currently in -mm which might be from dhowells@redhat.com are

crypto-cifs-fix-error-handling-in-extract_iter_to_sg.patch
mm-merge-folio_has_private-filemap_release_folio-call-pairs.patch
mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache.patch
shmem-apply-a-couple-of-filemap_splice_read-fixes-to-shmem_splice_read.patch


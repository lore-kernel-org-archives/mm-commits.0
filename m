Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 203F3C3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 02:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjAFCpa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 21:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbjAFCp2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 21:45:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6B265AFB
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 18:45:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BB15CCE1BDA
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 02:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF354C433D2;
        Fri,  6 Jan 2023 02:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672973124;
        bh=AmkWQAtURXrvDeClX0RoE9oTbSOFWbpapanh1w51zAc=;
        h=Date:To:From:Subject:From;
        b=oVH9oQKATShd9oWMDLuEYWdPsDInohzXYUnq+TleUDFTnKi2zAYDWVdD1eqt6en+m
         KXhEW1993fQ9VsM4jFvUrOqKPlnCY7M6LfZ5i9spgay/Ky0RfKKMq1T6fkc8/p2IEK
         9FU0TYpAx3R2oCvV7l1vfcdYKw81kuUcMBc3mi5E=
Date:   Thu, 05 Jan 2023 18:45:23 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, hch@infradead.org, jack@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-dont-allocate-blocks-beyond-eof-from-__mpage_writepage.patch added to mm-unstable branch
Message-Id: <20230106024523.EF354C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: don't allocate blocks beyond EOF from __mpage_writepage
has been added to the -mm mm-unstable branch.  Its filename is
     fs-dont-allocate-blocks-beyond-eof-from-__mpage_writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-dont-allocate-blocks-beyond-eof-from-__mpage_writepage.patch

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
From: Jan Kara <jack@suse.cz>
Subject: fs: don't allocate blocks beyond EOF from __mpage_writepage
Date: Tue, 3 Jan 2023 11:44:30 +0100

When __mpage_writepage() is called for a page beyond EOF, it will go and
allocate all blocks underlying the page.  This is not only unnecessary but
this way blocks can get leaked (e.g.  if a page beyond EOF is marked dirty
but in the end write fails and i_size is not extended).

Link: https://lkml.kernel.org/r/20230103104430.27749-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/mpage.c~fs-dont-allocate-blocks-beyond-eof-from-__mpage_writepage
+++ a/fs/mpage.c
@@ -524,6 +524,12 @@ static int __mpage_writepage(struct page
 	 */
 	BUG_ON(!PageUptodate(page));
 	block_in_file = (sector_t)page->index << (PAGE_SHIFT - blkbits);
+	/*
+	 * Whole page beyond EOF? Skip allocating blocks to avoid leaking
+	 * space.
+	 */
+	if (block_in_file >= (i_size + (1 << blkbits) - 1) >> blkbits)
+		goto page_is_mapped;
 	last_block = (i_size - 1) >> blkbits;
 	map_bh.b_page = page;
 	for (page_block = 0; page_block < blocks_per_page; ) {
_

Patches currently in -mm which might be from jack@suse.cz are

fs-dont-allocate-blocks-beyond-eof-from-__mpage_writepage.patch


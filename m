Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640E5C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F55264EBD
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhCDA6p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:58:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1391442AbhCCWgl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 17:36:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAE5C64EEE;
        Wed,  3 Mar 2021 22:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614810941;
        bh=n6E1ktTRpf2UiCJn5zScyZ7SvMmmrDzI73z86YFGCOE=;
        h=Date:From:To:Subject:From;
        b=ocKaC0jF5RrFvtpypfD74d5nKUdtWnscu9ZBjbO81p6mZnFMcc+109mKhUJwcWjUh
         yvhLzGfazF742UPMQOufYl6VGdtlPGPQi8EH++HqBYOC/eGhCBe9KVw5zdwTTvCGo3
         LwaD+wijHEB9tzqQnVRgUgelLHj1kzUmEamNjdhw=
Date:   Wed, 03 Mar 2021 14:35:41 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org
Subject:  +
 mm-filemap-drop-check-for-truncated-page-after-i-o.patch added to -mm tree
Message-ID: <20210303223541.IsGcDPUb4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: drop check for truncated page after I/O
has been added to the -mm tree.  Its filename is
     mm-filemap-drop-check-for-truncated-page-after-i-o.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-drop-check-for-truncated-page-after-i-o.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-drop-check-for-truncated-page-after-i-o.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: drop check for truncated page after I/O

If the I/O completed successfully, the page will remain Uptodate, even if
it is subsequently truncated.  If the I/O completed with an error, this
check would cause us to retry the I/O if the page were truncated before we
woke up.  There is no need to retry the I/O; the I/O to fill the page
failed, so we can legitimately just return -EIO.

This code was originally added by commit 56f0d5fe6851 ("[PATCH]
readpage-vs-invalidate fix") in 2005 (this commit ID is from the
linux-fullhistory tree; it is also commit ba1f08f14b52 in tglx-history).

At the time, truncate_complete_page() called ClearPageUptodate(), and so
this was fixing a real bug.  In 2008, commit 84209e02de48 ("mm: dont clear
PG_uptodate on truncate/invalidate") removed the call to
ClearPageUptodate, and this check has been unnecessary ever since.

It doesn't do any real harm, but there's no need to keep it.

Link: https://lkml.kernel.org/r/20210303222547.1056428-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/filemap.c~mm-filemap-drop-check-for-truncated-page-after-i-o
+++ a/mm/filemap.c
@@ -2281,8 +2281,6 @@ static int filemap_read_page(struct file
 		return error;
 	if (PageUptodate(page))
 		return 0;
-	if (!page->mapping)	/* page truncated */
-		return AOP_TRUNCATED_PAGE;
 	shrink_readahead_size_eio(&file->f_ra);
 	return -EIO;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-filemap-use-filemap_read_page-in-filemap_fault.patch
mm-filemap-drop-check-for-truncated-page-after-i-o.patch


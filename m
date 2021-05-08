Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5498BC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BA826141D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhEHWlg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEHWlf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D71D61421;
        Sat,  8 May 2021 22:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513632;
        bh=a2GmZxo3y5N4HOgOnW4mi1a7KegwVC2VnV3H6AEnq/0=;
        h=Date:From:To:Subject:From;
        b=s3IQBJltw9UEwWnGfjdOk5K9J8Eb5s1RlmD9cEII8TrhBDpBuwkghweSgKvIJcEy5
         pRHlB74O1yVjzyt4U69ysn8KR62wNLq+VWyFc6i4UU4zWN3grmGw8IAPYLI9sXti3B
         +1rFL5hXjXqyDtKbnU0PgJH5on298StO5nGh9NBk=
Date:   Sat, 08 May 2021 15:40:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org
Subject:  [merged]
 mm-filemap-drop-check-for-truncated-page-after-i-o.patch removed from -mm
 tree
Message-ID: <20210508224032.tBOkwsJvh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: drop check for truncated page after I/O
has been removed from the -mm tree.  Its filename was
     mm-filemap-drop-check-for-truncated-page-after-i-o.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/filemap.c~mm-filemap-drop-check-for-truncated-page-after-i-o
+++ a/mm/filemap.c
@@ -2348,8 +2348,6 @@ static int filemap_read_page(struct file
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



Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D674C25B6F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjJYXs0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbjJYXsG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3102A1A1
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1471C433C8;
        Wed, 25 Oct 2023 23:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277682;
        bh=xC0QjBz2d4VSB+hp65YypayfB3/2NqSJXi7osO78igQ=;
        h=Date:To:From:Subject:From;
        b=NDqWI8xj2Xmb+reUdbYNKwo0zxk1AKvEWwHLJ6l3vLOxINVa2WEUkaET8ZAxvQh8/
         Oly8iqu4CaPEvJMNt8OpT5lX7YQ/rPYRrLmEx/p+ynNMO4z1k+aJ01PHMPLyDhCsMf
         Q3tdYGiRMJUGXNAaIKJkkffdJNlxUT0mAA7cZxNU=
Date:   Wed, 25 Oct 2023 16:48:01 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nilfs2-remove-nilfs_page_get_nth_block.patch removed from -mm tree
Message-Id: <20231025234801.F1471C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: remove nilfs_page_get_nth_block
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-nilfs_page_get_nth_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: remove nilfs_page_get_nth_block
Date: Mon, 16 Oct 2023 21:11:02 +0100

All users have now been converted to get_nth_block().

Link: https://lkml.kernel.org/r/20231016201114.1928083-16-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/nilfs2/page.h~nilfs2-remove-nilfs_page_get_nth_block
+++ a/fs/nilfs2/page.h
@@ -52,10 +52,4 @@ unsigned long nilfs_find_uncommitted_ext
 #define NILFS_PAGE_BUG(page, m, a...) \
 	do { nilfs_page_bug(page); BUG(); } while (0)
 
-static inline struct buffer_head *
-nilfs_page_get_nth_block(struct page *page, unsigned int count)
-{
-	return get_nth_bh(page_buffers(page), count);
-}
-
 #endif /* _NILFS_PAGE_H */
_

Patches currently in -mm which might be from willy@infradead.org are



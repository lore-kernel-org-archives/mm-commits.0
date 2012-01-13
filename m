From: akpm@linux-foundation.org
Subject: [merged] fs-remove-unneeded-plug-in-mpage_readpages.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:37:48 -0800
Message-ID: <20120113203749.073425C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42927 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:37:50 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25473eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:37:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linkinjeon@gmail.com, amit.sahrawat83@gmail.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: remove unneeded plug in mpage_readpages()
has been removed from the -mm tree.  Its filename was
     fs-remove-unneeded-plug-in-mpage_readpages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: fs: remove unneeded plug in mpage_readpages()

The block plug in mpage_readpages() is duplicates the one in read_pages().

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/mpage.c~fs-remove-unneeded-plug-in-mpage_readpages fs/mpage.c
--- a/fs/mpage.c~fs-remove-unneeded-plug-in-mpage_readpages
+++ a/fs/mpage.c
@@ -371,9 +371,6 @@ mpage_readpages(struct address_space *ma
 	sector_t last_block_in_bio = 0;
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
-	struct blk_plug plug;

From: akpm@linux-foundation.org
Subject: + fs-remove-unneeded-plug-in-mpage_readpages.patch added to -mm tree
Date: Tue, 22 Nov 2011 15:23:27 -0800
Message-ID: <201111222323.pAMNNRgq000341@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:64005 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1KVXX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 18:23:29 -0500
Received: by ywb5 with SMTP id 5so140362ywb.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 15:23:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linkinjeon@gmail.com, amit.sahrawat83@gmail.com, axboe@kernel.dk


The patch titled
     Subject: fs: remove unneeded plug in mpage_readpages()
has been added to the -mm tree.  Its filename is
     fs-remove-unneeded-plug-in-mpage_readpages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

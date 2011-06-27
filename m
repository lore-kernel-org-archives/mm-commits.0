From: akpm@linux-foundation.org
Subject: + reiserfs-use-hweight_long.patch added to -mm tree
Date: Mon, 27 Jun 2011 14:56:07 -0700
Message-ID: <201106272156.p5RLu7io029658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754928Ab1F0V4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jun 2011 17:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     reiserfs: use hweight_long()
has been added to the -mm tree.  Its filename is
     reiserfs-use-hweight_long.patch

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
Subject: reiserfs: use hweight_long()
From: Akinobu Mita <akinobu.mita@gmail.com>

Use hweight_long() to count free bits in the bitmap.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/bitmap.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/reiserfs/bitmap.c~reiserfs-use-hweight_long fs/reiserfs/bitmap.c
--- a/fs/reiserfs/bitmap.c~reiserfs-use-hweight_long
+++ a/fs/reiserfs/bitmap.c
@@ -1222,15 +1222,11 @@ void reiserfs_cache_bitmap_metadata(stru
 	info->free_count = 0;
 
 	while (--cur >= (unsigned long *)bh->b_data) {
-		int i;

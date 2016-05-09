From: akpm@linux-foundation.org
Subject: +
 fs-befs-datastreamc-befs_read_datastream-remove-unneeded-initialization-to-null.patch added to -mm tree
Date: Mon, 09 May 2016 14:52:16 -0700
Message-ID: <57310690.W4Y13zqoh0MvWk2R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbcEIVwS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 17:52:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/datastream.c:befs_read_datastream(): remove unneeded initialization to NULL
has been added to the -mm tree.  Its filename is
     fs-befs-datastreamc-befs_read_datastream-remove-unneeded-initialization-to-null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-datastreamc-befs_read_datastream-remove-unneeded-initialization-to-null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-datastreamc-befs_read_datastream-remove-unneeded-initialization-to-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Salah Triki <salah.triki@acm.org>
Subject: fs/befs/datastream.c:befs_read_datastream(): remove unneeded initialization to NULL

bh is reinitialized by befs_bread_iaddr() so no need to init it
with NULL in the beginning of befs_read_datastream().

Link: http://lkml.kernel.org/r/81e1f70187db34d195c8e42b1ff78be6a71c0060.1462649034.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/datastream.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/befs/datastream.c~fs-befs-datastreamc-befs_read_datastream-remove-unneeded-initialization-to-null fs/befs/datastream.c
--- a/fs/befs/datastream.c~fs-befs-datastreamc-befs_read_datastream-remove-unneeded-initialization-to-null
+++ a/fs/befs/datastream.c
@@ -48,7 +48,7 @@ struct buffer_head *
 befs_read_datastream(struct super_block *sb, befs_data_stream * ds,
 		     befs_off_t pos, uint * off)
 {
-	struct buffer_head *bh = NULL;
+	struct buffer_head *bh;
 	befs_block_run run;
 	befs_blocknr_t block;	/* block coresponding to pos */
 
_

Patches currently in -mm which might be from salah.triki@acm.org are

fs-befs-datastreamc-befs_read_datastream-remove-unneeded-initialization-to-null.patch
fs-befs-datastreamc-befs_read_lsymlink-remove-unneeded-initialization-to-null.patch
fs-befs-datastreamc-befs_find_brun_dblindirect-remove-unneeded-initializations-to-null.patch


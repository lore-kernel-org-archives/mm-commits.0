From: akpm@linux-foundation.org
Subject: +
 fs-befs-datastreamc-befs_read_lsymlink-remove-unneeded-initialization-to-null.patch added to -mm tree
Date: Mon, 09 May 2016 14:52:18 -0700
Message-ID: <57310692.Iil94FjWCL4QSLGR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbcEIVwT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 17:52:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/datastream.c:befs_read_lsymlink(): remove unneeded initialization to NULL
has been added to the -mm tree.  Its filename is
     fs-befs-datastreamc-befs_read_lsymlink-remove-unneeded-initialization-to-null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-datastreamc-befs_read_lsymlink-remove-unneeded-initialization-to-null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-datastreamc-befs_read_lsymlink-remove-unneeded-initialization-to-null.patch

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
Subject: fs/befs/datastream.c:befs_read_lsymlink(): remove unneeded initialization to NULL

bh is reinitialized by befs_read_datastream() so no need to init it
with NULL in the beginning of befs_read_lsymlink().

Link: http://lkml.kernel.org/r/e22f279bceb8d026af048952e02ba98925b21c92.1462649034.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/datastream.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/befs/datastream.c~fs-befs-datastreamc-befs_read_lsymlink-remove-unneeded-initialization-to-null fs/befs/datastream.c
--- a/fs/befs/datastream.c~fs-befs-datastreamc-befs_read_lsymlink-remove-unneeded-initialization-to-null
+++ a/fs/befs/datastream.c
@@ -127,7 +127,7 @@ befs_read_lsymlink(struct super_block *
 {
 	befs_off_t bytes_read = 0;	/* bytes readed */
 	u16 plen;
-	struct buffer_head *bh = NULL;
+	struct buffer_head *bh;
 	befs_debug(sb, "---> %s length: %llu", __func__, len);
 
 	while (bytes_read < len) {
_

Patches currently in -mm which might be from salah.triki@acm.org are

fs-befs-datastreamc-befs_read_datastream-remove-unneeded-initialization-to-null.patch
fs-befs-datastreamc-befs_read_lsymlink-remove-unneeded-initialization-to-null.patch
fs-befs-datastreamc-befs_find_brun_dblindirect-remove-unneeded-initializations-to-null.patch


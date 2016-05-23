From: akpm@linux-foundation.org
Subject: [patch 05/84] fs/befs/datastream.c:befs_read_lsymlink(): remove
 unneeded initialization to NULL
Date: Mon, 23 May 2016 16:22:35 -0700
Message-ID: <574390bb.Ve6GyWuHq91RUx4R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbcEWXWg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:22:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, salah.triki@acm.org

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
@@ -127,7 +127,7 @@ befs_read_lsymlink(struct super_block *s
 {
 	befs_off_t bytes_read = 0;	/* bytes readed */
 	u16 plen;
-	struct buffer_head *bh = NULL;
+	struct buffer_head *bh;
 	befs_debug(sb, "---> %s length: %llu", __func__, len);
 
 	while (bytes_read < len) {
_

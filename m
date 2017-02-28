From: akpm@linux-foundation.org
Subject: [merged] fs-reiserfs-atomically-read-inode-size.patch removed
 from -mm tree
Date: Tue, 28 Feb 2017 12:49:59 -0800
Message-ID: <58b5e277.vS/L/3rI2v3A95sb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52710 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751723AbdB1Uvc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/reiserfs: atomically read inode size
has been removed from the -mm tree.  Its filename was
     fs-reiserfs-atomically-read-inode-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/reiserfs: atomically read inode size

See i_size_read() comments in include/linux/fs.h

Link: http://lkml.kernel.org/r/20170123174701.30394-1-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/super.c~fs-reiserfs-atomically-read-inode-size fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~fs-reiserfs-atomically-read-inode-size
+++ a/fs/reiserfs/super.c
@@ -1166,7 +1166,7 @@ static int reiserfs_parse_options(struct
 			if (!strcmp(arg, "auto")) {
 				/* From JFS code, to auto-get the size. */
 				*blocks =
-				    s->s_bdev->bd_inode->i_size >> s->
+				    i_size_read(s->s_bdev->bd_inode) >> s->
 				    s_blocksize_bits;
 			} else {
 				*blocks = simple_strtoul(arg, &p, 0);
_

Patches currently in -mm which might be from fabf@skynet.be are



From: akpm@linux-foundation.org
Subject: [merged] hfs-atomically-read-inode-size.patch removed from -mm
 tree
Date: Tue, 28 Feb 2017 12:52:20 -0800
Message-ID: <58b5e304.A9aSlQx6haAVejeF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52880 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751954AbdB1UwW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:52:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: atomically read inode size
has been removed from the -mm tree.  Its filename was
     hfs-atomically-read-inode-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: hfs: atomically read inode size

See i_size_read() comments in include/linux/fs.h

Link: http://lkml.kernel.org/r/20170123175245.3272-1-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/mdb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfs/mdb.c~hfs-atomically-read-inode-size fs/hfs/mdb.c
--- a/fs/hfs/mdb.c~hfs-atomically-read-inode-size
+++ a/fs/hfs/mdb.c
@@ -38,7 +38,7 @@ static int hfs_get_last_session(struct s
 
 	/* default values */
 	*start = 0;
-	*size = sb->s_bdev->bd_inode->i_size >> 9;
+	*size = i_size_read(sb->s_bdev->bd_inode) >> 9;
 
 	if (HFS_SB(sb)->session >= 0) {
 		te.cdte_track = HFS_SB(sb)->session;
_

Patches currently in -mm which might be from fabf@skynet.be are



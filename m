From: akpm@linux-foundation.org
Subject: [merged] hfsplus-atomically-read-inode-size.patch removed from
 -mm tree
Date: Tue, 28 Feb 2017 12:49:57 -0800
Message-ID: <58b5e275.N12Tfv+kzsC7lmsU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52604 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751683AbdB1Uvc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: atomically read inode size
has been removed from the -mm tree.  Its filename was
     hfsplus-atomically-read-inode-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: hfsplus: atomically read inode size

See i_size_read() comments in include/linux/fs.h

Link: http://lkml.kernel.org/r/20170123175338.3840-1-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/wrapper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfsplus/wrapper.c~hfsplus-atomically-read-inode-size fs/hfsplus/wrapper.c
--- a/fs/hfsplus/wrapper.c~hfsplus-atomically-read-inode-size
+++ a/fs/hfsplus/wrapper.c
@@ -132,7 +132,7 @@ static int hfsplus_get_last_session(stru
 
 	/* default values */
 	*start = 0;
-	*size = sb->s_bdev->bd_inode->i_size >> 9;
+	*size = i_size_read(sb->s_bdev->bd_inode) >> 9;
 
 	if (HFSPLUS_SB(sb)->session >= 0) {
 		te.cdte_track = HFSPLUS_SB(sb)->session;
_

Patches currently in -mm which might be from fabf@skynet.be are



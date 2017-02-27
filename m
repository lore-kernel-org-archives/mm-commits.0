From: akpm@linux-foundation.org
Subject: [patch 13/78] hfsplus: atomically read inode size
Date: Mon, 27 Feb 2017 14:27:19 -0800
Message-ID: <58b4a7c7.mojlhKu6kfYsphWd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44856 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbdB0W3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:29:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, fabf@skynet.be

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

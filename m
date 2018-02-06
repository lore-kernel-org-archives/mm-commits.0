From: akpm@linux-foundation.org
Subject: [patch 020/114] fs/proc/array.c: delete
 children_seq_release()
Date: Tue, 06 Feb 2018 15:37:10 -0800
Message-ID: <20180206233710.O2dCO2Y_N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54384 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754120AbeBFXhL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:37:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, gorcunov@openvz.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/proc/array.c: delete children_seq_release()

It is 1:1 wrapper around seq_release().

Link: http://lkml.kernel.org/r/20171122171510.GA12161@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN fs/proc/array.c~proc-delete-children_seq_release fs/proc/array.c
--- a/fs/proc/array.c~proc-delete-children_seq_release
+++ a/fs/proc/array.c
@@ -736,16 +736,10 @@ static int children_seq_open(struct inod
 	return ret;
 }
 
-int children_seq_release(struct inode *inode, struct file *file)
-{
-	seq_release(inode, file);
-	return 0;
-}

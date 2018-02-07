From: akpm@linux-foundation.org
Subject: [merged] proc-delete-children_seq_release.patch removed
 from -mm tree
Date: Wed, 07 Feb 2018 11:56:03 -0800
Message-ID: <20180207195603.HKCvLPAO0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58168 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754157AbeBGT4E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:56:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, gorcunov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/array.c: delete children_seq_release()
has been removed from the -mm tree.  Its filename was
     proc-delete-children_seq_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

From: akpm@linux-foundation.org
Subject: + proc-delete-children_seq_release.patch added to -mm tree
Date: Tue, 28 Nov 2017 14:43:27 -0800
Message-ID: <5a1de68f.IM66tHWJMTp6S3F1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46662 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbdK1Wn2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Nov 2017 17:43:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, gorcunov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/array.c: delete children_seq_release()
has been added to the -mm tree.  Its filename is
     proc-delete-children_seq_release.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-delete-children_seq_release.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-delete-children_seq_release.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -733,16 +733,10 @@ static int children_seq_open(struct inod
 	return ret;
 }
 
-int children_seq_release(struct inode *inode, struct file *file)
-{
-	seq_release(inode, file);
-	return 0;
-}

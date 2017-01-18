From: akpm@linux-foundation.org
Subject: + hfs-fix-fix-hfs_readdir.patch added to -mm tree
Date: Wed, 18 Jan 2017 13:07:05 -0800
Message-ID: <587fd8f9.vwF1YZgaLmHjgXo7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33650 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753179AbdARVHG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 16:07:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, slava@dubeyko.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: fix fix hfs_readdir()
has been added to the -mm tree.  Its filename is
     hfs-fix-fix-hfs_readdir.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfs-fix-fix-hfs_readdir.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfs-fix-fix-hfs_readdir.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: hfs: fix fix hfs_readdir()

I was looking through static analysis warnings and there is a bug here
that goes all the way back to the start of git.  Basically we're copying
the pointer and nearby garbage instead of the data the fd.key pointer is
pointing to.

Link: http://lkml.kernel.org/r/20170118111320.GA23725@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfs/dir.c~hfs-fix-fix-hfs_readdir fs/hfs/dir.c
--- a/fs/hfs/dir.c~hfs-fix-fix-hfs_readdir
+++ a/fs/hfs/dir.c
@@ -169,7 +169,7 @@ static int hfs_readdir(struct file *file
 	 * Can be done after the list insertion; exclusion with
 	 * hfs_delete_cat() is provided by directory lock.
 	 */
-	memcpy(&rd->key, &fd.key, sizeof(struct hfs_cat_key));
+	memcpy(&rd->key, &fd.key->cat, sizeof(struct hfs_cat_key));
 out:
 	hfs_find_exit(&fd);
 	return err;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix.patch
hfs-fix-fix-hfs_readdir.patch


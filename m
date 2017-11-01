From: akpm@linux-foundation.org
Subject: + nilfs2-use-octal-for-unreadable-permission-macro.patch added to -mm tree
Date: Wed, 01 Nov 2017 14:16:22 -0700
Message-ID: <59fa39a6.Q/B/ssyfybixla3U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41002 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933194AbdKAVQX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2017 17:16:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: use octal for unreadable permission macro
has been added to the -mm tree.  Its filename is
     nilfs2-use-octal-for-unreadable-permission-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-use-octal-for-unreadable-permission-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-use-octal-for-unreadable-permission-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: use octal for unreadable permission macro

Replace S_IRWXUGO with 0777 because symbolic permissions are considered
harmful:

 https://lwn.net/Articles/696229/

Link: http://lkml.kernel.org/r/1509367935-3086-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/namei.c~nilfs2-use-octal-for-unreadable-permission-macro fs/nilfs2/namei.c
--- a/fs/nilfs2/namei.c~nilfs2-use-octal-for-unreadable-permission-macro
+++ a/fs/nilfs2/namei.c
@@ -150,7 +150,7 @@ static int nilfs_symlink(struct inode *d
 	if (err)
 		return err;
 
-	inode = nilfs_new_inode(dir, S_IFLNK | S_IRWXUGO);
+	inode = nilfs_new_inode(dir, S_IFLNK | 0777);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out;
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-align-block-comments-of-nilfs_sufile_truncate_range-at.patch
nilfs2-use-octal-for-unreadable-permission-macro.patch


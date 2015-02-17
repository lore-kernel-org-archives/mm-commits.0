From: akpm@linux-foundation.org
Subject: + fs-fat-remove-unnecessary-defintion.patch added to -mm tree
Date: Tue, 17 Feb 2015 14:36:16 -0800
Message-ID: <54e3c260.leb0jBW/lpKUlS7Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbbBQWgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 17:36:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fat: remove unnecessary defintion
has been added to the -mm tree.  Its filename is
     fs-fat-remove-unnecessary-defintion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-fat-remove-unnecessary-defintion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-fat-remove-unnecessary-defintion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: fs/fat: remove unnecessary defintion

'*sb' never used, so let's remote it and pass inode->i_sb directly to the
MSDOS_SB.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/fat/inode.c~fs-fat-remove-unnecessary-defintion fs/fat/inode.c
--- a/fs/fat/inode.c~fs-fat-remove-unnecessary-defintion
+++ a/fs/fat/inode.c
@@ -1280,8 +1280,7 @@ out:
 
 static int fat_read_root(struct inode *inode)
 {
-	struct super_block *sb = inode->i_sb;
-	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	int error;
 
 	MSDOS_I(inode)->i_pos = MSDOS_ROOT_INO;
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

origin.patch
kexec-fix-a-typo-in-comment.patch
fs-fat-remove-unnecessary-defintion.patch
fs-fat-remove-unnecessary-includes.patch


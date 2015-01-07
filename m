From: akpm@linux-foundation.org
Subject: + fs-fat-use-msdos_sb-macro-to-get-msdos_sb_info.patch added to
 -mm tree
Date: Tue, 06 Jan 2015 16:31:13 -0800
Message-ID: <54ac7e51.TVfzx1+xZtATh4fq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496AbbAGAbO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 19:31:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fred.chou.nd@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: fat: use MSDOS_SB macro to get msdos_sb_info
has been added to the -mm tree.  Its filename is
     fs-fat-use-msdos_sb-macro-to-get-msdos_sb_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-fat-use-msdos_sb-macro-to-get-msdos_sb_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-fat-use-msdos_sb-macro-to-get-msdos_sb_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fred Chou <fred.chou.nd@gmail.com>
Subject: fs: fat: use MSDOS_SB macro to get msdos_sb_info

Use the MSDOS_SB macro to get msdos_sb_info, instead of coding it
directly.

Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fs-fat-use-msdos_sb-macro-to-get-msdos_sb_info fs/fat/inode.c
--- a/fs/fat/inode.c~fs-fat-use-msdos_sb-macro-to-get-msdos_sb_info
+++ a/fs/fat/inode.c
@@ -580,7 +580,7 @@ static void fat_set_state(struct super_b
 {
 	struct buffer_head *bh;
 	struct fat_boot_sector *b;
-	struct msdos_sb_info *sbi = sb->s_fs_info;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
 	/* do not change any thing if mounted read only */
 	if ((sb->s_flags & MS_RDONLY) && !force)
_

Patches currently in -mm which might be from fred.chou.nd@gmail.com are

fs-fat-use-msdos_sb-macro-to-get-msdos_sb_info.patch


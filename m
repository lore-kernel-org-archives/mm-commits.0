From: akpm@linux-foundation.org
Subject: + fat-fix-non-atomic-nfs-i_pos-read.patch added to -mm tree
Date: Fri, 29 Jun 2012 14:27:21 -0700
Message-ID: <20120629212721.9BA46A024B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:35372 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab2F2V1X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jun 2012 17:27:23 -0400
Received: by wgbdt11 with SMTP id dt11so190323wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 29 Jun 2012 14:27:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steve@digidescorp.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat: fix non-atomic NFS i_pos read
has been added to the -mm tree.  Its filename is
     fat-fix-non-atomic-nfs-i_pos-read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Steven J. Magnani" <steve@digidescorp.com>
Subject: fat: fix non-atomic NFS i_pos read

fat_encode_fh() can fetch an invalid i_pos value on systems where 64-bit
accesses are not atomic.  Make it use the same accessor as the rest of the
FAT code.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN fs/fat/inode.c~fat-fix-non-atomic-nfs-i_pos-read fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-non-atomic-nfs-i_pos-read
+++ a/fs/fat/inode.c
@@ -738,22 +738,21 @@ static int
 fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
 {
 	int len = *lenp;
-	u32 ipos_h, ipos_m, ipos_l;
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	loff_t i_pos;
 
 	if (len < 5) {
 		*lenp = 5;
 		return 255; /* no room */
 	}
 
-	ipos_h = MSDOS_I(inode)->i_pos >> 8;
-	ipos_m = (MSDOS_I(inode)->i_pos & 0xf0) << 24;
-	ipos_l = (MSDOS_I(inode)->i_pos & 0x0f) << 28;
+	i_pos = fat_i_pos_read(sbi, inode);
 	*lenp = 5;
 	fh[0] = inode->i_ino;
 	fh[1] = inode->i_generation;
-	fh[2] = ipos_h;
-	fh[3] = ipos_m | MSDOS_I(inode)->i_logstart;
-	fh[4] = ipos_l;
+	fh[2] = i_pos >> 8;
+	fh[3] = ((i_pos & 0xf0) << 24) | MSDOS_I(inode)->i_logstart;
+	fh[4] = (i_pos & 0x0f) << 28;
 	if (parent)
 		fh[4] |= MSDOS_I(parent)->i_logstart;
 	return 3;
_
Subject: Subject: fat: fix non-atomic NFS i_pos read

Patches currently in -mm which might be from steve@digidescorp.com are

fat-fix-non-atomic-nfs-i_pos-read.patch
fat-accessors-for-msdos_dir_entry-start-fields.patch


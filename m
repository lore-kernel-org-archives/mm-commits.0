From: akpm@linux-foundation.org
Subject: [merged] fat-add-fat_msg_ratelimit.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:31 -0700
Message-ID: <20120601193331.5B598A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:52311 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2FATdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:32 -0400
Received: by vbnl22 with SMTP id l22so244305vbn.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linkinjeon@gmail.com, amit.sahrawat83@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: add fat_msg_ratelimit()
has been removed from the -mm tree.  Its filename was
     fat-add-fat_msg_ratelimit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: fat: add fat_msg_ratelimit()

Add a fat_msg_ratelimit() to limit the message generation rate.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/fat/fat.h~fat-add-fat_msg_ratelimit fs/fat/fat.h
--- a/fs/fat/fat.h~fat-add-fat_msg_ratelimit
+++ a/fs/fat/fat.h
@@ -335,6 +335,11 @@ void __fat_fs_error(struct super_block *
 	__fat_fs_error(sb, __ratelimit(&MSDOS_SB(sb)->ratelimit), fmt , ## args)
 __printf(3, 4) __cold
 void fat_msg(struct super_block *sb, const char *level, const char *fmt, ...);
+#define fat_msg_ratelimit(sb, level, fmt, args...)	\
+	do {	\
+			if (__ratelimit(&MSDOS_SB(sb)->ratelimit))	\
+				fat_msg(sb, level, fmt, ## args);	\
+	 } while (0)
 extern int fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
 extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
_

Patches currently in -mm which might be from linkinjeon@gmail.com are

origin.patch
drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch
ufs-fix-incorrect-return-value-about-success-and-failed.patch
fat-use-fat_msg_ratelimit-in-fat__get_entry.patch


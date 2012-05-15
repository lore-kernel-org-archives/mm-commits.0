From: akpm@linux-foundation.org
Subject: + fat-add-fat_msg_ratelimit.patch added to -mm tree
Date: Tue, 15 May 2012 12:36:00 -0700
Message-ID: <20120515193601.18F1AA0280@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:60351 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966576Ab2EOTgF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 15:36:05 -0400
Received: by lbbgp10 with SMTP id gp10so332090lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 12:36:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linkinjeon@gmail.com, amit.sahrawat83@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat: add fat_msg_ratelimit()
has been added to the -mm tree.  Its filename is
     fat-add-fat_msg_ratelimit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: fat: add fat_msg_ratelimit()

Patches currently in -mm which might be from linkinjeon@gmail.com are

linux-next.patch
drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch
ufs-fix-incorrect-return-value-about-success-and-failed.patch
fat-add-fat_msg_ratelimit.patch
fat-use-fat_msg_ratelimit-in-fat__get_entry.patch


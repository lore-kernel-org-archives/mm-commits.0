From: akpm@linux-foundation.org
Subject: + fs-sysv-v7-adjust-sanity-checks-for-some-volumes.patch added to -mm tree
Date: Thu, 22 Jul 2010 16:06:34 -0700
Message-ID: <201007222306.o6MN6YA1017469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752059Ab0GVXGq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Jul 2010 19:06:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkundrak@v3.sk, hch@lst.de


The patch titled
     fs/sysv: v7: adjust sanity checks for some volumes
has been added to the -mm tree.  Its filename is
     fs-sysv-v7-adjust-sanity-checks-for-some-volumes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/sysv: v7: adjust sanity checks for some volumes
From: Lubomir Rintel <lkundrak@v3.sk>

Newly mkfs-ed filesystems from Seventh Edition have last modification time
set to zero, but are otherwise perfectly valid.

Also, tighten up other sanity checks to filter out most filesystems with

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/super.c         |    6 ++++--
 include/linux/sysv_fs.h |   11 +++++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff -puN fs/sysv/super.c~fs-sysv-v7-adjust-sanity-checks-for-some-volumes fs/sysv/super.c
--- a/fs/sysv/super.c~fs-sysv-v7-adjust-sanity-checks-for-some-volumes
+++ a/fs/sysv/super.c
@@ -470,7 +470,7 @@ static int v7_fill_super(struct super_bl
 	v7sb = (struct v7_super_block *) bh->b_data;
 	if (fs16_to_cpu(sbi, v7sb->s_nfree) > V7_NICFREE ||
 	    fs16_to_cpu(sbi, v7sb->s_ninode) > V7_NICINOD ||
-	    fs32_to_cpu(sbi, v7sb->s_time) == 0)
+	    fs32_to_cpu(sbi, v7sb->s_fsize) > V7_MAXSIZE)
 		goto failed;
 
 	/* plausibility check on root inode: it is a directory,
@@ -480,7 +480,9 @@ static int v7_fill_super(struct super_bl
 	v7i = (struct sysv_inode *)(bh2->b_data + 64);
 	if ((fs16_to_cpu(sbi, v7i->i_mode) & ~0777) != S_IFDIR ||
 	    (fs32_to_cpu(sbi, v7i->i_size) == 0) ||
-	    (fs32_to_cpu(sbi, v7i->i_size) & 017) != 0)
+	    (fs32_to_cpu(sbi, v7i->i_size) & 017) ||
+	    (fs32_to_cpu(sbi, v7i->i_size) > V7_NFILES *
+	     sizeof (struct sysv_dir_entry)))
 		goto failed;
 	brelse(bh2);
 	bh2 = NULL;
diff -puN include/linux/sysv_fs.h~fs-sysv-v7-adjust-sanity-checks-for-some-volumes include/linux/sysv_fs.h
--- a/include/linux/sysv_fs.h~fs-sysv-v7-adjust-sanity-checks-for-some-volumes
+++ a/include/linux/sysv_fs.h
@@ -148,6 +148,17 @@ struct v7_super_block {
 	char    s_fname[6];     /* file system name */
 	char    s_fpack[6];     /* file system pack name */
 };
+/* Constants to aid sanity checking */
+/* This is not a hard limit, nor enforced by v7 kernel. It's actually just
+ * the limit used by Seventh Edition's ls, though is high enough to assume
+ * that no reasonable file system would have that much entries in root
+ * directory. Thus, if we see anything higher, we just probably got the
+ * endiannes wrong. */
+#define V7_NFILES	1024
+/* The disk addresses are three-byte (despite direct block addresses being
+ * aligned word-wise in inode). If the most significant byte is non-zero,
+ * something is most likely wrong (not a filesystem, bad bytesex). */
+#define V7_MAXSIZE	0x00ffffff
 
 /* Coherent super-block data on disk */
 #define COH_NICINOD	100	/* number of inode cache entries */
_

Patches currently in -mm which might be from lkundrak@v3.sk are

fs-sysv-add-v7-alias.patch
fs-sysv-v7-adjust-sanity-checks-for-some-volumes.patch
fs-sysv-v7-add-support-for-non-pdp11-v7-filesystems.patch


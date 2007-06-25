From: akpm@linux-foundation.org
Subject: + is_power_of_2-ext3-superc.patch added to -mm tree
Date: Mon, 25 Jun 2007 12:12:12 -0700
Message-ID: <200706251912.l5PJCCRX008680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36258 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751520AbXFYTMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 15:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vignesh.babu@wipro.com


The patch titled
     is_power_of_2: ext3/super.c
has been added to the -mm tree.  Its filename is
     is_power_of_2-ext3-superc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: is_power_of_2: ext3/super.c
From: vignesh babu <vignesh.babu@wipro.com>

Replace (n & (n-1)) in the context of power of 2 checks with is_power_of_2()

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ext3/super.c~is_power_of_2-ext3-superc fs/ext3/super.c
--- a/fs/ext3/super.c~is_power_of_2-ext3-superc
+++ a/fs/ext3/super.c
@@ -35,6 +35,7 @@
 #include <linux/namei.h>
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
+#include <linux/log2.h>
 
 #include <asm/uaccess.h>
 
@@ -1574,7 +1575,7 @@ static int ext3_fill_super (struct super
 		sbi->s_inode_size = le16_to_cpu(es->s_inode_size);
 		sbi->s_first_ino = le32_to_cpu(es->s_first_ino);
 		if ((sbi->s_inode_size < EXT3_GOOD_OLD_INODE_SIZE) ||
-		    (sbi->s_inode_size & (sbi->s_inode_size - 1)) ||
+		    (!is_power_of_2(sbi->s_inode_size)) ||
 		    (sbi->s_inode_size > blocksize)) {
 			printk (KERN_ERR
 				"EXT3-fs: unsupported inode size: %d\n",
_

Patches currently in -mm which might be from vignesh.babu@wipro.com are

git-ubi.patch
use-is_power_of_2-in-cxgb3-cxgb3_mainc.patch
use-is_power_of_2-in-myri10ge-myri10gec.patch
is_power_of_2-ext3-superc.patch

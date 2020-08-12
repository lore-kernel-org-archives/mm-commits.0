Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB3BC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BA35207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266291;
	bh=WvVO6h8IcNLRto4pkfPlIw+WRjMFC2pBXtRlWcsAPfA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xNB1s0BRyBwFgxVkfIl7sBgXNwWEbbev2aVAv456Khfp3RW6u747Ykr5HOr2OYhKY
	 LrIRiFpeNcAHZXrAJz7Jm8riKjwa/K3is/CBJc7HJwEjo3D2qWHRNE6OksLo5i49Ms
	 XlsCJKnYrfCD21wsWMOPNdGAcHLnDVWtF6aX22JI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgHLVEv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgHLVEu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:50 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 754CA2078B;
        Wed, 12 Aug 2020 21:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266290;
        bh=WvVO6h8IcNLRto4pkfPlIw+WRjMFC2pBXtRlWcsAPfA=;
        h=Date:From:To:Subject:From;
        b=OU0lQoRO7WBL8RsqOTf/nDM9ZwTeyIxIOz2d2kb22w7udmlDKmDFr2ulZGqK0Rob7
         9MXF288RwKx1gsKjs0xHqrUzGovpTVb0lb/3UpmqFAmbJSvPONLy1ySvECic3a9oCE
         YKCDFIjVZdTxJXGLxnabq3aBuXY/H3EHVj3YUmmg=
Date:   Wed, 12 Aug 2020 14:04:50 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, konishi.ryusuke@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 nilfs2-convert-__nilfs_msg-to-integrate-the-level-and-format.patch removed
 from -mm tree
Message-ID: <20200812210450.LZQogaiVZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: convert __nilfs_msg to integrate the level and format
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-__nilfs_msg-to-integrate-the-level-and-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: nilfs2: convert __nilfs_msg to integrate the level and format

Reduce object size a bit by removing the KERN_<LEVEL> as a separate
argument and adding it to the format string.

Reduce overall object size by about ~.5% (x86-64 defconfig w/ nilfs2)

old:
$ size -t fs/nilfs2/built-in.a | tail -1
 191738	   8676	     44	 200458	  30f0a	(TOTALS)

new:
$ size -t fs/nilfs2/built-in.a | tail -1
 190971	   8676	     44	 199691	  30c0b	(TOTALS)

Link: http://lkml.kernel.org/r/1595860111-3920-3-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/nilfs.h |    9 ++++-----
 fs/nilfs2/super.c |   16 +++++++++++-----
 2 files changed, 15 insertions(+), 10 deletions(-)

--- a/fs/nilfs2/nilfs.h~nilfs2-convert-__nilfs_msg-to-integrate-the-level-and-format
+++ a/fs/nilfs2/nilfs.h
@@ -289,9 +289,8 @@ static inline int nilfs_mark_inode_dirty
 /* super.c */
 extern struct inode *nilfs_alloc_inode(struct super_block *);
 
-extern __printf(3, 4)
-void __nilfs_msg(struct super_block *sb, const char *level,
-		 const char *fmt, ...);
+__printf(2, 3)
+void __nilfs_msg(struct super_block *sb, const char *fmt, ...);
 extern __printf(3, 4)
 void __nilfs_error(struct super_block *sb, const char *function,
 		   const char *fmt, ...);
@@ -299,7 +298,7 @@ void __nilfs_error(struct super_block *s
 #ifdef CONFIG_PRINTK
 
 #define nilfs_msg(sb, level, fmt, ...)					\
-	__nilfs_msg(sb, level, fmt, ##__VA_ARGS__)
+	__nilfs_msg(sb, level fmt, ##__VA_ARGS__)
 #define nilfs_error(sb, fmt, ...)					\
 	__nilfs_error(sb, __func__, fmt, ##__VA_ARGS__)
 
@@ -307,7 +306,7 @@ void __nilfs_error(struct super_block *s
 
 #define nilfs_msg(sb, level, fmt, ...)					\
 	do {								\
-		no_printk(fmt, ##__VA_ARGS__);				\
+		no_printk(level fmt, ##__VA_ARGS__);			\
 		(void)(sb);						\
 	} while (0)
 #define nilfs_error(sb, fmt, ...)					\
--- a/fs/nilfs2/super.c~nilfs2-convert-__nilfs_msg-to-integrate-the-level-and-format
+++ a/fs/nilfs2/super.c
@@ -62,19 +62,25 @@ struct kmem_cache *nilfs_btree_path_cach
 static int nilfs_setup_super(struct super_block *sb, int is_mount);
 static int nilfs_remount(struct super_block *sb, int *flags, char *data);
 
-void __nilfs_msg(struct super_block *sb, const char *level, const char *fmt,
-		 ...)
+void __nilfs_msg(struct super_block *sb, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
+	int level;
 
 	va_start(args, fmt);
-	vaf.fmt = fmt;
+
+	level = printk_get_level(fmt);
+	vaf.fmt = printk_skip_level(fmt);
 	vaf.va = &args;
+
 	if (sb)
-		printk("%sNILFS (%s): %pV\n", level, sb->s_id, &vaf);
+		printk("%c%cNILFS (%s): %pV\n",
+		       KERN_SOH_ASCII, level, sb->s_id, &vaf);
 	else
-		printk("%sNILFS: %pV\n", level, &vaf);
+		printk("%c%cNILFS: %pV\n",
+		       KERN_SOH_ASCII, level, &vaf);
+
 	va_end(args);
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch


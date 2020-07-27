Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0053EC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 19:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8B0920759
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 19:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595879822;
	bh=DrxnG1u+EWG0OYXkdsERDBRxFiFvVw5lhgIa9w4TErs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=xIrzvLl2zQJauwCz1ZuTwHb6yweDA1XsDfGAnCxOtK8SyyRmWcqGvgeJD0+TnKZ9M
	 MnLb5IS7pFNJEw9TCxwoxme8aY1tngTd+nBUCm/ngYtXzH0tPAIgyahqdRitQFV2Iy
	 r9wbYFmkRM8CP1yjS3TL4XMXBYEIAsJHTWPYN/gM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgG0T5C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 15:57:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728867AbgG0T5C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 15:57:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDA932074F;
        Mon, 27 Jul 2020 19:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595879821;
        bh=DrxnG1u+EWG0OYXkdsERDBRxFiFvVw5lhgIa9w4TErs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=alP02lxng9GzQa2RJ7JOkCOT968pQkJO3eNDP7n16+q8mWYXRPf6Sa4VxZ5A9VhDs
         4f6C2wB0tiVAmW4st0m8U6jL0UZxLQOweLhNlXLdsd6x41Y8X9cAWVy1dtS1WdrXAd
         iuIubRC5rDeNNXGmcMCiR3RChV5fY7jfXiD9TNrE=
Date:   Mon, 27 Jul 2020 12:57:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     joe@perches.com, konishi.ryusuke@gmail.com,
        mm-commits@vger.kernel.org
Subject:  +
 nilfs2-convert-__nilfs_msg-to-integrate-the-level-and-format.patch added to
 -mm tree
Message-ID: <20200727195700.RCNZqxWEM%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: Convert __nilfs_msg to integrate the level and format
has been added to the -mm tree.  Its filename is
     nilfs2-convert-__nilfs_msg-to-integrate-the-level-and-format.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-convert-__nilfs_msg-to-integrate-the-level-and-format.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-convert-__nilfs_msg-to-integrate-the-level-and-format.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: nilfs2: Convert __nilfs_msg to integrate the level and format

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
const_structscheckpatch-add-regulator_ops.patch
checkpatch-add-test-for-possible-misuse-of-is_enabled-without-config_.patch
checkpatch-add-fix-option-for-assign_in_if.patch
nilfs2-convert-__nilfs_msg-to-integrate-the-level-and-format.patch
nilfs2-use-a-more-common-logging-style.patch


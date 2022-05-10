Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6F4C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbiEJEX6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236222AbiEJEXL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C63E1C94D5
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E5A661770
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52D3C385C2;
        Tue, 10 May 2022 04:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156269;
        bh=K6fdA6OM/71/BR/jMc5LTe+OQMss1WJAbnUCJJheDD0=;
        h=Date:To:From:Subject:From;
        b=UGKLIlMi3eUz/CXwRLovVBHnKKQJNabH33iLJIKEEMRAbLzoS7y1AD5HWREQw1ydo
         DLNQzwaIP9NHAYu3cHKzDL4rsfzLDup+yQ6HT45PLTDQFjiP69a0GUgFGVtOIDiDwb
         IGg8vJJPMFoboizEqjBQQyznat4vyMipYLU9Nd6k=
Date:   Mon, 09 May 2022 21:17:49 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com,
        hirofumi@mail.parknet.co.jp, jof@thejof.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] add-fat-messages-to-printk-index.patch removed from -mm tree
Message-Id: <20220510041749.D52D3C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fatfs: add FAT messages to printk index
has been removed from the -mm tree.  Its filename was
     add-fat-messages-to-printk-index.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jonathan Lassoff <jof@thejof.com>
Subject: fatfs: add FAT messages to printk index

In order for end users to quickly react to new issues that come up in
production, it is proving useful to leverage the printk indexing system. 
This printk index enables kernel developers to use calls to printk() with
changeable ad-hoc format strings (as they always have; no change of
expectations), while enabling end users to examine format strings to
detect changes.

Since end users are using regular expressions to match messages printed
through printk(), being able to detect changes in chosen format strings
from release to release provides a useful signal to review
printk()-matching regular expressions for any necessary updates.

So that detailed FAT messages are captured by this printk index, this
patch wraps fat_msg with a macro.

[akpm@linux-foundation.org: coding-style cleanups]
Link: https://lkml.kernel.org/r/8aaa2dd7995e820292bb40d2120ab69756662c65.1648688136.git.jof@thejof.com
Signed-off-by: Jonathan Lassoff <jof@thejof.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h  |    9 ++++++++-
 fs/fat/misc.c |   14 ++++++++++----
 2 files changed, 18 insertions(+), 5 deletions(-)

--- a/fs/fat/fat.h~add-fat-messages-to-printk-index
+++ a/fs/fat/fat.h
@@ -433,8 +433,15 @@ void __fat_fs_error(struct super_block *
 	__fat_fs_error(sb, 1, fmt , ## args)
 #define fat_fs_error_ratelimit(sb, fmt, args...) \
 	__fat_fs_error(sb, __ratelimit(&MSDOS_SB(sb)->ratelimit), fmt , ## args)
+
+#define FAT_PRINTK_PREFIX "%sFAT-fs (%s): "
+#define fat_msg(sb, level, fmt, args...)				\
+do {									\
+	printk_index_subsys_emit(FAT_PRINTK_PREFIX, level, fmt, ##args);\
+	_fat_msg(sb, level, fmt, ##args);				\
+} while (0)
 __printf(3, 4) __cold
-void fat_msg(struct super_block *sb, const char *level, const char *fmt, ...);
+void _fat_msg(struct super_block *sb, const char *level, const char *fmt, ...);
 #define fat_msg_ratelimit(sb, level, fmt, args...)	\
 	do {	\
 			if (__ratelimit(&MSDOS_SB(sb)->ratelimit))	\
--- a/fs/fat/misc.c~add-fat-messages-to-printk-index
+++ a/fs/fat/misc.c
@@ -42,10 +42,16 @@ void __fat_fs_error(struct super_block *
 EXPORT_SYMBOL_GPL(__fat_fs_error);
 
 /**
- * fat_msg() - print preformated FAT specific messages. Every thing what is
- * not fat_fs_error() should be fat_msg().
+ * _fat_msg() - Print a preformatted FAT message based on a superblock.
+ * @sb: A pointer to a &struct super_block
+ * @level: A Kernel printk level constant
+ * @fmt: The printf-style format string to print.
+ *
+ * Everything that is not fat_fs_error() should be fat_msg().
+ *
+ * fat_msg() wraps _fat_msg() for printk indexing.
  */
-void fat_msg(struct super_block *sb, const char *level, const char *fmt, ...)
+void _fat_msg(struct super_block *sb, const char *level, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -53,7 +59,7 @@ void fat_msg(struct super_block *sb, con
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk("%sFAT-fs (%s): %pV\n", level, sb->s_id, &vaf);
+	_printk(FAT_PRINTK_PREFIX "%pV\n", level, sb->s_id, &vaf);
 	va_end(args);
 }
 
_

Patches currently in -mm which might be from jof@thejof.com are



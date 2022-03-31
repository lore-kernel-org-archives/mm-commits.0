Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5866C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 01:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245534AbiCaBnR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Mar 2022 21:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiCaBnQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Mar 2022 21:43:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED6C483A5
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 18:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5B062CE1F58
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 01:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8158CC340EC;
        Thu, 31 Mar 2022 01:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648690886;
        bh=t+UoJtNB4FRDIqQzwONmYvZNkfGbiFhl7w0Cc7lK9GU=;
        h=Date:To:From:Subject:From;
        b=B6Iem3eoIuM4nR7j3EgnLrOdZYo/VAPYWeFs5aw5L1KcM9Mo5bs9+gP+93/P3Q3IG
         a+gNovuMPEeuW2Ohtku7DvrkCyz6502hJV23CgIZv8Dmo0kJiwUqt8FdAX175VHTJk
         edHKIqnAhn4E8wZ56yD2ueFqXjiYDLiHfS4+lckk=
Date:   Wed, 30 Mar 2022 18:41:25 -0700
To:     mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp,
        jof@thejof.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + add-fat-messages-to-printk-index.patch added to -mm tree
Message-Id: <20220331014126.8158CC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fatfs: add FAT messages to printk index
has been added to the -mm tree.  Its filename is
     add-fat-messages-to-printk-index.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/add-fat-messages-to-printk-index.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/add-fat-messages-to-printk-index.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jonathan Lassoff <jof@thejof.com>
Subject: fatfs: add FAT messages to printk index

In order for end users to quickly react to new issues that come up in
production, it is proving useful to leverage the printk indexing system. 
This printk index enables kernel developers to use calls to printk() with
changable ad-hoc format strings (as they always have; no change of
expectations), while enabling end users to examine format strings to
detect changes.

Since end users are using regular expressions to match messages printed
through printk(), being able to detect changes in chosen format strings
from release to release provides a useful signal to review
printk()-matching regular expressions for any necessary updates.

So that detailed FAT messages are captured by this printk index, this
patch wraps fat_msg with a macro.

Link: https://lkml.kernel.org/r/8aaa2dd7995e820292bb40d2120ab69756662c65.1648688136.git.jof@thejof.com
Signed-off-by: Jonathan Lassoff <jof@thejof.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
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
+} while(0)
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

add-fat-messages-to-printk-index.patch


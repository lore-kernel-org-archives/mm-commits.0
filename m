Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B00BC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 18:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347361AbiFCShh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347573AbiFCShI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 14:37:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015B21E3DB
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 11:32:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94A136194E
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 18:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AF4C385A9;
        Fri,  3 Jun 2022 18:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654281153;
        bh=RS8blxvAFTbjaZx/Z8gngASa4ipLnJCCM8wlxo3ktqk=;
        h=Date:To:From:Subject:From;
        b=p1QQNMDoi9XeNQPZ3J9dt016qX/McaNgx62SWVFVhhe6fLsxRnvzTE1NYTawUuxH8
         pzgFJI6UY4nOyMlortrvNUd/W4dBh2/OO3ncCu+fh04HOQXE9iCrmy1CBL6R5AayMb
         pYttBk/FZDrwgypU0h6uUhryIZt+ZTUf95QHz4tc=
Date:   Fri, 03 Jun 2022 11:32:32 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernelh-move-sysfs-related-macro-to-sysfsh.patch added to mm-nonmm-unstable branch
Message-Id: <20220603183232.E9AF4C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: move sysfs related macro to sysfs.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernelh-move-sysfs-related-macro-to-sysfsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernelh-move-sysfs-related-macro-to-sysfsh.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kernel.h: move sysfs related macro to sysfs.h
Date: Fri, 3 Jun 2022 20:21:01 +0300

As stated in the comment of VERIFY_OCTAL_PERMISSIONS() it's related to
sysfs.  Move it to the corresponding header.

Link: https://lkml.kernel.org/r/20220603172101.49950-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   12 ------------
 include/linux/sysfs.h  |   13 +++++++++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

--- a/include/linux/kernel.h~kernelh-move-sysfs-related-macro-to-sysfsh
+++ a/include/linux/kernel.h
@@ -496,16 +496,4 @@ static inline void ftrace_dump(enum ftra
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
 #endif
 
-/* Permissions on a sysfs file: you didn't miss the 0 prefix did you? */
-#define VERIFY_OCTAL_PERMISSIONS(perms)						\
-	(BUILD_BUG_ON_ZERO((perms) < 0) +					\
-	 BUILD_BUG_ON_ZERO((perms) > 0777) +					\
-	 /* USER_READABLE >= GROUP_READABLE >= OTHER_READABLE */		\
-	 BUILD_BUG_ON_ZERO((((perms) >> 6) & 4) < (((perms) >> 3) & 4)) +	\
-	 BUILD_BUG_ON_ZERO((((perms) >> 3) & 4) < ((perms) & 4)) +		\
-	 /* USER_WRITABLE >= GROUP_WRITABLE */					\
-	 BUILD_BUG_ON_ZERO((((perms) >> 6) & 2) < (((perms) >> 3) & 2)) +	\
-	 /* OTHER_WRITABLE?  Generally considered a bad idea. */		\
-	 BUILD_BUG_ON_ZERO((perms) & 2) +					\
-	 (perms))
 #endif
--- a/include/linux/sysfs.h~kernelh-move-sysfs-related-macro-to-sysfsh
+++ a/include/linux/sysfs.h
@@ -98,6 +98,19 @@ struct attribute_group {
 
 #define SYSFS_PREALLOC 010000
 
+/* Permissions on a sysfs file: you didn't miss the 0 prefix did you? */
+#define VERIFY_OCTAL_PERMISSIONS(perms)						\
+	(BUILD_BUG_ON_ZERO((perms) < 0) +					\
+	 BUILD_BUG_ON_ZERO((perms) > 0777) +					\
+	 /* USER_READABLE >= GROUP_READABLE >= OTHER_READABLE */		\
+	 BUILD_BUG_ON_ZERO((((perms) >> 6) & 4) < (((perms) >> 3) & 4)) +	\
+	 BUILD_BUG_ON_ZERO((((perms) >> 3) & 4) < ((perms) & 4)) +		\
+	 /* USER_WRITABLE >= GROUP_WRITABLE */					\
+	 BUILD_BUG_ON_ZERO((((perms) >> 6) & 2) < (((perms) >> 3) & 2)) +	\
+	 /* OTHER_WRITABLE?  Generally considered a bad idea. */		\
+	 BUILD_BUG_ON_ZERO((perms) & 2) +					\
+	 (perms))
+
 #define __ATTR(_name, _mode, _show, _store) {				\
 	.attr = {.name = __stringify(_name),				\
 		 .mode = VERIFY_OCTAL_PERMISSIONS(_mode) },		\
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

rbtree-replace-kernelh-with-the-necessary-inclusions.patch
xarray-replace-kernelh-with-the-necessary-inclusions.patch
kernelh-move-sysfs-related-macro-to-sysfsh.patch


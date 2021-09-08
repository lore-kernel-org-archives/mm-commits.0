Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C285C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED4F861152
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347404AbhIHDBl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347322AbhIHDBh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:01:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B8076113C;
        Wed,  8 Sep 2021 03:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631070030;
        bh=V3Lsf9ju94cbEYISwW4POWlIza6cbQEJotoBWZoo3yU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jwV7IW3VYIW6ByPzFil0hSkQK8jb9TUgyFXPqnp7bEKCeXBGGW8ojSPixX+nUy52h
         m6CF7sD3SPYNGS4YnNLvvQZd5tLX/XokAh5iabBvcfN10NmS9y+Koe2EUNfbaM2ofF
         OjS2opIWI6dLYE1aIFGERiq3Q+zR/bqf0hYp18C8=
Date:   Tue, 07 Sep 2021 20:00:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david.oberhollenzer@sigma-star.at,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 137/147] fs/coredump.c: log if a core dump is
 aborted due to changed file permissions
Message-ID: <20210908030029.TAOch83kD%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Oberhollenzer <david.oberhollenzer@sigma-star.at>
Subject: fs/coredump.c: log if a core dump is aborted due to changed file permissions

For obvious security reasons, a core dump is aborted if the filesystem
cannot preserve ownership or permissions of the dump file.

This affects filesystems like e.g.  vfat, but also something like a 9pfs
share in a Qemu test setup, running as a regular user, depending on the
security model used.  In those cases, the result is an empty core file and
a confused user.

To hopefully safe other people a lot of time figuring out the cause, this
patch adds a simple log message for those specific cases.

[akpm@linux-foundation.org: s/|%s/%s/ in printk text]
Link: https://lkml.kernel.org/r/20210701233151.102720-1-david.oberhollenzer@sigma-star.at
Signed-off-by: David Oberhollenzer <david.oberhollenzer@sigma-star.at>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/coredump.c~log-if-a-core-dump-is-aborted-due-to-changed-file-permissions
+++ a/fs/coredump.c
@@ -782,10 +782,17 @@ void do_coredump(const kernel_siginfo_t
 		 * filesystem.
 		 */
 		mnt_userns = file_mnt_user_ns(cprm.file);
-		if (!uid_eq(i_uid_into_mnt(mnt_userns, inode), current_fsuid()))
+		if (!uid_eq(i_uid_into_mnt(mnt_userns, inode),
+			    current_fsuid())) {
+			pr_info_ratelimited("Core dump to %s aborted: cannot preserve file owner\n",
+					    cn.corename);
 			goto close_fail;
-		if ((inode->i_mode & 0677) != 0600)
+		}
+		if ((inode->i_mode & 0677) != 0600) {
+			pr_info_ratelimited("Core dump to %s aborted: cannot preserve file permissions\n",
+					    cn.corename);
 			goto close_fail;
+		}
 		if (!(cprm.file->f_mode & FMODE_CAN_WRITE))
 			goto close_fail;
 		if (do_truncate(mnt_userns, cprm.file->f_path.dentry,
_

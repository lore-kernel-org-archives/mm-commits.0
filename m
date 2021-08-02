Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C32F7C432BE
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 21:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A20AD6101D
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 21:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhHBVko (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232758AbhHBVko (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Aug 2021 17:40:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E29760F4B;
        Mon,  2 Aug 2021 21:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627940433;
        bh=B5Ju5H13DTJI1rNYPehpJrqPSqis3hsSlCMQeV4I9uE=;
        h=Date:From:To:Subject:From;
        b=Mk3fLUTmpYp7Wa+P0rIes700HzU1dv1KTP2Xme/eAJOpn40/MAZ+Cu6CX6mn1NUjp
         pM5GG0tr2++Zsq1JL5QuvQ5skw/JAP4x71EbelQV+wIN9prFLeQK9vvIIGO124Xrgk
         JDFULnEDtF+2paFquftDiP0OQZ1DHbCJtxgkliCY=
Date:   Mon, 02 Aug 2021 14:40:33 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        david.oberhollenzer@sigma-star.at
Subject:  +
 log-if-a-core-dump-is-aborted-due-to-changed-file-permissions.patch added to
 -mm tree
Message-ID: <20210802214033.Th0Zk%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/coredump.c: log if a core dump is aborted due to changed file permissions
has been added to the -mm tree.  Its filename is
     log-if-a-core-dump-is-aborted-due-to-changed-file-permissions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/log-if-a-core-dump-is-aborted-due-to-changed-file-permissions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/log-if-a-core-dump-is-aborted-due-to-changed-file-permissions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
+			pr_info_ratelimited("Core dump to |%s aborted: cannot preserve file owner\n",
+					    cn.corename);
 			goto close_fail;
-		if ((inode->i_mode & 0677) != 0600)
+		}
+		if ((inode->i_mode & 0677) != 0600) {
+			pr_info_ratelimited("Core dump to |%s aborted: cannot preserve file permissions\n",
+					    cn.corename);
 			goto close_fail;
+		}
 		if (!(cprm.file->f_mode & FMODE_CAN_WRITE))
 			goto close_fail;
 		if (do_truncate(mnt_userns, cprm.file->f_path.dentry,
_

Patches currently in -mm which might be from david.oberhollenzer@sigma-star.at are

log-if-a-core-dump-is-aborted-due-to-changed-file-permissions.patch


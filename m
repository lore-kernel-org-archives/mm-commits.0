Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CDFC4332F
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2011611EE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhIIVGy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347076AbhIIVG1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86277611C1;
        Thu,  9 Sep 2021 21:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221517;
        bh=XJK4mpoFkpJSMbAi8tPMwBfDB5JmCdA6Lr3Mec4E9NI=;
        h=Date:From:To:Subject:From;
        b=KST7rFjhMzobb+CpiliDXznddjZ5dE4fBbeL390SQyspv6WFlXAiz47s/ew3v/AjR
         sRCLOjGuZ8r5SrhLt7ecD6Jk/UHEmHB02vKskKytfy+qRfKnhEtUZ9+dktqcIkv+UZ
         yIMDnDCIqIaGu52AYi2t09PDnOK8xDRCJ9zgH0NI=
Date:   Thu, 09 Sep 2021 14:05:17 -0700
From:   akpm@linux-foundation.org
To:     david.oberhollenzer@sigma-star.at, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 log-if-a-core-dump-is-aborted-due-to-changed-file-permissions.patch removed
 from -mm tree
Message-ID: <20210909210517.X7zqfD5JS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/coredump.c: log if a core dump is aborted due to changed file permissions
has been removed from the -mm tree.  Its filename was
     log-if-a-core-dump-is-aborted-due-to-changed-file-permissions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from david.oberhollenzer@sigma-star.at are



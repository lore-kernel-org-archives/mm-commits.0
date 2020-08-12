Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0D4C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D69F207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266321;
	bh=TeYqLK8zk1Bz6WOJKrXrVzLm8hw9FWYqxfdxMUE9CP0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SP66ZQ3XgvbvVIlj75P2QCPH48ZQI1yYtDCK0IT3HZnG/cIbbD+uuY73GfAevJ7CW
	 3M1isvo56TmItXkGFA+Xq5F+m4rT6C6Om2NmF8Yj6E8QOtG+s6Zm6RlsHb8bZD0GD5
	 xbf2X0N43ifldEiB1bDZH40c+/A5xODmxXw77FeE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgHLVFV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgHLVFU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:20 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B973920774;
        Wed, 12 Aug 2020 21:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266319;
        bh=TeYqLK8zk1Bz6WOJKrXrVzLm8hw9FWYqxfdxMUE9CP0=;
        h=Date:From:To:Subject:From;
        b=nj49M/uwaXuHNymqheLp/lxhNzhLQ+l2lZz4F733LuXl3NbOeZtBmZN+3VZcCnXGt
         lddHZ75P0OkBVrS/iAGzpSOvUBdzCvWO+1Ger1nr9V6k6UbabX+wUeA4EpoaInppvR
         s833mR5ILlbXe8FxHv2Aei7c93NFSxDfziTJkfZw=
Date:   Wed, 12 Aug 2020 14:05:18 -0700
From:   akpm@linux-foundation.org
To:     christian.brauner@ubuntu.com, cyphar@cyphar.com,
        dvyukov@google.com, ebiggers3@gmail.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        viro@zeniv.linux.org.uk
Subject:  [merged] exec-move-s_isreg-check-earlier.patch removed
 from -mm tree
Message-ID: <20200812210518.IS3NXvRjH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: exec: move S_ISREG() check earlier
has been removed from the -mm tree.  Its filename was
     exec-move-s_isreg-check-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: exec: move S_ISREG() check earlier

The execve(2)/uselib(2) syscalls have always rejected non-regular files. 
Recently, it was noticed that a deadlock was introduced when trying to
execute pipes, as the S_ISREG() test was happening too late.  This was
fixed in commit 73601ea5b7b1 ("fs/open.c: allow opening only regular files
during execve()"), but it was added after inode_permission() had already
run, which meant LSMs could see bogus attempts to execute non-regular
files.

Move the test into the other inode type checks (which already look for
other pathological conditions[1]).  Since there is no need to use
FMODE_EXEC while we still have access to "acc_mode", also switch the test
to MAY_EXEC.

Also include a comment with the redundant S_ISREG() checks at the end of
execve(2)/uselib(2) to note that they are present to avoid any mistakes.

My notes on the call path, and related arguments, checks, etc:

do_open_execat()
    struct open_flags open_exec_flags = {
        .open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
        .acc_mode = MAY_EXEC,
        ...
    do_filp_open(dfd, filename, open_flags)
        path_openat(nameidata, open_flags, flags)
            file = alloc_empty_file(open_flags, current_cred());
            do_open(nameidata, file, open_flags)
                may_open(path, acc_mode, open_flag)
		    /* new location of MAY_EXEC vs S_ISREG() test */
                    inode_permission(inode, MAY_OPEN | acc_mode)
                        security_inode_permission(inode, acc_mode)
                vfs_open(path, file)
                    do_dentry_open(file, path->dentry->d_inode, open)
                        /* old location of FMODE_EXEC vs S_ISREG() test */
                        security_file_open(f)
                        open()

[1] https://lore.kernel.org/lkml/202006041910.9EF0C602@keescook/

Link: http://lkml.kernel.org/r/20200605160013.3954297-3-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers3@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c  |   14 ++++++++++++--
 fs/namei.c |    6 ++++--
 fs/open.c  |    6 ------
 3 files changed, 16 insertions(+), 10 deletions(-)

--- a/fs/exec.c~exec-move-s_isreg-check-earlier
+++ a/fs/exec.c
@@ -141,8 +141,13 @@ SYSCALL_DEFINE1(uselib, const char __use
 	if (IS_ERR(file))
 		goto out;
 
+	/*
+	 * may_open() has already checked for this, so it should be
+	 * impossible to trip now. But we need to be extra cautious
+	 * and check again at the very end too.
+	 */
 	error = -EACCES;
-	if (!S_ISREG(file_inode(file)->i_mode))
+	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)))
 		goto exit;
 
 	if (path_noexec(&file->f_path))
@@ -908,8 +913,13 @@ static struct file *do_open_execat(int f
 	if (IS_ERR(file))
 		goto out;
 
+	/*
+	 * may_open() has already checked for this, so it should be
+	 * impossible to trip now. But we need to be extra cautious
+	 * and check again at the very end too.
+	 */
 	err = -EACCES;
-	if (!S_ISREG(file_inode(file)->i_mode))
+	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)))
 		goto exit;
 
 	if (path_noexec(&file->f_path))
--- a/fs/namei.c~exec-move-s_isreg-check-earlier
+++ a/fs/namei.c
@@ -2849,16 +2849,18 @@ static int may_open(const struct path *p
 	case S_IFLNK:
 		return -ELOOP;
 	case S_IFDIR:
-		if (acc_mode & MAY_WRITE)
+		if (acc_mode & (MAY_WRITE | MAY_EXEC))
 			return -EISDIR;
 		break;
 	case S_IFBLK:
 	case S_IFCHR:
 		if (!may_open_dev(path))
 			return -EACCES;
-		/*FALLTHRU*/
+		fallthrough;
 	case S_IFIFO:
 	case S_IFSOCK:
+		if (acc_mode & MAY_EXEC)
+			return -EACCES;
 		flag &= ~O_TRUNC;
 		break;
 	}
--- a/fs/open.c~exec-move-s_isreg-check-earlier
+++ a/fs/open.c
@@ -779,12 +779,6 @@ static int do_dentry_open(struct file *f
 		return 0;
 	}
 
-	/* Any file opened for execve()/uselib() has to be a regular file. */
-	if (unlikely(f->f_flags & FMODE_EXEC && !S_ISREG(inode->i_mode))) {
-		error = -EACCES;
-		goto cleanup_file;
-	}
-
 	if (f->f_mode & FMODE_WRITE && !special_file(inode->i_mode)) {
 		error = get_write_access(inode);
 		if (unlikely(error))
_

Patches currently in -mm which might be from keescook@chromium.org are



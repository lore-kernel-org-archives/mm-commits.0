Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A48C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6218E2080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266323;
	bh=mDYr/HxLINQ50jO0VY8eWSlywjZWcpcvN9YZzzVhyjA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ZgtMqU1bE+PlCGF7jjACnpcL4eEdhpwEf3jBBF6l7R9XtFntm4d1LUCUqdj40nGZf
	 gvtHnhec+rjundE1trTwAIvYvfZFoRWZJwX02VaJweTJ0v+NsA3rHYQDTL4NiY/dGY
	 VgGrOpQQp3c3+TVoSXW6Wfk7XnIuhp/MLE4x3ZCM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgHLVFX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgHLVFX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:23 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1221207F7;
        Wed, 12 Aug 2020 21:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266322;
        bh=mDYr/HxLINQ50jO0VY8eWSlywjZWcpcvN9YZzzVhyjA=;
        h=Date:From:To:Subject:From;
        b=vrEjugokNuZu09iZ1KT5RrsIonBNgMPE8TzuTLtApXwtwUkIvTzESONhPeNJlIvKm
         XZsdytcI5TcFGapzoOv6rFR40QBjWLi2XnQsHcpUA3od59VKu8NLzE1OuyYdf0DTJL
         QRkXHAgYP8uIIyjtaYdUBa47HbrZTD0Xb5f932mU=
Date:   Wed, 12 Aug 2020 14:05:21 -0700
From:   akpm@linux-foundation.org
To:     christian.brauner@ubuntu.com, cyphar@cyphar.com,
        dvyukov@google.com, ebiggers3@gmail.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        viro@zeniv.linux.org.uk
Subject:  [merged] exec-move-path_noexec-check-earlier.patch
 removed from -mm tree
Message-ID: <20200812210521.38pFtZMFe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: exec: move path_noexec() check earlier
has been removed from the -mm tree.  Its filename was
     exec-move-path_noexec-check-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: exec: move path_noexec() check earlier

The path_noexec() check, like the regular file check, was happening too
late, letting LSMs see impossible execve()s.  Check it earlier as well in
may_open() and collect the redundant fs/exec.c path_noexec() test under
the same robustness comment as the S_ISREG() check.

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
                    /* new location of MAY_EXEC vs path_noexec() test */
                    inode_permission(inode, MAY_OPEN | acc_mode)
                        security_inode_permission(inode, acc_mode)
                vfs_open(path, file)
                    do_dentry_open(file, path->dentry->d_inode, open)
                        security_file_open(f)
                        open()
    /* old location of path_noexec() test */

Link: http://lkml.kernel.org/r/20200605160013.3954297-4-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers3@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c  |   12 ++++--------
 fs/namei.c |    4 ++++
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/fs/exec.c~exec-move-path_noexec-check-earlier
+++ a/fs/exec.c
@@ -147,10 +147,8 @@ SYSCALL_DEFINE1(uselib, const char __use
 	 * and check again at the very end too.
 	 */
 	error = -EACCES;
-	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)))
-		goto exit;
-
-	if (path_noexec(&file->f_path))
+	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
+			 path_noexec(&file->f_path)))
 		goto exit;
 
 	fsnotify_open(file);
@@ -919,10 +917,8 @@ static struct file *do_open_execat(int f
 	 * and check again at the very end too.
 	 */
 	err = -EACCES;
-	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)))
-		goto exit;
-
-	if (path_noexec(&file->f_path))
+	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
+			 path_noexec(&file->f_path)))
 		goto exit;
 
 	err = deny_write_access(file);
--- a/fs/namei.c~exec-move-path_noexec-check-earlier
+++ a/fs/namei.c
@@ -2863,6 +2863,10 @@ static int may_open(const struct path *p
 			return -EACCES;
 		flag &= ~O_TRUNC;
 		break;
+	case S_IFREG:
+		if ((acc_mode & MAY_EXEC) && path_noexec(path))
+			return -EACCES;
+		break;
 	}
 
 	error = inode_permission(inode, MAY_OPEN | acc_mode);
_

Patches currently in -mm which might be from keescook@chromium.org are



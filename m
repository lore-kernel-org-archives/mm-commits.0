Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBA1C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED1E56103C
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbhKKC4o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234622AbhKKC4o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F50660F46;
        Thu, 11 Nov 2021 02:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599235;
        bh=YRzBD6eiRthyeG5JOQZkaPNtf7NE0A8vcvigkFtYBhY=;
        h=Date:From:To:Subject:From;
        b=lI5p/IGm9pPiS5rjaFmrkqTm0jQ8hoOkTJTCDvKMM0IIlfobbpGvlVZf8p10NiAxd
         tux4yqnPb/pBDSP8fwBcksXWivx62/wpze0XlIQVCEqcgLl8oVAMe/kIDUG/LzeGd4
         u+7rVviPJpHaGLzWyyEXimZYBzHD159YcUyxehn8=
Date:   Wed, 10 Nov 2021 18:53:55 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, ebiederm@xmission.com, krisman@collabora.com,
        legion@kernel.org, mm-commits@vger.kernel.org,
        peterz@infradead.org, ran.xiaokai@zte.com.cn
Subject:  [merged] unshare-use-swap-to-make-code-cleaner.patch
 removed from -mm tree
Message-ID: <20211111025355.OuPPf4BRp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork.c: unshare(): use swap() to make code cleaner
has been removed from the -mm tree.  Its filename was
     unshare-use-swap-to-make-code-cleaner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: kernel/fork.c: unshare(): use swap() to make code cleaner

Use swap() instead of reimplementing it.

Link: https://lkml.kernel.org/r/20210909022046.8151-1-ran.xiaokai@zte.com.cn
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alexey Gladkov <legion@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/kernel/fork.c~unshare-use-swap-to-make-code-cleaner
+++ a/kernel/fork.c
@@ -3027,7 +3027,7 @@ int unshare_fd(unsigned long unshare_fla
 int ksys_unshare(unsigned long unshare_flags)
 {
 	struct fs_struct *fs, *new_fs = NULL;
-	struct files_struct *fd, *new_fd = NULL;
+	struct files_struct *new_fd = NULL;
 	struct cred *new_cred = NULL;
 	struct nsproxy *new_nsproxy = NULL;
 	int do_sysvsem = 0;
@@ -3114,11 +3114,8 @@ int ksys_unshare(unsigned long unshare_f
 			spin_unlock(&fs->lock);
 		}
 
-		if (new_fd) {
-			fd = current->files;
-			current->files = new_fd;
-			new_fd = fd;
-		}
+		if (new_fd)
+			swap(current->files, new_fd);
 
 		task_unlock(current);
 
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are



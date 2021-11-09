Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9B6C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B8E261381
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbhKICiI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:38:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:53580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237743AbhKICiI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:38:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9772A6137F;
        Tue,  9 Nov 2021 02:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425322;
        bh=lYyLnLUzjt+IxmgIR2Nk+9mu8Z8DWSmmZ87vpx6+u3k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=c699rOgr9MO2OC1wQNy9RC85LSc5NejY/1cCibW9a/briz6HWojGSuiaBio5Y+R1T
         j+pLu2eFsfhKp1Mikgn39ne0FPom3i8QJGmoIwPobtetVdIgdINm1obcHSl5T4ZBWY
         fo3qF3b7/bzZoniLqg5m08fNChE3ff6DhAW4ruW8=
Date:   Mon, 08 Nov 2021 18:35:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, ebiederm@xmission.com,
        krisman@collabora.com, legion@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        ran.xiaokai@zte.com.cn, torvalds@linux-foundation.org
Subject:  [patch 74/87] kernel/fork.c: unshare(): use swap() to
 make code cleaner
Message-ID: <20211109023522.1_gvxnX2r%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

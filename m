Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF356C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEFB160233
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhEHWwz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhEHWwy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9173260233;
        Sat,  8 May 2021 22:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514312;
        bh=LIpbsoDG+Yo8Bxv2a8IWylfFB9l3Tggmkoulg6+aViU=;
        h=Date:From:To:Subject:From;
        b=t5tq8YIrY/KIRF0jZ5fa6cKsFDzLiOqyRdjb5ZfqMzUZ+P5aEaP78cVA5N+HMHKyf
         MmnCCZn6F+RjamwT1pnXl545SynYBXVJmS86yscUDr1FYo7tX4yf1H6gimW283llrc
         3lcrrqQcHwjw1wnTGzzz5/Uzp81YGWbThUhNRsM8=
Date:   Sat, 08 May 2021 15:51:52 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, gladkov.alexey@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged] proc-delete-redundant-subset=pid-check.patch
 removed from -mm tree
Message-ID: <20210508225152.bqYenucM1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: delete redundant subset=pid check
has been removed from the -mm tree.  Its filename was
     proc-delete-redundant-subset=pid-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: delete redundant subset=pid check

Two checks in lookup and readdir code should be enough to not have third
check in open code.

Can't open what can't be looked up?

Link: https://lkml.kernel.org/r/YFYYwIBIkytqnkxP@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Alexey Gladkov <gladkov.alexey@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/proc/inode.c~proc-delete-redundant-subset=pid-check
+++ a/fs/proc/inode.c
@@ -483,7 +483,6 @@ proc_reg_get_unmapped_area(struct file *
 
 static int proc_reg_open(struct inode *inode, struct file *file)
 {
-	struct proc_fs_info *fs_info = proc_sb_info(inode->i_sb);
 	struct proc_dir_entry *pde = PDE(inode);
 	int rv = 0;
 	typeof_member(struct proc_ops, proc_open) open;
@@ -497,9 +496,6 @@ static int proc_reg_open(struct inode *i
 		return rv;
 	}
 
-	if (fs_info->pidonly == PROC_PIDONLY_ON)
-		return -ENOENT;
-
 	/*
 	 * Ensure that
 	 * 1) PDE's ->release hook will be called no matter what
_

Patches currently in -mm which might be from adobriyan@gmail.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6B7C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE53C61920
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhC1WO4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:14:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231205AbhC1WOz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:14:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 916D76191C;
        Sun, 28 Mar 2021 22:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616969695;
        bh=ovazuPUMPaXdAtXRlKHT/cH8iOFLe/Vh0NhVFYXbBHo=;
        h=Date:From:To:Subject:From;
        b=nuUTxKIhy/dU9U7hnZwncb6Dp5CtcPTr9PIXWp5S/LxHPVSFA/9JVvoCVDzzcHyp3
         oti6UYThlWgbAhZ+edMuW6RUkiooQk6zJDfpvoT+M4Pvh7mB3g8ZGuXRuFMwNvRdwN
         cVrHtHjzvuTBB2R3PJ50BiE3mtDvEs3qyBSfNXaU=
Date:   Sun, 28 Mar 2021 15:14:55 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, gladkov.alexey@gmail.com,
        mm-commits@vger.kernel.org
Subject:  + proc-delete-redundant-subset=pid-check.patch added to
 -mm tree
Message-ID: <20210328221455.tUUEiKBWy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: delete redundant subset=pid check
has been added to the -mm tree.  Its filename is
     proc-delete-redundant-subset=pid-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-delete-redundant-subset%3Dpid-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-delete-redundant-subset%3Dpid-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -493,7 +493,6 @@ proc_reg_get_unmapped_area(struct file *
 
 static int proc_reg_open(struct inode *inode, struct file *file)
 {
-	struct proc_fs_info *fs_info = proc_sb_info(inode->i_sb);
 	struct proc_dir_entry *pde = PDE(inode);
 	int rv = 0;
 	typeof_member(struct proc_ops, proc_open) open;
@@ -507,9 +506,6 @@ static int proc_reg_open(struct inode *i
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

proc-delete-redundant-subset=pid-check.patch
proc-test-subset=pid.patch


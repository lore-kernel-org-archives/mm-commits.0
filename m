Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B46C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED278610FA
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhEGBDT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233982AbhEGBDS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:03:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C3DC610FA;
        Fri,  7 May 2021 01:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349339;
        bh=9L+ljA+NlZn0Wxzg+hqmrQsBM6yHnu6d0idefJNZQVg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pSzbLDGtBNg4COCBI54pXzw+EexYyCMsjNrk3DgO9dI9A7zJ+Lcm8viFH72dYsd+4
         PT8zwulPpgo2P/GPSzk55N2VkxeYD1z3jdIqqlXZr2q4r0L6Xf/JMIE62i2okKekvZ
         wPWj42ETOASEPglwt8rwQy59oc8wEO5CWyfkfIOQ=
Date:   Thu, 06 May 2021 18:02:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        gladkov.alexey@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 06/91] proc: delete redundant subset=pid check
Message-ID: <20210507010218.wNSDkfLoo%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

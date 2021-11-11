Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86F7C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4446619E2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbhKKC4l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234621AbhKKC4l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B01B3610A2;
        Thu, 11 Nov 2021 02:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599232;
        bh=YezsZGblhY8yG3FC1KjlxnYdXsvQidQ4u4TiyKYiq6k=;
        h=Date:From:To:Subject:From;
        b=RErYgpuzjq1M+PbaQoY5FFfgzodxSeM3b2B1swwXkPpqVHu+vnHkilwqto51bWmpn
         6sSg0rY71Who5voYLvoS1o0dqz2hE4rFestVNUKH423dJKYs/0ELn2PLMED44UHxHk
         ALKMYtJk5Oh40llwFQ5DwXjVkulVlJfl6YqoXj1Y=
Date:   Wed, 10 Nov 2021 18:53:52 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, andriy.shevchenko@linux.intel.com,
        christian.brauner@ubuntu.com, mm-commits@vger.kernel.org,
        revest@chromium.org, sfr@canb.auug.org.au, songmuchun@bytedance.com
Subject:  [merged] seq_file-fix-passing-wrong-private-data.patch
 removed from -mm tree
Message-ID: <20211111025352.l5K1a1aIU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file: fix passing wrong private data
has been removed from the -mm tree.  Its filename was
     seq_file-fix-passing-wrong-private-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: seq_file: fix passing wrong private data

DEFINE_PROC_SHOW_ATTRIBUTE() is supposed to be used to define a series
of functions and variables to register proc file easily. And the users
can use proc_create_data() to pass their own private data and get it
via seq->private in the callback. Unfortunately, the proc file system
use PDE_DATA() to get private data instead of inode->i_private. So fix
it. Fortunately, there only one user of it which does not pass any
private data, so this bug does not break any in-tree codes.

Link: https://lkml.kernel.org/r/20211029032638.84884-1-songmuchun@bytedance.com
Fixes: 97a32539b956 ("proc: convert everything to "struct proc_ops"")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Florent Revest <revest@chromium.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/seq_file.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/seq_file.h~seq_file-fix-passing-wrong-private-data
+++ a/include/linux/seq_file.h
@@ -209,7 +209,7 @@ static const struct file_operations __na
 #define DEFINE_PROC_SHOW_ATTRIBUTE(__name)				\
 static int __name ## _open(struct inode *inode, struct file *file)	\
 {									\
-	return single_open(file, __name ## _show, inode->i_private);	\
+	return single_open(file, __name ## _show, PDE_DATA(inode));	\
 }									\
 									\
 static const struct proc_ops __name ## _proc_ops = {			\
_

Patches currently in -mm which might be from songmuchun@bytedance.com are



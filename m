Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38299C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Oct 2021 22:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 049F561038
	for <mm-commits@archiver.kernel.org>; Fri, 29 Oct 2021 22:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhJ2WTz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Oct 2021 18:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230325AbhJ2WTy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 29 Oct 2021 18:19:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFC9060FDA;
        Fri, 29 Oct 2021 22:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635545845;
        bh=1lj8WNhvfjfiR0ZcRwowwLslHQ8kHbyqUKxJB87QmCs=;
        h=Date:From:To:Subject:From;
        b=rrbYIcOtvozckhfQnlocdtcUcRsojkD3XTsUgurQtroaSClyQ6cmeVc5fFD2niPDg
         dTTpis29KQgsalLhB7jHZsr355C/kF6afeCNjNkjVLMgXLZFSKsf8atQhyIbU8kMhR
         GQBE1BNAh3gCT5eVqzjo3IOnN67CsSdG4LAoUlwY=
Date:   Fri, 29 Oct 2021 15:17:24 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, andriy.shevchenko@linux.intel.com,
        christian.brauner@ubuntu.com, mm-commits@vger.kernel.org,
        revest@chromium.org, sfr@canb.auug.org.au, songmuchun@bytedance.com
Subject:  + seq_file-fix-passing-wrong-private-data.patch added to
 -mm tree
Message-ID: <20211029221724.GcJ6E35MS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file: fix passing wrong private data
has been added to the -mm tree.  Its filename is
     seq_file-fix-passing-wrong-private-data.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/seq_file-fix-passing-wrong-private-data.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/seq_file-fix-passing-wrong-private-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-list_lru-remove-holding-lru-lock.patch
mm-list_lru-fix-the-return-value-of-list_lru_count_one.patch
mm-memcontrol-remove-kmemcg_id-reparenting.patch
mm-memcontrol-remove-the-kmem-states.patch
mm-list_lru-only-add-memcg-aware-lrus-to-the-global-lru-list.patch
seq_file-fix-passing-wrong-private-data.patch


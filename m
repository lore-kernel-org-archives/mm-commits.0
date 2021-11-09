Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BA2C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01EE7614C8
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238104AbhKICiF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:38:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237743AbhKICiF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:38:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F35461360;
        Tue,  9 Nov 2021 02:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425319;
        bh=4m/9it/qoKLdrA83lbpAfV0YEspJ+kRur+ACqIJhMOc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0EPaqoaQLPdcy2dIu47ycuGpnqKyIXNjjrH5IdjCnfM4pjv54La/WKU9dxqCvCexG
         DDZYSel+yMPjVtfxzkQaURqPLD1P7PvHowLWUBsL4LNPhQuIj/fSv2fzR6qI8WDcie
         ChKRC+ji9osQioDmEVuejHxwNNR/34+aCTGjjzAQ=
Date:   Mon, 08 Nov 2021 18:35:19 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, christian.brauner@ubuntu.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        revest@chromium.org, sfr@canb.auug.org.au,
        songmuchun@bytedance.com, torvalds@linux-foundation.org
Subject:  [patch 73/87] seq_file: fix passing wrong private data
Message-ID: <20211109023519.9dvm6-aET%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

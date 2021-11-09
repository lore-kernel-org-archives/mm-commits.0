Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5CCC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44ECB61288
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbhKIChW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhKIChW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 053F361207;
        Tue,  9 Nov 2021 02:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425277;
        bh=gLOMIN8QQZcN06BJDTzjdGTz5NM4BPZ96ixKcmC+c9s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Iea/4qkPMyCDl2KyFNxgiCsXD/yf+vgK59y86cqrdpToBbgbXVrmSvoDscxAKlDAt
         1EHBr+X0hgug4ymzWsigHO+Hem83v0XE4cObX1oyKExDRNNX0SMMZQgzIqvnL9NQmh
         DuLqw49WluTN8v34AoBWmV9clpe7I6/IyRJEya1w=
Date:   Mon, 08 Nov 2021 18:34:36 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        jaharkes@cs.cmu.edu, jing.yangyang@zte.com.cn, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tanxin.ctf@gmail.com,
        torvalds@linux-foundation.org, xiyuyang19@fudan.edu.cn,
        zealci@zte.com.cn
Subject:  [patch 59/87] coda: remove err which no one care
Message-ID: <20211109023436.brvXunALu%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: coda: remove err which no one care

No one care 'err' in func coda_release, so better remove it.

Link: https://lkml.kernel.org/r/20210908140308.18491-4-jaharkes@cs.cmu.edu
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Jing Yangyang <jing.yangyang@zte.com.cn>
Cc: Xin Tan <tanxin.ctf@gmail.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/file.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/coda/file.c~coda-remove-err-which-no-one-care
+++ a/fs/coda/file.c
@@ -238,11 +238,10 @@ int coda_release(struct inode *coda_inod
 	struct coda_file_info *cfi;
 	struct coda_inode_info *cii;
 	struct inode *host_inode;
-	int err;
 
 	cfi = coda_ftoc(coda_file);
 
-	err = venus_close(coda_inode->i_sb, coda_i2f(coda_inode),
+	venus_close(coda_inode->i_sb, coda_i2f(coda_inode),
 			  coda_flags, coda_file->f_cred->fsuid);
 
 	host_inode = file_inode(cfi->cfi_container);
_

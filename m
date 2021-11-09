Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CA5C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 525CE6134F
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbhKIChZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhKIChZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14B0461284;
        Tue,  9 Nov 2021 02:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425280;
        bh=ohq+xby/Q0J2Nt4hZBVMMqzXY6qRlC7jQ6DICbM7idE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZLTHk9XKYTCTwdlgvBFrHNMi8CULZZaJxq08GGKwRSG5HGvnVfsaBqVyb04vFfyGg
         40neHvi41tis/wCDgROSAzrpOO7UKAvPsuVuEo531pgtHEeITwp/RPJWRMqF+7HJ/p
         3ExyCD9LArs/Q00f07tyaxYX7W08HB3ED9KU5YB8=
Date:   Mon, 08 Nov 2021 18:34:39 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        jaharkes@cs.cmu.edu, jing.yangyang@zte.com.cn, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tanxin.ctf@gmail.com,
        torvalds@linux-foundation.org, xiyuyang19@fudan.edu.cn,
        zealci@zte.com.cn
Subject:  [patch 60/87] coda: avoid flagging NULL inodes
Message-ID: <20211109023439.Ur2PyYjGa%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: coda: avoid flagging NULL inodes

Somehow we hit a negative dentry in coda_rename even after checking with
d_really_is_positive.  Maybe something raced and turned the new_dentry
negative while we were fixing up directory link counts.

Link: https://lkml.kernel.org/r/20210908140308.18491-5-jaharkes@cs.cmu.edu
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jing Yangyang <jing.yangyang@zte.com.cn>
Cc: Xin Tan <tanxin.ctf@gmail.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/coda_linux.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/coda/coda_linux.h~coda-avoid-flagging-null-inodes
+++ a/fs/coda/coda_linux.h
@@ -83,6 +83,9 @@ static __inline__ void coda_flag_inode(s
 {
 	struct coda_inode_info *cii = ITOC(inode);
 
+	if (!inode)
+		return;
+
 	spin_lock(&cii->c_lock);
 	cii->c_flags |= flag;
 	spin_unlock(&cii->c_lock);
_

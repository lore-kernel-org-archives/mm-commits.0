Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372FEC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2191A61279
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbhKIChQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhKIChQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D059A60FDA;
        Tue,  9 Nov 2021 02:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425271;
        bh=o6L0qY84f8UQYA5jUM1iA2bbMnRN6jRHWa+Qf2tMPvA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HVUwi3iV3z75mSQR9v03b/WAbqqQlBBAMm4FY7yoiwew5LBLEumpeU4v/SA1p4n2Y
         U6sjfac1HyTR6y3A8dzsVn8jKyoNc0NwIij8irwaM5Og3hzGvLez7/PRkP6z4pEVaR
         HE099ybrHPyKPyGxkBgSU86Wcx8CGooIV/195XSw=
Date:   Mon, 08 Nov 2021 18:34:30 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        jaharkes@cs.cmu.edu, jing.yangyang@zte.com.cn, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tanxin.ctf@gmail.com,
        torvalds@linux-foundation.org, xiyuyang19@fudan.edu.cn,
        zealci@zte.com.cn
Subject:  [patch 57/87] coda: avoid NULL pointer dereference from a
 bad inode
Message-ID: <20211109023430.7SI-sYBYi%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: coda: avoid NULL pointer dereference from a bad inode

Patch series "Coda updates for -next".

The following patch series contains some fixes for the Coda kernel module
I've had sitting around and were tested extensively in a development
version of the Coda kernel module that lives outside of the main kernel.


This patch (of 9):

Avoid accessing coda_inode_info from a dentry with a bad inode.

Link: https://lkml.kernel.org/r/20210908140308.18491-1-jaharkes@cs.cmu.edu
Link: https://lkml.kernel.org/r/20210908140308.18491-2-jaharkes@cs.cmu.edu
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jing Yangyang <jing.yangyang@zte.com.cn>
Cc: Xin Tan <tanxin.ctf@gmail.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/dir.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/coda/dir.c~coda-avoid-null-pointer-dereference-from-a-bad-inode
+++ a/fs/coda/dir.c
@@ -499,15 +499,20 @@ out:
  */
 static int coda_dentry_delete(const struct dentry * dentry)
 {
-	int flags;
+	struct inode *inode;
+	struct coda_inode_info *cii;
 
 	if (d_really_is_negative(dentry)) 
 		return 0;
 
-	flags = (ITOC(d_inode(dentry))->c_flags) & C_PURGE;
-	if (is_bad_inode(d_inode(dentry)) || flags) {
+	inode = d_inode(dentry);
+	if (!inode || is_bad_inode(inode))
 		return 1;
-	}
+
+	cii = ITOC(inode);
+	if (cii->c_flags & C_PURGE)
+		return 1;
+
 	return 0;
 }
 
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C81C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6465C6134F
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbhKICh2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhKICh2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A3A561242;
        Tue,  9 Nov 2021 02:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425283;
        bh=zMJcG0nuHewLpQ75CcsO1skQByWm603LY1upCCbzezA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=v4cmjmOO/sG1AXllp44CjkyzGX0wJyG7VHqPPeERl/QM6Zg1Gq+inH3I7HUF2oA+2
         HdJQ/h/pgFvEkT2A3MXgiWzYxFKAKKo9LtOuG+TeqviovVpwviUpOZTYa0g6WHSs9P
         M/ikEODsRoQ9KLIo72gbv6Vn9B7ggSufKpJAWPf8=
Date:   Mon, 08 Nov 2021 18:34:42 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        jaharkes@cs.cmu.edu, jing.yangyang@zte.com.cn, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tanxin.ctf@gmail.com,
        torvalds@linux-foundation.org, xiyuyang19@fudan.edu.cn,
        zealci@zte.com.cn
Subject:  [patch 61/87] coda: avoid hidden code duplication in
 rename
Message-ID: <20211109023442.IbI4EeksA%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: coda: avoid hidden code duplication in rename

We were actually fixing up the directory mtime in both branches after the
negative dentry test, it was just that one branch was only flagging the
directory inodes to refresh their attributes while the other branch used
the optional optimization to set mtime to the current time and not go back
to the Coda client.

Link: https://lkml.kernel.org/r/20210908140308.18491-6-jaharkes@cs.cmu.edu
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jing Yangyang <jing.yangyang@zte.com.cn>
Cc: Xin Tan <tanxin.ctf@gmail.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/dir.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/coda/dir.c~coda-avoid-hidden-code-duplication-in-rename
+++ a/fs/coda/dir.c
@@ -317,13 +317,10 @@ static int coda_rename(struct user_names
 				coda_dir_drop_nlink(old_dir);
 				coda_dir_inc_nlink(new_dir);
 			}
-			coda_dir_update_mtime(old_dir);
-			coda_dir_update_mtime(new_dir);
 			coda_flag_inode(d_inode(new_dentry), C_VATTR);
-		} else {
-			coda_flag_inode(old_dir, C_VATTR);
-			coda_flag_inode(new_dir, C_VATTR);
 		}
+		coda_dir_update_mtime(old_dir);
+		coda_dir_update_mtime(new_dir);
 	}
 	return error;
 }
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA2DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1731B60F46
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbhKKC4L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234509AbhKKC4L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C2FE610A2;
        Thu, 11 Nov 2021 02:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599202;
        bh=rR5WnCnTPHzFFzXzi/M1aTJICZtAoJaQcPopx2alrXs=;
        h=Date:From:To:Subject:From;
        b=CYvFsPm/BJVcXHa17ndMuXBTwfpdj1tKUZA/BVkXUlJWMxOW1qR/yMGvsY0RMPsr8
         ATHHbFKuJQQzEbGUfyT6IiZVkH6kcw51LJe+EQ+xTWeWqQ/JL1oQpIPIMx0PReOFCn
         TxVFoT1TtyFiEg8+SYB4TK9689mj4LP8PnGYPzAk=
Date:   Wed, 10 Nov 2021 18:53:22 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  [merged]
 coda-avoid-hidden-code-duplication-in-rename.patch removed from -mm tree
Message-ID: <20211111025322.k3RbrCmEd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: avoid hidden code duplication in rename
has been removed from the -mm tree.  Its filename was
     coda-avoid-hidden-code-duplication-in-rename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are



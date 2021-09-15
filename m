Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B22C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5B0D61242
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbhIOD6f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:58:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236272AbhIOD6d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:58:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8DBC6103C;
        Wed, 15 Sep 2021 03:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631678235;
        bh=U1I/urwsFtRsoYsGEHCbFMvDBb3aM9UUujN+0kYpFSs=;
        h=Date:From:To:Subject:From;
        b=ax3n1fQz3l/xyyAy1b6Q21Gp6AYzySgZEHg4U1W+vpK4SejDCEMvZ2r9+ZWyEhoVE
         FSJnz6DKYGq07YtjL1pvcz84PiwMsCaPeAgUtB1vf5fwO+RdDk3h7onqhSjCjBr4zk
         RUcjcbbuDp772CEFWEEVbiLLJZ3j9eIhicDD6+SA=
Date:   Tue, 14 Sep 2021 20:57:14 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  + coda-avoid-hidden-code-duplication-in-rename.patch
 added to -mm tree
Message-ID: <20210915035714.eCqtTZmqu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: avoid hidden code duplication in rename
has been added to the -mm tree.  Its filename is
     coda-avoid-hidden-code-duplication-in-rename.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/coda-avoid-hidden-code-duplication-in-rename.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/coda-avoid-hidden-code-duplication-in-rename.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

coda-avoid-null-pointer-dereference-from-a-bad-inode.patch
coda-check-for-async-upcall-request-using-local-state.patch
coda-avoid-flagging-null-inodes.patch
coda-avoid-hidden-code-duplication-in-rename.patch
coda-avoid-doing-bad-things-on-inode-type-changes-during-revalidation.patch
coda-bump-module-version-to-72.patch


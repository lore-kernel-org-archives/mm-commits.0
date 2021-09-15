Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03242C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C248B60FC0
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbhIOD60 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:58:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230107AbhIOD6Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:58:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC95860E74;
        Wed, 15 Sep 2021 03:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631678227;
        bh=Umr84BVYnCkFdkzVxuWcjYpm89GOLh+0g6vNC4dVop8=;
        h=Date:From:To:Subject:From;
        b=xZT53mO51v8j0wZ5eRpD5HISYc5dWOilDjGmZ7nuo+FgQ/LT6qBB+sSOj8kHtAqKW
         MkXPhx31YYRyddJJq8AN442C/yXlsTh2sKItgmra0qQYpRS+Od2f2j47Y6tHqPJD/G
         0x/vEcg+X8qGZSE/SLiS3wqkzkWtTlJoRREWALLE=
Date:   Tue, 14 Sep 2021 20:57:06 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  +
 coda-avoid-null-pointer-dereference-from-a-bad-inode.patch added to -mm
 tree
Message-ID: <20210915035706.UaZx766k9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: avoid NULL pointer dereference from a bad inode
has been added to the -mm tree.  Its filename is
     coda-avoid-null-pointer-dereference-from-a-bad-inode.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/coda-avoid-null-pointer-dereference-from-a-bad-inode.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/coda-avoid-null-pointer-dereference-from-a-bad-inode.patch

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

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

coda-avoid-null-pointer-dereference-from-a-bad-inode.patch
coda-check-for-async-upcall-request-using-local-state.patch
coda-avoid-flagging-null-inodes.patch
coda-avoid-hidden-code-duplication-in-rename.patch
coda-avoid-doing-bad-things-on-inode-type-changes-during-revalidation.patch
coda-bump-module-version-to-72.patch


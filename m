Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4969C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A88146121F
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhIOD6d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230107AbhIOD6b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:58:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D47A960FC0;
        Wed, 15 Sep 2021 03:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631678233;
        bh=NGACvWlwbv9FlLPZUz738fKmOJPaWm3VM5b5Eyu3O2I=;
        h=Date:From:To:Subject:From;
        b=nDBqsSC89aT4nMGgFPEJbaf7m3pD+yR4noHQawn2SSdE/HgRSf270zXQ5YIpVXANt
         FVmEV+dotkLLPbA8vQ0teGuo0jG5gf0XT/ruvIuhY7gBxPEv+uYbPe7+mP6kVJ1C7z
         4r/2Hv03y82A6unodDWHU05nRJN5Jor0VSVjBNjk=
Date:   Tue, 14 Sep 2021 20:57:12 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  + coda-avoid-flagging-null-inodes.patch added to -mm tree
Message-ID: <20210915035712.VKBSzJAVn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: avoid flagging NULL inodes
has been added to the -mm tree.  Its filename is
     coda-avoid-flagging-null-inodes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/coda-avoid-flagging-null-inodes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/coda-avoid-flagging-null-inodes.patch

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

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

coda-avoid-null-pointer-dereference-from-a-bad-inode.patch
coda-check-for-async-upcall-request-using-local-state.patch
coda-avoid-flagging-null-inodes.patch
coda-avoid-hidden-code-duplication-in-rename.patch
coda-avoid-doing-bad-things-on-inode-type-changes-during-revalidation.patch
coda-bump-module-version-to-72.patch


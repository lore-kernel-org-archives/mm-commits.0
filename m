Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6A7C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357502AbiCYBhQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357509AbiCYBf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD34D36E12
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 814A1B8272F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4C5C340EC;
        Fri, 25 Mar 2022 01:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172040;
        bh=KoUog8E7NS1dadb+cjL/VioBpqNYvTzF0WXFbAqw138=;
        h=Date:To:From:Subject:From;
        b=k/trUgOCNp60KFRqyZ33trMLF+YfP7sVRZubnmBfbB2q7NrtRGSkpS7rlPn1bGpU+
         HqDIyBQF9M7gqnU+o5cYwkx1DbctxaGEPWUac1ZnN3r///kPtFkHTgK4qclzEZkRAk
         UyzASTc1fdkxtMxMjUffzEB7gPlga2FDUZPubVxE=
Date:   Thu, 24 Mar 2022 18:33:59 -0700
To:     mm-commits@vger.kernel.org, christian.brauner@ubuntu.com,
        0x7f454c46@gmail.com, avagin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fs-pipe-local-vars-has-to-match-types-of-proper-pipe_inode_info-fields.patch removed from -mm tree
Message-Id: <20220325013400.3C4C5C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/pipe.c: local vars have to match types of proper pipe_inode_info fields
has been removed from the -mm tree.  Its filename was
     fs-pipe-local-vars-has-to-match-types-of-proper-pipe_inode_info-fields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrei Vagin <avagin@gmail.com>
Subject: fs/pipe.c: local vars have to match types of proper pipe_inode_info fields

head, tail, ring_size are declared as unsigned int, so all local variables
that operate with these fields have to be unsigned to avoid signed integer
overflow.

Right now, it isn't an issue because the maximum pipe size is limited by
1U<<31.

Link: https://lkml.kernel.org/r/20220106171946.36128-1-avagin@gmail.com
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Suggested-by: Dmitry Safonov <0x7f454c46@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/pipe.c~fs-pipe-local-vars-has-to-match-types-of-proper-pipe_inode_info-fields
+++ a/fs/pipe.c
@@ -607,7 +607,7 @@ out:
 static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct pipe_inode_info *pipe = filp->private_data;
-	int count, head, tail, mask;
+	unsigned int count, head, tail, mask;
 
 	switch (cmd) {
 	case FIONREAD:
@@ -829,7 +829,7 @@ out_free_uid:
 
 void free_pipe_info(struct pipe_inode_info *pipe)
 {
-	int i;
+	unsigned int i;
 
 #ifdef CONFIG_WATCH_QUEUE
 	if (pipe->watch_queue)
_

Patches currently in -mm which might be from avagin@gmail.com are



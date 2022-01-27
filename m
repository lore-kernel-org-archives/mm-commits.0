Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EB1C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 02:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiA0Ciw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jan 2022 21:38:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52622 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbiA0Civ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jan 2022 21:38:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69B3361338
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 02:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AA8C340E7;
        Thu, 27 Jan 2022 02:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643251130;
        bh=bu0hMM3EHar3uHxhCB4MyTbBQLI9o1CJrZ8c4ueEyWI=;
        h=Date:From:To:Subject:From;
        b=w0MKUsOoE6KGJP8xkYUzgeqiuyz4nK8Jm5MFmp6nQUWYRJgdCuRKsaBrVZKV4tPzV
         7uHCPJlrRPpZtNfUe0fOKKHu1DhS9YeUJViW7Fv+sxYswDdgjiIkP29XryDhGHUCV+
         MlMx0nl0PdWFCBmRRP43CzPQaWGGqHv3it99mBlA=
Date:   Wed, 26 Jan 2022 18:38:50 -0800
From:   akpm@linux-foundation.org
To:     0x7f454c46@gmail.com, avagin@gmail.com, mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?fs-pipe-local-vars-has-to-match-types-of-proper-pipe=5Fino?=
 =?US-ASCII?Q?de=5Finfo-fields.patch?= added to -mm tree
Message-ID: <20220127023850.o2eIwEK85%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/pipe.c: local vars have to match types of proper pipe_inode_info fields
has been added to the -mm tree.  Its filename is
     fs-pipe-local-vars-has-to-match-types-of-proper-pipe_inode_info-fields.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-pipe-local-vars-has-to-match-types-of-proper-pipe_inode_info-fields.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-pipe-local-vars-has-to-match-types-of-proper-pipe_inode_info-fields.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/pipe.c~fs-pipe-local-vars-has-to-match-types-of-proper-pipe_inode_info-fields
+++ a/fs/pipe.c
@@ -606,7 +606,7 @@ out:
 static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct pipe_inode_info *pipe = filp->private_data;
-	int count, head, tail, mask;
+	unsigned int count, head, tail, mask;
 
 	switch (cmd) {
 	case FIONREAD:
@@ -828,7 +828,7 @@ out_free_uid:
 
 void free_pipe_info(struct pipe_inode_info *pipe)
 {
-	int i;
+	unsigned int i;
 
 #ifdef CONFIG_WATCH_QUEUE
 	if (pipe->watch_queue) {
_

Patches currently in -mm which might be from avagin@gmail.com are

fs-pipe-use-kvcalloc-to-allocate-a-pipe_buffer-array.patch
fs-pipe-local-vars-has-to-match-types-of-proper-pipe_inode_info-fields.patch


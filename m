Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09EDC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352332AbiCYBhW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357507AbiCYBf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5608F35863
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFC2360A75
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A21C340EC;
        Fri, 25 Mar 2022 01:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172039;
        bh=dUH7cBCzI1CM20uQ7O4/ODh7154+/bsniX27L+g+7LM=;
        h=Date:To:From:Subject:From;
        b=x8OYpC3WXieVUa1wSkPXrIYSMwbGT0DkzKYgCqa/n6gZgmWJs7tpgTKzTXCApsetz
         wq2LBezrDEXT7HJl6hV+1BpaRi3Af7QXEs8DCOTOni+y1WrKuh8jh8fTYbSCha+I5N
         7p6XM0KPWkolnSXiRdsDULQ0aYHAV06Kbokhxjn4=
Date:   Thu, 24 Mar 2022 18:33:58 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        0x7f454c46@gmail.com, avagin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fs-pipe-use-kvcalloc-to-allocate-a-pipe_buffer-array.patch removed from -mm tree
Message-Id: <20220325013359.41A21C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/pipe: use kvcalloc to allocate a pipe_buffer array
has been removed from the -mm tree.  Its filename was
     fs-pipe-use-kvcalloc-to-allocate-a-pipe_buffer-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrei Vagin <avagin@gmail.com>
Subject: fs/pipe: use kvcalloc to allocate a pipe_buffer array

Right now, kcalloc is used to allocate a pipe_buffer array.  The size of
the pipe_buffer struct is 40 bytes.  kcalloc allows allocating reliably
chunks with sizes less or equal to PAGE_ALLOC_COSTLY_ORDER (3).  It means
that the maximum pipe size is 3.2MB in this case.

In CRIU, we use pipes to dump processes memory.  CRIU freezes a target
process, injects a parasite code into it and then this code splices memory
into pipes.  If a maximum pipe size is small, we need to do many
iterations or create many pipes.

kvcalloc attempt to allocate physically contiguous memory, but upon
failure, fall back to non-contiguous (vmalloc) allocation and so it isn't
limited by PAGE_ALLOC_COSTLY_ORDER.

The maximum pipe size for non-root users is limited by the
/proc/sys/fs/pipe-max-size sysctl that is 1MB by default, so only the root
user will be able to trigger vmalloc allocations.

Link: https://lkml.kernel.org/r/20220104171058.22580-1-avagin@gmail.com
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Reviewed-by: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/pipe.c~fs-pipe-use-kvcalloc-to-allocate-a-pipe_buffer-array
+++ a/fs/pipe.c
@@ -804,7 +804,7 @@ struct pipe_inode_info *alloc_pipe_info(
 	if (too_many_pipe_buffers_hard(user_bufs) && pipe_is_unprivileged_user())
 		goto out_revert_acct;
 
-	pipe->bufs = kcalloc(pipe_bufs, sizeof(struct pipe_buffer),
+	pipe->bufs = kvcalloc(pipe_bufs, sizeof(struct pipe_buffer),
 			     GFP_KERNEL_ACCOUNT);
 
 	if (pipe->bufs) {
@@ -849,7 +849,7 @@ void free_pipe_info(struct pipe_inode_in
 #endif
 	if (pipe->tmp_page)
 		__free_page(pipe->tmp_page);
-	kfree(pipe->bufs);
+	kvfree(pipe->bufs);
 	kfree(pipe);
 }
 
@@ -1264,8 +1264,7 @@ int pipe_resize_ring(struct pipe_inode_i
 	if (nr_slots < n)
 		return -EBUSY;
 
-	bufs = kcalloc(nr_slots, sizeof(*bufs),
-		       GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
+	bufs = kvcalloc(nr_slots, sizeof(*bufs), GFP_KERNEL_ACCOUNT);
 	if (unlikely(!bufs))
 		return -ENOMEM;
 
@@ -1292,7 +1291,7 @@ int pipe_resize_ring(struct pipe_inode_i
 	head = n;
 	tail = 0;
 
-	kfree(pipe->bufs);
+	kvfree(pipe->bufs);
 	pipe->bufs = bufs;
 	pipe->ring_size = nr_slots;
 	if (pipe->max_usage > nr_slots)
_

Patches currently in -mm which might be from avagin@gmail.com are



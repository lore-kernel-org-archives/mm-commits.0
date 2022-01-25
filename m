Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2263FC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 06:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355779AbiAYGk4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 01:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354371AbiAYGiM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 01:38:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C538C058CA8
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 20:56:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9BF21CE16B9
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 04:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02DAC340E0;
        Tue, 25 Jan 2022 04:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643086572;
        bh=TqWS79Ts6A2mKajqvdNL1hsWSRrq/ORnitqDFdpHBvo=;
        h=Date:From:To:Subject:From;
        b=LLb7t4XMBvrLFnCgvfjSOzodEB196QVRTNM50+BlAdt4TG2rwV3TeuTnOxIh19cJY
         rAkspghxdpAz2nP5wLbzVuNwzWOyfewOVNUim4OOsl8WFjohXdvREMwlt2iOOy4NFI
         ZIahYTTvKe/rYsfr7UsLohQ2MqPu6llK1lhB+ZSE=
Date:   Mon, 24 Jan 2022 20:56:12 -0800
From:   akpm@linux-foundation.org
To:     0x7f454c46@gmail.com, avagin@gmail.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  +
 fs-pipe-use-kvcalloc-to-allocate-a-pipe_buffer-array.patch added to -mm
 tree
Message-ID: <20220125045612.0_A0LAXgY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/pipe: use kvcalloc to allocate a pipe_buffer array
has been added to the -mm tree.  Its filename is
     fs-pipe-use-kvcalloc-to-allocate-a-pipe_buffer-array.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-pipe-use-kvcalloc-to-allocate-a-pipe_buffer-array.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-pipe-use-kvcalloc-to-allocate-a-pipe_buffer-array.patch

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
Cc: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/pipe.c~fs-pipe-use-kvcalloc-to-allocate-a-pipe_buffer-array
+++ a/fs/pipe.c
@@ -803,7 +803,7 @@ struct pipe_inode_info *alloc_pipe_info(
 	if (too_many_pipe_buffers_hard(user_bufs) && pipe_is_unprivileged_user())
 		goto out_revert_acct;
 
-	pipe->bufs = kcalloc(pipe_bufs, sizeof(struct pipe_buffer),
+	pipe->bufs = kvcalloc(pipe_bufs, sizeof(struct pipe_buffer),
 			     GFP_KERNEL_ACCOUNT);
 
 	if (pipe->bufs) {
@@ -846,7 +846,7 @@ void free_pipe_info(struct pipe_inode_in
 	}
 	if (pipe->tmp_page)
 		__free_page(pipe->tmp_page);
-	kfree(pipe->bufs);
+	kvfree(pipe->bufs);
 	kfree(pipe);
 }
 
@@ -1261,8 +1261,7 @@ int pipe_resize_ring(struct pipe_inode_i
 	if (nr_slots < n)
 		return -EBUSY;
 
-	bufs = kcalloc(nr_slots, sizeof(*bufs),
-		       GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
+	bufs = kvcalloc(nr_slots, sizeof(*bufs), GFP_KERNEL_ACCOUNT);
 	if (unlikely(!bufs))
 		return -ENOMEM;
 
@@ -1289,7 +1288,7 @@ int pipe_resize_ring(struct pipe_inode_i
 	head = n;
 	tail = 0;
 
-	kfree(pipe->bufs);
+	kvfree(pipe->bufs);
 	pipe->bufs = bufs;
 	pipe->ring_size = nr_slots;
 	if (pipe->max_usage > nr_slots)
_

Patches currently in -mm which might be from avagin@gmail.com are

fs-pipe-use-kvcalloc-to-allocate-a-pipe_buffer-array.patch


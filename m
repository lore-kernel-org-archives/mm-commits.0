Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7E7C4332E
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20C3564F4D
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhBZBW0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:22:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230024AbhBZBV0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:21:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DED164F35;
        Fri, 26 Feb 2021 01:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302450;
        bh=4kwnhsvHnunV0PbvGukeCWyoYx4n6/wK2rMbcDVazKg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jTAcVdPAUd5zU9n7DbX01hGsOPmcHredgzU2vIbQPblX6jiYMSWiwM5w4oAmkl/ea
         DxubJCvyVGuE5H7HuOnIm/9btMEo6Cw+cFN4xqL5HsO+OdSfUtVlwZSm5c9crXPrYq
         /5MCK2N03qDyoGHieBqlRUTkHEXVyx6cKocBTi80=
Date:   Thu, 25 Feb 2021 17:20:49 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, hch@lst.de,
        josef@toxicpanda.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [patch 084/118] proc: use kvzalloc for our kernel buffer
Message-ID: <20210226012049.3cWZof4oq%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>
Subject: proc: use kvzalloc for our kernel buffer

Since

  sysctl: pass kernel pointers to ->proc_handler

we have been pre-allocating a buffer to copy the data from the proc
handlers into, and then copying that to userspace.  The problem is this
just blindly kzalloc()'s the buffer size passed in from the read, which in
the case of our 'cat' binary was 64kib.  Order-4 allocations are not
awesome, and since we can potentially allocate up to our maximum order, so
use kvzalloc for these buffers.

[willy@infradead.org: changelog tweaks]
Link: https://lkml.kernel.org/r/6345270a2c1160b89dd5e6715461f388176899d1.1612972413.git.josef@toxicpanda.com
Fixes: 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
CC: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/proc_sysctl.c~proc-use-vmalloc-for-our-kernel-buffer
+++ a/fs/proc/proc_sysctl.c
@@ -571,7 +571,7 @@ static ssize_t proc_sys_call_handler(str
 	error = -ENOMEM;
 	if (count >= KMALLOC_MAX_SIZE)
 		goto out;
-	kbuf = kzalloc(count + 1, GFP_KERNEL);
+	kbuf = kvzalloc(count + 1, GFP_KERNEL);
 	if (!kbuf)
 		goto out;
 
@@ -600,7 +600,7 @@ static ssize_t proc_sys_call_handler(str
 
 	error = count;
 out_free_buf:
-	kfree(kbuf);
+	kvfree(kbuf);
 out:
 	sysctl_head_finish(head);
 
_

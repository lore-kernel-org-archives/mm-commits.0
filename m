Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 707AAC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 00:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DDF164E4B
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 00:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhBLAER (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Feb 2021 19:04:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbhBLAER (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Feb 2021 19:04:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE7A464E4A;
        Fri, 12 Feb 2021 00:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613088216;
        bh=EHo8slU8eGsWimbed6u0jl5n2k1Q2f1mfnoxmXjlKAA=;
        h=Date:From:To:Subject:From;
        b=XucsssQdve6w6sXcIy4OCXnwumM1MEz/hQ2xXxFz5RPVFs7T9BzKvuEBrEEfNOo+m
         url3gpZ/6Xnfufs0uPBZXn/sNtQg5BPuzba4BjmklG2nN8kcZ5XfmsSHxn1tAfQcyJ
         LOJhfV1B/3ntgoeS6LYCJB48zZd9coRXDkP8sL1U=
Date:   Thu, 11 Feb 2021 16:03:36 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, vbabka@suse.cz, hch@lst.de,
        adobriyan@gmail.com, josef@toxicpanda.com
Subject:  + proc-use-vmalloc-for-our-kernel-buffer.patch added to -mm
 tree
Message-ID: <20210212000336.Tg9YT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: use kvzalloc for our kernel buffer
has been added to the -mm tree.  Its filename is
     proc-use-vmalloc-for-our-kernel-buffer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-use-vmalloc-for-our-kernel-buffer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-use-vmalloc-for-our-kernel-buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from josef@toxicpanda.com are

proc-use-vmalloc-for-our-kernel-buffer.patch


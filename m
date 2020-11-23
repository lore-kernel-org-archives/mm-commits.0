Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11821C63777
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 19:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FEFB2072C
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 19:19:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZELE5Xva"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731248AbgKWTTQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 14:19:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:55288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729407AbgKWTTP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 14:19:15 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40C282063A;
        Mon, 23 Nov 2020 19:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606159154;
        bh=3b2EKbJuOov52bNpfS73A9VuKo9lO+n9q7da4TsrT7A=;
        h=Date:From:To:Subject:From;
        b=ZELE5XvaeoTqvBkM5McVLu/9H4O0PAl9eQwCfYUz7DskaDwjJXwQr9hlwy0MN7Db7
         eHW7UqsYOzkUCDg0CaSxG9DhM286reXRnx2FuUs8KFpNE5luYf73rwx3ArRjMXyUHL
         X23LmlXEdfYUV5esZUiAoouYhnDdKSNela/kcK3Q=
Date:   Mon, 23 Nov 2020 11:19:13 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, hch@infradead.org, jani.nikula@intel.com,
        kvalo@codeaurora.org, mm-commits@vger.kernel.org
Subject:  +
 relay-remove-unused-buf_mapped-and-buf_unmapped-callbacks.patch added to
 -mm tree
Message-ID: <20201123191913.tXJkcClnl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: relay: remove unused buf_mapped and buf_unmapped callbacks
has been added to the -mm tree.  Its filename is
     relay-remove-unused-buf_mapped-and-buf_unmapped-callbacks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/relay-remove-unused-buf_mapped-and-buf_unmapped-callbacks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/relay-remove-unused-buf_mapped-and-buf_unmapped-callbacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: relay: remove unused buf_mapped and buf_unmapped callbacks

Patch series "relay: cleanup and const callbacks", v2.

None of the relay users require the use of mutable structs for callbacks,
however the relay code does.  Instead of assigning default callbacks when
there is none, add callback wrappers to conditionally call the client
callbacks if available, and fall back to default behaviour (typically
no-op) otherwise.

This lets all relay users make their struct rchan_callbacks const data.

This series starts with a number of cleanups first based on Christoph's
feedback.


This patch (of 9):

No relay client uses the buf_mapped or buf_unmapped callbacks.  Remove
them.  This makes relay's vm_operations_struct close callback a dummy,
remove it as well.

Link: https://lkml.kernel.org/r/cover.1606153547.git.jani.nikula@intel.com
Link: https://lkml.kernel.org/r/c69fff6e0cd485563604240bbfcc028434983bec.1606153547.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/relay.h |   19 -------------------
 kernel/relay.c        |   34 ----------------------------------
 2 files changed, 53 deletions(-)

--- a/include/linux/relay.h~relay-remove-unused-buf_mapped-and-buf_unmapped-callbacks
+++ a/include/linux/relay.h
@@ -102,25 +102,6 @@ struct rchan_callbacks
 			     size_t prev_padding);
 
 	/*
-	 * buf_mapped - relay buffer mmap notification
-	 * @buf: the channel buffer
-	 * @filp: relay file pointer
-	 *
-	 * Called when a relay file is successfully mmapped
-	 */
-        void (*buf_mapped)(struct rchan_buf *buf,
-			   struct file *filp);
-
-	/*
-	 * buf_unmapped - relay buffer unmap notification
-	 * @buf: the channel buffer
-	 * @filp: relay file pointer
-	 *
-	 * Called when a relay file is successfully unmapped
-	 */
-        void (*buf_unmapped)(struct rchan_buf *buf,
-			     struct file *filp);
-	/*
 	 * create_buf_file - create file to represent a relay channel buffer
 	 * @filename: the name of the file to create
 	 * @parent: the parent of the file to create
--- a/kernel/relay.c~relay-remove-unused-buf_mapped-and-buf_unmapped-callbacks
+++ a/kernel/relay.c
@@ -28,15 +28,6 @@ static DEFINE_MUTEX(relay_channels_mutex
 static LIST_HEAD(relay_channels);
 
 /*
- * close() vm_op implementation for relay file mapping.
- */
-static void relay_file_mmap_close(struct vm_area_struct *vma)
-{
-	struct rchan_buf *buf = vma->vm_private_data;
-	buf->chan->cb->buf_unmapped(buf, vma->vm_file);
-}
-
-/*
  * fault() vm_op implementation for relay file mapping.
  */
 static vm_fault_t relay_buf_fault(struct vm_fault *vmf)
@@ -62,7 +53,6 @@ static vm_fault_t relay_buf_fault(struct
  */
 static const struct vm_operations_struct relay_file_mmap_ops = {
 	.fault = relay_buf_fault,
-	.close = relay_file_mmap_close,
 };
 
 /*
@@ -96,7 +86,6 @@ static void relay_free_page_array(struct
 static int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
 {
 	unsigned long length = vma->vm_end - vma->vm_start;
-	struct file *filp = vma->vm_file;
 
 	if (!buf)
 		return -EBADF;
@@ -107,7 +96,6 @@ static int relay_mmap_buf(struct rchan_b
 	vma->vm_ops = &relay_file_mmap_ops;
 	vma->vm_flags |= VM_DONTEXPAND;
 	vma->vm_private_data = buf;
-	buf->chan->cb->buf_mapped(buf, filp);
 
 	return 0;
 }
@@ -284,22 +272,6 @@ static int subbuf_start_default_callback
 }
 
 /*
- * buf_mapped() default callback.  Does nothing.
- */
-static void buf_mapped_default_callback(struct rchan_buf *buf,
-					struct file *filp)
-{
-}
-
-/*
- * buf_unmapped() default callback.  Does nothing.
- */
-static void buf_unmapped_default_callback(struct rchan_buf *buf,
-					  struct file *filp)
-{
-}
-
-/*
  * create_buf_file_create() default callback.  Does nothing.
  */
 static struct dentry *create_buf_file_default_callback(const char *filename,
@@ -322,8 +294,6 @@ static int remove_buf_file_default_callb
 /* relay channel default callbacks */
 static struct rchan_callbacks default_channel_callbacks = {
 	.subbuf_start = subbuf_start_default_callback,
-	.buf_mapped = buf_mapped_default_callback,
-	.buf_unmapped = buf_unmapped_default_callback,
 	.create_buf_file = create_buf_file_default_callback,
 	.remove_buf_file = remove_buf_file_default_callback,
 };
@@ -509,10 +479,6 @@ static void setup_callbacks(struct rchan
 
 	if (!cb->subbuf_start)
 		cb->subbuf_start = subbuf_start_default_callback;
-	if (!cb->buf_mapped)
-		cb->buf_mapped = buf_mapped_default_callback;
-	if (!cb->buf_unmapped)
-		cb->buf_unmapped = buf_unmapped_default_callback;
 	if (!cb->create_buf_file)
 		cb->create_buf_file = create_buf_file_default_callback;
 	if (!cb->remove_buf_file)
_

Patches currently in -mm which might be from jani.nikula@intel.com are

relay-remove-unused-buf_mapped-and-buf_unmapped-callbacks.patch
relay-require-non-null-callbacks-in-relay_open.patch
relay-make-create_buf_file-and-remove_buf_file-callbacks-mandatory.patch
relay-allow-the-use-of-const-callback-structs.patch
drm-i915-make-relay-callbacks-const.patch
ath10k-make-relay-callbacks-const.patch
ath11k-make-relay-callbacks-const.patch
ath9k-make-relay-callbacks-const.patch
blktrace-make-relay-callbacks-const.patch


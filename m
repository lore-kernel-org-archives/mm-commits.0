Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6735C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3DFF2332A
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgLPEqD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:46:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgLPEqD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:46:03 -0500
Date:   Tue, 15 Dec 2020 20:45:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093948;
        bh=0enrh9TNjX45dgmAVI8tee9TVoO/XhGoSJcGEiuQ9L8=;
        h=From:To:Subject:In-Reply-To:From;
        b=EhYmPo8t6m37VPc6gFL95drDQbyZdx4ElPF9FIrbDnX0PM/ImmPgwF5Ipr1dN7mL0
         9Ptg8IWaYaduRT7SRrrec0meafTceFL5M3gc97NxcJZpw0n/AEP12298LiGuvNvYKK
         xHkCQJzHrK0AY6rIdlm7EjrsxQCihs20kCnIOOQs=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, hch@infradead.org,
        hch@lst.de, jani.nikula@intel.com, kvalo@codeaurora.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 64/95] relay: remove unused buf_mapped and
 buf_unmapped callbacks
Message-ID: <20201216044547.3E7honKWK%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FB4C63777
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 19:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D025A20663
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 19:19:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ullbfmOn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731878AbgKWTTV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 14:19:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729435AbgKWTTV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 14:19:21 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1469C2063A;
        Mon, 23 Nov 2020 19:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606159160;
        bh=U6ObECR7sLCebhUKs3Ut4lUwI3TjefIxCBglrLyto5A=;
        h=Date:From:To:Subject:From;
        b=ullbfmOnqnP5HYSIvxvwtF5rb/sitv+nHZYDlOZU8BEn7a6vAxHXS+pssGapVHCb7
         n2ei9BMyj0sNpC3wjoOzRqLghuEJumoX5hUMtufviiGHXtCHSBL3zOjIdCxqMnFT1g
         9SjwYWQ+wgglo5Na5RL1BOyAB91PetV39/NH7jSY=
Date:   Mon, 23 Nov 2020 11:19:19 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, hch@infradead.org, jani.nikula@intel.com,
        kvalo@codeaurora.org, mm-commits@vger.kernel.org
Subject:  +
 relay-make-create_buf_file-and-remove_buf_file-callbacks-mandatory.patch
 added to -mm tree
Message-ID: <20201123191919.EGk0xmd4A%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: relay: make create_buf_file and remove_buf_file callbacks mandatory
has been added to the -mm tree.  Its filename is
     relay-make-create_buf_file-and-remove_buf_file-callbacks-mandatory.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/relay-make-create_buf_file-and-remove_buf_file-callbacks-mandatory.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/relay-make-create_buf_file-and-remove_buf_file-callbacks-mandatory.patch

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
Subject: relay: make create_buf_file and remove_buf_file callbacks mandatory

All clients provide create_buf_file and remove_buf_file callbacks, and
they're required for relay to make sense.  There is no point in them being
optional.

Also document whether each callback is mandatory/optional.

Link: https://lkml.kernel.org/r/88003c1527386b93036e286e7917f1e33aec84ac.1606153547.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/relay.h |    6 ++++++
 kernel/relay.c        |   26 +-------------------------
 2 files changed, 7 insertions(+), 25 deletions(-)

--- a/include/linux/relay.h~relay-make-create_buf_file-and-remove_buf_file-callbacks-mandatory
+++ a/include/linux/relay.h
@@ -89,6 +89,8 @@ struct rchan_callbacks
 	 * The client should return 1 to continue logging, 0 to stop
 	 * logging.
 	 *
+	 * This callback is optional.
+	 *
 	 * NOTE: subbuf_start will also be invoked when the buffer is
 	 *       created, so that the first sub-buffer can be initialized
 	 *       if necessary.  In this case, prev_subbuf will be NULL.
@@ -122,6 +124,8 @@ struct rchan_callbacks
 	 * cause relay_open() to create a single global buffer rather
 	 * than the default set of per-cpu buffers.
 	 *
+	 * This callback is mandatory.
+	 *
 	 * See Documentation/filesystems/relay.rst for more info.
 	 */
 	struct dentry *(*create_buf_file)(const char *filename,
@@ -139,6 +143,8 @@ struct rchan_callbacks
 	 * channel buffer.
 	 *
 	 * The callback should return 0 if successful, negative if not.
+	 *
+	 * This callback is mandatory.
 	 */
 	int (*remove_buf_file)(struct dentry *dentry);
 };
--- a/kernel/relay.c~relay-make-create_buf_file-and-remove_buf_file-callbacks-mandatory
+++ a/kernel/relay.c
@@ -271,26 +271,6 @@ static int subbuf_start_default_callback
 	return 1;
 }
 
-/*
- * create_buf_file_create() default callback.  Does nothing.
- */
-static struct dentry *create_buf_file_default_callback(const char *filename,
-						       struct dentry *parent,
-						       umode_t mode,
-						       struct rchan_buf *buf,
-						       int *is_global)
-{
-	return NULL;
-}
-
-/*
- * remove_buf_file() default callback.  Does nothing.
- */
-static int remove_buf_file_default_callback(struct dentry *dentry)
-{
-	return -EINVAL;
-}
-
 /**
  *	wakeup_readers - wake up readers waiting on a channel
  *	@work: contains the channel buffer
@@ -467,10 +447,6 @@ static void setup_callbacks(struct rchan
 {
 	if (!cb->subbuf_start)
 		cb->subbuf_start = subbuf_start_default_callback;
-	if (!cb->create_buf_file)
-		cb->create_buf_file = create_buf_file_default_callback;
-	if (!cb->remove_buf_file)
-		cb->remove_buf_file = remove_buf_file_default_callback;
 	chan->cb = cb;
 }
 
@@ -530,7 +506,7 @@ struct rchan *relay_open(const char *bas
 		return NULL;
 	if (subbuf_size > UINT_MAX / n_subbufs)
 		return NULL;
-	if (!cb)
+	if (!cb || !cb->create_buf_file || !cb->remove_buf_file)
 		return NULL;
 
 	chan = kzalloc(sizeof(struct rchan), GFP_KERNEL);
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


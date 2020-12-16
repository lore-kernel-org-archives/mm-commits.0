Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B0CC2BBD5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42FE323340
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgLPEqg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:46:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgLPEqf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:46:35 -0500
Date:   Tue, 15 Dec 2020 20:45:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093954;
        bh=RjA8wXS/9JlXO5kh5wOjkys6tyHDe/pm2hAwYxSgpmY=;
        h=From:To:Subject:In-Reply-To:From;
        b=nl7DW+ehk4V1NBvcfFrNSVz3ooqPyC9p/aO7xHhLl9IvcfOscQ90ZI4EnSAj1wBtM
         8pgZuuq6T2l2lEwwq8+lk3TYi2in3mh0g4Ml5rOKqsEE5rFWzs1tgkYr38isdeBETi
         mWDWoTRnZMg+GSG6oCGsQ72A5fVZPOcKSPIJTC2E=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, hch@infradead.org,
        hch@lst.de, jani.nikula@intel.com, kvalo@codeaurora.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 66/95] relay: make create_buf_file and
 remove_buf_file callbacks mandatory
Message-ID: <20201216044553.xvkdftETH%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>
Subject: relay: make create_buf_file and remove_buf_file callbacks mandatory

All clients provide create_buf_file and remove_buf_file callbacks, and
they're required for relay to make sense.  There is no point in them being
optional.

Also document whether each callback is mandatory/optional.

Link: https://lkml.kernel.org/r/88003c1527386b93036e286e7917f1e33aec84ac.1606153547.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

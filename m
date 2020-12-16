Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B792C2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFBEE23357
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgLPEqH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:46:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgLPEqG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:46:06 -0500
Date:   Tue, 15 Dec 2020 20:45:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093951;
        bh=msmMUv/yUz0YuWdelBs+LXtBN1wS3D8HrufuQmAz6nE=;
        h=From:To:Subject:In-Reply-To:From;
        b=Bc/f6w3zFx7ZFp+Tpl6+nl/GqobCrmdoT/e2zIwIPli6QAk+BWlR7WSwzLU+b/QQV
         JNg8tlsDNTmlm7mrmYF0gDPbKr7/MKf5bgavJImxOU2gDcmW10B7i2Rs4MJfV0/5kg
         El+ZseBKGHcQYj7o9d5t1OmASkP88NiPkkfB7wAM=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, hch@infradead.org,
        hch@lst.de, jani.nikula@intel.com, kvalo@codeaurora.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 65/95] relay: require non-NULL callbacks in
 relay_open()
Message-ID: <20201216044550.588a_ys7z%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>
Subject: relay: require non-NULL callbacks in relay_open()

There are no clients passing NULL callbacks, which makes sense as it
wouldn't even create a file.  Require non-NULL callbacks, and throw away
the handling for NULL callbacks.

Link: https://lkml.kernel.org/r/e40642f3b027d2bb6bc851ddb60e0a61ea51f5f8.1606153547.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/kernel/relay.c~relay-require-non-null-callbacks-in-relay_open
+++ a/kernel/relay.c
@@ -291,13 +291,6 @@ static int remove_buf_file_default_callb
 	return -EINVAL;
 }
 
-/* relay channel default callbacks */
-static struct rchan_callbacks default_channel_callbacks = {
-	.subbuf_start = subbuf_start_default_callback,
-	.create_buf_file = create_buf_file_default_callback,
-	.remove_buf_file = remove_buf_file_default_callback,
-};
-
 /**
  *	wakeup_readers - wake up readers waiting on a channel
  *	@work: contains the channel buffer
@@ -472,11 +465,6 @@ static void relay_close_buf(struct rchan
 static void setup_callbacks(struct rchan *chan,
 				   struct rchan_callbacks *cb)
 {
-	if (!cb) {
-		chan->cb = &default_channel_callbacks;
-		return;
-	}
-
 	if (!cb->subbuf_start)
 		cb->subbuf_start = subbuf_start_default_callback;
 	if (!cb->create_buf_file)
@@ -542,6 +530,8 @@ struct rchan *relay_open(const char *bas
 		return NULL;
 	if (subbuf_size > UINT_MAX / n_subbufs)
 		return NULL;
+	if (!cb)
+		return NULL;
 
 	chan = kzalloc(sizeof(struct rchan), GFP_KERNEL);
 	if (!chan)
_

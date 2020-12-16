Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F84C3526C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4B1F23406
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgLPRLF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:11:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726812AbgLPRLF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:11:05 -0500
Date:   Wed, 16 Dec 2020 09:10:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138649;
        bh=FKN1wkaR3nwKszLlHI9U30N4fBkd5tDqJglEX4GgM2o=;
        h=From:To:Subject:From;
        b=tEifL/v4vIob72SRkAg+4flAdaKYz9oEuMdygy2J9QiFNYWTcBG4Xf8KEfbCEj0GY
         W09ugOrD13GzZsQE8NncHAOIPltY3WiTKJS660ow1p7eFpIPePecTzBZW+lRiyTEwg
         cwItul/dK21WbWiKjq1sZ4NP8xc6AeYhQBogXQ0Q=
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, hch@infradead.org, hch@lst.de,
        jani.nikula@intel.com, kvalo@codeaurora.org,
        mm-commits@vger.kernel.org
Subject:  [merged]
 relay-require-non-null-callbacks-in-relay_open.patch removed from -mm tree
Message-ID: <20201216171049.gG9d2giBw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: relay: require non-NULL callbacks in relay_open()
has been removed from the -mm tree.  Its filename was
     relay-require-non-null-callbacks-in-relay_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from jani.nikula@intel.com are



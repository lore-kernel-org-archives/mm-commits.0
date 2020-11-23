Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20DFC2D0E4
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 19:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DF77206CA
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 19:19:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QojrBwIn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgKWTTT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 14:19:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729305AbgKWTTT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 14:19:19 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CB3620663;
        Mon, 23 Nov 2020 19:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606159157;
        bh=FsOV8ThcoRrWknFq8Lr7mXgM3U/tpt21gQ9bV6MLQfU=;
        h=Date:From:To:Subject:From;
        b=QojrBwIn9uXTYceCPlALYm++OwvmQLk3Cv25syTLpNnx2cX1zx0s5AASyLLokeYV+
         bG9VNC5Da5FbILuUJtjDmDe7TiVuwA9Co2AkVuis2WyR76Jd7JYlQFxREiFw2FA4CB
         UZtQL878N0JTRUXlMeA/J+VYQrsoVeIEo532ZS88=
Date:   Mon, 23 Nov 2020 11:19:16 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, hch@infradead.org, jani.nikula@intel.com,
        kvalo@codeaurora.org, mm-commits@vger.kernel.org
Subject:  + relay-require-non-null-callbacks-in-relay_open.patch
 added to -mm tree
Message-ID: <20201123191916.boyJLzgQ4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: relay: require non-NULL callbacks in relay_open()
has been added to the -mm tree.  Its filename is
     relay-require-non-null-callbacks-in-relay_open.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/relay-require-non-null-callbacks-in-relay_open.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/relay-require-non-null-callbacks-in-relay_open.patch

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
Subject: relay: require non-NULL callbacks in relay_open()

There are no clients passing NULL callbacks, which makes sense as it
wouldn't even create a file.  Require non-NULL callbacks, and throw away
the handling for NULL callbacks.

Link: https://lkml.kernel.org/r/e40642f3b027d2bb6bc851ddb60e0a61ea51f5f8.1606153547.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
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

relay-remove-unused-buf_mapped-and-buf_unmapped-callbacks.patch
relay-require-non-null-callbacks-in-relay_open.patch
relay-make-create_buf_file-and-remove_buf_file-callbacks-mandatory.patch
relay-allow-the-use-of-const-callback-structs.patch
drm-i915-make-relay-callbacks-const.patch
ath10k-make-relay-callbacks-const.patch
ath11k-make-relay-callbacks-const.patch
ath9k-make-relay-callbacks-const.patch
blktrace-make-relay-callbacks-const.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184C8C56202
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD31B2168B
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:07:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MwAI6kwC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgKZAHj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 19:07:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:41392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbgKZAHj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 19:07:39 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF74F206C0;
        Thu, 26 Nov 2020 00:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606349258;
        bh=8Q9rfpbLiwu7MWYcaMdEmNfZfIneyHhraP1K4tQ7azw=;
        h=Date:From:To:Subject:From;
        b=MwAI6kwC+mDZACxO8xYevkCpPahfYg+mTVZneXkdViZ0IyXxKbqZG/ytE4wV5qKEU
         JYsQjQcZddVpelEeRqbnluuNnuX02/olJllCTLLckK85vZp+v4JrYqefIAVBXjKuNR
         oaXbGAiaPswQIDyb7E//yc6e/owyrDKkpl3K3Hoc=
Date:   Wed, 25 Nov 2020 16:07:37 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, hch@lst.de, jani.nikula@intel.com,
        kvalo@codeaurora.org, mm-commits@vger.kernel.org
Subject:  + relay-allow-the-use-of-const-callback-structs-v3.patch
 added to -mm tree
Message-ID: <20201126000737.NiODJxG5F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: relay-allow-the-use-of-const-callback-structs-v3
has been added to the -mm tree.  Its filename is
     relay-allow-the-use-of-const-callback-structs-v3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/relay-allow-the-use-of-const-callback-structs-v3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/relay-allow-the-use-of-const-callback-structs-v3.patch

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
Subject: relay-allow-the-use-of-const-callback-structs-v3

cleanups, per Christoph

Link: https://lkml.kernel.org/r/20201124115412.32402-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/kernel/relay.c~relay-allow-the-use-of-const-callback-structs-v3
+++ a/kernel/relay.c
@@ -252,18 +252,14 @@ EXPORT_SYMBOL_GPL(relay_buf_full);
  * High-level relay kernel API and associated functions.
  */
 
-/* subbuf_start callback wrapper */
-static int cb_subbuf_start(struct rchan_buf *buf, void *subbuf,
-			   void *prev_subbuf, size_t prev_padding)
-{
-	if (buf->chan->cb->subbuf_start)
-		return buf->chan->cb->subbuf_start(buf, subbuf,
-						   prev_subbuf, prev_padding);
-
-	if (relay_buf_full(buf))
-		return 0;
+static int relay_subbuf_start(struct rchan_buf *buf, void *subbuf,
+			      void *prev_subbuf, size_t prev_padding)
+{
+	if (!buf->chan->cb->subbuf_start)
+		return !relay_buf_full(buf);
 
-	return 1;
+	return buf->chan->cb->subbuf_start(buf, subbuf,
+					   prev_subbuf, prev_padding);
 }
 
 /**
@@ -309,7 +305,7 @@ static void __relay_reset(struct rchan_b
 	for (i = 0; i < buf->chan->n_subbufs; i++)
 		buf->padding[i] = 0;
 
-	cb_subbuf_start(buf, buf->data, NULL, 0);
+	relay_subbuf_start(buf, buf->data, NULL, 0);
 }
 
 /**
@@ -699,7 +695,7 @@ size_t relay_switch_subbuf(struct rchan_
 	new_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
 	new = buf->start + new_subbuf * buf->chan->subbuf_size;
 	buf->offset = 0;
-	if (!cb_subbuf_start(buf, new, old, buf->prev_padding)) {
+	if (!relay_subbuf_start(buf, new, old, buf->prev_padding)) {
 		buf->offset = buf->chan->subbuf_size + 1;
 		return 0;
 	}
_

Patches currently in -mm which might be from jani.nikula@intel.com are

relay-remove-unused-buf_mapped-and-buf_unmapped-callbacks.patch
relay-require-non-null-callbacks-in-relay_open.patch
relay-make-create_buf_file-and-remove_buf_file-callbacks-mandatory.patch
relay-allow-the-use-of-const-callback-structs.patch
relay-allow-the-use-of-const-callback-structs-v3.patch
drm-i915-make-relay-callbacks-const.patch
ath10k-make-relay-callbacks-const.patch
ath11k-make-relay-callbacks-const.patch
ath9k-make-relay-callbacks-const.patch
blktrace-make-relay-callbacks-const.patch


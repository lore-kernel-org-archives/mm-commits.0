Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBADCC4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8405723118
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgLPEOi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:14:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbgLPEOi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:14:38 -0500
Date:   Tue, 15 Dec 2020 20:13:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608092031;
        bh=2RvCEZufQF0DEqASrBav2bTlRjRsF2dRYoLv8NV921U=;
        h=From:To:Subject:From;
        b=D+GpKqqPqR70eQAMiCox+W0JWhlp+wa0I8VuE85M2h9VJVGLAUfk28met3yMrNRnu
         pgJQr75IX79fmtXRaO6NE+79FQweZfqet60n/n8r8CDtqr3BR50jW2A9LazKFQQJyi
         lO7OYsyMgI3jRVqJV9mn32vnc+ma7wwUwpCGMtcs=
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, hch@lst.de, jani.nikula@intel.com,
        kvalo@codeaurora.org, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 relay-allow-the-use-of-const-callback-structs-v3.patch removed from -mm
 tree
Message-ID: <20201216041350.TcfGna8EE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: relay-allow-the-use-of-const-callback-structs-v3
has been removed from the -mm tree.  Its filename was
     relay-allow-the-use-of-const-callback-structs-v3.patch

This patch was dropped because it was folded into relay-allow-the-use-of-const-callback-structs.patch

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
drm-i915-make-relay-callbacks-const.patch
ath10k-make-relay-callbacks-const.patch
ath11k-make-relay-callbacks-const.patch
ath9k-make-relay-callbacks-const.patch
blktrace-make-relay-callbacks-const.patch


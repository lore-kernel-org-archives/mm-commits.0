Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E62C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3E0B2342C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgLPRLL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:11:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgLPRLL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:11:11 -0500
Date:   Wed, 16 Dec 2020 09:10:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138655;
        bh=sNroD754V26zan9c+vG8cFRiZtKhDNtlwhcvcxMCvrY=;
        h=From:To:Subject:From;
        b=ZxsGVeu90CGEV341IvoovN0bePu+oTwLRqxv0lKBXRDZLwU1n76mjzrd/saejBEwW
         WmNOaTWjXgjslUEplVXkMQHmdfT/2vuoQIr3RZKf0Kc+M1wXyVND2e2E6KDNmsA4mn
         kDjcWmQr/KDYVcaFjvpYNwAjxxlBfZz2P+7FifM4=
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, hch@lst.de, jani.nikula@intel.com,
        kvalo@codeaurora.org, mm-commits@vger.kernel.org
Subject:  [merged]
 relay-allow-the-use-of-const-callback-structs.patch removed from -mm tree
Message-ID: <20201216171055.Ge5xtBBmC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: relay: allow the use of const callback structs
has been removed from the -mm tree.  Its filename was
     relay-allow-the-use-of-const-callback-structs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: relay: allow the use of const callback structs

None of the relay users require the use of mutable structs for callbacks,
however the relay code does.  Instead of assigning the default callback
for subbuf_start, add a wrapper to conditionally call the client callback
if available, and fall back to default behaviour otherwise.

This lets all relay users make their struct rchan_callbacks const data.

[jani.nikula@intel.com: cleanups, per Christoph]
  Link: https://lkml.kernel.org/r/20201124115412.32402-1-jani.nikula@intel.com
Link: https://lkml.kernel.org/r/cc3ff292e4eb4fdc56bee3d690c7b8e39209cd37.1606153547.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/relay.h |    4 ++--
 kernel/relay.c        |   37 ++++++++++---------------------------
 2 files changed, 12 insertions(+), 29 deletions(-)

--- a/include/linux/relay.h~relay-allow-the-use-of-const-callback-structs
+++ a/include/linux/relay.h
@@ -62,7 +62,7 @@ struct rchan
 	size_t subbuf_size;		/* sub-buffer size */
 	size_t n_subbufs;		/* number of sub-buffers per buffer */
 	size_t alloc_size;		/* total buffer size allocated */
-	struct rchan_callbacks *cb;	/* client callbacks */
+	const struct rchan_callbacks *cb; /* client callbacks */
 	struct kref kref;		/* channel refcount */
 	void *private_data;		/* for user-defined data */
 	size_t last_toobig;		/* tried to log event > subbuf size */
@@ -157,7 +157,7 @@ struct rchan *relay_open(const char *bas
 			 struct dentry *parent,
 			 size_t subbuf_size,
 			 size_t n_subbufs,
-			 struct rchan_callbacks *cb,
+			 const struct rchan_callbacks *cb,
 			 void *private_data);
 extern int relay_late_setup_files(struct rchan *chan,
 				  const char *base_filename,
--- a/kernel/relay.c~relay-allow-the-use-of-const-callback-structs
+++ a/kernel/relay.c
@@ -252,23 +252,14 @@ EXPORT_SYMBOL_GPL(relay_buf_full);
  * High-level relay kernel API and associated functions.
  */
 
-/*
- * rchan_callback implementations defining default channel behavior.  Used
- * in place of corresponding NULL values in client callback struct.
- */
-
-/*
- * subbuf_start() default callback.  Does nothing.
- */
-static int subbuf_start_default_callback (struct rchan_buf *buf,
-					  void *subbuf,
-					  void *prev_subbuf,
-					  size_t prev_padding)
+static int relay_subbuf_start(struct rchan_buf *buf, void *subbuf,
+			      void *prev_subbuf, size_t prev_padding)
 {
-	if (relay_buf_full(buf))
-		return 0;
+	if (!buf->chan->cb->subbuf_start)
+		return !relay_buf_full(buf);
 
-	return 1;
+	return buf->chan->cb->subbuf_start(buf, subbuf,
+					   prev_subbuf, prev_padding);
 }
 
 /**
@@ -314,7 +305,7 @@ static void __relay_reset(struct rchan_b
 	for (i = 0; i < buf->chan->n_subbufs; i++)
 		buf->padding[i] = 0;
 
-	buf->chan->cb->subbuf_start(buf, buf->data, NULL, 0);
+	relay_subbuf_start(buf, buf->data, NULL, 0);
 }
 
 /**
@@ -442,14 +433,6 @@ static void relay_close_buf(struct rchan
 	kref_put(&buf->kref, relay_remove_buf);
 }
 
-static void setup_callbacks(struct rchan *chan,
-				   struct rchan_callbacks *cb)
-{
-	if (!cb->subbuf_start)
-		cb->subbuf_start = subbuf_start_default_callback;
-	chan->cb = cb;
-}
-
 int relay_prepare_cpu(unsigned int cpu)
 {
 	struct rchan *chan;
@@ -495,7 +478,7 @@ struct rchan *relay_open(const char *bas
 			 struct dentry *parent,
 			 size_t subbuf_size,
 			 size_t n_subbufs,
-			 struct rchan_callbacks *cb,
+			 const struct rchan_callbacks *cb,
 			 void *private_data)
 {
 	unsigned int i;
@@ -529,7 +512,7 @@ struct rchan *relay_open(const char *bas
 		chan->has_base_filename = 1;
 		strlcpy(chan->base_filename, base_filename, NAME_MAX);
 	}
-	setup_callbacks(chan, cb);
+	chan->cb = cb;
 	kref_init(&chan->kref);
 
 	mutex_lock(&relay_channels_mutex);
@@ -712,7 +695,7 @@ size_t relay_switch_subbuf(struct rchan_
 	new_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
 	new = buf->start + new_subbuf * buf->chan->subbuf_size;
 	buf->offset = 0;
-	if (!buf->chan->cb->subbuf_start(buf, new, old, buf->prev_padding)) {
+	if (!relay_subbuf_start(buf, new, old, buf->prev_padding)) {
 		buf->offset = buf->chan->subbuf_size + 1;
 		return 0;
 	}
_

Patches currently in -mm which might be from jani.nikula@intel.com are



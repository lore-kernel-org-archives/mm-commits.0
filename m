Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A49AC64E7A
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 19:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 335C620663
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 19:19:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TEpcdwt0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgKWTTj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 14:19:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729435AbgKWTTj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 14:19:39 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DB342063A;
        Mon, 23 Nov 2020 19:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606159178;
        bh=sAzKU6PiVZxBCh5sBBqOLcdugXebopQyzko3RtErUHo=;
        h=Date:From:To:Subject:From;
        b=TEpcdwt0OC2Hg4CodrvBKxtkbaUz1zH+rrzaMjqmqdrPxs8+ydYEJUNicfjHxGDnl
         O50Hz2q1MloAsr1wVNiuJuQ2h0LJ6Y5DQCrN/WB4/hBB/ZKGEbB/QN0q6RbH+gOa6p
         4OO/852GfW+WsKuwmuzE/R9oNwpWq368q08/uvO4=
Date:   Mon, 23 Nov 2020 11:19:37 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, hch@infradead.org, jani.nikula@intel.com,
        kvalo@codeaurora.org, mm-commits@vger.kernel.org
Subject:  + blktrace-make-relay-callbacks-const.patch added to -mm
 tree
Message-ID: <20201123191937.HOyH0ZtSS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: blktrace: make relay callbacks const
has been added to the -mm tree.  Its filename is
     blktrace-make-relay-callbacks-const.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/blktrace-make-relay-callbacks-const.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/blktrace-make-relay-callbacks-const.patch

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
Subject: blktrace: make relay callbacks const

Now that relay_open() accepts const callbacks, make relay callbacks
const.

Link: https://lkml.kernel.org/r/7ff5ce0b735901eb4f10e13da2704f1d8c4a2507.1606153547.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/blktrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/blktrace.c~blktrace-make-relay-callbacks-const
+++ a/kernel/trace/blktrace.c
@@ -449,7 +449,7 @@ static struct dentry *blk_create_buf_fil
 					&relay_file_operations);
 }
 
-static struct rchan_callbacks blk_relay_callbacks = {
+static const struct rchan_callbacks blk_relay_callbacks = {
 	.subbuf_start		= blk_subbuf_start_callback,
 	.create_buf_file	= blk_create_buf_file_callback,
 	.remove_buf_file	= blk_remove_buf_file_callback,
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


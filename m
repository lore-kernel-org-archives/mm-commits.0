Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962B9C6379D
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 19:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D6E920663
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 19:19:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RL63DMnP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731891AbgKWTT1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 14:19:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729435AbgKWTT0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 14:19:26 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14B8F2063A;
        Mon, 23 Nov 2020 19:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606159166;
        bh=So+/yUbUyDSCl9WRs2fG5lhX5gJ293at7nNNDKnP3V8=;
        h=Date:From:To:Subject:From;
        b=RL63DMnP3ZCr5o9IZOL2TN1alVxrQf/pZPCHrHi+CxyR/IYjOwkXCdMZPr/ogeaSt
         k+4JY5RXddjmX1y+h9mdZgU/U5Tog6YsysfU7dVxmKISJXXc4sZGJ4NdnOfBws7aTz
         qDHZJzq3FR6+hvKCI2vuhvwHHG3UYmk1P/PQ8iTs=
Date:   Mon, 23 Nov 2020 11:19:25 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, hch@infradead.org, jani.nikula@intel.com,
        kvalo@codeaurora.org, mm-commits@vger.kernel.org
Subject:  + drm-i915-make-relay-callbacks-const.patch added to -mm
 tree
Message-ID: <20201123191925.Mj3sZiKvU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915: make relay callbacks const
has been added to the -mm tree.  Its filename is
     drm-i915-make-relay-callbacks-const.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/drm-i915-make-relay-callbacks-const.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/drm-i915-make-relay-callbacks-const.patch

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
Subject: drm/i915: make relay callbacks const

Now that relay_open() accepts const callbacks, make relay callbacks const.

Link: https://lkml.kernel.org/r/534d089f413db98aa0b94773fa49d5275d0d3c25.1606153547.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gt/uc/intel_guc_log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c~drm-i915-make-relay-callbacks-const
+++ a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
@@ -134,7 +134,7 @@ static int remove_buf_file_callback(stru
 }
 
 /* relay channel callbacks */
-static struct rchan_callbacks relay_callbacks = {
+static const struct rchan_callbacks relay_callbacks = {
 	.subbuf_start = subbuf_start_callback,
 	.create_buf_file = create_buf_file_callback,
 	.remove_buf_file = remove_buf_file_callback,
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


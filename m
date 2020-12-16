Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF83C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AECB523433
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgLPRLj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:11:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:32920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgLPRLj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:11:39 -0500
Date:   Wed, 16 Dec 2020 09:10:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138658;
        bh=8VCD2hA2/JXIMQz10twx3YFCCW7HmCdqKUzCP5G8TYo=;
        h=From:To:Subject:From;
        b=Lh+Zsb9T+rXvTwaTkwcamgp4L0PCHco9Z8BTramAgwR6CIj2Xso9fzyE7oGygjNPC
         +BbtX32llQeOSdgQL+kU0zbEAh1YfQy0SdhGBnEQQ5oxeu/yoNNvsrzJnbA5LSilmB
         BeDwpU4T4LdwvUfifbFqpQSjN3X8J/ZSVCr0TAKY=
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, hch@lst.de, jani.nikula@intel.com,
        kvalo@codeaurora.org, mm-commits@vger.kernel.org
Subject:  [merged] drm-i915-make-relay-callbacks-const.patch
 removed from -mm tree
Message-ID: <20201216171058.fCE9iNnwZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915: make relay callbacks const
has been removed from the -mm tree.  Its filename was
     drm-i915-make-relay-callbacks-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: drm/i915: make relay callbacks const

Now that relay_open() accepts const callbacks, make relay callbacks const.

Link: https://lkml.kernel.org/r/534d089f413db98aa0b94773fa49d5275d0d3c25.1606153547.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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



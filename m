Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B09C2BBD5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2694223343
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgLPEqQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:46:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgLPEqQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:46:16 -0500
Date:   Tue, 15 Dec 2020 20:46:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093961;
        bh=DmUNYfQJqoLdsOKB4hyo2SmjJOtWXEcQeZEoWjzSPVE=;
        h=From:To:Subject:In-Reply-To:From;
        b=upvc7xuvKZTX/qrN7H++WhIhGr45Q7YUArpKpgfqmwM9IDQ12AtnB5FkG1VBmETC/
         0xa978Aojy76CD0notEzQz0EXUatdFZEpWfWKL2gCktvFFRnbfeZk/ntPf6ALvGNRZ
         FMBgsEO3T8k5jKstFNK+PkJ4mvJIulBGz2BuvzYg=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, hch@lst.de,
        jani.nikula@intel.com, kvalo@codeaurora.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 68/95] drm/i915: make relay callbacks const
Message-ID: <20201216044600.WGsoBXdQ_%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

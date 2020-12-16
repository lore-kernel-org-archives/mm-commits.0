Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE2CC2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 212E22333E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgLPEq3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:46:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgLPEq3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:46:29 -0500
Date:   Tue, 15 Dec 2020 20:46:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093974;
        bh=Kb4V+mc3ew1J3ivpZMqjExaKjvZ1Y4uLRJYEAOn/EHY=;
        h=From:To:Subject:In-Reply-To:From;
        b=uYXSeZfCW7456jG3pzVwoOMoHgO+w2stwhZCvsM5lSFk/UW5QevyIzjHLSCcH3OGv
         OBWytNxZfdUiqUBw0p3I/OS5PLGWaeD1hNlbNkad0WmnmrdLs0Q0P5t51C3oRGc8cw
         cky8nfJo3V2XMoMcjCnP3u/fuLH+RlBaUwzwjxJ4=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, hch@lst.de,
        jani.nikula@intel.com, kvalo@codeaurora.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 72/95] blktrace: make relay callbacks const
Message-ID: <20201216044613.oXo3YjXv2%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>
Subject: blktrace: make relay callbacks const

Now that relay_open() accepts const callbacks, make relay callbacks
const.

Link: https://lkml.kernel.org/r/7ff5ce0b735901eb4f10e13da2704f1d8c4a2507.1606153547.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
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

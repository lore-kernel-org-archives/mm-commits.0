Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B4DCC4167B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Nov 2022 23:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiK2X1A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Nov 2022 18:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiK2X07 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2022 18:26:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F2D5B593
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 15:26:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CAB3B8196F
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 23:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B4CC433C1;
        Tue, 29 Nov 2022 23:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669764416;
        bh=PIpWMyUZywOn5lnRuB5GsEDvWGP9FPW/sdl2t3nCUxQ=;
        h=Date:To:From:Subject:From;
        b=OyFjlL+tRTQYGuKheWi1R/q9jHJgDWxYlRJ3QBrYvR1bmqaA7lrMpViZU0IjfikK1
         vzFqCjghdyLJa4ImiInhslMkRAWPxfDRI1Z0VoEtfogolxZSHm6gX9GFdvae2GzuzR
         hTF0ue6Yoz5sz5jxPssVqZmYWYV4noPK1/fmP+QA=
Date:   Tue, 29 Nov 2022 15:26:55 -0800
To:     mm-commits@vger.kernel.org, wuchi.zero@gmail.com,
        colin.i.king@gmail.com, axboe@kernel.dk, Ilia.Gavrilov@infotecs.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + relay-fix-type-mismatch-when-allocating-memory-in-relay_create_buf.patch added to mm-nonmm-unstable branch
Message-Id: <20221129232656.12B4CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: relay: fix type mismatch when allocating memory in relay_create_buf()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     relay-fix-type-mismatch-when-allocating-memory-in-relay_create_buf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/relay-fix-type-mismatch-when-allocating-memory-in-relay_create_buf.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Subject: relay: fix type mismatch when allocating memory in relay_create_buf()
Date: Tue, 29 Nov 2022 09:23:38 +0000

The 'padding' field of the 'rchan_buf' structure is an array of 'size_t'
elements, but the memory is allocated for an array of 'size_t *' elements.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lkml.kernel.org/r/20221129092002.3538384-1-Ilia.Gavrilov@infotecs.ru
Fixes: b86ff981a825 ("[PATCH] relay: migrate from relayfs to a generic relay API")
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: wuchi <wuchi.zero@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/relay.c~relay-fix-type-mismatch-when-allocating-memory-in-relay_create_buf
+++ a/kernel/relay.c
@@ -148,13 +148,13 @@ static struct rchan_buf *relay_create_bu
 {
 	struct rchan_buf *buf;
 
-	if (chan->n_subbufs > KMALLOC_MAX_SIZE / sizeof(size_t *))
+	if (chan->n_subbufs > KMALLOC_MAX_SIZE / sizeof(size_t))
 		return NULL;
 
 	buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
 	if (!buf)
 		return NULL;
-	buf->padding = kmalloc_array(chan->n_subbufs, sizeof(size_t *),
+	buf->padding = kmalloc_array(chan->n_subbufs, sizeof(size_t),
 				     GFP_KERNEL);
 	if (!buf->padding)
 		goto free_buf;
_

Patches currently in -mm which might be from Ilia.Gavrilov@infotecs.ru are

relay-fix-type-mismatch-when-allocating-memory-in-relay_create_buf.patch


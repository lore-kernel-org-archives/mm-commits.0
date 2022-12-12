Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BCEC4167B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 03:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiLLDb3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 22:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiLLDbV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 22:31:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B97DE88
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 19:31:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F43660ECD
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 03:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6852C433D2;
        Mon, 12 Dec 2022 03:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670815875;
        bh=mqmdL6IG4HXSl/rKolWvDx1G155jFQTLxUTS3bCVsjk=;
        h=Date:To:From:Subject:From;
        b=rN1ebQBSMQ3w5JZKOXxBGzU2aDp3m92rRbmjewxFOkO/CoXcu7vBPc38ia8qEqs+K
         4l7JHPRfnFPg3Y14Rk+kKz5w8V48U5mMr1JakygqEaMY+c9kJYTGg1z7aNDOOKv2hz
         RXmRD2xDseNckezLIFyq8h49Q1ACjNkOapRIRdyo=
Date:   Sun, 11 Dec 2022 19:31:14 -0800
To:     mm-commits@vger.kernel.org, wuchi.zero@gmail.com,
        colin.i.king@gmail.com, axboe@kernel.dk, Ilia.Gavrilov@infotecs.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] relay-fix-type-mismatch-when-allocating-memory-in-relay_create_buf.patch removed from -mm tree
Message-Id: <20221212033115.A6852C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: relay: fix type mismatch when allocating memory in relay_create_buf()
has been removed from the -mm tree.  Its filename was
     relay-fix-type-mismatch-when-allocating-memory-in-relay_create_buf.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B63C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E109C61D00
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhF2ChO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231750AbhF2ChO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:37:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8908061A1D;
        Tue, 29 Jun 2021 02:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934087;
        bh=lkgn4pt9h1Qyk58iAMwg9tD1porpp5u3Bv6fJ7+MkAI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cw8hZWYgN2AZZHDT+bDxMXxC5lunrRgQGeKHr/L8Fy6wChBva2A8Bz0fdgmzhenAI
         +6/rPt2xG9Swe1gfDz7b2xlhn5FJ+UmmwIuPD/6Ea9d+eQFNnaz8Uc1uXJLfP49Ghq
         xJiiLhrBCzMRiZIidgqEY5Xc+exs3Fqr8rXgieQo=
Date:   Mon, 28 Jun 2021 19:34:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        penberg@kernel.org, pmladek@suse.com, rientjes@google.com,
        songmuchun@bytedance.com, swboyd@chromium.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 028/192] slub: actually use 'message' in
 restore_bytes()
Message-ID: <20210629023446.-AeYIO0Zx%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>
Subject: slub: actually use 'message' in restore_bytes()

The message argument isn't used here.  Let's pass the string to the printk
message so that the developer can figure out what's happening, instead of
guessing that a redzone is being restored, etc.

Link: https://lkml.kernel.org/r/20210601182202.3011020-3-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joe Perches <joe@perches.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~slub-actually-use-message-in-restore_bytes
+++ a/mm/slub.c
@@ -806,7 +806,7 @@ static void init_object(struct kmem_cach
 static void restore_bytes(struct kmem_cache *s, char *message, u8 data,
 						void *from, void *to)
 {
-	slab_fix(s, "Restoring 0x%p-0x%p=0x%x\n", from, to - 1, data);
+	slab_fix(s, "Restoring %s 0x%p-0x%p=0x%x\n", message, from, to - 1, data);
 	memset(from, data, to - from);
 }
 
_

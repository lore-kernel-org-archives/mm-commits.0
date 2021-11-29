Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD1D3C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 22:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhK2W2Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 17:28:25 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56934 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbhK2W14 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 17:27:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8EDD4CE16C0
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 22:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F0FC53FC7;
        Mon, 29 Nov 2021 22:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638224674;
        bh=Bzd65lo1gNJneUe2UdBN1Qw+QuVtL0rvAIwtGMuRTLQ=;
        h=Date:From:To:Subject:From;
        b=u6C6b4p56kTZ4y3KQjgAHQDfQ1/0VSIOjbSqS+x7N/VztPEO3yJXlIjetxQGlkeFn
         OSGdNruhTqqDf7UOZJDVs24EPXP3j6/Z+iDCuwQzNd5zcUpNvkv7elwDh/45vNA97j
         Yd1gzj9Clc32hSslYRVYgBGCLPEEIv7gK7tVsbSw=
Date:   Mon, 29 Nov 2021 14:24:34 -0800
From:   akpm@linux-foundation.org
To:     christophe.jaillet@wanadoo.fr, mm-commits@vger.kernel.org
Subject:  + mm-mempool-use-non-atomic-__set_bit-when-possible.patch
 added to -mm tree
Message-ID: <20211129222434.wFokRdshF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/frontswap.c: use non-atomic '__set_bit()' when possible
has been added to the -mm tree.  Its filename is
     mm-mempool-use-non-atomic-__set_bit-when-possible.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempool-use-non-atomic-__set_bit-when-possible.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempool-use-non-atomic-__set_bit-when-possible.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: mm/frontswap.c: use non-atomic '__set_bit()' when possible

the 'a' and 'b' bitmaps are local to this function, so no concurrent
access can occur.  So the non-atomic '__set_bit()' can be used to save a
few cycles.

Link: https://lkml.kernel.org/r/e52476da5cee57151745c5c3c934a69798dc6fa4.1638132190.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/frontswap.c~mm-mempool-use-non-atomic-__set_bit-when-possible
+++ a/mm/frontswap.c
@@ -127,7 +127,7 @@ void frontswap_register_ops(struct front
 	spin_lock(&swap_lock);
 	plist_for_each_entry(si, &swap_active_head, list) {
 		if (!WARN_ON(!si->frontswap_map))
-			set_bit(si->type, a);
+			__set_bit(si->type, a);
 	}
 	spin_unlock(&swap_lock);
 
@@ -149,7 +149,7 @@ void frontswap_register_ops(struct front
 	spin_lock(&swap_lock);
 	plist_for_each_entry(si, &swap_active_head, list) {
 		if (si->frontswap_map)
-			set_bit(si->type, b);
+			__set_bit(si->type, b);
 	}
 	spin_unlock(&swap_lock);
 
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

mm-mempool-use-non-atomic-__set_bit-when-possible.patch


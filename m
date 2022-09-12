Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C80ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:57:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiILE5E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiILE4r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D47327FE2
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F369260AF4
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A3FC433C1;
        Mon, 12 Sep 2022 04:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958596;
        bh=DTFRenkSK/6d0vSvDnajzMqoEhjS4nZaRgV/lbPIZsc=;
        h=Date:To:From:Subject:From;
        b=MlrtuPXz8T+WtyqMX1LKutV0tN0+OxrR+Bu2GgA4b4GAjcbQB4v8Yqxejz50WCxi/
         uw2qRtADTtKcxPW5khJXZGi17AQfFnim2euFLdYYdKS9c5jopL32N2AWMr3WJ/MCnD
         iuYoEmP0vmX/EbUAdqYOukL4cD9/xoi/ImjMAxAs=
Date:   Sun, 11 Sep 2022 21:56:35 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] aio-use-atomic_try_cmpxchg-in-__get_reqs_available.patch removed from -mm tree
Message-Id: <20220912045636.58A3FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: aio: use atomic_try_cmpxchg in __get_reqs_available
has been removed from the -mm tree.  Its filename was
     aio-use-atomic_try_cmpxchg-in-__get_reqs_available.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: aio: use atomic_try_cmpxchg in __get_reqs_available
Date: Thu, 14 Jul 2022 18:48:51 +0200

Use atomic_try_cmpxchg instead of atomic_cmpxchg (*ptr, old, new) == old
in __get_reqs_available.  x86 CMPXCHG instruction returns success in ZF
flag, so this change saves a compare after cmpxchg (and related move
instruction in front of cmpxchg).

Also, atomic_try_cmpxchg implicitly assigns old *ptr value to "old" when
cmpxchg fails, enabling further code simplifications.

No functional change intended.

Link: https://lkml.kernel.org/r/20220714164851.3055-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/fs/aio.c~aio-use-atomic_try_cmpxchg-in-__get_reqs_available
+++ a/fs/aio.c
@@ -951,16 +951,13 @@ static bool __get_reqs_available(struct
 	local_irq_save(flags);
 	kcpu = this_cpu_ptr(ctx->cpu);
 	if (!kcpu->reqs_available) {
-		int old, avail = atomic_read(&ctx->reqs_available);
+		int avail = atomic_read(&ctx->reqs_available);
 
 		do {
 			if (avail < ctx->req_batch)
 				goto out;
-
-			old = avail;
-			avail = atomic_cmpxchg(&ctx->reqs_available,
-					       avail, avail - ctx->req_batch);
-		} while (avail != old);
+		} while (!atomic_try_cmpxchg(&ctx->reqs_available,
+					     &avail, avail - ctx->req_batch));
 
 		kcpu->reqs_available += ctx->req_batch;
 	}
_

Patches currently in -mm which might be from ubizjak@gmail.com are



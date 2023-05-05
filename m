Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D140C77B7D
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 20:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjEEUJ7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 16:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjEEUJ6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 16:09:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E97EB1
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 13:09:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A120B636D0
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 20:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE106C433D2;
        Fri,  5 May 2023 20:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683317396;
        bh=uvybxzPrqaMFWXh3u9ME9DUOgRYCKw+pV2gVAQeo5tY=;
        h=Date:To:From:Subject:From;
        b=tPmwO38zm3VVCf3bq8g4X+9M7rDWtn52qEb+tfvMKvukRhIhotmeOXlE9LcFyll+5
         oNQMnWnUsSH2CQKJG0EKstsvIkE/Iw/WA5su1zVZgmhpzJEo5cB6yhzbp+k7TTZRjz
         HtgTx453EE+pAvxHedWmM6pViPLXjbo4WqpaTqOY=
Date:   Fri, 05 May 2023 13:09:55 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        glider@google.com, elver@google.com, David.Laight@ACULAB.COM,
        mpe@ellerman.id.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-fix-false-positives-on-big-endian.patch added to mm-hotfixes-unstable branch
Message-Id: <20230505200955.EE106C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kfence: fix false positives on big endian
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kfence-fix-false-positives-on-big-endian.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-fix-false-positives-on-big-endian.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: mm: kfence: fix false positives on big endian
Date: Fri, 5 May 2023 13:51:27 +1000

Since commit 1ba3cbf3ec3b ("mm: kfence: improve the performance of
__kfence_alloc() and __kfence_free()"), kfence reports failures in random
places at boot on big endian machines.

The problem is that the new KFENCE_CANARY_PATTERN_U64 encodes the address
of each byte in its value, so it needs to be byte swapped on big endian
machines.

The compiler is smart enough to do the le64_to_cpu() at compile time, so
there is no runtime overhead.

Link: https://lkml.kernel.org/r/20230505035127.195387-1-mpe@ellerman.id.au
Fixes: 1ba3cbf3ec3b ("mm: kfence: improve the performance of __kfence_alloc() and __kfence_free()")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kfence/kfence.h~mm-kfence-fix-false-positives-on-big-endian
+++ a/mm/kfence/kfence.h
@@ -29,7 +29,7 @@
  * canary of every 8 bytes is the same. 64-bit memory can be filled and checked
  * at a time instead of byte by byte to improve performance.
  */
-#define KFENCE_CANARY_PATTERN_U64 ((u64)0xaaaaaaaaaaaaaaaa ^ (u64)(0x0706050403020100))
+#define KFENCE_CANARY_PATTERN_U64 ((u64)0xaaaaaaaaaaaaaaaa ^ (u64)(le64_to_cpu(0x0706050403020100)))
 
 /* Maximum stack depth for reports. */
 #define KFENCE_STACK_DEPTH 64
_

Patches currently in -mm which might be from mpe@ellerman.id.au are

mm-kfence-fix-false-positives-on-big-endian.patch


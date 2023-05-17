Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C71C7EE2A
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 22:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjEQWZW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 18:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjEQWZV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 18:25:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3641849DC
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 15:25:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9B2064030
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 22:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC6FC4339C;
        Wed, 17 May 2023 22:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684362319;
        bh=VDETg/A83XppSym7M7HwOR3Xo0qGNYeOhQIWf01fXOQ=;
        h=Date:To:From:Subject:From;
        b=cefr+IV3ZHcvMwAiieIcIHmwnPU8zEBj6mb6AVmbi3MOCrhkISs3nkStMIy0tsjB1
         gBRQwwWp9JZvDK9WR/z+qkVXo7Uaoz8/4cNUpcozmlnaRjINGVLaZpwoNDKtLDuK7e
         XHMlprrxuAiyqEwCe1ljPbZt7P/+qeOHFez7ocww=
Date:   Wed, 17 May 2023 15:25:18 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        glider@google.com, elver@google.com, David.Laight@ACULAB.COM,
        mpe@ellerman.id.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kfence-fix-false-positives-on-big-endian.patch removed from -mm tree
Message-Id: <20230517222519.1BC6FC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kfence: fix false positives on big endian
has been removed from the -mm tree.  Its filename was
     mm-kfence-fix-false-positives-on-big-endian.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-add-selftests-for-cachestat-fix-2.patch


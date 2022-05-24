Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B64C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 24 May 2022 18:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbiEXStW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 May 2022 14:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbiEXStV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 May 2022 14:49:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8FD167C3
        for <mm-commits@vger.kernel.org>; Tue, 24 May 2022 11:49:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF580B81B85
        for <mm-commits@vger.kernel.org>; Tue, 24 May 2022 18:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D288C34100;
        Tue, 24 May 2022 18:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653418157;
        bh=UuQHpCyB9qdQC5xzWHC7N8BtJodSS1zr6bX9JkZ4WAs=;
        h=Date:To:From:Subject:From;
        b=HDf71A1RM5tfT5/gRob5Oal/ZomBhJyiL2t+uFV81KWGhz97gEknIrbALO8MFEhzv
         VEiEJLRpQDts3McLVhVojiZnJj8nevU2n0UGshVaTUiZ6WICvsPVS844okp9d6aSeV
         nL8gJrCmfV6imZ8y8JyBE7VE7RTHUeYxozPb4qPs=
Date:   Tue, 24 May 2022 11:49:16 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, hannes@cmpxchg.org,
        axboe@kernel.dk, rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-kconfig-dependency-warning.patch added to mm-stable branch
Message-Id: <20220524184917.6D288C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix Kconfig dependency warning
has been added to the -mm mm-stable branch.  Its filename is
     zram-fix-kconfig-dependency-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-kconfig-dependency-warning.patch

This patch will later appear in the mm-stable branch at
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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: zram: fix Kconfig dependency warning
Date: Sun, 22 May 2022 13:40:27 -0700

ZSMALLOC depends on MMU so ZRAM should also depend on MMU since 'select'
does not follow any dependency chains.

Fixes this Kconfig warning:

WARNING: unmet direct dependencies detected for ZSMALLOC
  Depends on [n]: MMU [=n]
  Selected by [y]:
  - ZRAM [=y] && BLK_DEV [=y] && BLOCK [=y] && SYSFS [=y] && (CRYPTO_LZO [=y] || CRYPTO_ZSTD [=m] || CRYPTO_LZ4 [=m] || CRYPTO_LZ4HC [=n] || CRYPTO_842 [=n])

Link: https://lkml.kernel.org/r/20220522204027.22964-1-rdunlap@infradead.org
Fixes: b3fbd58fcbb10 ("mm: Kconfig: simplify zswap configuration")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/Kconfig~zram-fix-kconfig-dependency-warning
+++ a/drivers/block/zram/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config ZRAM
 	tristate "Compressed RAM block device support"
-	depends on BLOCK && SYSFS
+	depends on BLOCK && SYSFS && MMU
 	depends on CRYPTO_LZO || CRYPTO_ZSTD || CRYPTO_LZ4 || CRYPTO_LZ4HC || CRYPTO_842
 	select ZSMALLOC
 	help
_

Patches currently in -mm which might be from rdunlap@infradead.org are

zram-fix-kconfig-dependency-warning.patch


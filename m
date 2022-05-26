Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5ED8C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 26 May 2022 21:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245433AbiEZVD5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 May 2022 17:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbiEZVDx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2022 17:03:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F592E7312
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 14:03:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99E0A61AC6
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 21:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BF9C385A9;
        Thu, 26 May 2022 21:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653599029;
        bh=OrI4CmpF/cNkknVDAJyBPmHsW3lfG3dlnvWg1ShHgZ0=;
        h=Date:To:From:Subject:From;
        b=x5X8yQJ1MRqTe58OIFZ3R92u/8NdvZwy0n/+14U6kVeAXUKIiMra+LHd7UWDUHHgW
         DGBsqPG/AZrfJfobuQoTGRCKAkEh777iJ7LHBDqT5QpEmWV+t3FbWaJbe/elr8izIY
         IYJ3ev6kCn7/8dv/j85aowWxOOHKU72bZOZt1K8s=
Date:   Thu, 26 May 2022 14:03:49 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, hannes@cmpxchg.org,
        axboe@kernel.dk, rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-fix-kconfig-dependency-warning.patch removed from -mm tree
Message-Id: <20220526210349.C9BF9C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: fix Kconfig dependency warning
has been removed from the -mm tree.  Its filename was
     zram-fix-kconfig-dependency-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC805C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 00:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbiKOAmQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 19:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236173AbiKOAmP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 19:42:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A331B1D9
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 16:42:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8626F614E2
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 00:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9B7C433C1;
        Tue, 15 Nov 2022 00:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668472932;
        bh=/krplORB6vTuX96ZCiwh9VlAMVhttpnJKwjwomNFtN8=;
        h=Date:To:From:Subject:From;
        b=IbgdvpFMNKhH9ctL4MPSQWYneHlbmMu9eILakfHDXAjZtKyVGUT+VVxkjBhTPFd1D
         22tYFZuoQIb6NmdjnXQ5pkVVrdAMMZwr4NndchiMgOdNc4JZb18Veo8e/6SrQF7IRO
         hyCiJmiWy75i7y13hg3cq/x0y7tTIJOczLe27ogw=
Date:   Mon, 14 Nov 2022 16:42:12 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, ngupta@vflare.org,
        minchan@kernel.org, keescook+coverity-bot@chromium.org,
        keescook@chromium.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-introduce-recompress-sysfs-knob-fix-2.patch added to mm-unstable branch
Message-Id: <20221115004212.CD9B7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: explicitly limit prio_max for static analyzers
has been added to the -mm mm-unstable branch.  Its filename is
     zram-introduce-recompress-sysfs-knob-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-introduce-recompress-sysfs-knob-fix-2.patch

This patch will later appear in the mm-unstable branch at
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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: explicitly limit prio_max for static analyzers
Date: Mon, 14 Nov 2022 11:14:20 +0900

Link: https://lkml.kernel.org/r/20221114021420.4060601-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/zram/zram_drv.c~zram-introduce-recompress-sysfs-knob-fix-2
+++ a/drivers/block/zram/zram_drv.c
@@ -1689,6 +1689,7 @@ static int zram_recompress(struct zram *
 	 * Iterate the secondary comp algorithms list (in order of priority)
 	 * and try to recompress the page.
 	 */
+	prio_max = min(prio_max, ZRAM_MAX_COMPS);
 	for (; prio < prio_max; prio++) {
 		if (!zram->comps[prio])
 			continue;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
zram-introduce-recompress-sysfs-knob-fix.patch
zram-introduce-recompress-sysfs-knob-fix-2.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zram-remove-redundant-checks-from-zram_recompress.patch
zram-add-algo-parameter-support-to-zram_recompress.patch
documentation-add-zram-recompression-documentation.patch
zram-add-incompressible-writeback.patch
zram-add-incompressible-flag-to-read_block_state.patch


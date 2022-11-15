Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7ACEC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 23:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiKOXHq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 18:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiKOXHp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 18:07:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9C22C67F
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 15:07:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C837B81B88
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 23:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E006FC433B5;
        Tue, 15 Nov 2022 23:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668553662;
        bh=A866E0QqttkPIYg5f9pbMdQtpSjXfXf4WMbQcXaFRd4=;
        h=Date:To:From:Subject:From;
        b=smeOl8qXsg+PYf6lvZAl9NJxNMh8gbZKW12c+eISQOSgLfbNIrEIRAn285pq9ImDv
         IyqqF0dCuGKbUj1QGB6uVl4mgRCHDWnAxPBdKvkSBfsQT352rxM6uh/obJT7dluPHa
         03m0woblSjO+F8lL5QgpunWFp6ItRHDsPK3L00Gg=
Date:   Tue, 15 Nov 2022 15:07:41 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, ngupta@vflare.org,
        minchan@kernel.org, keescook+coverity-bot@chromium.org,
        keescook@chromium.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] zram-introduce-recompress-sysfs-knob-fix-2.patch removed from -mm tree
Message-Id: <20221115230741.E006FC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: explicitly limit prio_max for static analyzers
has been removed from the -mm tree.  Its filename was
     zram-introduce-recompress-sysfs-knob-fix-2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: explicitly limit prio_max for static analyzers
Date: Mon, 14 Nov 2022 11:14:20 +0900

coverity (got confused by the code, so this simply is supposed to help
coverity figure out that we never do an out of bounds access in comps[]
array: https://lore.kernel.org/lkml/202211100847.388C61B3@keescook/

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
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zram-remove-redundant-checks-from-zram_recompress.patch
zram-add-algo-parameter-support-to-zram_recompress.patch
documentation-add-zram-recompression-documentation.patch
zram-add-incompressible-writeback.patch
zram-add-incompressible-flag-to-read_block_state.patch


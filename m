Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7DEAC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 23:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiJRXVC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 19:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiJRXU4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 19:20:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4E4D7E3C
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 16:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBB85B8218F
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 23:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AD3C433C1;
        Tue, 18 Oct 2022 23:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666135250;
        bh=8sp4NW7DEJ0qZ3xMjnNKhaF60CIPMPTbTH0JJwURpIE=;
        h=Date:To:From:Subject:From;
        b=LEiWffe2qqW+HzMrQ2SXfUvbUNqw2jKYmZ8HNG6eSZjqQH/UqyYb55RgBg4Qe/Zcw
         OIOu5TEILqPS47Q4JK2HrIuk9Iec7vDGlg+9v9LOkuET6Uk1smIExaA31JfjsnME/U
         8eckvB4MP4oIdQ4DliKfF6Ug0eiSptWE+2GmxyM0=
Date:   Tue, 18 Oct 2022 16:20:49 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-add-recompression-documentation.patch added to mm-unstable branch
Message-Id: <20221018232050.70AD3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: documentation: add recompression documentation
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-add-recompression-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-add-recompression-documentation.patch

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
Subject: documentation: add recompression documentation
Date: Tue, 18 Oct 2022 13:55:29 +0900

Document user-space visible device attributes that are enabled by
ZRAM_MULTI_COMP.

Link: https://lkml.kernel.org/r/20221018045533.2396670-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   55 ++++++++++++++++++
 1 file changed, 55 insertions(+)

--- a/Documentation/admin-guide/blockdev/zram.rst~documentation-add-recompression-documentation
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -401,6 +401,61 @@ budget in next setting is user's job.
 If admin wants to measure writeback count in a certain period, they could
 know it via /sys/block/zram0/bd_stat's 3rd column.
 
+recompression
+-------------
+
+With CONFIG_ZRAM_MULTI_COMP, zram can recompress idle/huge pages using
+alternative (secondary) compression algorithm. The basic idea is that
+alternative compression algorithm can provide better compression ratio
+at a price of (potentially) slower compression/decompression speeds.
+Alternative compression algorithm can, for example, be more successful
+compressing huge pages (those that default algorithm failed to compress).
+Another application is idle pages recompression - pages that are cold and
+sit in the memory can be recompressed using more effective algorithm and,
+hence, reduce zsmalloc memory usage.
+
+With CONFIG_ZRAM_MULTI_COMP, zram will setup two compression algorithms
+per-CPU: primary and secondary ones. Primary zram compressor is explained
+in "3) Select compression algorithm", the secondary algorithm is configured
+in a similar way, using recomp_algorithm device attribute:
+
+Examples::
+
+	#show supported recompression algorithms
+	cat /sys/block/zramX/recomp_algorithm
+	zstd [lzo]
+
+	#select zstd recompression algorithm
+	echo zstd > /sys/block/zramX/recomp_algorithm
+
+Another device attribute that CONFIG_ZRAM_MULTI_COMP enables is recompress,
+which controls recompression:
+
+Examples::
+
+	#IDLE pages recompression is activated by `idle` mode
+	echo idle > /sys/block/zramX/recompress
+
+	#HUGE pages recompression is activated by `huge` mode
+	echo huge > /sys/block/zram0/recompress
+
+	#HUGE_IDLE pages recompression is activated by `huge_idle` mode
+	echo huge_idle > /sys/block/zramX/recompress
+
+The number of idle pages can be significant, so user-space can pass a size
+watermark value (in bytes) to the recompress knob, to filter out idle pages
+for recompression: zram will recompress only idle pages of equal or greater
+size:::
+
+	#recompress idle pages larger than 3000 bytes
+	echo 3000 > /sys/block/zramX/recompress
+
+	#recompress idle pages larger than 2000 bytes
+	echo 2000 > /sys/block/zramX/recompress
+
+Recompression is mostly focused on idle pages (except for huge pages
+recompression), so it works better in conjunction with memory tracking.
+
 memory tracking
 ===============
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
documentation-add-recompression-documentation.patch
zram-add-recompression-algorithm-choice-to-kconfig.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch


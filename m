Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A61EC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 03:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiJRDWT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 23:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiJRDVf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 23:21:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3494A0316
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57BA26142C
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 03:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2F5C433B5;
        Tue, 18 Oct 2022 03:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666062910;
        bh=MsZSZ+tR3N9tkEQgne/ZjU6ifv+imeZzjPFOMKPrkh8=;
        h=Date:To:From:Subject:From;
        b=NQ0Wt6qfU4Ky1UEACmdfNzEgLlGvL+2GR5xomyXxAMTpyYUbvWFaQbT5xLKSD3qJa
         aYfr6wn/meWMcuU6vmW1GVpZghWpK/FYzXGVes2yAeExDfXbdBwwTUVzE1NjXY2RKD
         oPC8M5zy8+/kt8aeeTF/3zMNOCT4ivTO1gLgmiig=
Date:   Mon, 17 Oct 2022 20:15:09 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-add-recompression-documentation-fix.patch added to mm-unstable branch
Message-Id: <20221018031510.AC2F5C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Re: documentation: Add recompression documentation
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-add-recompression-documentation-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-add-recompression-documentation-fix.patch

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
Subject: Re: documentation: Add recompression documentation
Date: Tue, 18 Oct 2022 11:50:21 +0900

Document user-space visible device attributes that
are enabled by ZRAM_MULTI_COMP.

Link: https://lkml.kernel.org/r/Y04UbTZh3fJYPhvJ@google.com
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   55 ++++++++++++++++++
 1 file changed, 55 insertions(+)

--- a/Documentation/admin-guide/blockdev/zram.rst~documentation-add-recompression-documentation-fix
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -456,6 +456,61 @@ size:::
 Recompression is mostly focused on idle pages (except for huge pages
 recompression), so it works better in conjunction with memory tracking.
 
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
+watermark (in bytes) value to the recompress knob, to filter out idle pages
+for recompression: zram will recompress only idle pages of equal or greater
+size (bytes):::
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
zram-introduce-recompress-sysfs-knob-fix.patch
documentation-add-recompression-documentation.patch
documentation-add-recompression-documentation-fix.patch
zram-add-recompression-algorithm-choice-to-kconfig.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-correct-typos.patch


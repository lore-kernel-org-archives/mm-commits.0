Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8098CC43217
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 00:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiKJAbj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiKJAbZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 19:31:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1412A25C
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 16:31:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D2F1B82058
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 00:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BEFC433D7;
        Thu, 10 Nov 2022 00:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668040270;
        bh=YQ3gKEx9RS8Th24RdmYza9MRQ7kurlWb/BVKlNNI1KI=;
        h=Date:To:From:Subject:From;
        b=tTAZifzMm+CZ+thG51RNveUpr8yhwIVd59P59TCfQIVHrm7z7EF7BD4iUptwVGN3h
         vjfQLVLtZ3s/r7fSMHy5Y6bS8bEcV/wi6Pv+M4ipHnGJoGJe5fd74RILyOMXPNgyVl
         +1IOpI4P6ccfPlSI3gqkUEbD5OdqZvPmRMMzTeSQ=
Date:   Wed, 09 Nov 2022 16:31:10 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-add-zram-recompression-documentation.patch added to mm-unstable branch
Message-Id: <20221110003110.D4BEFC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: documentation: add zram recompression documentation
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-add-zram-recompression-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-add-zram-recompression-documentation.patch

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
Subject: documentation: add zram recompression documentation
Date: Wed, 9 Nov 2022 20:50:45 +0900

Document user-space visible device attributes that are enabled by
ZRAM_MULTI_COMP.

Link: https://lkml.kernel.org/r/20221109115047.2921851-12-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   81 ++++++++++++++++++
 1 file changed, 81 insertions(+)

--- a/Documentation/admin-guide/blockdev/zram.rst~documentation-add-zram-recompression-documentation
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -401,6 +401,87 @@ budget in next setting is user's job.
 If admin wants to measure writeback count in a certain period, they could
 know it via /sys/block/zram0/bd_stat's 3rd column.
 
+recompression
+-------------
+
+With CONFIG_ZRAM_MULTI_COMP, zram can recompress pages using alternative
+(secondary) compression algorithms. The basic idea is that alternative
+compression algorithm can provide better compression ratio at a price of
+(potentially) slower compression/decompression speeds. Alternative compression
+algorithm can, for example, be more successful compressing huge pages (those
+that default algorithm failed to compress). Another application is idle pages
+recompression - pages that are cold and sit in the memory can be recompressed
+using more effective algorithm and, hence, reduce zsmalloc memory usage.
+
+With CONFIG_ZRAM_MULTI_COMP, zram supports up to 4 compression algorithms:
+one primary and up to 3 secondary ones. Primary zram compressor is explained
+in "3) Select compression algorithm", secondary algorithms are configured
+using recomp_algorithm device attribute.
+
+Example:::
+
+	#show supported recompression algorithms
+	cat /sys/block/zramX/recomp_algorithm
+	#1: lzo lzo-rle lz4 lz4hc [zstd]
+	#2: lzo lzo-rle lz4 [lz4hc] zstd
+
+Alternative compression algorithms are sorted by priority. In the example
+above, zstd is used as the first alternative algorithm, which has priority
+of 1, while lz4hc is configured as a compression algorithm with priority 2.
+Alternative compression algorithm's priority is provided during algorithms
+configuration:::
+
+	#select zstd recompression algorithm, priority 1
+	echo "algo=zstd priority=1" > /sys/block/zramX/recomp_algorithm
+
+	#select deflate recompression algorithm, priority 2
+	echo "algo=deflate priority=2" > /sys/block/zramX/recomp_algorithm
+
+Another device attribute that CONFIG_ZRAM_MULTI_COMP enables is recompress,
+which controls recompression.
+
+Examples:::
+
+	#IDLE pages recompression is activated by `idle` mode
+	echo "type=idle" > /sys/block/zramX/recompress
+
+	#HUGE pages recompression is activated by `huge` mode
+	echo "type=huge" > /sys/block/zram0/recompress
+
+	#HUGE_IDLE pages recompression is activated by `huge_idle` mode
+	echo "type=huge_idle" > /sys/block/zramX/recompress
+
+The number of idle pages can be significant, so user-space can pass a size
+threshold (in bytes) to the recompress knob: zram will recompress only pages
+of equal or greater size:::
+
+	#recompress all pages larger than 3000 bytes
+	echo "threshold=3000" > /sys/block/zramX/recompress
+
+	#recompress idle pages larger than 2000 bytes
+	echo "type=idle threshold=2000" > /sys/block/zramX/recompress
+
+Recompression of idle pages requires memory tracking.
+
+During re-compression for every page, that matches re-compression criteria,
+ZRAM iterates the list of registered alternative compression algorithms in
+order of their priorities. ZRAM stops either when re-compression was
+successful (re-compressed object is smaller in size than the original one)
+and matches re-compression criteria (e.g. size threshold) or when there are
+no secondary algorithms left to try. If none of the secondary algorithms can
+successfully re-compressed the page such a page is marked as incompressible,
+so ZRAM will not attempt to re-compress it in the future.
+
+This re-compression behaviour, when it iterates through the list of
+registered compression algorithms, increases our chances of finding the
+algorithm that successfully compresses a particular page. Sometimes, however,
+it is convenient (and sometimes even necessary) to limit recompression to
+only one particular algorithm so that it will not try any other algorithms.
+This can be achieved by providing a algo=NAME parameter:::
+
+	#use zstd algorithm only (if registered)
+	echo "type=huge algo=zstd" > /sys/block/zramX/recompress
+
 memory tracking
 ===============
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zram-remove-redundant-checks-from-zram_recompress.patch
zram-add-algo-parameter-support-to-zram_recompress.patch
documentation-add-zram-recompression-documentation.patch
zram-add-incompressible-writeback.patch
zram-add-incompressible-flag-to-read_block_state.patch


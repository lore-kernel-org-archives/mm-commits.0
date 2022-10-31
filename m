Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B17EBECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 31 Oct 2022 22:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiJaW3p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiJaW3U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2022 18:29:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F08526F7
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 15:29:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E0E1BCE191D
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 22:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A52C433C1;
        Mon, 31 Oct 2022 22:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667255341;
        bh=RLX0TmFFgYV5lxk6za4Peu9VZbQo8nSw+JFQ457Z68o=;
        h=Date:To:From:Subject:From;
        b=2lxCGAz50QvH+JqlHjMF5Bbumo+Dg2qZOB7s0hJAGEMLiOJ3zweY2OZk13otG6GpD
         2y8JAABsuXP7pMDknXwmdD0K7Rbth1BC1854miRtwHAjkNK9QWoh/POnqxFqzIsnxl
         h61I6WbB9uxF1uAy3JoPLs56jESCNu3FhpGrqMoA=
Date:   Mon, 31 Oct 2022 15:29:00 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        avromanov@sberdevices.ru, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-document-zram-pages_per_pool_page-attribute.patch added to mm-unstable branch
Message-Id: <20221031222900.E7A52C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: document zram pages_per_pool_page attribute
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-document-zram-pages_per_pool_page-attribute.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-document-zram-pages_per_pool_page-attribute.patch

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
Subject: Documentation: document zram pages_per_pool_page attribute
Date: Mon, 31 Oct 2022 14:41:07 +0900

Provide a simple documentation for pages_per_pool_page ZRAM device
attribute.

Link: https://lkml.kernel.org/r/20221031054108.541190-9-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   38 ++++++++++++++----
 1 file changed, 30 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~documentation-document-zram-pages_per_pool_page-attribute
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -112,7 +112,29 @@ to list all of them using, for instance,
 method. This, however, has an advantage of permitting the usage of
 custom crypto compression modules (implementing S/W or H/W compression).
 
-4) Set Disksize
+4) Set pages per-pool page limit: Optional
+==========================================
+
+zsmalloc pages can consist of up to ZS_DEFAULT_PAGES_PER_ZSPAGE (single)
+physical pages. The exact number is calculated for each zsmalloc size
+class during zsmalloc pool creation. ZRAM provides pages_per_pool_page
+device attribute that lets one adjust that limit (maximum possible value
+is ZS_MAX_PAGES_PER_ZSPAGE). The default limit is considered to be good
+enough, so tweak this value only when the changes in zsmalloc size classes
+characteristics are beneficial for your data patterns. The limit on the
+pages per zspages (currently) should be in [1,16] range; default value
+is 4.
+
+Examples::
+
+	#show current zsmalloc pages per-pool page limit
+	cat /sys/block/zramX/pages_per_pool_page
+	4
+
+	#set zsmalloc pages per-pool page limit
+	echo 8 > /sys/block/zramX/pages_per_pool_page
+
+5) Set Disksize
 ===============
 
 Set disk size by writing the value to sysfs node 'disksize'.
@@ -132,7 +154,7 @@ There is little point creating a zram of
 since we expect a 2:1 compression ratio. Note that zram uses about 0.1% of the
 size of the disk when not in use so a huge zram is wasteful.
 
-5) Set memory limit: Optional
+6) Set memory limit: Optional
 =============================
 
 Set memory limit by writing the value to sysfs node 'mem_limit'.
@@ -151,7 +173,7 @@ Examples::
 	# To disable memory limit
 	echo 0 > /sys/block/zram0/mem_limit
 
-6) Activate
+7) Activate
 ===========
 
 ::
@@ -162,7 +184,7 @@ Examples::
 	mkfs.ext4 /dev/zram1
 	mount /dev/zram1 /tmp
 
-7) Add/remove zram devices
+8) Add/remove zram devices
 ==========================
 
 zram provides a control interface, which enables dynamic (on-demand) device
@@ -182,7 +204,7 @@ execute::
 
 	echo X > /sys/class/zram-control/hot_remove
 
-8) Stats
+9) Stats
 ========
 
 Per-device statistics are exported as various nodes under /sys/block/zram<id>/
@@ -283,15 +305,15 @@ a single line of text and contains the f
 		Unit: 4K bytes
  ============== =============================================================
 
-9) Deactivate
-=============
+10) Deactivate
+==============
 
 ::
 
 	swapoff /dev/zram0
 	umount /dev/zram1
 
-10) Reset
+11) Reset
 =========
 
 	Write any positive value to 'reset' sysfs node::
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
zsmalloc-turn-zspage-order-into-runtime-variable.patch
zsmalloc-move-away-from-page-order-defines.patch
zsmalloc-make-huge-class-watermark-zs_pool-member.patch
zram-huge-size-watermark-cannot-be-global.patch
zsmalloc-pass-limit-on-pages-per-zspage-to-zs_create_pool.patch
zram-add-pages_per_pool_page-device-attribute.patch
documentation-document-zram-pages_per_pool_page-attribute.patch
zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch


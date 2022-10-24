Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB144C38A2D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Oct 2022 22:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiJXWTv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 18:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbiJXWT0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 18:19:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEA42D6E26
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 13:36:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7AB5B81250
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 20:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC00C433C1;
        Mon, 24 Oct 2022 20:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666643741;
        bh=iaBPJVnxeHtvtUtIZ2XZ2fuZzmHrFAjskK8wGYqu8ik=;
        h=Date:To:From:Subject:From;
        b=YKFDwbDwT7QXkTTBM+Gy268XQaHSRsXJr91zhVeKY5lSQVFRZmYnpc+sMbHJ6AMzR
         R4p3qFH7w7oJH6uokLuJlfjSmZ7UlWa70mO+luUFJEsQWq55WURU0xPeGkzbEBZM3M
         IW52ozPvOXpXRSeqnd6er/aBLW9bhknluHIO/sTo=
Date:   Mon, 24 Oct 2022 13:35:40 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-document-zram-pool_page_order-attribute.patch added to mm-unstable branch
Message-Id: <20221024203541.5DC00C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: document zram pool_page_order attribute
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-document-zram-pool_page_order-attribute.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-document-zram-pool_page_order-attribute.patch

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
Subject: Documentation: document zram pool_page_order attribute
Date: Tue, 25 Oct 2022 01:12:11 +0900

Provide a simple documentation for zram pool_page_order device attribute.

Link: https://lkml.kernel.org/r/20221024161213.3221725-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   31 +++++++++++++-----
 1 file changed, 24 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~documentation-document-zram-pool_page_order-attribute
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -112,7 +112,24 @@ to list all of them using, for instance,
 method. This, however, has an advantage of permitting the usage of
 custom crypto compression modules (implementing S/W or H/W compression).
 
-4) Set Disksize
+4) Set maximum pool page order
+==============================
+
+zsmalloc pages can consist of up to 2^N physical pages. The exact size
+is calculated per each zsmalloc size class during zsmalloc pool creation.
+ZRAM provides pool_page_order device attribute to see or change N.
+
+Examples::
+
+	#show current maximum zsmalloc page order
+	cat /sys/block/zramX/pool_page_order
+	2
+
+	#set maximum zsmalloc page order
+	echo 3 > /sys/block/zramX/pool_page_order
+
+
+5) Set Disksize
 ===============
 
 Set disk size by writing the value to sysfs node 'disksize'.
@@ -132,7 +149,7 @@ There is little point creating a zram of
 since we expect a 2:1 compression ratio. Note that zram uses about 0.1% of the
 size of the disk when not in use so a huge zram is wasteful.
 
-5) Set memory limit: Optional
+6) Set memory limit: Optional
 =============================
 
 Set memory limit by writing the value to sysfs node 'mem_limit'.
@@ -151,7 +168,7 @@ Examples::
 	# To disable memory limit
 	echo 0 > /sys/block/zram0/mem_limit
 
-6) Activate
+7) Activate
 ===========
 
 ::
@@ -162,7 +179,7 @@ Examples::
 	mkfs.ext4 /dev/zram1
 	mount /dev/zram1 /tmp
 
-7) Add/remove zram devices
+8) Add/remove zram devices
 ==========================
 
 zram provides a control interface, which enables dynamic (on-demand) device
@@ -182,7 +199,7 @@ execute::
 
 	echo X > /sys/class/zram-control/hot_remove
 
-8) Stats
+9) Stats
 ========
 
 Per-device statistics are exported as various nodes under /sys/block/zram<id>/
@@ -283,7 +300,7 @@ a single line of text and contains the f
 		Unit: 4K bytes
  ============== =============================================================
 
-9) Deactivate
+10) Deactivate
 =============
 
 ::
@@ -291,7 +308,7 @@ a single line of text and contains the f
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
zsmalloc-zram-pass-zspage-order-to-zs_create_pool.patch
zram-add-pool_page_order-device-attribute.patch
documentation-document-zram-pool_page_order-attribute.patch
zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch
zsmalloc-make-sure-we-select-best-zspage-size.patch


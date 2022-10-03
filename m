Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B2FC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiJCVNN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4E451A1A
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49429611FB
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBA7C433C1;
        Mon,  3 Oct 2022 21:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831229;
        bh=udYkpI9AYSWNxRc3MtglbOD0cy96LNt67cwh1Onl1UA=;
        h=Date:To:From:Subject:From;
        b=muDPiO+Y1TtPHDL252/4m3Ql5ctkqvzC5xy5nQs/OKD9xK8KPAbU/yn7XspbiQ4+4
         5VKsHPMqHUqYg0DcNlGb7oeGZ6HSzU/iEl9mrpvSeemz57NBuzg2TGM68Y8nn9iY9U
         pE46/wMv/FpD/3DU+l6T2W85OQ3LuVfWw3G/jRMg=
Date:   Mon, 03 Oct 2022 14:07:08 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        bgeffon@google.com, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-do-not-waste-zram_table_entry-flags-bits.patch removed from -mm tree
Message-Id: <20221003210709.9DBA7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: do not waste zram_table_entry flags bits
has been removed from the -mm tree.  Its filename was
     zram-do-not-waste-zram_table_entry-flags-bits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not waste zram_table_entry flags bits
Date: Tue, 13 Sep 2022 00:27:44 +0900

zram_table_entry::flags stores object size in the lower bits and zram
pageflags in the upper bits.  However, for some reason, we use 24 lower
bits, while maximum zram object size is PAGE_SIZE, which requires
PAGE_SHIFT bits (up to 16 on arm64).  This wastes 24 - PAGE_SHIFT bits
that we can use for additional zram pageflags instead.

Also add a BUILD_BUG_ON() to alert us should we run out of bits in
zram_table_entry::flags.

Link: https://lkml.kernel.org/r/20220912152744.527438-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Brian Geffon <bgeffon@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 drivers/block/zram/zram_drv.h |   15 +++++++--------
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-waste-zram_table_entry-flags-bits
+++ a/drivers/block/zram/zram_drv.c
@@ -2131,6 +2131,8 @@ static int __init zram_init(void)
 {
 	int ret;
 
+	BUILD_BUG_ON(__NR_ZRAM_PAGEFLAGS > BITS_PER_LONG);
+
 	ret = cpuhp_setup_state_multi(CPUHP_ZCOMP_PREPARE, "block/zram:prepare",
 				      zcomp_cpu_up_prepare, zcomp_cpu_dead);
 	if (ret < 0)
--- a/drivers/block/zram/zram_drv.h~zram-do-not-waste-zram_table_entry-flags-bits
+++ a/drivers/block/zram/zram_drv.h
@@ -30,16 +30,15 @@
 
 
 /*
- * The lower ZRAM_FLAG_SHIFT bits of table.flags is for
- * object size (excluding header), the higher bits is for
- * zram_pageflags.
+ * ZRAM is mainly used for memory efficiency so we want to keep memory
+ * footprint small and thus squeeze size and zram pageflags into a flags
+ * member. The lower ZRAM_FLAG_SHIFT bits is for object size (excluding
+ * header), which cannot be larger than PAGE_SIZE (requiring PAGE_SHIFT
+ * bits), the higher bits are for zram_pageflags.
  *
- * zram is mainly used for memory efficiency so we want to keep memory
- * footprint small so we can squeeze size and flags into a field.
- * The lower ZRAM_FLAG_SHIFT bits is for object size (excluding header),
- * the higher bits is for zram_pageflags.
+ * We use BUILD_BUG_ON() to make sure that zram pageflags don't overflow.
  */
-#define ZRAM_FLAG_SHIFT 24
+#define ZRAM_FLAG_SHIFT (PAGE_SHIFT + 1)
 
 /* Flags for zram pages (table[page_no].flags) */
 enum zram_pageflags {
_

Patches currently in -mm which might be from senozhatsky@chromium.org are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97896C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 03:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiJRDbp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 23:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiJRDbF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 23:31:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542679DD88
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:22:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 483E76140F
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 03:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F290C433D6;
        Tue, 18 Oct 2022 03:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666062731;
        bh=qgWIf7TdC/6oLYUU+85/Nfhc6gyNKmBm358XPNr3Qb0=;
        h=Date:To:From:Subject:From;
        b=OJ4m9agDTcKJzLhH62vcW7i+HMtq/C0PdZTbRjN71b6+CooeEtRlZvOVNl5Lf9P0T
         u8WjaQ26T/LZY9uShyg+ZJuYyIT4LxhNcHFAg6s6Zesco6eEfIdtBRWMVZVwUZhzIM
         wKoZDlIvVE8O9XU5uGRrvllcvKhTmUXtM1jCFbXM=
Date:   Mon, 17 Oct 2022 20:12:10 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-introduce-recompress-sysfs-knob-fix.patch added to mm-unstable branch
Message-Id: <20221018031211.9F290C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Re: zram: Introduce recompress sysfs knob
has been added to the -mm mm-unstable branch.  Its filename is
     zram-introduce-recompress-sysfs-knob-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-introduce-recompress-sysfs-knob-fix.patch

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
Subject: Re: zram: Introduce recompress sysfs knob
Date: Tue, 18 Oct 2022 11:42:39 +0900

A fixup patch: update Kconfig description and tweak coding styles.

Link: https://lkml.kernel.org/r/Y04Sn50kt5qLxpbK@google.com
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig    |    3 +++
 drivers/block/zram/zram_drv.c |    7 ++-----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/block/zram/Kconfig~zram-introduce-recompress-sysfs-knob-fix
+++ a/drivers/block/zram/Kconfig
@@ -90,3 +90,6 @@ config ZRAM_MULTI_COMP
 
           echo TIMEOUT > /sys/block/zramX/idle
           echo SIZE > /sys/block/zramX/recompress
+
+	SIZE (in bytes) parameter sets the object size watermark: idle
+	objects that are of a smaller size will not get recompressed.
--- a/drivers/block/zram/zram_drv.c~zram-introduce-recompress-sysfs-knob-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -1623,9 +1623,7 @@ out:
  *
  * Corresponding ZRAM slot should be locked.
  */
-static int zram_recompress(struct zram *zram,
-			   u32 index,
-			   struct page *page,
+static int zram_recompress(struct zram *zram, u32 index, struct page *page,
 			   int size_watermark)
 {
 	unsigned long handle_prev;
@@ -1708,8 +1706,7 @@ static int zram_recompress(struct zram *
 
 static ssize_t recompress_store(struct device *dev,
 				struct device_attribute *attr,
-				const char *buf,
-				size_t len)
+				const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
zram-introduce-recompress-sysfs-knob-fix.patch
documentation-add-recompression-documentation.patch
zram-add-recompression-algorithm-choice-to-kconfig.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-correct-typos.patch


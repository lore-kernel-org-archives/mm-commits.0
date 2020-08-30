Return-Path: <SRS0=GXSN=CI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3214C433E2
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 19:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCBDE20757
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 19:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598817529;
	bh=1VsczWhSQPszi+0xzBgl/vj3piLDBlNHxHeUPewiiHw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dyEgUQnjS8RoInI1ZOnMODtaacwupksxAIR/Z4oEU5AfxtGtv8c6L0+Wc7KqmnA6f
	 vphcHXvY4vSnCuXOMbSPoCxLP/Tejx+vI82lThg7RO+BT0+jmXvth04vngLOjY5BNe
	 OxndyCV6e1sejT3yScTfP79dUTB3YqQE9ubuRw/4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgH3T6t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 15:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgH3T6s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 15:58:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A33A20757;
        Sun, 30 Aug 2020 19:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598817528;
        bh=1VsczWhSQPszi+0xzBgl/vj3piLDBlNHxHeUPewiiHw=;
        h=Date:From:To:Subject:From;
        b=i4O0c7r7ddMgoZ9PYiW7nnaHgaunjb2jBD97X8j32dS8EAxNeyGbkU9PdXOitTado
         0jzSZfU4amvL66WxHAFC0J+Za8U7io+BMnLdkMMNMOYeBoCVeSf+AQovnw2vOeSFXF
         rAX9T2hDdNN6tMpWv6XUrkYUH2UhUq4vAI7mMlmI=
Date:   Sun, 30 Aug 2020 12:58:47 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20200830195847.3wId5L4qJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   23 ------------
 1 file changed, 23 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3027,28 +3027,6 @@ static int get_brightness_range(const st
 	}
 	return 1;
 }
-<<<<<<< HEAD
-
-static u32 convert_brightness_from_user(const struct amdgpu_dm_backlight_caps *caps,
-					uint32_t brightness)
-{
-	unsigned min, max;
-
-	if (!get_brightness_range(caps, &min, &max))
-		return brightness;
-
-	// Rescale 0..255 to min..max
-	return min + DIV_ROUND_CLOSEST((max - min) * brightness,
-				       AMDGPU_MAX_BL_LEVEL);
-}
-
-static u32 convert_brightness_to_user(const struct amdgpu_dm_backlight_caps *caps,
-				      uint32_t brightness)
-{
-	unsigned min, max;
-
-=======
-
 static u32 convert_brightness_from_user(const struct amdgpu_dm_backlight_caps *caps,
 					uint32_t brightness)
 {
@@ -3067,7 +3045,6 @@ static u32 convert_brightness_to_user(co
 {
 	unsigned min, max;
 
->>>>>>> linux-next/akpm-base
 	if (!get_brightness_range(caps, &min, &max))
 		return brightness;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch


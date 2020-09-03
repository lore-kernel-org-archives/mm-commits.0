Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CAFC433E2
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1E5E20658
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599159784;
	bh=aPrNgkpH3po0IN8PQRToUxImbf7psgnj0GcxfUxJ4BA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=nmhKHuoqLKhHkmcFKUKCCENgBCTOV+wz4k5NJQ5t5VDRn9wWiRICa9mRj/qPrcWFd
	 sj/JVAUtT0Jj6OBvU4TbaaA+fgjmg8gSAPfSDVsfi3UC0U2usjIBeoHlTQaDJsMa/E
	 Cdm9FNHmvuuiOPnXUlb2BHv5z8hQsBTexQNW4SB4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbgICTDE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 15:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729051AbgICTDE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 15:03:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D97E20658;
        Thu,  3 Sep 2020 19:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599159781;
        bh=aPrNgkpH3po0IN8PQRToUxImbf7psgnj0GcxfUxJ4BA=;
        h=Date:From:To:Subject:From;
        b=zmoe9Y6bYhL4k9PpbrKPJX9l5lzTyfYxUUl/2G/wP7IBYsOmF/VYrRme7lppMXoOg
         LUSwE7Stjjql2Xe3WxjxSJCjiVsxCaaB4EdcXvRAL9GwQnucOgrgJxdYe5UdXzDTm8
         WfZz8nMCNIvPXnfUiIqwZinH+KHxIGEgWn28HrOQ=
Date:   Thu, 03 Sep 2020 12:03:01 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20200903190301.IPynhWIBA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

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


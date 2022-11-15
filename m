Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C8CC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiKOWdW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238499AbiKOWcr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4351930564
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF4C8B81A1C
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E74C433D6;
        Tue, 15 Nov 2022 22:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551549;
        bh=PZORXXzcpRQfWUxpgfu5A6KP9hxDH9wBpl3kiPrG4kE=;
        h=Date:To:From:Subject:From;
        b=qh+REWXYZFVaPKr76AgjVfeGZaAu36/0vTUin8vweHRgF+i9c908FuwJc/G9Fv965
         ZKU+V6pLAQqj7/Lir//YCMPWJQWAcICsFxSzKaUUcOJF0/ZKkPVvtqDDX445VzJsfF
         SjDJ1tEIiV6NMLicsxJhiDXEmFtoEzFPoHHtHC98=
Date:   Tue, 15 Nov 2022 14:32:29 -0800
To:     mm-commits@vger.kernel.org, cuigaosheng1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-fonts-fix-undefined-behavior-in-bit-shift-for-get_default_font.patch removed from -mm tree
Message-Id: <20221115223229.91E74C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/fonts: fix undefined behavior in bit shift for get_default_font
has been removed from the -mm tree.  Its filename was
     lib-fonts-fix-undefined-behavior-in-bit-shift-for-get_default_font.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gaosheng Cui <cuigaosheng1@huawei.com>
Subject: lib/fonts: fix undefined behavior in bit shift for get_default_font
Date: Mon, 31 Oct 2022 19:38:29 +0800

Shifting signed 32-bit value by 31 bits is undefined, so changing
significant bit to unsigned.  The UBSAN warning calltrace like below:

UBSAN: shift-out-of-bounds in lib/fonts/fonts.c:139:20
left shift of 1 by 31 places cannot be represented in type 'int'
 <TASK>
 dump_stack_lvl+0x7d/0xa5
 dump_stack+0x15/0x1b
 ubsan_epilogue+0xe/0x4e
 __ubsan_handle_shift_out_of_bounds+0x1e7/0x20c
 get_default_font+0x1c7/0x1f0
 fbcon_startup+0x347/0x3a0
 do_take_over_console+0xce/0x270
 do_fbcon_takeover+0xa1/0x170
 do_fb_registered+0x2a8/0x340
 fbcon_fb_registered+0x47/0xe0
 register_framebuffer+0x294/0x4a0
 __drm_fb_helper_initial_config_and_unlock+0x43c/0x880 [drm_kms_helper]
 drm_fb_helper_initial_config+0x52/0x80 [drm_kms_helper]
 drm_fbdev_client_hotplug+0x156/0x1b0 [drm_kms_helper]
 drm_fbdev_generic_setup+0xfc/0x290 [drm_kms_helper]
 bochs_pci_probe+0x6ca/0x772 [bochs]
 local_pci_probe+0x4d/0xb0
 pci_device_probe+0x119/0x320
 really_probe+0x181/0x550
 __driver_probe_device+0xc6/0x220
 driver_probe_device+0x32/0x100
 __driver_attach+0x195/0x200
 bus_for_each_dev+0xbb/0x120
 driver_attach+0x27/0x30
 bus_add_driver+0x22e/0x2f0
 driver_register+0xa9/0x190
 __pci_register_driver+0x90/0xa0
 bochs_pci_driver_init+0x52/0x1000 [bochs]
 do_one_initcall+0x76/0x430
 do_init_module+0x61/0x28a
 load_module+0x1f82/0x2e50
 __do_sys_finit_module+0xf8/0x190
 __x64_sys_finit_module+0x23/0x30
 do_syscall_64+0x58/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 </TASK>

Link: https://lkml.kernel.org/r/20221031113829.4183153-1-cuigaosheng1@huawei.com
Fixes: c81f717cb9e0 ("fbcon: Fix typo and bogus logic in get_default_font")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fonts/fonts.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/fonts/fonts.c~lib-fonts-fix-undefined-behavior-in-bit-shift-for-get_default_font
+++ a/lib/fonts/fonts.c
@@ -135,8 +135,8 @@ const struct font_desc *get_default_font
 		if (res > 20)
 			c += 20 - res;
 
-		if ((font_w & (1 << (f->width - 1))) &&
-		    (font_h & (1 << (f->height - 1))))
+		if ((font_w & (1U << (f->width - 1))) &&
+		    (font_h & (1U << (f->height - 1))))
 			c += 1000;
 
 		if (c > cc) {
_

Patches currently in -mm which might be from cuigaosheng1@huawei.com are



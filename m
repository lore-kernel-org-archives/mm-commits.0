Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C61FA3744
	for <mm-commits@archiver.kernel.org>; Mon, 31 Oct 2022 22:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiJaWCW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiJaWCV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2022 18:02:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7DF140F7
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 15:02:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16E2D614C4
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 22:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A59FC43470;
        Mon, 31 Oct 2022 22:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667253737;
        bh=76qpCjD1H52Vm8XhCn7VBNuABKJfuSyMnY08Sh0jPi8=;
        h=Date:To:From:Subject:From;
        b=sEIa1npOQGg65hV6Ank8FBXYHuFsK1CM9XNsIs5wB389a8CB8PY3nv4CVo5dDA52E
         gj9BaTto+U2CYp4z9cYtbT21TZCya0Ao3DfYeC8baqDsYaJrlU515QSBIFTe6p6dwM
         Z3Tpmo32r+UC31BSjnZ0wtotIjo7Z5dhgOB3Yr5k=
Date:   Mon, 31 Oct 2022 15:02:16 -0700
To:     mm-commits@vger.kernel.org, cuigaosheng1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-fonts-fix-undefined-behavior-in-bit-shift-for-get_default_font.patch added to mm-nonmm-unstable branch
Message-Id: <20221031220217.6A59FC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/fonts: fix undefined behavior in bit shift for get_default_font
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-fonts-fix-undefined-behavior-in-bit-shift-for-get_default_font.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-fonts-fix-undefined-behavior-in-bit-shift-for-get_default_font.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

ia64-kprobes-remove-orphan-declarations-from-arch-ia64-include-asm-kprobesh.patch
lib-fonts-fix-undefined-behavior-in-bit-shift-for-get_default_font.patch


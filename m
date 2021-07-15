Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C7FAC636CD
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 21:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14C1B613CC
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 21:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbhGOVnE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 17:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhGOVnD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 17:43:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD5C0613C4;
        Thu, 15 Jul 2021 21:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626385208;
        bh=Xu96YLApAp3tAGFa5cca9UKCPT/Mex0P2qLo0lslomc=;
        h=Date:From:To:Subject:From;
        b=yiuF6nQ3lkOdXg0vCf57oGnGcW+YEeW6wXNFrOBfrB3bU4YqJZD3KFYU/0V6ea8D7
         /qf5P+uA21Bx2kxRc/vlzcgOLLgRvgY/3e3bvT/+gcvb5p3ALp7peegDafiK1/z2u4
         lHxthuFnTrPEXL1lZtsfiN63xqb7b7K/RyqxOLwU=
Date:   Thu, 15 Jul 2021 14:40:08 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, lkp@intel.com, mm-commits@vger.kernel.org
Subject:  + decouple-build-from-userspace-headers-fix.patch added
 to -mm tree
Message-ID: <20210715214008.IbiY7Klah%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fixup "Decouple build from userspace headers"
has been added to the -mm tree.  Its filename is
     decouple-build-from-userspace-headers-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/decouple-build-from-userspace-headers-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/decouple-build-from-userspace-headers-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fixup "Decouple build from userspace headers"

Allow to find SIMD headers where necessary.

Link: https://lkml.kernel.org/r/YPClYgoJOTUn4V0w@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/lib/Makefile   |    2 +-
 arch/powerpc/lib/Makefile |    2 +-
 lib/raid6/Makefile        |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/lib/Makefile~decouple-build-from-userspace-headers-fix
+++ a/arch/arm64/lib/Makefile
@@ -8,7 +8,7 @@ lib-y		:= clear_user.o delay.o copy_from
 ifeq ($(CONFIG_KERNEL_MODE_NEON), y)
 obj-$(CONFIG_XOR_BLOCKS)	+= xor-neon.o
 CFLAGS_REMOVE_xor-neon.o	+= -mgeneral-regs-only
-CFLAGS_xor-neon.o		+= -ffreestanding
+CFLAGS_xor-neon.o		+= -ffreestanding -isystem $(shell $(CC) -print-file-name=include)
 endif
 
 lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
--- a/arch/powerpc/lib/Makefile~decouple-build-from-userspace-headers-fix
+++ a/arch/powerpc/lib/Makefile
@@ -64,6 +64,6 @@ obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
 obj-$(CONFIG_FTR_FIXUP_SELFTEST) += feature-fixups-test.o
 
 obj-$(CONFIG_ALTIVEC)	+= xor_vmx.o xor_vmx_glue.o
-CFLAGS_xor_vmx.o += -maltivec $(call cc-option,-mabi=altivec)
+CFLAGS_xor_vmx.o += -maltivec $(call cc-option,-mabi=altivec) -isystem $(shell $(CC) -print-file-name=include)
 
 obj-$(CONFIG_PPC64) += $(obj64-y)
--- a/lib/raid6/Makefile~decouple-build-from-userspace-headers-fix
+++ a/lib/raid6/Makefile
@@ -13,7 +13,7 @@ raid6_pq-$(CONFIG_S390) += s390vx8.o rec
 hostprogs	+= mktables
 
 ifeq ($(CONFIG_ALTIVEC),y)
-altivec_flags := -maltivec $(call cc-option,-mabi=altivec)
+altivec_flags := -maltivec $(call cc-option,-mabi=altivec) -isystem $(shell $(CC) -print-file-name=include)
 
 ifdef CONFIG_CC_IS_CLANG
 # clang ppc port does not yet support -maltivec when -msoft-float is
@@ -33,7 +33,7 @@ endif
 # The GCC option -ffreestanding is required in order to compile code containing
 # ARM/NEON intrinsics in a non C99-compliant environment (such as the kernel)
 ifeq ($(CONFIG_KERNEL_MODE_NEON),y)
-NEON_FLAGS := -ffreestanding
+NEON_FLAGS := -ffreestanding -isystem $(shell $(CC) -print-file-name=include)
 ifeq ($(ARCH),arm)
 NEON_FLAGS += -march=armv7-a -mfloat-abi=softfp -mfpu=neon
 endif
_

Patches currently in -mm which might be from adobriyan@gmail.com are

decouple-build-from-userspace-headers.patch
decouple-build-from-userspace-headers-fix.patch


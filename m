Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA281C12002
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 21:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AABD36136E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 21:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhGNVww (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jul 2021 17:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhGNVwv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Jul 2021 17:52:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97E2E61362;
        Wed, 14 Jul 2021 21:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626299398;
        bh=YayVdk8TIwBAir26IXlOhkD/deR3kpwSIl3Ryj8shC8=;
        h=Date:From:To:Subject:From;
        b=Dluz5dB+6g1uQCOsHzfJ6nf3MKxIKlbaHiZfl6JmKPIEaE2oXoxEiuUojErjA90yB
         GjX1mupjv3aE5bWB60ajyu1QaJqAGjmt+6m5YWtjiLevMyv8+0fGlmvT2tDYNjsfFa
         BrAVBY8w/hU1R4C9Zo+Ju6teLX5YvqLAOWJ0Iq9c=
Date:   Wed, 14 Jul 2021 14:49:58 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, arnd@arndb.de, mm-commits@vger.kernel.org
Subject:  [to-be-updated]
 decouple-build-from-userspace-headers.patch removed from -mm tree
Message-ID: <20210714214958.Uq9Q7VJVc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kbuild: decouple build from userspace headers
has been removed from the -mm tree.  Its filename was
     decouple-build-from-userspace-headers.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: kbuild: decouple build from userspace headers

In theory, userspace headers can be under incompatible license.

Linux by virtue of being OS kernel is fully independent piece of code and
should not require anything from userspace.

For this:

* ship minimal <stdarg.h>
	2 types, 4 macros

* delete "-isystem"
	This is what enables leakage.

* fixup compilation where necessary.

Link: https://lkml.kernel.org/r/YO3txvw87MjKfdpq@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile                                                               |    2 +-
 arch/um/include/shared/irq_user.h                                      |    1 -
 arch/um/os-Linux/signal.c                                              |    2 +-
 crypto/aegis128-neon-inner.c                                           |    2 --
 drivers/net/wwan/iosm/iosm_ipc_imem.h                                  |    1 -
 drivers/pinctrl/aspeed/pinmux-aspeed.h                                 |    1 -
 drivers/staging/media/atomisp/pci/hive_isp_css_common/host/isp_local.h |    2 --
 include/stdarg.h                                                       |    9 +++++++++
 sound/aoa/codecs/onyx.h                                                |    1 -
 sound/aoa/codecs/tas.c                                                 |    1 -
 10 files changed, 11 insertions(+), 11 deletions(-)

--- a/arch/um/include/shared/irq_user.h~decouple-build-from-userspace-headers
+++ a/arch/um/include/shared/irq_user.h
@@ -7,7 +7,6 @@
 #define __IRQ_USER_H__
 
 #include <sysdep/ptrace.h>
-#include <stdbool.h>
 
 enum um_irq_type {
 	IRQ_READ,
--- a/arch/um/os-Linux/signal.c~decouple-build-from-userspace-headers
+++ a/arch/um/os-Linux/signal.c
@@ -67,7 +67,7 @@ int signals_enabled;
 #ifdef UML_CONFIG_UML_TIME_TRAVEL_SUPPORT
 static int signals_blocked;
 #else
-#define signals_blocked false
+#define signals_blocked 0
 #endif
 static unsigned int signals_pending;
 static unsigned int signals_active = 0;
--- a/crypto/aegis128-neon-inner.c~decouple-build-from-userspace-headers
+++ a/crypto/aegis128-neon-inner.c
@@ -15,8 +15,6 @@
 
 #define AEGIS_BLOCK_SIZE	16
 
-#include <stddef.h>
-
 extern int aegis128_have_aes_insn;
 
 void *memcpy(void *dest, const void *src, size_t n);
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h~decouple-build-from-userspace-headers
+++ a/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -7,7 +7,6 @@
 #define IOSM_IPC_IMEM_H
 
 #include <linux/skbuff.h>
-#include <stdbool.h>
 
 #include "iosm_ipc_mmio.h"
 #include "iosm_ipc_pcie.h"
--- a/drivers/pinctrl/aspeed/pinmux-aspeed.h~decouple-build-from-userspace-headers
+++ a/drivers/pinctrl/aspeed/pinmux-aspeed.h
@@ -5,7 +5,6 @@
 #define ASPEED_PINMUX_H
 
 #include <linux/regmap.h>
-#include <stdbool.h>
 
 /*
  * The ASPEED SoCs provide typically more than 200 pins for GPIO and other
--- a/drivers/staging/media/atomisp/pci/hive_isp_css_common/host/isp_local.h~decouple-build-from-userspace-headers
+++ a/drivers/staging/media/atomisp/pci/hive_isp_css_common/host/isp_local.h
@@ -16,8 +16,6 @@
 #ifndef __ISP_LOCAL_H_INCLUDED__
 #define __ISP_LOCAL_H_INCLUDED__
 
-#include <stdbool.h>
-
 #include "isp_global.h"
 
 #include <isp2400_support.h>
--- /dev/null
+++ a/include/stdarg.h
@@ -0,0 +1,9 @@
+#ifndef _LINUX_STDARG_H
+#define _LINUX_STDARG_H
+typedef __builtin_va_list __gnuc_va_list;
+typedef __builtin_va_list va_list;
+#define va_start(v, l)	__builtin_va_start(v, l)
+#define va_end(v)	__builtin_va_end(v)
+#define va_arg(v, T)	__builtin_va_arg(v, T)
+#define va_copy(d, s)	__builtin_va_copy(d, s)
+#endif
--- a/Makefile~decouple-build-from-userspace-headers
+++ a/Makefile
@@ -978,7 +978,7 @@ KBUILD_CFLAGS += -falign-functions=64
 endif
 
 # arch Makefile may override CC so keep this after arch Makefile is included
-NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
+NOSTDINC_FLAGS += -nostdinc
 
 # warn about C99 declaration after statement
 KBUILD_CFLAGS += -Wdeclaration-after-statement
--- a/sound/aoa/codecs/onyx.h~decouple-build-from-userspace-headers
+++ a/sound/aoa/codecs/onyx.h
@@ -6,7 +6,6 @@
  */
 #ifndef __SND_AOA_CODEC_ONYX_H
 #define __SND_AOA_CODEC_ONYX_H
-#include <stddef.h>
 #include <linux/i2c.h>
 #include <asm/pmac_low_i2c.h>
 #include <asm/prom.h>
--- a/sound/aoa/codecs/tas.c~decouple-build-from-userspace-headers
+++ a/sound/aoa/codecs/tas.c
@@ -58,7 +58,6 @@
  *    and up to the hardware designer to not wire
  *    them up in some weird unusable way.
  */
-#include <stddef.h>
 #include <linux/i2c.h>
 #include <asm/pmac_low_i2c.h>
 #include <asm/prom.h>
_

Patches currently in -mm which might be from adobriyan@gmail.com are

decouple-build-from-userspace-headers-v2.patch


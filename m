Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FECC4167B
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjLDTVR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjLDTVQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:21:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E62CE6
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:21:22 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B8DC433C8;
        Mon,  4 Dec 2023 19:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717682;
        bh=d6X9aj/Wby64nAxNglpgI1OF5sNXVFohB/rpCc20R4k=;
        h=Date:To:From:Subject:From;
        b=qAIccKigpsyv77R7xEh+ecf9g44/ou1oyte5+HXuAuqngiv6h6WKUdyTevEAIICve
         QoMovUiMqWuOPt2kkkAB5Bb68/IPvyXW5v5hFmdM8f6E03FbB7XqHAxhdSqlxJwxru
         1a0koz32y7i4c2cWIWrcjWq6jcoTQQosdh6OLluc=
Date:   Mon, 04 Dec 2023 11:21:21 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-decompress-fix-add-missing-prototypes.patch added to mm-nonmm-unstable branch
Message-Id: <20231204192122.27B8DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: decompress: fix add missing prototypes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-decompress-fix-add-missing-prototypes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-decompress-fix-add-missing-prototypes.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: decompress: fix add missing prototypes
Date: Mon, 4 Dec 2023 12:56:51 +0100

Patch series "mips: address -Wmissing-prototypes warnings".

Address the -Wmissing-prototypes warnings that showed up in mips as the
last major architecture after my patch to enable the option everywhere.


This patch (of 20):

The mips decompressor has some string functions defined locally that are
not declared in the right place:

arch/mips/boot/compressed/dbg.c:12:13: error: no previous prototype for 'putc' [-Werror=missing-prototypes]
arch/mips/boot/compressed/dbg.c:16:6: error: no previous prototype for 'puts' [-Werror=missing-prototypes]
arch/mips/boot/compressed/dbg.c:26:6: error: no previous prototype for 'puthex' [-Werror=missing-prototypes]
arch/mips/boot/compressed/string.c:11:7: error: no previous prototype for 'memcpy' [-Werror=missing-prototypes]
arch/mips/boot/compressed/string.c:22:7: error: no previous prototype for 'memset' [-Werror=missing-prototypes]
arch/mips/boot/compressed/string.c:32:15: error: no previous prototype for 'memmove' [-Werror=missing-prototypes]
arch/mips/boot/compressed/decompress.c:43:6: error: no previous prototype for 'error' [-Werror=missing-prototypes]
arch/mips/boot/compressed/decompress.c:91:6: error: no previous prototype for 'decompress_kernel' [-Werror=missing-prototypes]

Include the string.h header where needed and add a decompress.h header to
have shared prototypes for the rest.

Link: https://lkml.kernel.org/r/20231204115710.2247097-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20231204115710.2247097-2-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/boot/compressed/dbg.c        |    2 +
 arch/mips/boot/compressed/decompress.c |   16 +--------------
 arch/mips/boot/compressed/decompress.h |   24 +++++++++++++++++++++++
 arch/mips/boot/compressed/string.c     |    1 
 4 files changed, 29 insertions(+), 14 deletions(-)

--- a/arch/mips/boot/compressed/dbg.c~mips-decompress-fix-add-missing-prototypes
+++ a/arch/mips/boot/compressed/dbg.c
@@ -9,6 +9,8 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 
+#include "decompress.h"
+
 void __weak putc(char c)
 {
 }
--- a/arch/mips/boot/compressed/decompress.c~mips-decompress-fix-add-missing-prototypes
+++ a/arch/mips/boot/compressed/decompress.c
@@ -19,6 +19,8 @@
 #include <asm/unaligned.h>
 #include <asm-generic/vmlinux.lds.h>
 
+#include "decompress.h"
+
 /*
  * These two variables specify the free mem region
  * that can be used for temporary malloc area
@@ -26,20 +28,6 @@
 unsigned long free_mem_ptr;
 unsigned long free_mem_end_ptr;
 
-/* The linker tells us where the image is. */
-extern unsigned char __image_begin[], __image_end[];
-
-/* debug interfaces  */
-#ifdef CONFIG_DEBUG_ZBOOT
-extern void puts(const char *s);
-extern void puthex(unsigned long long val);
-#else
-#define puts(s) do {} while (0)
-#define puthex(val) do {} while (0)
-#endif
-
-extern char __appended_dtb[];
-
 void error(char *x)
 {
 	puts("\n\n");
--- /dev/null
+++ a/arch/mips/boot/compressed/decompress.h
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef _DECOMPRESSOR_H
+#define _DECOMPRESSOR_H
+
+/* The linker tells us where the image is. */
+extern unsigned char __image_begin[], __image_end[];
+
+/* debug interfaces  */
+#ifdef CONFIG_DEBUG_ZBOOT
+extern void putc(char c);
+extern void puts(const char *s);
+extern void puthex(unsigned long long val);
+#else
+#define putc(s) do {} while (0)
+#define puts(s) do {} while (0)
+#define puthex(val) do {} while (0)
+#endif
+
+extern char __appended_dtb[];
+
+void error(char *x);
+void decompress_kernel(unsigned long boot_heap_start);
+
+#endif
--- a/arch/mips/boot/compressed/string.c~mips-decompress-fix-add-missing-prototypes
+++ a/arch/mips/boot/compressed/string.c
@@ -7,6 +7,7 @@
 
 #include <linux/compiler_attributes.h>
 #include <linux/types.h>
+#include <asm/string.h>
 
 void *memcpy(void *dest, const void *src, size_t n)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
arch-turn-off-werror-for-architectures-with-known-warnings.patch
mips-decompress-fix-add-missing-prototypes.patch
mips-add-asm-syscallsh-header.patch
mips-add-missing-declarations-for-trap-handlers.patch
mips-rs870e-stop-exporting-local-functions.patch
mips-signal-move-sigcontext-declarations-to-header.patch
mips-mark-local-function-static-if-possible.patch
mips-move-build_tlb_refill_handler-prototype.patch
mips-move-jump_label_apply_nops-declaration-to-header.patch
mips-unhide-uasm_in_compat_space_p-declaration.patch
mips-fix-setup_zero_pages-prototype.patch
mips-fix-tlb_init-prototype.patch
mips-move-cache-declarations-into-header.patch
mips-add-missing-declarations.patch
mips-spram-fix-missing-prototype-warning-for-spram_config.patch
mips-mt-include-asm-mips_mth.patch
mips-remove-extraneous-asm-generic-iomaph-include.patch
mips-suspend-include-linux-suspendh-as-needed.patch
mips-hide-conditionally-unused-functions.patch
mips-smp-fix-setup_profiling_timer-prototype.patch
mips-kexec-include-linux-rebooth.patch
ida-make-ida_dump-static.patch
jffs2-mark-__jffs2_dbg_superblock_counts-static.patch
sched-fair-move-unused-stub-functions-to-header.patch
x86-sta2x11-include-header-for-sta2x11_get_instance-prototype.patch
usb-fsl-mph-dr-of-mark-fsl_usb2_mpc5121_init-static.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch


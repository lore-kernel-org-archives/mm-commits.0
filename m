Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE23C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 18:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 567AC64E66
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 18:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhBKSeb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Feb 2021 13:34:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:56470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232728AbhBKScl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Feb 2021 13:32:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD0CA64E6F;
        Thu, 11 Feb 2021 18:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613068248;
        bh=vnorOQG3Xg/l/uWXxttxvanWmS0BTqTDH6ZSI0CCJBo=;
        h=Date:From:To:Subject:From;
        b=beWzS1R9Kkr0pzh5SGPH2QkGEhy5yzV/WuUAI7tzsN/yx5+pChL2FYj2O6NgKdWKy
         sHwFU+6C1Q+oGx6fU/7pnKZGQxBy4gaFiJhBSDaUk7N2IAvKKmssvnoj/NnNFNr2q9
         jAn7m2XIYrsIMZjr6c+6k2Tgy2ljwmmpZR9KjaLQ=
Date:   Thu, 11 Feb 2021 10:30:48 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, dianders@chromium.org, lkp@intel.com,
        maskray@google.com, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Subject:  [merged] firmware_loader-align-builtin_fw-to-8.patch
 removed from -mm tree
Message-ID: <20210211183048.5lHy_QvQf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: firmware_loader: align .builtin_fw to 8
has been removed from the -mm tree.  Its filename was
     firmware_loader-align-builtin_fw-to-8.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fangrui Song <maskray@google.com>
Subject: firmware_loader: align .builtin_fw to 8

arm64 references the start address of .builtin_fw (__start_builtin_fw)
with a pair of R_AARCH64_ADR_PREL_PG_HI21/R_AARCH64_LDST64_ABS_LO12_NC
relocations.  The compiler is allowed to emit the
R_AARCH64_LDST64_ABS_LO12_NC relocation because struct builtin_fw in
include/linux/firmware.h is 8-byte aligned.

The R_AARCH64_LDST64_ABS_LO12_NC relocation requires the address to be a
multiple of 8, which may not be the case if .builtin_fw is empty. 
Unconditionally align .builtin_fw to fix the linker error.  32-bit
architectures could use ALIGN(4) but that would add unnecessary
complexity, so just use ALIGN(8).

Link: https://lkml.kernel.org/r/20201208054646.2913063-1-maskray@google.com
Link: https://github.com/ClangBuiltLinux/linux/issues/1204
Fixes: 5658c76 ("firmware: allow firmware files to be built into kernel image")
Signed-off-by: Fangrui Song <maskray@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/vmlinux.lds.h~firmware_loader-align-builtin_fw-to-8
+++ a/include/asm-generic/vmlinux.lds.h
@@ -459,7 +459,7 @@
 	}								\
 									\
 	/* Built-in firmware blobs */					\
-	.builtin_fw        : AT(ADDR(.builtin_fw) - LOAD_OFFSET) {	\
+	.builtin_fw : AT(ADDR(.builtin_fw) - LOAD_OFFSET) ALIGN(8) {	\
 		__start_builtin_fw = .;					\
 		KEEP(*(.builtin_fw))					\
 		__end_builtin_fw = .;					\
_

Patches currently in -mm which might be from maskray@google.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D3AC433DB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 20:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECE8B64EE8
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 20:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbhBESur (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 13:50:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232870AbhBEStz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 13:49:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB04A64F31;
        Fri,  5 Feb 2021 20:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612557098;
        bh=A8N7tHMfu+I4DYn6dMGyU/pXd+uyfQJVVgNSB+zRUC4=;
        h=Date:From:To:Subject:From;
        b=wl+SAvOBVQQB2fsZeLu5ocrv1zxRRmUK+ctxmMwbVbaj7ehJJ+Uiuc8+mMqxGwEXG
         PoUCLDzefTMPIp0PjKKfcUmn0lgo9LrW5ZMYpxEzPF+qpzq79QbeR6QXeZfSKaIiH2
         g39g0C6A7fCjUINfJbjHRn1uEhAn2FsoDI/X2OdA=
Date:   Fri, 05 Feb 2021 12:31:37 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, dianders@chromium.org, lkp@intel.com,
        maskray@google.com, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Subject:  + firmware_loader-align-builtin_fw-to-8.patch added to
 -mm tree
Message-ID: <20210205203137.jHV27DEyx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: firmware_loader: align .builtin_fw to 8
has been added to the -mm tree.  Its filename is
     firmware_loader-align-builtin_fw-to-8.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/firmware_loader-align-builtin_fw-to-8.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/firmware_loader-align-builtin_fw-to-8.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

firmware_loader-align-builtin_fw-to-8.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD59DC77B75
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 21:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240559AbjELVOE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 17:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239906AbjELVNq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 17:13:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A209EF0
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 14:12:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04CCF60EE1
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 21:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54752C433D2;
        Fri, 12 May 2023 21:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683925871;
        bh=6UseJLHascJwzoqkn5S61pRT6ti5791iCaFyGppqmZ0=;
        h=Date:To:From:Subject:From;
        b=OuRjJtgzPUl4oPEAQR4JxnPD+FsFNP2AtIPOeu90hYDOcMiQFM1pk0kWGRaBHi4Uk
         biJNRX5/05P6UuXXycGmcF7AK+PvRlwcTxDvu/vybezHx1RmcGLsme1kohdl7mBd4U
         MSafb9Xg8f8n5qrOM5uA3JEHyyAmLU088LxCWleI=
Date:   Fri, 12 May 2023 14:11:10 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + add-intptr_t.patch added to mm-nonmm-unstable branch
Message-Id: <20230512211111.54752C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: add intptr_t
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     add-intptr_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/add-intptr_t.patch

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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: add intptr_t
Date: Fri, 12 May 2023 13:33:38 +0300

Add signed intptr_t given that a) it is standard type and b) uintptr_t is
in tree.

Link: https://lkml.kernel.org/r/ed66b9e4-1fb7-45be-9bb9-d4bc291c691f@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/fw/cfe/cfe_api.h |    3 ---
 include/linux/types.h                  |    1 +
 lib/zstd/common/zstd_deps.h            |   18 ------------------
 3 files changed, 1 insertion(+), 21 deletions(-)

--- a/arch/mips/include/asm/fw/cfe/cfe_api.h~add-intptr_t
+++ a/arch/mips/include/asm/fw/cfe/cfe_api.h
@@ -17,9 +17,6 @@
 #include <linux/types.h>
 #include <linux/string.h>
 
-typedef long intptr_t;
-
-
 /*
  * Constants
  */
--- a/include/linux/types.h~add-intptr_t
+++ a/include/linux/types.h
@@ -35,6 +35,7 @@ typedef __kernel_uid16_t        uid16_t;
 typedef __kernel_gid16_t        gid16_t;
 
 typedef unsigned long		uintptr_t;
+typedef long			intptr_t;
 
 #ifdef CONFIG_HAVE_UID16
 /* This is defined by include/asm-{arch}/posix_types.h */
--- a/lib/zstd/common/zstd_deps.h~add-intptr_t
+++ a/lib/zstd/common/zstd_deps.h
@@ -105,21 +105,3 @@ static uint64_t ZSTD_div64(uint64_t divi
 
 #endif /* ZSTD_DEPS_IO */
 #endif /* ZSTD_DEPS_NEED_IO */
-
-/*
- * Only requested when MSAN is enabled.
- * Need:
- * intptr_t
- */
-#ifdef ZSTD_DEPS_NEED_STDINT
-#ifndef ZSTD_DEPS_STDINT
-#define ZSTD_DEPS_STDINT
-
-/*
- * The Linux Kernel doesn't provide intptr_t, only uintptr_t, which
- * is an unsigned long.
- */
-typedef long intptr_t;
-
-#endif /* ZSTD_DEPS_STDINT */
-#endif /* ZSTD_DEPS_NEED_STDINT */
_

Patches currently in -mm which might be from adobriyan@gmail.com are

add-intptr_t.patch


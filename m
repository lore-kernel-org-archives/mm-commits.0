Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 566A9C7EE25
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjFJApK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjFJApI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D472730F6
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71E57651CF
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91D7C433D2;
        Sat, 10 Jun 2023 00:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357905;
        bh=bHpRb3gJetHcFDdyBYrvmAR+eTKoEtRIWJ7nok8WEWA=;
        h=Date:To:From:Subject:From;
        b=JpnMjCopM/HN9RJc6G+yBp2cDWPIv9f47lO9rV4ySO3F/7WwNbF9d7KW8R2dP3hEl
         WUL9jVkbjdlzqFgves8tm7KBeT9fr5Vapo/kizooiGsECsKPJQixbKZj0O5ux1uZiY
         1zV4008RpWF9Puye9gVDuFETkEd2f1/J7420t4E8=
Date:   Fri, 09 Jun 2023 17:45:05 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] add-intptr_t.patch removed from -mm tree
Message-Id: <20230610004505.C91D7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: add intptr_t
has been removed from the -mm tree.  Its filename was
     add-intptr_t.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

fix-mult_frac-multiple-argument-evaluation-bug.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3ADC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 500F8613C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbhDPWqi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 18:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234886AbhDPWqi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 18:46:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8375613C3;
        Fri, 16 Apr 2021 22:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618613172;
        bh=BfY/oKu7RUiPBfLmlqzjnlcOkUlautBG4ewu6wU4Okk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=y4lWlCW0W8Fnl5g3MfMl4oJgqAloRsv4caT8EC9IJ4Q3Eix7TF+pj0F1sBsR+6lNM
         ZXeCuPuGMcrnM0G6ArC8jF0SyjPrOTuBszzHQoe27WfQrxFboAZyKg5jpBOEoRNhiJ
         qJWhwAS5r4jX0eai6mUmX2PWiiIN0EdcFXVIxBc0=
Date:   Fri, 16 Apr 2021 15:46:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, glaubitz@physik.fu-berlin.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 07/12] ia64: tools: remove inclusion of
 ia64-specific version of errno.h header
Message-ID: <20210416224612.CwMWAe8pW%akpm@linux-foundation.org>
In-Reply-To: <20210416154523.3f9794326e8e1db549873cf8@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: John Paul Adrian Glaubitz <glaubitz () physik ! fu-berlin ! de>
Subject: ia64: tools: remove inclusion of ia64-specific version of errno.h header

There is no longer an ia64-specific version of the errno.h header below
arch/ia64/include/uapi/asm/, so trying to build tools/bpf fails with:

  CC       /usr/src/linux/tools/bpf/bpftool/btf_dumper.o
In file included from /usr/src/linux/tools/include/linux/err.h:8,
                 from btf_dumper.c:11:
/usr/src/linux/tools/include/uapi/asm/errno.h:13:10: fatal error: ../../../arch/ia64/include/uapi/asm/errno.h: No such file or directory
   13 | #include "../../../arch/ia64/include/uapi/asm/errno.h"
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.

Thus, just remove the inclusion of the ia64-specific errno.h so that
the build will use the generic errno.h header on this target which was
used there anyway as the ia64-specific errno.h was just a wrapper for
the generic header.

Fixes: c25f867ddd00 ("ia64: remove unneeded uapi asm-generic wrappers")
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/uapi/asm/errno.h |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/include/uapi/asm/errno.h~ia64-tools-remove-inclusion-of-ia64-specific-version-of-errnoh-header
+++ a/tools/include/uapi/asm/errno.h
@@ -9,8 +9,6 @@
 #include "../../../arch/alpha/include/uapi/asm/errno.h"
 #elif defined(__mips__)
 #include "../../../arch/mips/include/uapi/asm/errno.h"
-#elif defined(__ia64__)
-#include "../../../arch/ia64/include/uapi/asm/errno.h"
 #elif defined(__xtensa__)
 #include "../../../arch/xtensa/include/uapi/asm/errno.h"
 #else
_

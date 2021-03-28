Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D593C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 21:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30E9261942
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 21:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhC1V23 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 17:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhC1V15 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 17:27:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B873461945;
        Sun, 28 Mar 2021 21:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616966876;
        bh=5JHnsLp+jbX/4+WoYfnBGbwi5hdOHMX+tQDmB7XPn1w=;
        h=Date:From:To:Subject:From;
        b=GL6kmSu9C0wKhP6axG8Vcc/9KeLphlcwd3hXafo1LD6o6FPwZIWfXSlxH3mR8BI+u
         WNXPOMCPu+mUS5O2pQJW5ZueKqZ39Q03L5MfU0wVBEJrqPy+yELora4zWJaIytBRdp
         eXwzIsU2dQ79VAGH3G7JQBKvBnkCzrR5cg/OTecs=
Date:   Sun, 28 Mar 2021 14:27:56 -0700
From:   akpm@linux-foundation.org
To:     glaubitz@physik.fu-berlin.de, mm-commits@vger.kernel.org
Subject:  +
 ia64-tools-remove-inclusion-of-ia64-specific-version-of-errnoh-header.patch
 added to -mm tree
Message-ID: <20210328212756.yO29CNAbR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: tools: remove inclusion of ia64-specific version of errno.h header
has been added to the -mm tree.  Its filename is
     ia64-tools-remove-inclusion-of-ia64-specific-version-of-errnoh-header.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-tools-remove-inclusion-of-ia64-specific-version-of-errnoh-header.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-tools-remove-inclusion-of-ia64-specific-version-of-errnoh-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from glaubitz@physik.fu-berlin.de are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F1BC433B4
	for <mm-commits@archiver.kernel.org>; Tue, 20 Apr 2021 22:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C92E96140F
	for <mm-commits@archiver.kernel.org>; Tue, 20 Apr 2021 22:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbhDTW4U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Apr 2021 18:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234280AbhDTW4T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Apr 2021 18:56:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B25576140B;
        Tue, 20 Apr 2021 22:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618959346;
        bh=9xmfN304r17HemRR2hEPlS0aDwobj0g7aiBiT179cKA=;
        h=Date:From:To:Subject:From;
        b=LXBsD89vJtNZhXYNZO/7lGJY0jZAQgp1FTasFJkzho4/td5OkBzOKEmhh0oQ7mbtA
         lz8ZolklTfClE17dSxQ8idaVSkz/u1BfryZOSQ69tXH5sJa6B/o/2ywB/wWyjLLJxN
         pYUFBhFL73BcTS2cGHpooM22qO4fdO8yGFCGLc4Q=
Date:   Tue, 20 Apr 2021 15:55:46 -0700
From:   akpm@linux-foundation.org
To:     glaubitz@physik.fu-berlin.de, mm-commits@vger.kernel.org
Subject:  [merged]
 ia64-tools-remove-inclusion-of-ia64-specific-version-of-errnoh-header.patch
 removed from -mm tree
Message-ID: <20210420225546.RPIOztMYO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: tools: remove inclusion of ia64-specific version of errno.h header
has been removed from the -mm tree.  Its filename was
     ia64-tools-remove-inclusion-of-ia64-specific-version-of-errnoh-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56F7C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jun 2022 18:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiFXSvX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jun 2022 14:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiFXSvW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2022 14:51:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E028173E
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 11:51:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 112FC62120
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 18:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A61C34114;
        Fri, 24 Jun 2022 18:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656096680;
        bh=BRNffkz/ZoWrZ/s0mKPerBYcUPGAFgtii1Dv2QNNtTQ=;
        h=Date:To:From:Subject:From;
        b=ltKX2lmjUVSxQuR24T0NVSIIRioHgrHtrztivrNAIyN1MBZyd4p5sETVVkdGCTJKn
         3zCemTswxNcfp1K5lmYpsY6guG0hVwqEY1v0IY9yJrsMEBF70MxrDhm9mgMK5NGYha
         x6TIxUh72CGxnijTOqnghU0cZHGB0sd/elyfLIjc=
Date:   Fri, 24 Jun 2022 11:51:19 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + compiler-gcch-remove-ancient-workaround-for-gcc-pr-58670.patch added to mm-nonmm-unstable branch
Message-Id: <20220624185120.64A61C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-gcc.h: remove ancient workaround for gcc PR 58670
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     compiler-gcch-remove-ancient-workaround-for-gcc-pr-58670.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compiler-gcch-remove-ancient-workaround-for-gcc-pr-58670.patch

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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: compiler-gcc.h: remove ancient workaround for gcc PR 58670
Date: Fri, 24 Jun 2022 16:14:12 +0200

The workaround for 'asm goto' miscompilation introduces a compiler barrier
quirk that inhibits many useful compiler optimizations.  For example,
__try_cmpxchg_user compiles to:

   11375:	41 8b 4d 00          	mov    0x0(%r13),%ecx
   11379:	41 8b 02             	mov    (%r10),%eax
   1137c:	f0 0f b1 0a          	lock cmpxchg %ecx,(%rdx)
   11380:	0f 94 c2             	sete   %dl
   11383:	84 d2                	test   %dl,%dl
   11385:	75 c4                	jne    1134b <...>
   11387:	41 89 02             	mov    %eax,(%r10)

where the barrier inhibits flags propagation from asm when compiled with
gcc-12.

When the mentioned quirk is removed, the following code is generated:

   11553:	41 8b 4d 00          	mov    0x0(%r13),%ecx
   11557:	41 8b 02             	mov    (%r10),%eax
   1155a:	f0 0f b1 0a          	lock cmpxchg %ecx,(%rdx)
   1155e:	74 c9                	je     11529 <...>
   11560:	41 89 02             	mov    %eax,(%r10)

The refered compiler bug:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670

was fixed for gcc-4.8.2.

Current minimum required version of GCC is version 5.1 which has the above
'asm goto' miscompilation fixed, so remove the workaround.

Link: https://lkml.kernel.org/r/20220624141412.72274-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |   11 -----------
 1 file changed, 11 deletions(-)

--- a/include/linux/compiler-gcc.h~compiler-gcch-remove-ancient-workaround-for-gcc-pr-58670
+++ a/include/linux/compiler-gcc.h
@@ -66,17 +66,6 @@
 		__builtin_unreachable();	\
 	} while (0)
 
-/*
- * GCC 'asm goto' miscompiles certain code sequences:
- *
- *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
- *
- * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
- *
- * (asm goto is automatically volatile - the naming reflects this.)
- */
-#define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
-
 #if defined(CONFIG_ARCH_USE_BUILTIN_BSWAP)
 #define __HAVE_BUILTIN_BSWAP32__
 #define __HAVE_BUILTIN_BSWAP64__
_

Patches currently in -mm which might be from ubizjak@gmail.com are

compiler-gcch-remove-ancient-workaround-for-gcc-pr-58670.patch


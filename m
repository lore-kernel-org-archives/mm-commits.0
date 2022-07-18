Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD40C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbiGRAcg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiGRAca (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0A613CE1
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CF0C9CE1181
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3054BC341C0;
        Mon, 18 Jul 2022 00:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104345;
        bh=iQhdJfs1s6H9I/BD9fbSKzUZyoyzaPLYbvLJVqmye2A=;
        h=Date:To:From:Subject:From;
        b=M5kJtzSVqOl+EvuhVK+FGQIeaOMBVM/EIqwS1ZU1OcWXVpSLzYLpgINESpShHklN0
         +3f1Q9MR4bKBo5CgeJiPghRuapehX1dfj//jOk17WrWFgZTdIDVP42XWBD+Lj8rLNf
         e24TOloUgpY9vr8GOk7aR7++vuvHhYUpQq7bP7cM=
Date:   Sun, 17 Jul 2022 17:32:24 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@kernel.org,
        hpa@zytor.com, ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] compiler-gcch-remove-ancient-workaround-for-gcc-pr-58670.patch removed from -mm tree
Message-Id: <20220718003225.3054BC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: compiler-gcc.h: remove ancient workaround for gcc PR 58670
has been removed from the -mm tree.  Its filename was
     compiler-gcch-remove-ancient-workaround-for-gcc-pr-58670.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Ingo Molnar <mingo@kernel.org>
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



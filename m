Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01BF5C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 22:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbjCCW6c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 17:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjCCW6X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 17:58:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC9D41082
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 14:58:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACA8CB819F8
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 22:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617FCC433EF;
        Fri,  3 Mar 2023 22:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677884252;
        bh=BXsB/NEFjbUcuXjgIChSVEeOEN8uoQDqIRrn1Wegb0I=;
        h=Date:To:From:Subject:From;
        b=IOGYa1C+0E5LsT5sspqkeceJ811KVtPA5rLUTemE45OyOU8qb1T8xx5n6yjFP/3Z2
         paGP2yHaXAUKPiUDBLD2hoY5vWa/OZgyq7rPVM2K8TF4xUpZgYFVqzNkmo/J5MlgzW
         g92sviAxoOi+rC7dc5AkqvdLWmQypidY8Jq03oLI=
Date:   Fri, 03 Mar 2023 14:57:31 -0800
To:     mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        keescook@chromium.org, geert@linux-m68k.org, elver@google.com,
        deller@gmx.de, daniel@ffwll.ch, glider@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kmsan-use-c-versions-of-memset16-memset32-memset64.patch added to mm-unstable branch
Message-Id: <20230303225732.617FCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: kmsan: use C versions of memset16/memset32/memset64
has been added to the -mm mm-unstable branch.  Its filename is
     x86-kmsan-use-c-versions-of-memset16-memset32-memset64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kmsan-use-c-versions-of-memset16-memset32-memset64.patch

This patch will later appear in the mm-unstable branch at
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
From: Alexander Potapenko <glider@google.com>
Subject: x86: kmsan: use C versions of memset16/memset32/memset64
Date: Fri, 3 Mar 2023 15:14:32 +0100

KMSAN must see as many memory accesses as possible to prevent false
positive reports.  Fall back to versions of
memset16()/memset32()/memset64() implemented in lib/string.c instead of
those written in assembly.

Link: https://lkml.kernel.org/r/20230303141433.3422671-3-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/x86/include/asm/string_64.h~x86-kmsan-use-c-versions-of-memset16-memset32-memset64
+++ a/arch/x86/include/asm/string_64.h
@@ -22,6 +22,11 @@ extern void *__memcpy(void *to, const vo
 void *memset(void *s, int c, size_t n);
 void *__memset(void *s, int c, size_t n);
 
+/*
+ * KMSAN needs to instrument as much code as possible. Use C versions of
+ * memsetXX() from lib/string.c under KMSAN.
+ */
+#if !defined(CONFIG_KMSAN)
 #define __HAVE_ARCH_MEMSET16
 static inline void *memset16(uint16_t *s, uint16_t v, size_t n)
 {
@@ -57,6 +62,7 @@ static inline void *memset64(uint64_t *s
 		     : "memory");
 	return s;
 }
+#endif
 
 #define __HAVE_ARCH_MEMMOVE
 void *memmove(void *dest, const void *src, size_t count);
_

Patches currently in -mm which might be from glider@google.com are

x86-kmsan-dont-rename-memintrinsics-in-uninstrumented-files.patch
kmsan-another-take-at-fixing-memcpy-tests.patch
x86-kmsan-use-c-versions-of-memset16-memset32-memset64.patch
kmsan-add-memsetxx-tests.patch


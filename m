Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0BAC761A6
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjC1XWH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjC1XVm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00C41BFD
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6947EB81EEC
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26007C4339B;
        Tue, 28 Mar 2023 23:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045693;
        bh=Z+gTMmFSmdfaLEwt3+hOxZSd3y15ud/xQ0NdRu9CcGg=;
        h=Date:To:From:Subject:From;
        b=mlbqNB55Tm2vARvqseAwJDm4o9OB7VObSvdJHqytWCvjAYM7HqwmfHou7FxUgn4t2
         /7NxjFCA1K4G5LE82ZWjJKZrU45PvZ56q9Z0ZzHYCCOXe4Ub0kZ62MbktqQmS2vtWz
         vS4IzGvvsnVgquKefV+dpUnOscqktHVocsACblvU=
Date:   Tue, 28 Mar 2023 16:21:32 -0700
To:     mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        keescook@chromium.org, geert@linux-m68k.org, elver@google.com,
        deller@gmx.de, daniel@ffwll.ch, glider@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-kmsan-use-c-versions-of-memset16-memset32-memset64.patch removed from -mm tree
Message-Id: <20230328232133.26007C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86: kmsan: use C versions of memset16/memset32/memset64
has been removed from the -mm tree.  Its filename was
     x86-kmsan-use-c-versions-of-memset16-memset32-memset64.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 arch/x86/include/asm/string_64.h |    6 ++++++
 1 file changed, 6 insertions(+)

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



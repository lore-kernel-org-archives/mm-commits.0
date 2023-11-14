Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC7C7C46CC7
	for <mm-commits@archiver.kernel.org>; Tue, 14 Nov 2023 23:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjKNXAV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Nov 2023 18:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbjKNXAU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2023 18:00:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725A7DD
        for <mm-commits@vger.kernel.org>; Tue, 14 Nov 2023 15:00:17 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B425C433C7;
        Tue, 14 Nov 2023 23:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700002817;
        bh=XSCfqUAE14ALVKGipLw2DWtZIQYQBIwftbGmgwlLWuU=;
        h=Date:To:From:Subject:From;
        b=nV7CBW3nUcJ7KGDEWmk61yHz0FeBFeZhdKKUyoji4EtP0IcrwVCdzm/RloZSXg0Jc
         9QgQx9dEQc2jASkJdJ9/zAzq3fS/IBJ4E4/C+hIEUchL9oNGGTrEpxxbpHOZbOr6mu
         kK1YR67vUN15V0ERvLytFuEtW+1yrPRi7b6FqBrw=
Date:   Tue, 14 Nov 2023 15:00:16 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, paul.heidekrueger@tum.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-default-to-inline-instrumentation.patch added to mm-unstable branch
Message-Id: <20231114230017.0B425C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: default to inline instrumentation
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-default-to-inline-instrumentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-default-to-inline-instrumentation.patch

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
From: Paul Heidekrüger <paul.heidekrueger@tum.de>
Subject: kasan: default to inline instrumentation
Date: Thu, 9 Nov 2023 15:51:00 +0000

KASan inline instrumentation can yield up to a 2x performance gain at the
cost of a larger binary.

Make inline instrumentation the default, as suggested in the bug report
below.

When an architecture does not support inline instrumentation, it should
set ARCH_DISABLE_KASAN_INLINE, as done by PowerPC, for instance.

Link: https://lkml.kernel.org/r/20231109155101.186028-1-paul.heidekrueger@tum.de
Signed-off-by: Paul Heidekrüger <paul.heidekrueger@tum.de>
Reported-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=203495
Acked-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.kasan~kasan-default-to-inline-instrumentation
+++ a/lib/Kconfig.kasan
@@ -134,7 +134,7 @@ endchoice
 choice
 	prompt "Instrumentation type"
 	depends on KASAN_GENERIC || KASAN_SW_TAGS
-	default KASAN_OUTLINE
+	default KASAN_INLINE if !ARCH_DISABLE_KASAN_INLINE
 
 config KASAN_OUTLINE
 	bool "Outline instrumentation"
_

Patches currently in -mm which might be from paul.heidekrueger@tum.de are

kasan-default-to-inline-instrumentation.patch

